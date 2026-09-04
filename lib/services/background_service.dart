import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:another_telephony/telephony.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../logic/activity_profile.dart';
import '../utils/phone_utils.dart';
import '../utils/sms_splitter.dart';
import 'package:oksigenia_sms/oksigenia_sms.dart';
import '../utils/geo_links.dart';
import 'preferences_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Canal nuevo (no 'my_foreground'): el viejo se creó CON sonido y los canales
// son inmutables; no se puede borrar mientras el foreground service lo usa. Un
// id nuevo nace silencioso (playSound:false) sin pelear con el existente.
const String channelId = 'oksigenia_service';
const String alarmChannelId = 'oksigenia_alarm';
const int notificationId = 888;
const int alarmNotifId = 890;
const int _liveTrackingAlarmId = 891;
const int _liveTrackingShutdownAlarmId = 892;

// 🟢 CAMBIO: AudioPlayer ahora es dinámico, no estático
AudioPlayer? _audioPlayer;
final Telephony _telephony = Telephony.instance;
final Battery _battery = Battery();

// File logger for Smart Sentinel events. Writes to external scoped storage so
// we can pull it without run-as (release APKs block run-as):
//   adb pull /sdcard/Android/data/com.oksigenia.oksigenia_sos/files/sentinel.log
// On first run after upgrading, migrates any pre-existing internal log.
File? _sentinelLogFile;
bool _sentinelLogMigrated = false;

void _logSentinel(String line) {
  print(line);
  // El timestamp se captura AQUÍ (no dentro del append encolado) para que la
  // hora refleje el evento y no el momento en que la cola llegó a escribirlo.
  final ts = DateTime.now().toIso8601String();
  // Escrituras serializadas: dos streams de sensores loguean concurrentemente
  // (FREEFALL + Impacto coinciden por diseño) y los appends async sin orden
  // entrelazaban bytes, mutilando justo las líneas que hay que correlacionar.
  _sentinelLogChain = _sentinelLogChain.then((_) => _sentinelLogAppend('$ts $line'));
}

Future<void> _sentinelLogChain = Future.value();

Future<void> _sentinelLogAppend(String line) async {
  try {
    if (_sentinelLogFile == null) {
      Directory? dir = await getExternalStorageDirectory();
      dir ??= await getApplicationDocumentsDirectory();
      _sentinelLogFile = File('${dir.path}/sentinel.log');

      if (!_sentinelLogMigrated) {
        _sentinelLogMigrated = true;
        try {
          final prefs = await SharedPreferences.getInstance();
          if (!(prefs.getBool('sentinel_migrated_v2') ?? false)) {
            final internalDir = await getApplicationDocumentsDirectory();
            final internalLog = File('${internalDir.path}/sentinel.log');
            final bool internalExists = internalLog.existsSync();
            final int internalSize = internalExists ? internalLog.lengthSync() : 0;
            print("SENTINEL MIGRATE: internal=$internalExists size=$internalSize path=${internalLog.path}");
            if (internalExists &&
                internalLog.absolute.path != _sentinelLogFile!.absolute.path) {
              final bytes = internalLog.readAsBytesSync();
              _sentinelLogFile!.writeAsBytesSync(
                bytes,
                mode: FileMode.append,
                flush: true,
              );
              print("SENTINEL MIGRATE: copied $internalSize bytes to ${_sentinelLogFile!.path}");
            }
            await prefs.setBool('sentinel_migrated_v2', true);
          }
        } catch (e) {
          print("SENTINEL MIGRATE err: $e");
        }
      }
    }
    await _sentinelLogFile!
        .writeAsString('$line\n', mode: FileMode.append, flush: true);
  } catch (e) {
    print("SENTINEL LOG err: $e");
  }
}

// Variables de Configuración
List<String> _recipients = [];
String _customMessage = "";
Map<String, String> _texts = {
  'alertFallDetected': 'IMPACT DETECTED!',
  'holdToCancel': 'Hold to cancel',
  'alertSendingIn': 'Sending alert in...',
  'statusSent': 'Alert sent successfully.',
  'statusSendFailed': '⚠️ SOS NOT SENT',
  'statusSendFailedBody': 'No SMS could be sent. Check signal and contacts, then retry.',
  'statusReady': 'Oksigenia System Ready.',
  'smsHelpMessage': 'HELP! SOS!',
  'smsDyingGasp': 'BATTERY CRITICAL. Bye.',
  'pauseTitle': 'Monitoring paused',
  'resumesIn': 'Resumes in',
  'resumeNow': 'Resume now',
  'smsBeaconHeader': '📍 OKSIGENIA SOS — automatic follow-up to my emergency alert (this is NOT a new alarm). My updated location:',
  'smsBeaconDistance': 'from the point where the SOS was sent.',
};

// Smart Beacon: post-SOS position-update SMS protocol.
// Activates when an SOS SMS is sent (auto via _enviarSMSZombie or manual via
// UI sendSOS). Real outdoor rescues take 2–4 hours to arrive; the victim
// may wander, flee, or be carried during that time. If they move >300 m
// from the last reference point, send an update SMS with the new position
// so rescuers always have fresh coordinates. Throttled to one SMS every
// 5 minutes; capped at 20 updates over a 4-hour window. Stops automatically
// after the window or when the user taps "Restart system" on SentScreen.
const double _beaconDistanceM = 300.0;
const int _beaconMinIntervalSeconds = 300;
const int _beaconMaxUpdates = 20;
const int _beaconWindowSeconds = 14400;

// Variables Globales
Timer? _zombieTimer;
DateTime _lastStopTimestamp = DateTime.fromMillisecondsSinceEpoch(0);

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  // Canal del servicio: defaultImportance para seguir VISIBLE (fuera del grupo
  // de silenciosas en GrapheneOS), pero SIN sonido ni vibración. Una notif de
  // monitoreo persistente no debe sonar; antes "sonaba sólo la 1ª vez" gracias a
  // ONLY_ALERT_ONCE, pero cualquier re-emisión (cada setAsForeground/cambio de
  // estado) volvía a sonar. Quitando el sonido del canal, no suena jamás.
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    channelId,
    'Oksigenia SOS Service',
    description: 'Running in background monitoring sensors',
    importance: Importance.defaultImportance,
    playSound: false,
    enableVibration: false,
  );

  const AndroidNotificationChannel alarmChannel = AndroidNotificationChannel(
    'oksigenia_alarm',
    'Oksigenia SOS Alarm',
    description: 'Emergency lock-screen alarms',
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    // Limpiar el canal viejo 'my_foreground' (creado con sonido) que queda
    // huérfano al migrar al nuevo canal silencioso.
    await androidPlugin?.deleteNotificationChannel(channelId: 'my_foreground');
    await androidPlugin?.createNotificationChannel(channel);
    await androidPlugin?.createNotificationChannel(alarmChannel);
  }

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      notificationChannelId: channelId,
      foregroundServiceNotificationId: 888,
      initialNotificationTitle: 'Oksigenia SOS',
      initialNotificationContent: 'System Initializing...',
      autoStart: true,
      // autoStartOnBoot OFF: el autostart del plugin es incondicional y revive
      // el servicio en CADA reinicio (con su wakelock) aunque no haya nada que
      // vigilar → batería drenada en vacío. En su lugar, OksigeniaBootReceiver
      // arranca Sylvia tras el boot SOLO si hay monitoreo/beacon/alarma activos.
      autoStartOnBoot: false,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  // First log line of every service-isolate spawn. If we see this between an
  // impact and an alarm, Android killed and respawned the service mid-yellow.
  _logSentinel("SYLVIA SERVICE: 🚀 onStart entered (isolate spawn)");

  // B5: cargar la BD de zonas horarias una sola vez por spawn del isolate, no en
  // cada programación de AlarmClock (hasta 1/min en movimiento).
  tz.initializeTimeZones();

  const MethodChannel platform = MethodChannel('com.oksigenia.sos/sms');
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  int _zombieCountdown = 30;
  StreamSubscription? _accSub;
  StreamSubscription? _rawAccSub;

  bool _isMonitoringImpact = false;
  bool _isMonitoringInactivity = false;
  bool _isAlarmActive = false;

  DateTime _lastMovementTime = DateTime.now();
  int _inactivityLimitSeconds = 3600;
  Timer? _inactivityCheckTimer;

  // AlarmClock anti-Doze
  const int _inactivityAlarmNotifId = 889;
  DateTime _lastAlarmReschedule = DateTime.fromMillisecondsSinceEpoch(0);

  // Timed pause
  DateTime _pausedUntil = DateTime.fromMillisecondsSinceEpoch(0);

  // Live Tracking
  bool _isLiveTrackingActive = false;
  int _liveTrackingIntervalSeconds = 1800;
  DateTime _liveTrackingNextSend = DateTime.fromMillisecondsSinceEpoch(0);

  bool _sensorCooldown = false;
  // Smart Sentinel runtime parameters (mutable — driven by activity profile).
  // Defaults match the Trekking baseline; setMonitoring overrides on demand.
  double _yellowThreshold = 6.0;
  double _orangeThreshold = 12.0;
  int _settlingSeconds = 5;
  int _observationSeconds = 60;
  double _cvUpperBound = 1.30;
  bool _impactDetectionEnabled = true;
  double _lastG = 1.0;
  final List<double> _gBuffer = [];
  // Effective sample rate of the userAccelerometer stream. Android negotiates
  // SensorInterval.gameInterval (~50Hz target) but actually delivers anywhere
  // from 50–200Hz. Updated once per second from inside the listener.
  double _measuredHz = 50.0;
  bool _sentinelYellow = false;
  int _yellowCountdown = 60;
  Timer? _yellowTimer;
  Timer? _shieldTimer;

  // A1: liveness de los dos streams de acelerómetro. El watchdog de 5s los
  // resuscribe si dejan de emitir — si un stream muere en silencio, la
  // detección desaparece mientras la notificación sigue diciendo "protegido".
  DateTime _lastRawSample = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _lastUserSample = DateTime.fromMillisecondsSinceEpoch(0);
  // A2: GPS calentado durante la cuenta atrás de la alarma (30s de warmup) para
  // no pedir un fix en frío con 5s de margen justo cuando sale el SOS.
  StreamSubscription<Position>? _warmGpsSub;
  Position? _warmPos;
  // A3: throttle del sondeo GPS del beacon + guard de tick concurrente.
  DateTime _beaconLastProbe = DateTime.fromMillisecondsSinceEpoch(0);
  bool _beaconTickBusy = false;

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_stat_oksigenia');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
    onDidReceiveNotificationResponse: (details) async {
      if (details.actionId == 'resume_monitoring') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('pause_resume_requested', DateTime.now().millisecondsSinceEpoch);
      }
    },
    onDidReceiveBackgroundNotificationResponse: _handleNotificationAction,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
        'oksigenia_alarm',
        'Oksigenia SOS Alarm',
        description: 'Emergency lock-screen alarms',
        importance: Importance.max,
      ));

  // ---------------------------------------------------------------------------
  // 1. GESTIÓN DE AUDIO ROBUSTA (Crear y Destruir)
  // ---------------------------------------------------------------------------
  
  Future<void> _reproducirSonidoAlarma() async {
    try {
      // Matar anterior si existe
      await _audioPlayer?.stop();
      await _audioPlayer?.dispose();
      _audioPlayer = null;

      // Crear nuevo fresco
      _audioPlayer = AudioPlayer();
      
      await _audioPlayer!.setAudioContext(AudioContext(
        android: AudioContextAndroid(
            isSpeakerphoneOn: true,
            stayAwake: true,
            contentType: AndroidContentType.sonification,
            usageType: AndroidUsageType.alarm,
            audioFocus: AndroidAudioFocus.gain),
        iOS: AudioContextIOS(category: AVAudioSessionCategory.playback),
      ));
      
      await _audioPlayer!.setVolume(1.0);
      await _audioPlayer!.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer!.play(AssetSource('sounds/alarm.mp3'));
    } catch (e) {
      print("SYLVIA AUDIO ERROR: $e");
    }
  }

  Future<void> _detenerSonido() async {
    final player = _audioPlayer;
    _audioPlayer = null;
    try { await player?.stop(); } catch (_) {}
    try { await player?.dispose(); } catch (_) {}
  }

  Future<void> _reproducirConfirmacion() async {
    final old = _audioPlayer;
    _audioPlayer = null;
    try { await old?.stop(); } catch (_) {}
    try { await old?.dispose(); } catch (_) {}
    try {
      _audioPlayer = AudioPlayer();
      await _audioPlayer!.setVolume(1.0);
      await _audioPlayer!.play(AssetSource('sounds/send.mp3'));
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // 2. FUNCIONES AUXILIARES
  // ---------------------------------------------------------------------------

  void _activarEscudo({int segundos = 3}) {
    _sensorCooldown = true;
    _shieldTimer?.cancel();
    _shieldTimer = Timer(Duration(seconds: segundos), () => _sensorCooldown = false);
  }

  Future<void> _scheduleInactivityAlarmClock() async {
    if (!_isMonitoringInactivity) return;
    try {
      final scheduledDate = tz.TZDateTime.now(tz.UTC).add(Duration(seconds: _inactivityLimitSeconds));
      await flutterLocalNotificationsPlugin.cancel(id: _inactivityAlarmNotifId);
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: _inactivityAlarmNotifId,
        title: "🚨 OKSIGENIA SOS",
        body: _texts['holdToCancel'] ?? 'Hold to cancel',
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            alarmChannelId, 'Oksigenia SOS Alarm',
            icon: 'ic_stat_oksigenia',
            importance: Importance.max,
            priority: Priority.max,
            fullScreenIntent: true,
            color: Color(0xFFFF0000),
            playSound: false,
            enableVibration: false,
            category: AndroidNotificationCategory.alarm,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('inactivity_alarm_scheduled_for', scheduledDate.millisecondsSinceEpoch);
      _lastAlarmReschedule = DateTime.now();
      print("SYLVIA: ⏰ AlarmClock programado en ${_inactivityLimitSeconds}s");
    } catch (e) {
      // C1: se usa inexactAllowWhileIdle (no alarmClock) — así el plugin NO llama
      // a canScheduleExactAlarms() y no lanza sin permiso de alarma exacta, que
      // era lo que dejaba la capa anti-Doze sin programar en Android 12+. El
      // sistema puede retrasar la alarma unos minutos en Doze; irrelevante para
      // un umbral de inactividad de 1h. _logSentinel (no print) para que
      // cualquier fallo futuro quede en el log — este catch mudo ocultó C1.
      _logSentinel("SYLVIA: ❌ Error al programar alarma de inactividad: $e");
    }
  }

  Future<void> _cancelInactivityAlarmClock() async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id: _inactivityAlarmNotifId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('inactivity_alarm_scheduled_for', 0);
    } catch (_) {}
  }

  Future<void> _scheduleLiveTrackingAlarm() async {
    try {
      final scheduledDate = tz.TZDateTime.now(tz.UTC).add(Duration(seconds: _liveTrackingIntervalSeconds));
      _liveTrackingNextSend = scheduledDate;
      await flutterLocalNotificationsPlugin.cancel(id: _liveTrackingAlarmId);
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: _liveTrackingAlarmId,
        title: "📍 Live Tracking",
        body: "Sending position update...",
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            alarmChannelId, 'Oksigenia SOS Alarm',
            icon: 'ic_stat_oksigenia',
            importance: Importance.low,
            priority: Priority.low,
            playSound: false,
            enableVibration: false,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('live_tracking_next_send', scheduledDate.millisecondsSinceEpoch);
      print("SYLVIA: 📍 Live Tracking alarm scheduled in ${_liveTrackingIntervalSeconds}s");
    } catch (e) {
      _logSentinel("SYLVIA: ❌ Live Tracking alarm error: $e");
    }
  }

  Future<void> _cancelLiveTrackingAlarm() async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id: _liveTrackingAlarmId);
      await flutterLocalNotificationsPlugin.cancel(id: _liveTrackingShutdownAlarmId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('live_tracking_next_send', 0);
    } catch (_) {}
  }

  Future<void> _scheduleShutdownReminder(int afterSeconds) async {
    try {
      final scheduledDate = tz.TZDateTime.now(tz.UTC).add(Duration(seconds: afterSeconds));
      await flutterLocalNotificationsPlugin.cancel(id: _liveTrackingShutdownAlarmId);
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: _liveTrackingShutdownAlarmId,
        title: "⏰ Oksigenia SOS",
        body: "Live Tracking shutdown reminder. Open app to continue.",
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            alarmChannelId, 'Oksigenia SOS Alarm',
            icon: 'ic_stat_oksigenia',
            importance: Importance.high,
            priority: Priority.high,
            playSound: false,
            enableVibration: false,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
      print("SYLVIA: ⏰ Shutdown reminder scheduled in ${afterSeconds}s");
    } catch (e) {
      _logSentinel("SYLVIA: ❌ Shutdown reminder error: $e");
    }
  }

  // Fallback Fase 1: varios SMS con sendTextMessage (isMultipart:false) por
  // pieza (sms_splitter, sin partir enlaces). La vía validada en v4.3.0.
  // Declarada ANTES de _sendSmsTracked: las funciones locales de onStart no se
  // hoisted.
  Future<bool> _sendSplitFallback(String to, String message) async {
    final parts = splitSmsSafely(message);
    int ok = 0;
    for (final part in parts) {
      try {
        await _telephony.sendSms(to: to, message: part, isMultipart: false);
        ok++;
      } catch (e) {
        _logSentinel("SYLVIA SMS: ❌ fallback pieza ${ok + 1}/${parts.length} a $to: $e");
      }
    }
    if (ok < parts.length) {
      _logSentinel("SYLVIA SMS: ⚠️ fallback envió $ok/${parts.length} piezas a $to");
    }
    return ok > 0;
  }

  // Envía un SMS y ADEMÁS registra en el log si el radio llega a confirmarlo.
  // Devuelve true si se entregó a SmsManager sin excepción (misma semántica que
  // antes: "encolado"). OJO — techo conocido del plugin: su BroadcastReceiver
  // reenvía SMS_SENT sin mirar el resultCode, así que la confirmación significa
  // "el radio lo procesó" (éxito O error), no "entregado". No bloquea el envío:
  // el statusListener escribe en el log de forma asíncrona cuando llega la
  // confirmación. El listener del plugin es un campo compartido, por eso los
  // envíos SIEMPRE deben ser secuenciales (nunca en paralelo).
  Future<bool> _sendSmsTracked(String to, String message) async {
    // Fase 2 (#12): primario = plugin propio → UN SMS concatenado, sin
    // READ_PHONE_STATE, con resultCode. Si el plugin FALLA (excepción o código
    // de error), fallback al troceo de la Fase 1 (varios SMS, ya validado en
    // v4.3.0). 'unknown' = entregado sin acuse dentro del timeout (ver EXP5) →
    // se cuenta como enviado, sin re-enviar (evita SMS duplicados).
    try {
      final r = await OksigeniaSms.send(to: to, message: message);
      if (r.status == OksigeniaSmsStatus.failed) {
        _logSentinel("SYLVIA SMS: ⚠️ plugin falló (${r.error}) → fallback a troceo");
        return _sendSplitFallback(to, message);
      }
      _logSentinel("SYLVIA SMS: 📶 ${r.status.name} (${r.okParts}/${r.parts}) a $to");
      return true;
    } catch (e) {
      _logSentinel("SYLVIA SMS: ❌ excepción del plugin ($e) → fallback a troceo");
      return _sendSplitFallback(to, message);
    }
  }

  Future<void> _sendLiveTrackingSMS({bool isCheckin = false}) async {
    if (_recipients.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      _recipients = prefs.getStringList(PreferencesService.keyContacts) ?? [];
      if (_recipients.isEmpty) {
        print("SYLVIA: ❌ Live Tracking sin contactos. Reprogramando siguiente intento.");
        if (_isLiveTrackingActive && !isCheckin) await _scheduleLiveTrackingAlarm();
        return;
      }
    }

    String target = normalizePhoneE164(_recipients.first);
    int batteryLevel = 0;
    try { batteryLevel = await _battery.batteryLevel; } catch (_) {}

    String header = isCheckin
        ? "✅ I'M OK — Oksigenia SOS"
        : "📍 LIVE TRACKING — Oksigenia SOS";

    String msgBody = header;
    if (_customMessage.isNotEmpty && !isCheckin) {
      msgBody += "\n$_customMessage";
    }

    try {
      Position? pos;
      try {
        pos = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 8)));
      } catch (_) {
        pos = await Geolocator.getLastKnownPosition();
      }
      if (pos != null) {
        msgBody += "\n${geoLinks(pos.latitude, pos.longitude)}";
        msgBody += "\n\n🔋Bat: $batteryLevel% | 📡Alt: ${pos.altitude.toStringAsFixed(0)}m | 🎯Acc: ${pos.accuracy.toStringAsFixed(0)}m";
      } else {
        msgBody += "\n(No GPS)\n\n🔋Bat: $batteryLevel%";
      }
    } catch (_) {
      msgBody += "\n(GPS Error)\n\n🔋Bat: $batteryLevel%";
    }

    await _sendSmsTracked(target, msgBody);

    service.invoke("onLiveTrackingSent");

    if (_isLiveTrackingActive && !isCheckin) {
      await _scheduleLiveTrackingAlarm();
    }
  }

  void _updatePausedNotification() {
    final remaining = _pausedUntil.difference(DateTime.now());
    final totalMin = remaining.inMinutes;
    final secs = remaining.inSeconds % 60;
    final timeStr = totalMin > 0 ? "${totalMin}m ${secs.toString().padLeft(2, '0')}s" : "${remaining.inSeconds}s";
    final pauseLabel = _texts['pauseTitle'] ?? 'Monitoring paused';
    final resumesInLabel = _texts['resumesIn'] ?? 'Resumes in';
    final resumeNowLabel = _texts['resumeNow'] ?? 'Resume now';
    flutterLocalNotificationsPlugin.show(
      id: notificationId,
      title: "⏸ Oksigenia SOS — $pauseLabel",
      body: "$resumesInLabel $timeStr",
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channelId, 'Oksigenia SOS',
          icon: 'ic_stat_oksigenia',
          ongoing: true,
          importance: Importance.low,
          priority: Priority.low,
          onlyAlertOnce: true,
          playSound: false,
          enableVibration: false,
          actions: [
            AndroidNotificationAction(
              'resume_monitoring',
              resumeNowLabel,
              showsUserInterface: false,
              cancelNotification: false,
            ),
          ],
        ),
      ),
    );
  }

  // ÚNICA fuente de verdad de si Sylvia tiene algún motivo para seguir viva.
  // El foreground service mantiene un wakelock permanente del plugin mientras
  // exista; si no hay nada activo, ese wakelock drena la batería sin dar
  // protección a cambio. En montaña (sin WiFi → módem activo; con movimiento →
  // sin Doze profundo que enmascare el wakelock) eso son horas de batería
  // perdidas, y sin batería no hay SOS. Conservador a propósito: ante la duda,
  // seguir viva (un falso "parar" tiraría la protección a mitad de rescate).
  Future<bool> _shouldStayAlive() async {
    if (_isMonitoringImpact || _isMonitoringInactivity ||
        _isLiveTrackingActive || _isAlarmActive) {
      return true;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      if (prefs.getBool('beacon_active') ?? false) return true;
    } catch (_) {
      return true; // si no se pueden leer prefs, pecar de seguir viva
    }
    return false;
  }

  // Detiene el foreground service (liberando el wakelock permanente del plugin)
  // si no queda ningún motivo para seguir vivo. Devuelve true si detuvo.
  Future<bool> _stopIfIdle(String reason) async {
    if (await _shouldStayAlive()) return false;
    _logSentinel("SYLVIA SERVICE: 🌙 Nada activo ($reason) → deteniendo servicio y liberando wakelock");
    _accSub?.cancel(); _accSub = null;
    _rawAccSub?.cancel(); _rawAccSub = null;
    _inactivityCheckTimer?.cancel();
    _zombieTimer?.cancel();
    _yellowTimer?.cancel();
    _shieldTimer?.cancel();
    await _cancelInactivityAlarmClock();
    await _cancelLiveTrackingAlarm();
    try { await flutterLocalNotificationsPlugin.cancelAll(); } catch (_) {}
    // El wakelock del plugin (estático, PARTIAL_WAKE_LOCK) solo se libera cuando
    // el PROCESO muere: el plugin hace acquire() pero nunca release(). Por eso
    // hay que detener el servicio de verdad (stopSelf → isManuallyStopped, sin
    // watchdog que lo reviva), igual que el handler de "cerrar". Con la UI en
    // primer plano el proceso no muere aún (la UI lo sostiene); el wakelock se
    // suelta en cuanto la app pasa a segundo plano / se cierra. NO usar
    // setAsBackgroundService: dejaba config.isForeground=false persistido y al
    // rearrancar tras boot el servicio no llamaba startForeground → crash; y la
    // re-promoción que lo arreglaba reemitía la notif del plugin (hojita + sonido).
    service.stopSelf();
    return true;
  }

  Future<void> _activateBeacon(Position originPos) async {
    try {
      final p = await SharedPreferences.getInstance();
      final now = DateTime.now().millisecondsSinceEpoch;
      await p.setBool('beacon_active', true);
      await p.setDouble('beacon_origin_lat', originPos.latitude);
      await p.setDouble('beacon_origin_lon', originPos.longitude);
      await p.setInt('beacon_origin_ts', now);
      await p.setDouble('beacon_last_lat', originPos.latitude);
      await p.setDouble('beacon_last_lon', originPos.longitude);
      await p.setInt('beacon_last_ts', now);
      await p.setInt('beacon_count', 0);
      await p.setBool('beacon_origin_pending', false);
      _logSentinel("SYLVIA SERVICE: 📍 Beacon activated at ${originPos.latitude.toStringAsFixed(5)},${originPos.longitude.toStringAsFixed(5)}");
    } catch (e) {
      print("SYLVIA: Beacon activate error: $e");
    }
  }

  // M5: beacon armado sin fix de origen. Usa la hora de activación como origin_ts
  // (para que la ventana de 4h cuente desde el SOS) pero sin coordenadas: el
  // primer fix que consiga _beaconTick será el origen y se enviará de inmediato.
  Future<void> _activateBeaconPendingOrigin() async {
    try {
      final p = await SharedPreferences.getInstance();
      final now = DateTime.now().millisecondsSinceEpoch;
      await p.setBool('beacon_active', true);
      await p.setBool('beacon_origin_pending', true);
      await p.setInt('beacon_origin_ts', now);
      await p.setInt('beacon_last_ts', now);
      await p.setInt('beacon_count', 0);
      _beaconLastProbe = DateTime.fromMillisecondsSinceEpoch(0);
      _logSentinel("SYLVIA SERVICE: 📍 Beacon armed (origin pending — SOS sent without GPS)");
    } catch (e) {
      print("SYLVIA: Beacon pending-origin activate error: $e");
    }
  }

  // A2: arranca un stream de GPS al empezar la alarma para tener un fix caliente
  // cuando venza la cuenta atrás. Antes: 60s de amarillo + 30s de cuenta atrás
  // sin pedir GPS y, al final, un getCurrentPosition en frío con 5s → timeout →
  // lastKnown de horas. Ahora la cuenta atrás ES la ventana de calentamiento.
  void _startGpsWarmup() {
    _warmGpsSub?.cancel();
    _warmPos = null;
    try {
      _warmGpsSub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high, distanceFilter: 0),
      ).listen((p) => _warmPos = p, onError: (_) {});
    } catch (_) {}
  }

  void _stopGpsWarmup() {
    _warmGpsSub?.cancel();
    _warmGpsSub = null;
  }

  // Devuelve cuántos SMS salieron de verdad; 0 = el SOS NO se envió y el
  // llamante debe avisar de fallo en vez de fingir éxito.
  Future<int> _enviarSMSZombie() async {
    print("SYLVIA SERVICE: 🧟 TIEMPO AGOTADO. Ejecutando protocolo...");

    if (_recipients.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      _recipients = prefs.getStringList(PreferencesService.keyContacts) ?? [];
      if (_recipients.isEmpty) {
         _logSentinel("SYLVIA FATAL: No hay contactos configurados.");
         return 0;
      }
    }

    // Nota (personalizada o de ayuda): se compone aquí pero se coloca DESPUÉS
    // del enlace de Maps, para que las coordenadas viajen en el primer SMS.
    final String note = _customMessage.isNotEmpty
        ? _customMessage
        : (_texts['smsHelpMessage'] ?? 'HELP! SOS!');

    // #12: sin emojis en el cuerpo del SMS — fuerzan UCS-2 (67 chars/SMS) y
    // multiplican las piezas; en texto plano el SMS es GSM (152). Ver sms_splitter.
    String msgBody = "SOS OKSIGENIA";

    int batteryLevel = 0;
    try {
      batteryLevel = await _battery.batteryLevel;
    } catch (_) {}

    Position? sosPos;
    bool posIsStale = false;
    try {
      // A2: primero el fix caliente del warmup si es reciente; si no, pedir uno
      // nuevo con margen amplio (15s, no 5 en frío); y como último recurso el
      // lastKnown, etiquetando su antigüedad más abajo.
      if (_warmPos != null &&
          DateTime.now().difference(_warmPos!.timestamp).inSeconds < 40) {
        sosPos = _warmPos;
      } else {
        try {
          sosPos = await Geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(
                  accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 15)));
        } catch (_) {
          sosPos = await Geolocator.getLastKnownPosition();
          posIsStale = sosPos != null;
        }
      }
      if (sosPos != null) {
        final int fixAgeSec = DateTime.now().difference(sosPos.timestamp).inSeconds;
        // Un fix de hace minutos presentado como "posición actual" es peligroso
        // en un rescate: si viene del lastKnown o es viejo, decir de cuándo es.
        final String ageNote = (posIsStale || fixAgeSec > 90)
            ? " | ${(fixAgeSec / 60).round()}min"
            : "";
        // La nota del usuario justo bajo la cabecera (se lee primero); después
        // el bloque de ubicación (geo: + Google + OSM) y la línea técnica.
        msgBody += "\n$note";
        msgBody += "\n${geoLinks(sosPos.latitude, sosPos.longitude)}";
        msgBody += "\nBat: $batteryLevel% | Alt: ${sosPos.altitude.toStringAsFixed(0)}m | Acc: ${sosPos.accuracy.toStringAsFixed(0)}m$ageNote";
      } else {
        msgBody += "\n$note";
        msgBody += "\n(GPS Error/Timeout)";
        msgBody += "\nBat: $batteryLevel% (No Loc)";
      }
    } catch (e) {
      print("SYLVIA ERROR: GPS Falló ($e). Enviando sin loc.");
      msgBody += "\n$note";
      msgBody += "\n(GPS Error/Timeout)";
      msgBody += "\nBat: $batteryLevel% (No Loc)";
    }

    // M3: la adquisición de GPS puede tardar hasta 15s; si el usuario canceló la
    // alarma en esa ventana (hold-to-cancel apurando el último segundo), NO
    // enviar. Devolver -1 para que el llamante distinga "cancelado" de "0 SMS".
    if (!_isAlarmActive) {
      _logSentinel("SYLVIA SERVICE: 🛑 Alarma cancelada durante la adquisición de GPS. Envío abortado.");
      _stopGpsWarmup();
      return -1;
    }

    int sentCount = 0;
    for (String number in _recipients) {
      final target = normalizePhoneE164(number);
      // Secuencial a propósito: el statusListener del plugin es un único campo
      // compartido; enviar en paralelo cruzaría las confirmaciones.
      if (await _sendSmsTracked(target, msgBody)) {
        sentCount++;
      }
    }

    if (sentCount > 0) {
      if (sosPos != null) {
        await _activateBeacon(sosPos);
      } else {
        // M5: el SOS salió sin fix (montaña, GPS frío). Armar el beacon con
        // origen pendiente: en cuanto _beaconTick consiga un fix, lo fija como
        // origen y lo manda — es cuando más vale saber dónde está la víctima.
        await _activateBeaconPendingOrigin();
      }
    }

    _stopGpsWarmup();
    if (sentCount > 0) await _reproducirConfirmacion();
    return sentCount;
  }

  Future<void> _beaconTick() async {
    // A3: el checker de 5s invoca esto sin await; dos ticks podían solaparse
    // (ambos pasar el check de intervalo antes de escribir beacon_last_ts) y
    // gastar el presupuesto de 20 updates con envíos duplicados.
    if (_beaconTickBusy) return;
    _beaconTickBusy = true;
    try {
      final p = await SharedPreferences.getInstance();
      // beacon_active lo apaga la UI ("Reiniciar sistema") desde otro isolate;
      // sin reload este isolate seguiría viendo la copia cacheada.
      await p.reload();
      if (!(p.getBool('beacon_active') ?? false)) return;

      final now = DateTime.now().millisecondsSinceEpoch;
      final originTs = p.getInt('beacon_origin_ts') ?? 0;
      final count = p.getInt('beacon_count') ?? 0;

      if (now - originTs > _beaconWindowSeconds * 1000 || count >= _beaconMaxUpdates) {
        await p.setBool('beacon_active', false);
        _logSentinel("SYLVIA SERVICE: 📍 Beacon stopped (window/count reached)");
        // El beacon era lo único que mantenía viva a Sylvia → soltar el wakelock.
        await _stopIfIdle('beacon window ended');
        return;
      }

      // M5: origen pendiente (el SOS salió sin GPS). Establecerlo con el primer
      // fix disponible y enviarlo — sin esperar al umbral de 300 m ni al de 5 min.
      if (p.getBool('beacon_origin_pending') ?? false) {
        if (DateTime.now().difference(_beaconLastProbe).inSeconds < 60) return;
        _beaconLastProbe = DateTime.now();
        Position? fp;
        try {
          fp = await Geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(
                  accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 15)));
        } catch (_) {
          fp = await Geolocator.getLastKnownPosition();
        }
        if (fp == null) return;
        await p.setDouble('beacon_origin_lat', fp.latitude);
        await p.setDouble('beacon_origin_lon', fp.longitude);
        await p.setDouble('beacon_last_lat', fp.latitude);
        await p.setDouble('beacon_last_lon', fp.longitude);
        await p.setInt('beacon_last_ts', DateTime.now().millisecondsSinceEpoch);
        await p.setInt('beacon_count', count + 1);
        await p.setBool('beacon_origin_pending', false);
        final header = _texts['smsBeaconHeader'] ??
            'OKSIGENIA SOS - follow-up (NOT a new alarm):';
        String msg = "$header\n${geoLinks(fp.latitude, fp.longitude)}";
        if (_recipients.isEmpty) {
          _recipients = p.getStringList(PreferencesService.keyContacts) ?? [];
          if (_recipients.isEmpty) return;
        }
        for (final number in _recipients) {
          await _sendSmsTracked(normalizePhoneE164(number), msg);
        }
        _logSentinel("SYLVIA SERVICE: 📍 Beacon origin established from first post-SOS fix");
        return;
      }

      final lastTs = p.getInt('beacon_last_ts') ?? originTs;
      if (now - lastTs < _beaconMinIntervalSeconds * 1000) return;

      // A3: pasado el intervalo de envío (5 min), sin esto se sondeaba el GPS en
      // cada tick de 5s durante horas si la víctima no se movía >300 m. Limitar
      // el sondeo a 1/min recorta el consumo sin retrasar de forma apreciable un
      // aviso de movimiento (el intervalo mínimo entre envíos ya es de 5 min).
      if (DateTime.now().difference(_beaconLastProbe).inSeconds < 60) return;
      _beaconLastProbe = DateTime.now();

      Position? pos;
      try {
        pos = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 5)));
      } catch (_) {
        pos = await Geolocator.getLastKnownPosition();
      }
      if (pos == null) return;

      final lastLat = p.getDouble('beacon_last_lat') ?? 0;
      final lastLon = p.getDouble('beacon_last_lon') ?? 0;
      final delta = Geolocator.distanceBetween(lastLat, lastLon, pos.latitude, pos.longitude);
      if (delta < _beaconDistanceM) return;

      final originLat = p.getDouble('beacon_origin_lat') ?? 0;
      final originLon = p.getDouble('beacon_origin_lon') ?? 0;
      final totalDist = Geolocator.distanceBetween(originLat, originLon, pos.latitude, pos.longitude);

      // Mensaje autoexplicativo para quien lo recibe: el destinatario no debe
      // confundir un aviso de movimiento con una nueva alarma SOS (feedback
      // real de campo 2026-06-13: la contacto no sabía si los "moved" eran SOS).
      final header = _texts['smsBeaconHeader'] ??
          'OKSIGENIA SOS - follow-up (NOT a new alarm):';
      final distSuffix = _texts['smsBeaconDistance'] ?? 'from the SOS point.';
      String msg = "$header\n${totalDist.toStringAsFixed(0)} m $distSuffix";
      msg += "\n${geoLinks(pos.latitude, pos.longitude)}";

      if (_recipients.isEmpty) {
        _recipients = p.getStringList(PreferencesService.keyContacts) ?? [];
        if (_recipients.isEmpty) return;
      }
      for (final number in _recipients) {
        await _sendSmsTracked(normalizePhoneE164(number), msg);
      }

      await p.setDouble('beacon_last_lat', pos.latitude);
      await p.setDouble('beacon_last_lon', pos.longitude);
      await p.setInt('beacon_last_ts', now);
      await p.setInt('beacon_count', count + 1);
      _logSentinel("SYLVIA SERVICE: 📍 Beacon update #${count + 1} sent (delta ${delta.toStringAsFixed(0)}m, total ${totalDist.toStringAsFixed(0)}m)");
    } catch (e) {
      print("SYLVIA: Beacon tick error: $e");
    } finally {
      _beaconTickBusy = false;
    }
  }

  Future<void> _writeWidgetState(String state) async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString('widget_sentinel_state', state);
    } catch (_) {}
  }

  // resumeCountdown: segundos restantes al reanudar una alarma que sobrevivió
  // a un respawn del servicio (Android mató el isolate a mitad de cuenta atrás).
  Future<void> _lanzarAlarma({int? resumeCountdown, String cause = 'fall'}) async {
    // B6: guard de reentrada. Un segundo startAlarm con la cuenta atrás ya en
    // curso la reiniciaba a 30s. Me apoyo en el timer (no en _isAlarmActive, que
    // los llamantes internos fijan ANTES de llamar aquí). Se permite reentrar
    // sólo para REANUDAR tras un respawn (resumeCountdown != null).
    if ((_zombieTimer?.isActive ?? false) && resumeCountdown == null) {
      _logSentinel("SYLVIA SERVICE: startAlarm ignorado (cuenta atrás ya en curso)");
      return;
    }
    _logSentinel("SYLVIA SERVICE: 🚨 EJECUTANDO PROTOCOLO DE ALARMA"
        "${resumeCountdown != null ? ' (reanudada, ${resumeCountdown}s restantes)' : ''}");
    _isAlarmActive = true;
    // A2: calentar el GPS ya — la cuenta atrás de 30s es la ventana de warmup.
    _startGpsWarmup();
    _writeWidgetState('red');
    try { await _cancelInactivityAlarmClock(); } catch (_) {}
    // Pause live tracking during SOS — watchdog checks _isAlarmActive
    if (_isLiveTrackingActive) {
      print("SYLVIA: 📍 Live Tracking paused during SOS");
    }

    // Cada paso va en su propio try: un fallo en prefs, notificación, audio o
    // vibración no puede impedir que el zombie timer (el que acaba enviando el
    // SMS) llegue a crearse. Antes todo iba en un único try y una excepción
    // temprana dejaba _isAlarmActive=true sin timer: ni SMS ni sensores.
    SharedPreferences? prefs;
    try {
      prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_alarm_active', true);
      if (resumeCountdown == null) {
        await prefs.setInt('alarm_start_timestamp', DateTime.now().millisecondsSinceEpoch);
      }
    } catch (e) {
      print("SYLVIA: ❌ prefs en alarma: $e");
    }

    try {
      // fullScreenIntent: Android launches the Activity over the lock screen automatically.
      // This is the only reliable mechanism from the service isolate — MethodChannel calls
      // to 'com.oksigenia.sos/sms' fail silently here because that channel is registered
      // on the UI engine, not the background engine.
      await flutterLocalNotificationsPlugin.show(
        id: alarmNotifId,
        title: "🚨 ${_texts['alertFallDetected']}",
        body: _texts['holdToCancel'],
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            alarmChannelId, 'Oksigenia SOS Alarm',
            icon: 'ic_stat_oksigenia',
            ongoing: true,
            importance: Importance.max,
            priority: Priority.max,
            fullScreenIntent: true,
            color: Color(0xFFFF0000),
            playSound: false,
            enableVibration: false,
          ),
        ),
      );
    } catch (e) {
      print("SYLVIA: ❌ notificación de alarma: $e");
    }

    try {
      // NO llamar setAsForegroundService aquí: re-emite la notificación por
      // defecto del plugin (icono hoja de Flutter) junto a la nuestra → doble
      // icono. El servicio YA está en foreground (config.isForeground=true, solo
      // se degrada al parar), así que es redundante.
      // M7: la causa acompaña al evento; sin ella la UI mostraba SIEMPRE "caída"
      // aunque la alarma fuese por inactividad.
      service.invoke("onAlarmTriggered", {"cause": cause});
    } catch (e) {
      print("SYLVIA: ❌ onAlarmTriggered: $e");
    }

    try {
      await _reproducirSonidoAlarma();
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(pattern: [500, 1000, 500, 1000], repeat: 0);
      }
    } catch (e) {
      print("SYLVIA: ❌ audio/vibración: $e");
    }

    _zombieCountdown = resumeCountdown ?? 30;
    _zombieTimer?.cancel();
    _zombieTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!_isAlarmActive) {
         print("SYLVIA SERVICE: 🛑 Alarma cancelada detectada dentro del timer. Abortando.");
         timer.cancel();
         _stopGpsWarmup(); // A2: no dejar el stream de GPS del warmup colgado
         await _detenerSonido();
         Vibration.cancel();
         return;
      }

      _zombieCountdown--;

      try {
        flutterLocalNotificationsPlugin.show(
          id: alarmNotifId,
          title: "${_texts['alertSendingIn']} $_zombieCountdown s",
          body: _texts['holdToCancel'],
          notificationDetails: const NotificationDetails(
              android: AndroidNotificationDetails(
                  alarmChannelId, 'Oksigenia SOS Alarm',
                  icon: 'ic_stat_oksigenia',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.max,
                  color: Color(0xFFFF0000),
                  playSound: false,
                  enableVibration: false,
                  onlyAlertOnce: true)),
        );
      } catch (_) {}

      if (_zombieCountdown <= 0) {
        timer.cancel();
        try { await _detenerSonido(); } catch (_) {}
        Vibration.cancel();

        int sentCount = 0;
        try {
          sentCount = await _enviarSMSZombie();

          // M3: -1 = cancelada durante la adquisición de GPS. stopAlarm ya limpió
          // (sonido, notificación, flags); no pintar fallo ni confirmar envío.
          // El finally se ejecuta igual con el return.
          if (sentCount < 0) return;

          final p = prefs ?? await SharedPreferences.getInstance();
          await p.setBool('sos_sent_recently', sentCount > 0);

          _lastMovementTime = DateTime.now().add(const Duration(seconds: 60));

          await flutterLocalNotificationsPlugin.cancel(id: alarmNotifId);
          if (sentCount > 0) {
            flutterLocalNotificationsPlugin.show(
              id: notificationId,
              title: _texts['statusSent'],
              body: _texts['statusReady'],
              notificationDetails: const NotificationDetails(
                  android: AndroidNotificationDetails(
                      channelId, 'Oksigenia SOS',
                      icon: 'ic_stat_oksigenia',
                      importance: Importance.high)),
            );
          } else {
            // 0 SMS salieron: decirle "Alert sent successfully" a una víctima
            // sería mentirle. Notificación de fallo bien visible.
            _logSentinel("SYLVIA SERVICE: ❌ SOS NO ENVIADO (0 SMS, ${_recipients.length} contactos)");
            flutterLocalNotificationsPlugin.show(
              id: notificationId,
              title: _texts['statusSendFailed'],
              body: _texts['statusSendFailedBody'],
              notificationDetails: const NotificationDetails(
                  android: AndroidNotificationDetails(
                      channelId, 'Oksigenia SOS',
                      icon: 'ic_stat_oksigenia',
                      ongoing: true,
                      importance: Importance.max,
                      priority: Priority.max)),
            );
          }
          service.invoke("onSosSent", {"sent": sentCount});
        } catch (e) {
          _logSentinel("SYLVIA SERVICE: ❌ Error en protocolo de envío: $e");
        } finally {
          // Pase lo que pase, el flag no puede quedarse colgado: con
          // _isAlarmActive=true los sensores y el inactivity check quedan
          // muertos sin vía de recuperación.
          try {
            final p = prefs ?? await SharedPreferences.getInstance();
            await p.setBool('is_alarm_active', false);
          } catch (_) {}
          _isAlarmActive = false;
        }

        if (sentCount > 0) {
          try { await platform.invokeMethod('sleepScreen'); } catch (_) {}
        }
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Smart Sentinel — ordered after _lanzarAlarma (Dart requires declaration before use)
  // ---------------------------------------------------------------------------

  void _returnToGreen() {
    final bool wasYellow = _sentinelYellow;
    _sentinelYellow = false;
    _yellowTimer?.cancel();
    _yellowCountdown = _observationSeconds;
    _gBuffer.clear();
    _writeWidgetState('green');
    if (wasYellow) service.invoke("sentinelGreen");
  }

  // Cadence-CV "is the user alive and walking" check.
  // Operates on horizontal-G buffer (effX² + effY², Z removed). Resting value
  // ~1.0; walking peaks oscillate above. Z is excluded because the Pixel 8
  // bias filter distorts vertical signal during gait — see _startSensorListener.
  // 2-second analysis window for stable cadence stats:
  //   - >= 4 crossings of 1.12 (above hand-tremor noise; real walking peaks ~1.3-1.5G)
  //   - frequency >= 1.0 Hz (slow walking with heavy load is ~1-1.3Hz; pendulum still <1Hz)
  //   - CV of inter-crossing intervals in [0.05, 1.30]
  //       <0.05 = too regular = mechanical/pendulum
  //       >1.30 = chaotic/random (pure vibration, vehicle on rough road)
  //   Empirical CV from real-life logs (Pixel 7+8, phone in back pocket, walking
  //   + stairs): median ~1.1, range 0.81–1.71. Original 0.85 cap was tuned for
  //   trunk-mounted wearables (Bourke 2007). Smartphones in pockets see fabric
  //   damping + secondary microimpacts that legitimately raise CV.
  // Window length is fixed at ~2s of *real* samples — uses _measuredHz updated
  // by the sensor listener so timing math doesn't depend on Android delivering
  // exactly 50Hz on every device.
  List<int> _crossingsOver(List<double> samples, double threshold) {
    final List<int> idx = [];
    bool above = samples[0] > threshold;
    for (int i = 1; i < samples.length; i++) {
      final bool curr = samples[i] > threshold;
      if (curr != above) {
        idx.add(i);
        above = curr;
      }
    }
    return idx;
  }

  bool _isRhythmicMovement() {
    final int targetWindowSamples = (_measuredHz * 2).round().clamp(50, 400);
    if (_gBuffer.length < targetWindowSamples) return false;
    final recent = _gBuffer.length > targetWindowSamples
        ? _gBuffer.sublist(_gBuffer.length - targetWindowSamples)
        : List<double>.from(_gBuffer);

    // Window stats. Mean is also the adaptive crossing threshold below.
    final double meanH = recent.reduce((a, b) => a + b) / recent.length;
    final double varH = recent
            .map((v) => (v - meanH) * (v - meanH))
            .reduce((a, b) => a + b) /
        recent.length;
    final double stdH = sqrt(varH);
    double minH = recent[0];
    double maxH = recent[0];
    for (final v in recent) {
      if (v < minH) minH = v;
      if (v > maxH) maxH = v;
    }
    final String stats =
        "mean=${meanH.toStringAsFixed(2)} std=${stdH.toStringAsFixed(2)} min=${minH.toStringAsFixed(2)} max=${maxH.toStringAsFixed(2)}";

    // Primary detector: crossings over fixed 1.12 — walking baseline.
    // Adaptive fallback: when running keeps horizontalG persistently above
    // 1.12 (mean >1.5 = clearly elevated regime), recompute crossings over
    // the moving mean to catch the cadence still embedded in the high-G
    // oscillation. Validated against P8 logs 2026-04-30 and 2026-05-15.
    const double rhythmThreshold = 1.12;
    List<int> crossingIdx = _crossingsOver(recent, rhythmThreshold);
    bool usingAdaptive = false;

    if (crossingIdx.length < 4 && meanH > 1.5) {
      final adaptiveIdx = _crossingsOver(recent, meanH);
      if (adaptiveIdx.length >= 4) {
        crossingIdx = adaptiveIdx;
        usingAdaptive = true;
      }
    }
    final String mode = usingAdaptive ? "[adapt]" : "[fixed]";

    final int crossings = crossingIdx.length;
    if (crossings < 4) {
      _logSentinel("SYLVIA RHYTHM: $mode crossings=$crossings (< 4) $stats → NO");
      return false;
    }

    final double timeWindowSec = recent.length / _measuredHz;
    final double cycles = crossings / 2.0;
    final double freqHz = cycles / timeWindowSec;

    final List<double> intervals = [];
    for (int i = 1; i < crossingIdx.length; i++) {
      intervals.add((crossingIdx[i] - crossingIdx[i - 1]).toDouble());
    }
    final double mean = intervals.reduce((a, b) => a + b) / intervals.length;
    final double variance = intervals
            .map((v) => (v - mean) * (v - mean))
            .reduce((a, b) => a + b) /
        intervals.length;
    final double cv = mean > 0 ? sqrt(variance) / mean : 0;

    if (freqHz < 1.0) {
      _logSentinel("SYLVIA RHYTHM: $mode cross=$crossings f=${freqHz.toStringAsFixed(2)}Hz cv=${cv.toStringAsFixed(2)} $stats → NO (freq<1.0)");
      return false;
    }
    if (cv < 0.05 || cv > _cvUpperBound) {
      _logSentinel("SYLVIA RHYTHM: $mode cross=$crossings f=${freqHz.toStringAsFixed(2)}Hz cv=${cv.toStringAsFixed(2)} $stats → NO (cv out of range)");
      return false;
    }

    _logSentinel("SYLVIA RHYTHM: $mode cross=$crossings f=${freqHz.toStringAsFixed(2)}Hz cv=${cv.toStringAsFixed(2)} $stats → YES");
    return true;
  }

  void _enterYellowState() {
    if (_sentinelYellow || _isAlarmActive) return;
    _yellowCountdown = _observationSeconds;
    _logSentinel("SYLVIA SERVICE: 🟡 Impacto detectado. Análisis Smart Sentinel ($_yellowCountdown s)...");
    _sentinelYellow = true;
    _writeWidgetState('yellow');
    service.invoke("sentinelYellow");

    // Phased post-impact analysis (Bourke/Kangas/Musci-style):
    // 1. Settling window (per Musci 2021): movement ignored — could be tumbling,
    //    rolling, failed recovery attempts, secondary impacts.
    // 2. Sustained rhythm check (post-settling): cancellation requires 3 consecutive
    //    2s checks of rhythmic movement (= 6s of cadence-CV-validated gait).
    // 3. Imminent-alert (last 10s): emit sentinelOrange so UI can warn the user.
    final int totalObservation = _observationSeconds;
    final int settlingSeconds = _settlingSeconds;
    const int sustainedRhythmChecks = 3;
    const int orangeWarningSeconds = 10;
    int rhythmStreak = 0;
    bool orangeEmitted = false;

    _yellowTimer?.cancel();
    _yellowTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _yellowCountdown -= 2;
      final int elapsed = totalObservation - _yellowCountdown;

      if (!orangeEmitted && _yellowCountdown <= orangeWarningSeconds && _yellowCountdown > 0) {
        orangeEmitted = true;
        _logSentinel("SYLVIA SERVICE: 🟠 Alerta inminente (${_yellowCountdown}s restantes)");
        _writeWidgetState('orange');
        service.invoke("sentinelOrange");
      }

      if (elapsed >= settlingSeconds) {
        if (_isRhythmicMovement()) {
          rhythmStreak++;
          _logSentinel("SYLVIA SERVICE: 🟡 Ritmo detectado ($rhythmStreak/$sustainedRhythmChecks)");
          if (rhythmStreak >= sustainedRhythmChecks) {
            _logSentinel("SYLVIA SERVICE: ✅ Movimiento rítmico sostenido (${sustainedRhythmChecks * 2}s). Falso positivo.");
            _returnToGreen();
            timer.cancel();
            return;
          }
        } else {
          rhythmStreak = 0;
        }
      }

      if (_yellowCountdown <= 0) {
        timer.cancel();
        if (!_isAlarmActive) {
          _logSentinel("SYLVIA SERVICE: 🔴 Sin movimiento sostenido tras ${totalObservation}s. ACTIVANDO ALARMA.");
          // Limpieza manual en vez de _returnToGreen(): ese método emite
          // sentinelGreen y escribe el widget en verde — UI y widget dirían
          // "todo bien" un instante antes del rojo.
          _isAlarmActive = true;
          _sentinelYellow = false;
          _yellowCountdown = _observationSeconds;
          _gBuffer.clear();
          _lanzarAlarma();
        } else {
          _returnToGreen();
        }
      }
    });
  }

  void _startSensorListener() {
    if (_accSub != null) return;
    _logSentinel("SYLVIA SERVICE: Iniciando escucha de sensores...");
    _lastRawSample = DateTime.now();
    _lastUserSample = DateTime.now();

    // Z-only bias tracker. The Pixel 8 z-axis reports a stuck constant (~197 m/s²) that
    // would otherwise dominate magnitude. X and Y on healthy sensors oscillate around 0
    // during rest, so EMA bias on those axes contributes nothing in steady state — but
    // it amplifies transients (e.g. backpack reorientation after sustained walking) by
    // mismatching baseline. Keep filter only where the hardware bug demands it.
    double zBias = 0.0;
    int sensorSamples = 0;
    const double biasAlpha = 0.998;
    final DateTime sensorStreamStart = DateTime.now();
    // Peak watcher state — throttled to one log per 2s.
    DateTime lastPeakLog = DateTime.fromMillisecondsSinceEpoch(0);
    double currentPeakG = 0;
    double currentPeakX = 0, currentPeakY = 0, currentPeakZ = 0;
    // Sample-rate measurement: count packets per 1s window, then publish to
    // _measuredHz so _isRhythmicMovement() can compute frequency correctly
    // regardless of what Android negotiated.
    DateTime hzWindowStart = DateTime.now();
    int hzWindowSamples = 0;
    DateTime lastHzLog = DateTime.fromMillisecondsSinceEpoch(0);

    // --- Instrumentación de caída libre (SOLO logging — no gatea nada) ---
    // Una caída real lleva ~0.3-0.5s de G≈0 antes del impacto (Bourke 2007);
    // apoyar una mochila en un mueble es un descenso controlado sin caída
    // libre (falsas alarmas documentadas 2026-06-09 y 2026-06-10). La firma
    // se mide en el acelerómetro RAW (con gravedad: |a|≈9.81 en reposo, →0
    // cayendo) — el stream lineal del detector no la ve. Si los datos de
    // campo confirman la separación, se calibrará un gate del amarillo.
    DateTime lastFreefallEnd = DateTime.fromMillisecondsSinceEpoch(0);
    int lastFreefallMs = 0;
    DateTime freefallStart = DateTime.fromMillisecondsSinceEpoch(0);
    double freefallMinA = 99;
    bool inFreefall = false;
    // Salud del stream raw: si el bug de z-atascado del P8 afecta también al
    // raw, rawMag se clava en ~197 y la instrumentación quedaría muerta en
    // silencio. Se publica en el log HZ cada 30s para verificarlo en campo.
    double lastRawMag = 0;
    // Throttle: el running tiene fase aérea por zancada (~100ms, 3/s) — sin
    // esto, una carrera generaría miles de escrituras con flush.
    DateTime lastFfLogTime = DateTime.fromMillisecondsSinceEpoch(0);
    int ffSuppressed = 0;
    int ffSupMaxMs = 0;
    double ffSupMinA = 99;

    // Pico raw reciente (~400ms): corrobora la magnitud de los impactos del
    // stream lineal. Sospecha empírica 2026-06-10: dos caídas casi idénticas
    // al cojín dieron effZ=49 y effZ=164 — el bias EMA del Z atascado tarda
    // ~7s en converger tras un volteo y puede fabricar G fantasma. El raw del
    // P8 está sano y no tiene ese problema: si lineal dice 21G y raw dice
    // ~60 m/s², el impacto es artefacto del filtro.
    double recentRawMax = 0;
    DateTime recentRawMaxAt = DateTime.fromMillisecondsSinceEpoch(0);

    String freefallInfo() {
      final String raw = "rawPk=${recentRawMax.toStringAsFixed(0)}";
      // Un dip EN CURSO es el caso de la caída real (el impacto interrumpe la
      // caída libre, y el cierre llega por otro stream sin orden garantizado):
      // hay que reportarlo, no decir "none".
      if (inFreefall) {
        final int ms = DateTime.now().difference(freefallStart).inMilliseconds;
        return "freefall=ONGOING ${ms}ms minA=${freefallMinA.toStringAsFixed(1)} $raw";
      }
      final int agoMs = DateTime.now().difference(lastFreefallEnd).inMilliseconds;
      return (lastFreefallMs > 0 && agoMs < 3000)
          ? "freefall=${lastFreefallMs}ms@-${agoMs}ms $raw"
          : "freefall=none $raw";
    }

    _rawAccSub?.cancel();
    _rawAccSub = accelerometerEventStream(samplingPeriod: SensorInterval.gameInterval)
        .listen((e) {
      _lastRawSample = DateTime.now(); // A1: liveness para el watchdog de 5s
      final double rawMag = sqrt(e.x * e.x + e.y * e.y + e.z * e.z);
      lastRawMag = rawMag;
      if (rawMag >= recentRawMax ||
          DateTime.now().difference(recentRawMaxAt).inMilliseconds > 400) {
        recentRawMax = rawMag;
        recentRawMaxAt = DateTime.now();
      }
      if (rawMag < 4.0) {
        if (!inFreefall) {
          inFreefall = true;
          freefallStart = DateTime.now();
          freefallMinA = rawMag;
        } else if (rawMag < freefallMinA) {
          freefallMinA = rawMag;
        }
      } else if (inFreefall) {
        inFreefall = false;
        final int ms = DateTime.now().difference(freefallStart).inMilliseconds;
        if (ms >= 60) {
          final DateTime now = DateTime.now();
          lastFreefallEnd = now;
          lastFreefallMs = ms;
          if (now.difference(lastFfLogTime).inSeconds >= 2) {
            final String extra = ffSuppressed > 0
                ? " (+$ffSuppressed dips, max=${ffSupMaxMs}ms, minA=${ffSupMinA.toStringAsFixed(1)})"
                : "";
            _logSentinel("SYLVIA FREEFALL: ${ms}ms minA=${freefallMinA.toStringAsFixed(1)} m/s²$extra");
            lastFfLogTime = now;
            ffSuppressed = 0;
            ffSupMaxMs = 0;
            ffSupMinA = 99;
          } else {
            ffSuppressed++;
            if (ms > ffSupMaxMs) ffSupMaxMs = ms;
            if (freefallMinA < ffSupMinA) ffSupMinA = freefallMinA;
          }
        }
      }
    }, onError: (err) {
      // A1: sin esto, un error de plataforma cancelaba la suscripción en
      // silencio y la corroboración raw (recentRawMax) quedaba congelada,
      // convirtiendo TODO impacto futuro en "fantasma". El watchdog de 5s
      // detecta el mutismo y resuscribe.
      _logSentinel("SYLVIA SENSOR: ❌ stream RAW error: $err");
    });

    _accSub = userAccelerometerEventStream(samplingPeriod: SensorInterval.gameInterval)
        .listen((event) {
      _lastUserSample = DateTime.now(); // A1: liveness para el watchdog de 5s

      if (DateTime.now().difference(_lastStopTimestamp).inSeconds < 10 ||
          _isAlarmActive ||
          _sensorCooldown) {
        // Reinicia la ventana de medición de Hz: si no, la primera ventana al
        // salir del bloqueo abarca el hueco y publica un Hz absurdamente bajo
        // que distorsiona la frecuencia del detector de ritmo.
        hzWindowStart = DateTime.now();
        hzWindowSamples = 0;
        return;
      }

      sensorSamples++;
      if (sensorSamples == 1) {
        zBias = event.z;
      } else {
        zBias = biasAlpha * zBias + (1 - biasAlpha) * event.z;
      }

      hzWindowSamples++;
      final int hzWindowElapsedMs =
          DateTime.now().difference(hzWindowStart).inMilliseconds;
      if (hzWindowElapsedMs >= 1000) {
        _measuredHz = hzWindowSamples * 1000.0 / hzWindowElapsedMs;
        hzWindowStart = DateTime.now();
        hzWindowSamples = 0;
        if (DateTime.now().difference(lastHzLog).inSeconds >= 30) {
          // raw≈9.8 en reposo = stream raw sano; raw≈197 = bug z-atascado del
          // P8 también en el raw → la instrumentación freefall no puede operar.
          _logSentinel("SYLVIA HZ: ${_measuredHz.toStringAsFixed(1)} Hz raw=${lastRawMag.toStringAsFixed(1)}");
          lastHzLog = DateTime.now();
        }
      }

      // Need 100 samples (~2s) AND 4s elapsed before trusting bias-removed signal.
      if (sensorSamples < 100 ||
          DateTime.now().difference(sensorStreamStart).inMilliseconds < 4000) {
        return;
      }

      final double effX = event.x;
      final double effY = event.y;
      final double effZ = event.z - zBias;
      // Full magnitude (with bias-corrected Z) drives impact detection.
      final double userMagnitude = sqrt(effX * effX + effY * effY + effZ * effZ);
      final double instantG = 1.0 + userMagnitude / 9.81;
      // Horizontal-only magnitude drives cadence detection. The Pixel 8 z-axis
      // bias filter introduces asymmetric damping when Z varies during real
      // walking (steps), distorting magnitude and inflating the inter-crossing
      // CV. Walking-in-pocket signal is dominated by lateral sway + fore/aft
      // pitch (XY plane); Z amplitude is heavily damped by fabric anyway.
      // Removing Z from cadence yields a much more uniform CV across devices.
      final double horizontalMagnitude = sqrt(effX * effX + effY * effY);
      final double horizontalG = 1.0 + horizontalMagnitude / 9.81;

      final bool isPaused = _pausedUntil.isAfter(DateTime.now());

      // Peak watcher: track significant motion peaks (above 2.5G) and log the highest
      // every 2s so we can see what "normal use" looks like vs. what triggers the alarm.
      if (instantG > 2.5 && !_sentinelYellow) {
        if (instantG > currentPeakG) {
          currentPeakG = instantG;
          currentPeakX = effX;
          currentPeakY = effY;
          currentPeakZ = effZ;
        }
        if (DateTime.now().difference(lastPeakLog).inSeconds >= 2) {
          _logSentinel("SYLVIA PEAK: ${currentPeakG.toStringAsFixed(2)}G (effX=${currentPeakX.toStringAsFixed(1)} effY=${currentPeakY.toStringAsFixed(1)} effZ=${currentPeakZ.toStringAsFixed(1)}) rawPk=${recentRawMax.toStringAsFixed(0)}");
          lastPeakLog = DateTime.now();
          currentPeakG = 0;
        }
      }

      if (_isMonitoringImpact && _impactDetectionEnabled && !isPaused) {
        // Buffer holds horizontal G for the cadence detector; impact still uses
        // full instantG (line below). Decoupling the two signals fixes Pixel 8.
        _gBuffer.add(horizontalG);
        // Keep ~3s of margin even at 200Hz (some Pixels deliver that with
        // gameInterval); _isRhythmicMovement only uses last 2s of real samples.
        if (_gBuffer.length > 600) _gBuffer.removeAt(0);

        if (instantG > _yellowThreshold && !_sentinelYellow && !_isAlarmActive) {
          // Corroboración física: el stream lineal fabrica impactos fantasma
          // durante volteos/caída libre — medido 2026-06-10: "17.5G" con
          // rawPk=2, el móvil aún EN EL AIRE. Un impacto real tiene que
          // haberse visto también en el acelerómetro raw (impactos reales
          // contra colchón midieron rawPk=119-167; reposo=9.8; caída libre≈0).
          final bool rawCorroborated = recentRawMax >= 25.0;
          final bool isOrange = _orangeThreshold > 0 && instantG >= _orangeThreshold;

          if (!rawCorroborated) {
            _logSentinel("SYLVIA BACKGROUND: 👻 Impacto ${instantG.toStringAsFixed(2)}G DESCARTADO — rawPk=${recentRawMax.toStringAsFixed(0)} < 25 m/s², fantasma del stream lineal (effX=${effX.toStringAsFixed(1)} effY=${effY.toStringAsFixed(1)} effZ=${effZ.toStringAsFixed(1)}) ${freefallInfo()}");
          } else {
            // Decisión de diseño 2026-06-10: NINGÚN impacto dispara la alarma
            // directamente — siempre vigilancia primero. El antiguo
            // orange-direct saltaba el amarillo; ahora un impacto crítico
            // entra en la misma ventana de observación (se conserva el log
            // 🟠 para el análisis de campo). La pre-alerta de 30s y el
            // monitor de inactividad siguen siendo las redes de seguridad.
            if (isOrange) {
              _logSentinel("SYLVIA BACKGROUND: 🟠 Impacto crítico ${instantG.toStringAsFixed(2)}G ≥ ${_orangeThreshold}G → VIGILANCIA (effX=${effX.toStringAsFixed(1)} effY=${effY.toStringAsFixed(1)} effZ=${effZ.toStringAsFixed(1)}) ${freefallInfo()}");
            } else {
              _logSentinel("SYLVIA BACKGROUND: ⚡ Impacto ${instantG.toStringAsFixed(2)}G → Smart Sentinel (effX=${effX.toStringAsFixed(1)} effY=${effY.toStringAsFixed(1)} effZ=${effZ.toStringAsFixed(1)}) ${freefallInfo()}");
            }
            _activarEscudo(segundos: 3);
            _enterYellowState();
          }
        }
      }

      if (_isMonitoringInactivity) {
        double delta = (instantG - _lastG).abs();
        if (delta > 0.15 || instantG > 1.15 || instantG < 0.85) {
          _lastMovementTime = DateTime.now(); // always update, even while paused
          if (!isPaused && DateTime.now().difference(_lastAlarmReschedule).inSeconds > 60) {
            _scheduleInactivityAlarmClock();
          }
        }
        _lastG = instantG;
      }
    }, onError: (err) {
      _logSentinel("SYLVIA SENSOR: ❌ stream USER error: $err");
    });
  }

  void _startInactivityChecker() {
    _inactivityCheckTimer?.cancel();
    _inactivityCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      final bool isPaused = _pausedUntil.isAfter(DateTime.now());

      // Auto-resume when timed pause expires
      if (_pausedUntil.millisecondsSinceEpoch > 0 && !isPaused) {
        print("SYLVIA: ▶ Pausa temporizada finalizada. Reanudando.");
        _pausedUntil = DateTime.fromMillisecondsSinceEpoch(0);
        _lastMovementTime = DateTime.now();
        try { (await SharedPreferences.getInstance()).setInt('paused_until', 0); } catch (_) {} // M1
        if (_isMonitoringInactivity) _scheduleInactivityAlarmClock();
        service.invoke("onPauseResumed");
      }

      // Check "Resume now" action tapped on notification
      try {
        final prefs = await SharedPreferences.getInstance();
        // Este flag lo escribe OTRO isolate (la acción "Resume now" de la
        // notificación). Sin reload, esta copia cacheada no lo vería jamás.
        await prefs.reload();
        final int resumeReq = prefs.getInt('pause_resume_requested') ?? 0;
        if (resumeReq > 0) {
          await prefs.setInt('pause_resume_requested', 0);
          await prefs.setInt('paused_until', 0); // M1
          _pausedUntil = DateTime.fromMillisecondsSinceEpoch(0);
          _lastMovementTime = DateTime.now();
          if (_isMonitoringInactivity) _scheduleInactivityAlarmClock();
          service.invoke("onPauseResumed");
        }
      } catch (_) {}

      // Smart Beacon: post-SOS position-update protocol. Corre ANTES del
      // return de pausa: es protocolo de rescate, no monitorización — una
      // pausa no debe dejar a los rescatadores sin actualizaciones.
      _beaconTick();

      // A1: watchdog de streams. Si el monitoreo está activo pero los sensores
      // llevan >8s mudos (stream muerto por error de plataforma/HAL), resuscribir.
      // Sin esto la notificación seguía diciendo "protegido" con la detección
      // caída. _startSensorListener re-inicia los marcadores de liveness.
      if (_accSub != null &&
          (_isMonitoringImpact || _isMonitoringInactivity) &&
          !_isAlarmActive &&
          DateTime.now().difference(_lastStopTimestamp).inSeconds > 10) {
        final int userAge = DateTime.now().difference(_lastUserSample).inSeconds;
        final int rawAge = DateTime.now().difference(_lastRawSample).inSeconds;
        if (userAge > 8 || rawAge > 8) {
          _logSentinel("SYLVIA WATCHDOG: ⚠️ Sensores mudos (user=${userAge}s raw=${rawAge}s) → resuscribiendo streams");
          _accSub?.cancel(); _accSub = null;
          _rawAccSub?.cancel(); _rawAccSub = null;
          _startSensorListener();
        }
      }

      // M4: barrido de inactividad. Si no queda NADA activo (p. ej. la UI apagó
      // el beacon o el live-tracking en otro isolate, o terminó su ventana),
      // parar y soltar el wakelock permanente. _stopIfIdle revalida contra prefs
      // (beacon_active) antes de parar, así que no corta un beacon vivo.
      if (!_isMonitoringImpact && !_isMonitoringInactivity &&
          !_isLiveTrackingActive && !_isAlarmActive) {
        if (await _stopIfIdle('idle sweep')) return;
      }

      // Update pause countdown in notification
      if (_pausedUntil.isAfter(DateTime.now())) {
        _updatePausedNotification();
        return;
      }

      // Live Tracking watchdog: fire when AlarmClock-scheduled time is reached
      if (_isLiveTrackingActive && !_isAlarmActive) {
        final int nextSendMs = _liveTrackingNextSend.millisecondsSinceEpoch;
        if (nextSendMs > 0 && nextSendMs <= DateTime.now().millisecondsSinceEpoch) {
          _liveTrackingNextSend = DateTime.fromMillisecondsSinceEpoch(0);
          _sendLiveTrackingSMS();
        }
      }

      if (DateTime.now().difference(_lastStopTimestamp).inSeconds < 10) return;
      if (!_isMonitoringInactivity || _isAlarmActive) return;

      final secondsInactive = DateTime.now().difference(_lastMovementTime).inSeconds;
      if (secondsInactive > _inactivityLimitSeconds) {
        print("SYLVIA BACKGROUND: 💤 INACTIVIDAD DETECTADA ($secondsInactive s)");
        _isAlarmActive = true;
        _lanzarAlarma(cause: 'inactivity');
      }
    });
  }

  // ---------------------------------------------------------------------------
  // 3. CARGA DE CONFIGURACIÓN
  // ---------------------------------------------------------------------------

  // Aplica los parámetros del Smart Sentinel del perfil. Único punto de
  // verdad: lo usan setMonitoring (toggle desde la UI) y _loadConfigFromDisk
  // (respawn del servicio) — antes el respawn volvía a los defaults de
  // Trekking aunque el usuario corriera con yellow=10G.
  void _applyProfileConfig(String profileName) {
    final ActivityProfile profile = activityProfileFromName(profileName);
    final ActivityProfileConfig cfg = activityProfileConfigs[profile]!;
    _impactDetectionEnabled = cfg.impactDetectionEnabled;
    if (cfg.impactDetectionEnabled) {
      _yellowThreshold = cfg.yellowThreshold;
      _orangeThreshold = cfg.orangeThreshold;
      _settlingSeconds = cfg.settlingSeconds;
      _observationSeconds = cfg.observationSeconds;
      _cvUpperBound = cfg.cvUpperBound;
    }
    _logSentinel("SYLVIA SERVICE: 🎯 Profile=${profile.name} yellow=${_yellowThreshold}G orange=${_orangeThreshold}G obs=${_observationSeconds}s cv=$_cvUpperBound impactOn=$_impactDetectionEnabled");
  }

  Future<void> _loadConfigFromDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      _recipients = prefs.getStringList(PreferencesService.keyContacts) ?? [];
      _customMessage = prefs.getString(PreferencesService.keySosMessage) ?? "";

      // Restaurar el perfil de actividad: un respawn a mitad de ruta debe
      // volver con los umbrales del usuario, no con los defaults.
      _applyProfileConfig(prefs.getString(PreferencesService.keyActivityProfile) ?? 'trekking');

      bool savedFall = prefs.getBool('fall_detection_enabled') ?? false;
      bool savedInactivity = prefs.getBool('inactivity_monitor_enabled') ?? false;
      _inactivityLimitSeconds = prefs.getInt('inactivity_time') ?? 3600;

      // M1: restaurar una pausa en curso que sobreviva a un respawn del servicio.
      final int pausedUntilMs = prefs.getInt('paused_until') ?? 0;
      if (pausedUntilMs > DateTime.now().millisecondsSinceEpoch) {
        _pausedUntil = DateTime.fromMillisecondsSinceEpoch(pausedUntilMs);
        _logSentinel("SYLVIA BOOT: ⏸ Pausa restaurada (${_pausedUntil.difference(DateTime.now()).inMinutes} min restantes)");
      }

      _isLiveTrackingActive = prefs.getBool('live_tracking_enabled') ?? false;
      _liveTrackingIntervalSeconds = (prefs.getInt('live_tracking_interval_minutes') ?? 30) * 60;
      if (_isLiveTrackingActive) {
        final int nextMs = prefs.getInt('live_tracking_next_send') ?? 0;
        _liveTrackingNextSend = DateTime.fromMillisecondsSinceEpoch(nextMs);
        if (nextMs == 0 || nextMs <= DateTime.now().millisecondsSinceEpoch) {
          await _scheduleLiveTrackingAlarm();
        }
        _startInactivityChecker();
        print("SYLVIA BOOT: 📍 Live Tracking restaurado.");
      }

      print("SYLVIA BOOT: Contactos: ${_recipients.length}, Fall: $savedFall, Inactivity: $savedInactivity, LiveTracking: $_isLiveTrackingActive");

      // Red de seguridad: si el servicio arranca por cualquier vía sin nada que
      // vigilar (OksigeniaBootReceiver ya gatea el boot, pero el watchdog u otro
      // camino podrían levantarlo), parar ANTES de mostrar "System Ready" para
      // no mantener el wakelock permanente del plugin drenando batería en vacío.
      final bool bootBeacon = prefs.getBool('beacon_active') ?? false;
      final bool bootAlarm = prefs.getBool('is_alarm_active') ?? false;
      if (!savedFall && !savedInactivity && !_isLiveTrackingActive &&
          !bootBeacon && !bootAlarm) {
        _logSentinel("SYLVIA BOOT: 🌙 Nada activo al arrancar → deteniendo (no revivir en vacío)");
        try { await flutterLocalNotificationsPlugin.cancelAll(); } catch (_) {}
        service.stopSelf();
        return;
      }

      flutterLocalNotificationsPlugin.show(
          id: notificationId,
          title: 'Oksigenia SOS',
          body: 'System Ready',
          notificationDetails: const NotificationDetails(
              android: AndroidNotificationDetails(
                  channelId, 'Oksigenia SOS - Active Monitor',
                  icon: 'ic_stat_oksigenia',
                  ongoing: true,
                  importance: Importance.low,
                  priority: Priority.low,
                  onlyAlertOnce: true,
                  playSound: false,
                  enableVibration: false))
      );

      if (savedFall || savedInactivity) {
        _isMonitoringImpact = savedFall;
        _isMonitoringInactivity = savedInactivity;
        _startSensorListener();
        if (_isMonitoringInactivity) {
          _scheduleInactivityAlarmClock();
        }
      }
      // Always run the inactivity checker so the panic-widget poll fires even
      // when monitoring is off. Internal guards skip inactivity-specific logic.
      _startInactivityChecker();

      // Recuperación de alarma: si Android mató el servicio durante la cuenta
      // atrás, is_alarm_active sobrevive en prefs. La recuperación de la UI no
      // basta — exige que alguien abra la app, y la víctima puede estar
      // inconsciente. Reanudamos la cuenta atrás restante (mínimo 2s para que
      // el isolate termine de arrancar; si ya expiró, envía casi de inmediato).
      if (prefs.getBool('is_alarm_active') ?? false) {
        final int startMs = prefs.getInt('alarm_start_timestamp') ?? 0;
        final int elapsed = startMs > 0
            ? (DateTime.now().millisecondsSinceEpoch - startMs) ~/ 1000
            : 9999;
        _logSentinel("SYLVIA BOOT: 🚨 Alarma activa detectada tras respawn (${elapsed}s transcurridos)");
        _lanzarAlarma(resumeCountdown: (30 - elapsed).clamp(2, 30));
      }
    } catch (e) {
      print("SYLVIA BOOT ERROR: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // 4. LISTENERS DEL SERVICIO
  // ---------------------------------------------------------------------------

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) => service.setAsForegroundService());
    service.on('setAsBackground').listen((event) => service.setAsBackgroundService());

    service.on('stopService').listen((event) async {
      print("SYLVIA: 💀 Recibida orden de apagado.");
      _accSub?.cancel();
      _rawAccSub?.cancel();
      _inactivityCheckTimer?.cancel();
      _zombieTimer?.cancel();
      _yellowTimer?.cancel();
      _shieldTimer?.cancel();
      await _cancelInactivityAlarmClock();
      await _cancelLiveTrackingAlarm();
      try { await _detenerSonido(); } catch (_) {}
      try { await flutterLocalNotificationsPlugin.cancelAll(); } catch (_) {}
      if (service is AndroidServiceInstance) {
        try { await service.setAsBackgroundService(); } catch (_) {}
      }
      service.stopSelf();
    });

    service.on('setConfig').listen((event) {
      if (event == null) return;
      print("SYLVIA SERVICE: Recibiendo configuración...");
      
      if (event.containsKey('recipients')) {
        _recipients = List<String>.from(event['recipients']);
      }
      if (event.containsKey('customMessage')) {
        _customMessage = event['customMessage'] as String;
      }
      if (event.containsKey('texts')) {
        final Map<dynamic, dynamic> rawTexts = event['texts'];
        rawTexts.forEach((key, value) {
          _texts[key.toString()] = value.toString();
        });
      }
    });

    service.on('setMonitoring').listen((event) async {
      _logSentinel("SYLVIA SERVICE: 📥 setMonitoring received: active=${event?['active']} profile=${event?['profile']}");
      final prefs = await SharedPreferences.getInstance();
      _isMonitoringImpact = event?['active'] ?? false;

      if (event != null && event.containsKey('inactivity_limit')) {
         _inactivityLimitSeconds = event['inactivity_limit'];
      } else {
         _inactivityLimitSeconds = prefs.getInt('inactivity_time') ?? 3600;
      }

      if (event != null && event.containsKey('inactivity_enabled')) {
         _isMonitoringInactivity = event['inactivity_enabled'];
      } else {
         _isMonitoringInactivity = prefs.getBool('inactivity_monitor_enabled') ?? false;
      }

      // Activity profile drives Smart Sentinel parameters at runtime. Read from
      // event when present (UI just toggled), fall back to persisted setting.
      final String profileName = (event != null && event.containsKey('profile'))
          ? event['profile'] as String
          : (prefs.getString(PreferencesService.keyActivityProfile) ?? 'trekking');
      _applyProfileConfig(profileName);

      print("SYLVIA SERVICE: Monitor - Impact: $_isMonitoringImpact, Inactivity: $_isMonitoringInactivity (Limit: $_inactivityLimitSeconds s)");

      if (_isMonitoringImpact || _isMonitoringInactivity) {
        _activarEscudo(segundos: 4);
        _lastMovementTime = DateTime.now();
        _startSensorListener();
        if (_isMonitoringInactivity) {
          _scheduleInactivityAlarmClock();
        } else {
          _cancelInactivityAlarmClock();
        }
      } else {
        _accSub?.cancel();
        _accSub = null;
        _rawAccSub?.cancel();
        _rawAccSub = null;
        _cancelInactivityAlarmClock();
        // Sensor apagado: si tampoco hay live-tracking/beacon/alarma, Sylvia no
        // tiene nada que vigilar → parar y liberar el wakelock permanente
        // (antes seguía viva drenando batería con el monitoreo desactivado).
        if (await _stopIfIdle('monitoring toggles off')) return;
      }
      // El checker de 5s NUNCA se cancela aquí: atiende el Smart Beacon, el
      // watchdog de live tracking y el auto-resume de pausas. La lógica de
      // inactividad ya está gateada internamente por _isMonitoringInactivity.
      _startInactivityChecker();
    });

    service.on('setPaused').listen((event) async {
      final int until = event?['until'] ?? 0;
      _pausedUntil = DateTime.fromMillisecondsSinceEpoch(until);
      // M1: persistir la pausa. Sin esto, si Android mata a Sylvia durante la
      // pausa (p. ej. 1h en coche), el respawn rearmaba los sensores a mitad de
      // pausa y un bache disparaba un falso positivo.
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('paused_until', until);
      } catch (_) {}
      if (until > 0) {
        // Un amarillo en curso no puede sobrevivir a la pausa: con isPaused el
        // buffer se congela, la cancelación por ritmo es imposible y la alarma
        // dispararía en mitad de la pausa que el usuario pidió explícitamente.
        if (_sentinelYellow) _returnToGreen();
        await _cancelInactivityAlarmClock();
        _updatePausedNotification();
        print("SYLVIA: ⏸ Monitorización pausada por ${_pausedUntil.difference(DateTime.now()).inMinutes} min");
      } else {
        print("SYLVIA: ▶ Pausa cancelada desde UI");
      }
    });

    service.on('startAlarm').listen((event) => _lanzarAlarma());

    service.on('stopAlarm').listen((event) async {
      _logSentinel("SYLVIA SERVICE: 🛑 Recibida orden de STOP ALARM");

      _lastStopTimestamp = DateTime.now();

      _isAlarmActive = false;
      _returnToGreen();
      _activarEscudo(segundos: 4);
      _zombieTimer?.cancel();
      _stopGpsWarmup(); // A2: cerrar el warmup de GPS al cancelar la alarma
      await _cancelInactivityAlarmClock();
      
      _lastMovementTime = DateTime.now().add(const Duration(seconds: 15));

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_alarm_active', false);
        await _detenerSonido();
        Vibration.cancel();
        await flutterLocalNotificationsPlugin.cancel(id: alarmNotifId);
        if (_isMonitoringInactivity) _scheduleInactivityAlarmClock();
        if (_isLiveTrackingActive) await _scheduleLiveTrackingAlarm();

        flutterLocalNotificationsPlugin.show(
            id: notificationId,
            title: "Oksigenia SOS",
            body: _texts['statusReady'],
            notificationDetails: const NotificationDetails(
                android: AndroidNotificationDetails(
                    channelId, 'Oksigenia SOS - Active Monitor',
                    icon: 'ic_stat_oksigenia',
                    ongoing: true,
                    importance: Importance.low,
                    priority: Priority.low,
                    onlyAlertOnce: true,
                    playSound: false,
                    enableVibration: false)));
      } catch (e) {
        print("Error stop: $e");
      }
    });

    service.on('setLiveTracking').listen((event) async {
      final bool active = event?['active'] ?? false;
      final int intervalSec = event?['interval_seconds'] ?? 1800;
      final int shutdownSec = event?['shutdown_seconds'] ?? 0;
      _isLiveTrackingActive = active;
      _liveTrackingIntervalSeconds = intervalSec;
      if (active) {
        await _scheduleLiveTrackingAlarm();
        if (shutdownSec > 0) await _scheduleShutdownReminder(shutdownSec);
        _startInactivityChecker(); // ensures the 5s watchdog is running
        print("SYLVIA: 📍 Live Tracking activado. Intervalo: ${intervalSec}s");
      } else {
        await _cancelLiveTrackingAlarm();
        print("SYLVIA: 📍 Live Tracking desactivado.");
        // M4: si el live-tracking era lo único que mantenía viva a Sylvia,
        // soltar el wakelock permanente ya (no esperar al barrido de 5s).
        if (await _stopIfIdle('live tracking off')) return;
      }
    });

    service.on('sendLiveCheckin').listen((event) async {
      await _sendLiveTrackingSMS(isCheckin: true);
    });

    service.on('updateNotification').listen((event) async {
      if (event == null) return;
      String status = event['status'] ?? 'active';
      String title = event['title'] ?? 'Oksigenia SOS';
      String content = event['content'] ?? 'Active Monitor';
      const String iconName = 'ic_stat_oksigenia';

      try {
        await flutterLocalNotificationsPlugin.show(
          id: notificationId,
          title: title,
          body: content,
          notificationDetails: NotificationDetails(
              android: AndroidNotificationDetails(
                  channelId, 'Oksigenia SOS - Active Monitor',
                  icon: iconName,
                  ongoing: true,
                  importance: Importance.high,
                  priority: Priority.high,
                  onlyAlertOnce: true,
                  playSound: false,
                  enableVibration: false)),
        );
      } catch (e) {}
    });
  }
  
  await _loadConfigFromDisk();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  return true;
}

@pragma('vm:entry-point')
void _handleNotificationAction(NotificationResponse details) async {
  if (details.actionId == 'resume_monitoring') {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('pause_resume_requested', DateTime.now().millisecondsSinceEpoch);
  }
}