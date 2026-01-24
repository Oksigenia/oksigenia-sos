import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:oksigenia_sos/l10n/app_localizations.dart'; 
import '../services/preferences_service.dart';
import '../screens/settings_screen.dart'; 

enum SOSStatus { ready, scanning, locationFixed, preAlert, sent, error }
enum AlertCause { manual, fall, inactivity, dyingGasp }

class SOSLogic extends ChangeNotifier with WidgetsBindingObserver {
  SOSStatus _status = SOSStatus.ready;
  String _errorMessage = '';
  static const platform = MethodChannel('com.oksigenia.sos/sms');
  
  // FIX v3.8.3: Umbral subido a 12.0G para evitar saltos fuertes
  static const double _impactThreshold = 12.0;

  bool _isFallDetectionActive = false;
  bool _isInactivityMonitorActive = false;
  
  AlertCause _lastTrigger = AlertCause.manual;
  AlertCause get lastTrigger => _lastTrigger;

  int _currentInactivityLimit = 3600; 
  int get currentInactivityLimit => _currentInactivityLimit;

  double _visualGForce = 1.0;
  DateTime _lastMovementTime = DateTime.now();
  
  Timer? _inactivityTimer;
  Timer? _periodicUpdateTimer;
  StreamSubscription? _accelerometerSubscription;
  StreamSubscription? _gpsSubscription;
  
  // --- DATOS VISUALES (HEALTH DASHBOARD) ---
  int _batteryLevel = 0;
  double _gpsAccuracy = 0.0;
  Timer? _healthCheckTimer;
  
  int get batteryLevel => _batteryLevel;
  double get gpsAccuracy => _gpsAccuracy;
  // ----------------------------------------

  Timer? _preAlertTimer;
  int _countdownSeconds = 60;
  
  AudioPlayer? _audioPlayer; 
  double _currentVolume = 0.2;
  
  final Battery _battery = Battery();

  SOSStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get isFallDetectionActive => _isFallDetectionActive;
  bool get isInactivityMonitorActive => _isInactivityMonitorActive;
  int get countdownSeconds => _countdownSeconds;
  
  double get currentGForce => _visualGForce;
  
  String? get emergencyContact {
    final contacts = PreferencesService().getContacts();
    return contacts.isNotEmpty ? contacts.first : null;
  }

  // --- INICIO CORREGIDO (v3.8.2/3) ---
  Future<void> init() async {
    WidgetsBinding.instance.addObserver(this);
    await _loadSettings();

    // 1. Pedir permisos y arrancar Sylvia (Servicio) INMEDIATAMENTE.
    await _checkPermissions();
    final service = FlutterBackgroundService();
    if (!(await service.isRunning())) {
      await service.startService();
    }

    // 2. Iniciar sensores y monitores una vez el servicio está en pie.
    _startGForceMonitoring();
    _startHealthMonitor(); 
    _startPassiveGPS();
  }
  // ---------------------------------

  Future<bool> arePermissionsRestricted() async {
    bool smsRestricted = await Permission.sms.isPermanentlyDenied;
    bool locRestricted = await Permission.location.isPermanentlyDenied;
    return smsRestricted || locRestricted;
  }

  void _startHealthMonitor() {
    _checkHealth();
    _healthCheckTimer = Timer.periodic(const Duration(seconds: 10), (_) => _checkHealth());
  }

  Future<void> _checkHealth() async {
    try {
      _batteryLevel = await _battery.batteryLevel;
      if (_status != SOSStatus.locationFixed) {
         _gpsAccuracy = 0.0;
      }
      notifyListeners();
    } catch(e) { debugPrint("Health Check Error: $e"); }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint("🔄 APP RESUMED: Reactivando sensores...");
      _startGForceMonitoring();
      _checkHealth();
      if (_status == SOSStatus.ready) _startPassiveGPS();
    } else if (state == AppLifecycleState.paused) {
      _accelerometerSubscription?.cancel();
    }
  }

  Future<void> _loadSettings() async {
    final prefs = PreferencesService();
    _currentInactivityLimit = prefs.getInactivityTime();
    
    bool savedFallState = prefs.getFallDetectionState();
    bool savedInactivityState = prefs.getInactivityState();

    if (savedFallState && emergencyContact != null) {
      _isFallDetectionActive = true; 
    }
    
    if (savedInactivityState && emergencyContact != null) {
      toggleInactivityMonitor(true); 
    }
    notifyListeners();
  }

  Future<void> refreshConfig() async {
    await _loadSettings();
  }

  void _startPassiveGPS() async {
    await _gpsSubscription?.cancel();
    final LocationSettings locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
        forceLocationManager: true, 
        intervalDuration: const Duration(seconds: 5)
    );

    try {
      _gpsSubscription = Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((Position? position) {
            if (position != null) {
               _gpsAccuracy = position.accuracy; 
               if (_status == SOSStatus.ready) _setStatus(SOSStatus.locationFixed); 
               notifyListeners();
            }
          }, onError: (_) {
             if (_status == SOSStatus.locationFixed) _setStatus(SOSStatus.ready);
          });
    } catch (e) { debugPrint("Passive GPS Error: $e"); }
  }

  void _startGForceMonitoring() {
    _accelerometerSubscription?.cancel();
    try {
      _accelerometerSubscription = accelerometerEventStream(samplingPeriod: SensorInterval.gameInterval)
        .listen((AccelerometerEvent event) {
          double rawMagnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
          double instantG = rawMagnitude / 9.81;

          if (instantG > _visualGForce) {
            _visualGForce = instantG;
          } else {
            _visualGForce = (_visualGForce * 0.90) + (instantG * 0.10);
          }

          // FIX v3.8.3: Rango estrechado (1.1 / 0.9) para detectar movimientos sutiles
          // Esto evita que la alarma de inactividad salte mientras caminas suave o subes escaleras
          if ((instantG > 1.1 || instantG < 0.9)) {
             _lastMovementTime = DateTime.now();
          }
          
          // FIX v3.8.3: Usamos el nuevo umbral de 12.0G
          if (_isFallDetectionActive && instantG > _impactThreshold && (_status == SOSStatus.ready || _status == SOSStatus.locationFixed)) {
            debugPrint("💥 IMPACTO DETECTADO: ${instantG.toStringAsFixed(2)} G");
            _triggerPreAlert(AlertCause.fall);
          }
          notifyListeners();
        }, onError: (e) => debugPrint("Sensor Error: $e"));
    } catch (e) { debugPrint("Error iniciando acelerómetro: $e"); }
  }

  Future<void> _checkPermissions() async {
    await [Permission.location, Permission.sms, Permission.notification].request();
  }

  void openSettings(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()))
      .then((_) => refreshConfig());
  }
  
  void openPrivacy(BuildContext context) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx)!.privacyTitle),
        content: SingleChildScrollView(child: Text(AppLocalizations.of(ctx)!.privacyPolicyContent)),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK"))],
    ));
  }

  void openDonation(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: Text(l10n.donateDialogTitle),
      content: Text(l10n.donateDialogBody),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.donateClose)),
        ElevatedButton(
          onPressed: () {
            launchURL("https://www.paypal.com/donate/?business=paypal@oksigenia.cc&currency_code=EUR");
            Navigator.pop(ctx);
          }, 
          child: Text(l10n.donateBtn)
        )
      ],
    ));
  }

  void launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void toggleFallDetection(bool value) async {
    if (value && emergencyContact == null) {
      _setStatus(SOSStatus.error, "NO_CONTACT"); 
      _isFallDetectionActive = false;
      notifyListeners();
      return;
    }
    _isFallDetectionActive = value;
    if (value && _errorMessage == "NO_CONTACT") _setStatus(SOSStatus.ready); 
    if (value) {
      final service = FlutterBackgroundService();
      if (!(await service.isRunning())) service.startService();
    }
    PreferencesService().saveFallDetectionState(value);
    notifyListeners();
  }

  void toggleInactivityMonitor(bool value) async {
    if (value && emergencyContact == null) {
      _setStatus(SOSStatus.error, "NO_CONTACT");
      _isInactivityMonitorActive = false;
      notifyListeners();
      return;
    }
    _isInactivityMonitorActive = value;
    if (value && _errorMessage == "NO_CONTACT") _setStatus(SOSStatus.ready); 
    if (value) {
      final service = FlutterBackgroundService();
      if (!(await service.isRunning())) service.startService();
    }
    PreferencesService().saveInactivityState(value);

    if (value) {
      _lastMovementTime = DateTime.now();
      _inactivityTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
        if (_status != SOSStatus.ready && _status != SOSStatus.locationFixed) return;
        if (DateTime.now().difference(_lastMovementTime).inSeconds > _currentInactivityLimit) {
          _triggerPreAlert(AlertCause.inactivity);
        }
      });
    } else {
      _inactivityTimer?.cancel();
      if (_status == SOSStatus.preAlert) cancelAlert();
    }
    notifyListeners();
  }

  void _triggerPreAlert(AlertCause cause) async {
    _lastTrigger = cause;
    _gpsSubscription?.pause(); 
    try { await platform.invokeMethod('wakeScreen'); } catch(_) {}

    _status = SOSStatus.preAlert;
    _countdownSeconds = 60;
    _currentVolume = 0.2;
    notifyListeners();

    try {
        _audioPlayer?.dispose();
        _audioPlayer = AudioPlayer();
        await _audioPlayer!.setAudioContext(AudioContext(
           android: AudioContextAndroid(isSpeakerphoneOn: true, stayAwake: true, contentType: AndroidContentType.sonification, usageType: AndroidUsageType.alarm, audioFocus: AndroidAudioFocus.gainTransient),
           iOS: AudioContextIOS(category: AVAudioSessionCategory.playback)
        ));
        await _audioPlayer!.setReleaseMode(ReleaseMode.loop);
        await _audioPlayer!.play(AssetSource('sounds/alarm.mp3'), volume: _currentVolume);
    } catch(e) { debugPrint("Audio Panic: $e"); }
    
    try {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(pattern: [500, 1000, 500, 1000], repeat: 0);
      }
    } catch (e) { debugPrint("Vibration Error: $e"); }

    _preAlertTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        _countdownSeconds--;
        if (_currentVolume < 1.0 && _audioPlayer != null) {
          _currentVolume += 0.1;
          _audioPlayer!.setVolume(_currentVolume).catchError((_){});
        }
        notifyListeners();
      } else {
        _stopAllAlerts();    
        sendSOS();                
      }
    });
  }

  void cancelAlert() async {
    _stopAllAlerts();
    _status = SOSStatus.ready;
    _lastMovementTime = DateTime.now();
    if (_status == SOSStatus.ready) _startPassiveGPS();
    try { await platform.invokeMethod('sleepScreen'); } catch(_) {}
    notifyListeners();
  }

  void _stopAllAlerts() {
    _preAlertTimer?.cancel();
    _periodicUpdateTimer?.cancel();
    try { _audioPlayer?.stop(); _audioPlayer?.dispose(); _audioPlayer = null; } catch(_) {}
    try { Vibration.cancel(); } catch(_) {}
  }

  Future<void> sendSOS() async {
    final prefs = PreferencesService();
    final List<String> recipients = prefs.getContacts();
    final String customNote = prefs.getSosMessage();

    if (recipients.isEmpty) {
      _setStatus(SOSStatus.error, "NO_CONTACT");
      return;
    }
    
    _setStatus(SOSStatus.scanning);
    _inactivityTimer?.cancel();
    _gpsSubscription?.cancel();
    
    String msgBody = "🆘 SOS OKSIGENIA";
    if (customNote.isNotEmpty) {
      msgBody += "\n$customNote"; 
    } else {
      final sharedPrefs = await SharedPreferences.getInstance();
      String lang = sharedPrefs.getString('language_code') ?? 'en';
      String helpText = "HELP!";
      if (lang == 'es') helpText = "¡AYUDA!";
      else if (lang == 'fr') helpText = "AIDEZ-MOI !";
      else if (lang == 'pt') helpText = "AJUDA!";
      else if (lang == 'de') helpText = "HILFE!";
      msgBody += "\n$helpText"; 
    }
    
    try {
      int batteryLevel = await _battery.batteryLevel;
      final LocationSettings locationSettings = AndroidSettings(accuracy: LocationAccuracy.high, forceLocationManager: true, timeLimit: const Duration(seconds: 15));
      Position pos = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
      _setStatus(SOSStatus.locationFixed);
      
      msgBody += "\nMaps: https://maps.google.com/?q=${pos.latitude},${pos.longitude}";
      msgBody += "\nOSM: https://www.openstreetmap.org/?mlat=${pos.latitude}&mlon=${pos.longitude}";
      
      // Telemetría
      msgBody += "\n\n🔋Bat: $batteryLevel% | 📡Alt: ${pos.altitude.toStringAsFixed(0)}m | 🎯Acc: ${pos.accuracy.toStringAsFixed(0)}m";

    } catch (e) {
      msgBody += "\n(GPS Error/Timeout)";
    }

    int successCount = 0;
    for (String number in recipients) {
      try {
        final String result = await platform.invokeMethod('sendSMS', {"phone": number, "msg": msgBody});
        if (result == "OK") successCount++;
      } catch (e) { debugPrint("Error enviando: $e"); }
    }

    if (successCount > 0) {
      _setStatus(SOSStatus.sent);
      await platform.invokeMethod('sleepScreen');
      
      try {
        _audioPlayer = AudioPlayer();
        await _audioPlayer!.setAudioContext(AudioContext(
           android: AudioContextAndroid(
               isSpeakerphoneOn: true, 
               stayAwake: false, 
               contentType: AndroidContentType.sonification, 
               usageType: AndroidUsageType.media,
               audioFocus: AndroidAudioFocus.gainTransient
           ),
           iOS: AudioContextIOS(category: AVAudioSessionCategory.playback)
        ));
        await _audioPlayer!.setVolume(1.0); 
        await _audioPlayer!.play(AssetSource('sounds/send.mp3'));
      } catch(e) { debugPrint("Error beep send: $e"); }

      int interval = prefs.getUpdateInterval();
      if (interval > 0) _startPeriodicUpdates(interval, recipients);
    } else {
      _setStatus(SOSStatus.error, "Fallo SMS / SMS Failed");
    }
  }

  void _startPeriodicUpdates(int minutes, List<String> recipients) {
    if (recipients.isEmpty) return;
    String target = recipients.first; 
    _periodicUpdateTimer?.cancel();
    _periodicUpdateTimer = Timer.periodic(Duration(minutes: minutes), (timer) async {
      try {
        Position pos = await Geolocator.getCurrentPosition(timeLimit: const Duration(seconds: 20));
        String updateMsg = "📍 SEGUIMIENTO Oksigenia: Sigo en ruta / Still moving.";
        updateMsg += "\nMaps: https://maps.google.com/?q=${pos.latitude},${pos.longitude}";
        updateMsg += "\nOSM: https://www.openstreetmap.org/?mlat=${pos.latitude}&mlon=${pos.longitude}";
        await platform.invokeMethod('sendSMS', {"phone": target, "msg": updateMsg});
      } catch (e) { debugPrint("❌ Fallo update: $e"); }
    });
  }

  void _setStatus(SOSStatus s, [String? e]) { 
      _status = s; 
      if (s == SOSStatus.ready || s == SOSStatus.locationFixed) {
        _errorMessage = '';
      } else if (e != null) {
        _errorMessage = e; 
      }
      notifyListeners(); 
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _accelerometerSubscription?.cancel();
    _gpsSubscription?.cancel();
    _inactivityTimer?.cancel();
    _periodicUpdateTimer?.cancel();
    _healthCheckTimer?.cancel();
    _preAlertTimer?.cancel();
    _audioPlayer?.dispose();
    super.dispose();
  }
}