import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' hide ServiceStatus;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:oksigenia_sos/l10n/app_localizations.dart'; 
import '../services/preferences_service.dart';
import '../screens/settings_screen.dart'; 

import '../screens/alarm_screen.dart'; 
import '../screens/sent_screen.dart';  

final GlobalKey<NavigatorState> oksigeniaNavigatorKey = GlobalKey<NavigatorState>();

enum SOSStatus { ready, scanning, locationFixed, preAlert, sent, error }
enum AlertCause { manual, fall, inactivity, dyingGasp }

class SOSLogic extends ChangeNotifier with WidgetsBindingObserver {
  SOSStatus _status = SOSStatus.ready;
  String _errorMessage = '';
  static const platform = MethodChannel('com.oksigenia.sos/sms');
  
  static const double _impactThreshold = 12.0;

  bool _isFallDetectionActive = false;
  bool _isDyingGaspSent = false; 
  bool _isInactivityMonitorActive = false;
  
  AlertCause _lastTrigger = AlertCause.manual;
  AlertCause get lastTrigger => _lastTrigger;

  int _currentInactivityLimit = 3600; 
  int get currentInactivityLimit => _currentInactivityLimit;

  double _visualGForce = 1.0;
  DateTime _lastMovementTime = DateTime.now();
  DateTime _lastSensorPacket = DateTime.now();
  
  Timer? _inactivityTimer;
  Timer? _periodicUpdateTimer;
  StreamSubscription? _accelerometerSubscription;
  StreamSubscription? _gpsSubscription;
  StreamSubscription<ServiceStatus>? _serviceStatusSubscription;
  
  int _batteryLevel = 0;
  double _gpsAccuracy = 0.0;
  Timer? _healthCheckTimer;
  
  bool _gpsPermissionOk = false;
  bool _smsPermissionOk = false;
  bool _sensorsPermissionOk = false;
  bool _notifPermissionOk = false; 
  // 🔥 NUEVO: Variable para el permiso de superposición
  bool _overlayPermissionOk = false;

  int get batteryLevel => _batteryLevel;
  double get gpsAccuracy => _gpsAccuracy;
  bool get gpsPermissionOk => _gpsPermissionOk;
  bool get smsPermissionOk => _smsPermissionOk;
  bool get sensorsPermissionOk => _sensorsPermissionOk;
  bool get notifPermissionOk => _notifPermissionOk; 
  // 🔥 NUEVO: Getter
  bool get overlayPermissionOk => _overlayPermissionOk;

  Timer? _preAlertTimer;
  int _countdownSeconds = 30; 
  
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

  Future<void> init() async {
    WidgetsBinding.instance.addObserver(this);
    await _loadSettings();

    await _checkPermissions();
    final service = FlutterBackgroundService();
    if (!(await service.isRunning())) {
      await service.startService();
    }
    
    service.invoke("updateLanguage"); 
    
    service.on('force_ui_wake').listen((event) {
      debugPrint("SYLVIA UI: Recibida orden de despertar por impacto.");
      _triggerPreAlert(AlertCause.fall);
    });
    
    _startGForceMonitoring();
    _startHealthMonitor(); 
    _startPassiveGPS();
  }

  Future<bool> arePermissionsRestricted() async {
    bool smsRestricted = await Permission.sms.isPermanentlyDenied;
    bool locRestricted = await Permission.location.isPermanentlyDenied;
    return smsRestricted || locRestricted;
  }

  void _startHealthMonitor() {
    _checkHealth();
    _healthCheckTimer = Timer.periodic(const Duration(seconds: 2), (_) => _checkHealth());
  }

  Future<void> _checkHealth() async {
    try {
      _batteryLevel = await _battery.batteryLevel;
      
      bool locPerm = await Permission.location.isGranted;
      bool locService = await Geolocator.isLocationServiceEnabled();
      bool systemGpsOk = locPerm && locService;

      if (systemGpsOk) {
         if (_gpsSubscription == null) {
            _startPassiveGPS();
         }
         _gpsPermissionOk = true;
      } else {
         if (_gpsSubscription != null) {
            await _gpsSubscription?.cancel();
            _gpsSubscription = null; 
            _gpsAccuracy = 0.0;
         }
         _gpsPermissionOk = false;
      }

      _smsPermissionOk = await Permission.sms.isGranted;
      
      bool permActivity = await Permission.activityRecognition.isGranted;
      bool isSensorAlive = DateTime.now().difference(_lastSensorPacket).inSeconds < 4;
      _sensorsPermissionOk = await Permission.activityRecognition.isGranted && isSensorAlive;

      _notifPermissionOk = await Permission.notification.isGranted;

      // 🔥 NUEVO: Chequeo del permiso de superposición
      _overlayPermissionOk = await Permission.systemAlertWindow.isGranted;

      bool isSystemArmed = _isFallDetectionActive || _isInactivityMonitorActive;

      if (_batteryLevel <= 5 && !_isDyingGaspSent && emergencyContact != null && isSystemArmed) {
        _triggerDyingGasp();
      }
      
      notifyListeners();
    } catch(e) { debugPrint("Health Check Error: $e"); }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint("🔄 APP RESUMED: Reactivando sensores UI...");
      _startGForceMonitoring(); 
      _checkHealth();
      if (_status == SOSStatus.ready) _startPassiveGPS();
    } else if (state == AppLifecycleState.paused) {
      if (!_isInactivityMonitorActive && !_isFallDetectionActive) {
         _accelerometerSubscription?.cancel();
      } else {
         debugPrint("🛡️ Manteniendo sensores activos en segundo plano/bolsillo.");
      }
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

    try {
      Position? initialPos = await Geolocator.getLastKnownPosition();
      if (initialPos == null) {
         initialPos = await Geolocator.getCurrentPosition(
            timeLimit: const Duration(seconds: 2) 
         );
      }

      if (initialPos != null) {
        _gpsAccuracy = initialPos.accuracy;
        if (_status == SOSStatus.ready) _setStatus(SOSStatus.locationFixed);
        notifyListeners();
      }
    } catch (_) {}

    final LocationSettings locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0, 
        forceLocationManager: true, 
        intervalDuration: const Duration(seconds: 3)
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
    double lastG = 1.0;

    try {
      _accelerometerSubscription = accelerometerEventStream(samplingPeriod: SensorInterval.gameInterval)
        .listen((AccelerometerEvent event) {
          
          _lastSensorPacket = DateTime.now(); 

          double rawMagnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
          double instantG = rawMagnitude / 9.81;

          // Filtro de suavizado visual (Low-pass filter)
          if (instantG > _visualGForce) {
            _visualGForce = instantG; 
          } else {
            _visualGForce = (_visualGForce * 0.90) + (instantG * 0.10); 
          }

          double delta = (instantG - lastG).abs();
          lastG = instantG;

          // 🔥 AJUSTE CRÍTICO DE SENSIBILIDAD (v3.9.2)
          // Antes: 0.02 (Muy sensible, el viento reiniciaba el contador)
          // Ahora: 0.15 (Filtra viento/ramas, detecta pasos humanos)
          // Umbral G: Ampliado al 15% de desviación para ignorar inclinaciones suaves.
          
          bool isSignificantMovement = delta > 0.15 || instantG > 1.15 || instantG < 0.85;

          if (isSignificantMovement) {
             _lastMovementTime = DateTime.now();
          }

          // IMPACTO DURO (Mantenemos 12.0G por seguridad ante falsos positivos)
          if (_isFallDetectionActive && instantG > _impactThreshold && (_status == SOSStatus.ready || _status == SOSStatus.locationFixed)) {
            debugPrint("💥 IMPACTO DURO: ${instantG.toStringAsFixed(2)} G");
            _triggerPreAlert(AlertCause.fall);
          }
          
          notifyListeners();
        }, onError: (e) => debugPrint("Sensor Error: $e"));
        } catch (e) { debugPrint("Error: $e"); }
  }
  

  Future<void> _checkPermissions() async {
    await [
      Permission.location, 
      Permission.sms, 
      Permission.notification,
      Permission.activityRecognition,
      Permission.sensors,
      // 🔥 NO pedimos systemAlertWindow aquí para no saturar al inicio.
      // Lo pediremos solo si el usuario toca el icono de aviso.
    ].request();
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
    
    FlutterBackgroundService().invoke("updateLanguage");
    
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
    
    final service = FlutterBackgroundService();
    if (value) {
      if (!(await service.isRunning())) service.startService();
    }
    
    PreferencesService().saveInactivityState(value);
    
    service.invoke("updateLanguage");

    if (value) {
      _lastMovementTime = DateTime.now();
      _inactivityTimer?.cancel(); 
      _inactivityTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
        if (!_isInactivityMonitorActive) {
           timer.cancel();
           return;
        }
        if (_status != SOSStatus.ready && _status != SOSStatus.locationFixed) return;
        if (DateTime.now().difference(_lastMovementTime).inSeconds > _currentInactivityLimit) {
          debugPrint("💤 ALERTA: Inactividad detectada");
          _triggerPreAlert(AlertCause.inactivity);
        }
      });
    } else {
      _inactivityTimer?.cancel();
      if (_status == SOSStatus.preAlert && _lastTrigger == AlertCause.inactivity) {
        cancelAlert();
      }
    }
    notifyListeners();
  }

  void _triggerPreAlert(AlertCause cause) async {
    if (_status == SOSStatus.preAlert || _status == SOSStatus.scanning || _status == SOSStatus.sent) return;

    _lastTrigger = cause;
    _inactivityTimer?.cancel();
    
    try { _audioPlayer?.stop(); _audioPlayer?.dispose(); } catch(_) {}

    // 1. ORDEN DE TRAER AL FRENTE
    try {
      await platform.invokeMethod('bringToFront');
    } catch(e) {
      debugPrint("Error bringing to front: $e");
    }

    // 2. ENCENDER PANTALLA (Nativo)
    try { 
        WakelockPlus.enable(); 
        await platform.invokeMethod('wakeScreen'); 
    } catch(_) {}
    
    _startPassiveGPS(); 

    _status = SOSStatus.preAlert; 
    _countdownSeconds = 30; 
    _currentVolume = 0.2;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    oksigeniaNavigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => const AlarmScreen()) 
    );

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

    _preAlertTimer?.cancel();
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

  Future<void> _triggerDyingGasp() async {
    _isDyingGaspSent = true; 
    debugPrint("🪫 DYING GASP ACTIVADO: Batería crítica");

    final prefs = PreferencesService();
    final List<String> recipients = prefs.getContacts();
    if (recipients.isEmpty) return;

    final sharedPrefs = await SharedPreferences.getInstance();
    String langCode = sharedPrefs.getString('language_code') ?? 'en';
    final t = await AppLocalizations.delegate.load(Locale(langCode));
    
    try {
      Position pos = await Geolocator.getCurrentPosition(
        timeLimit: const Duration(seconds: 5)
      ).catchError((_) async {
        return await Geolocator.getLastKnownPosition() ?? Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0); 
      });

      String link = "http://maps.google.com/?q=${pos.latitude},${pos.longitude}";
      
      String rawMsg = t.panicMessage(link);
      rawMsg = rawMsg.replaceAll("Respira > Inspira > Crece;", "").trim();
      
      String msg = "⚠️ LOW BATTERY (<5%).\n$rawMsg";
      
      for (String number in recipients) {
        await platform.invokeMethod('sendSMS', {"phone": number, "msg": msg});
      }
    } catch (e) {
      debugPrint("❌ Fallo en Dying Gasp: $e");
    }
  }

  void cancelAlert() async {
    _stopAllAlerts();
    
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancel(id: 888);

    _status = SOSStatus.ready;
    _lastMovementTime = DateTime.now();
    
    if (_isInactivityMonitorActive) {
      toggleInactivityMonitor(true);
    }
    
    final service = FlutterBackgroundService();
    service.invoke("updateLanguage");

    if (_status == SOSStatus.ready) _startPassiveGPS();
    try { await platform.invokeMethod('sleepScreen'); } catch(_) {}
    
    if (oksigeniaNavigatorKey.currentState?.canPop() ?? false) {
      oksigeniaNavigatorKey.currentState?.pop();
    }
    
    notifyListeners();
  }

  void _stopAllAlerts() {
    _preAlertTimer?.cancel();
    _periodicUpdateTimer?.cancel();
    
    if (_audioPlayer != null) {
      try {
        _audioPlayer!.stop();
        _audioPlayer!.dispose();
      } catch (e) {
        debugPrint("Error parando audio: $e");
      }
      _audioPlayer = null; 
    }
    
    try { Vibration.cancel(); } catch(_) {}
  }

  Future<void> sendSOS() async {
    if (_status == SOSStatus.scanning || _status == SOSStatus.sent) return;

    final prefs = PreferencesService();
    final List<String> recipients = prefs.getContacts();
    final String customNote = prefs.getSosMessage();

    _isInactivityMonitorActive = false;
    _inactivityTimer?.cancel();
    prefs.saveInactivityState(false);

    if (recipients.isEmpty) {
      _setStatus(SOSStatus.error, "NO_CONTACT");
      return;
    }
    
    _setStatus(SOSStatus.scanning);
    _gpsSubscription?.cancel();
    
    final sharedPrefs = await SharedPreferences.getInstance();
    String langCode = sharedPrefs.getString('language_code') ?? 'en';
    final t = await AppLocalizations.delegate.load(Locale(langCode));

    int batteryLevel = await _battery.batteryLevel;
    String msgBody = "";
    
    try {
      final LocationSettings locationSettings = AndroidSettings(accuracy: LocationAccuracy.high, forceLocationManager: true, timeLimit: const Duration(seconds: 15));
      Position pos = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
      
      _setStatus(SOSStatus.sent);
      
      String mapsLink = "http://maps.google.com/?q=${pos.latitude},${pos.longitude}";
      String osmLink = "https://www.openstreetmap.org/?mlat=${pos.latitude}&mlon=${pos.longitude}";
      
      String combinedLinks = "$mapsLink\n----------------\nOSM: $osmLink";
      
      String rawMsg = t.panicMessage(combinedLinks);
      rawMsg = rawMsg.replaceAll("Respira > Inspira > Crece;", "");
      msgBody = rawMsg.trim();
      
      msgBody += "\n\n🔋Bat: $batteryLevel% | 📡Alt: ${pos.altitude.toStringAsFixed(0)}m | 🎯Acc: ${pos.accuracy.toStringAsFixed(0)}m";
      if (customNote.isNotEmpty) msgBody += "\nNote: $customNote";

    } catch (e) {
      _setStatus(SOSStatus.sent);
      String rawMsg = t.panicMessage("NO GPS DATA");
      rawMsg = rawMsg.replaceAll("Respira > Inspira > Crece;", "").trim();
      msgBody = rawMsg;
      msgBody += "\n\n🔋Bat: $batteryLevel%";
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
      
      oksigeniaNavigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => const SentScreen())
      );
      
      try {
        await Future.delayed(const Duration(milliseconds: 500)); 
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

      await Future.delayed(const Duration(seconds: 2));
      await platform.invokeMethod('sleepScreen');
      
    } else {
      _setStatus(SOSStatus.error, "SMS Failed");
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
        
        updateMsg += "\nMaps: http://maps.google.com/?q=${pos.latitude},${pos.longitude}";
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
    _serviceStatusSubscription?.cancel();
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