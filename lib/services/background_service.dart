import 'dart:async';
import 'dart:ui';
import 'dart:math'; 
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sensors_plus/sensors_plus.dart'; 
// Importación de tus localizaciones
import 'package:oksigenia_sos/l10n/app_localizations.dart'; 

// 🧠 MEMORIA DE SYLVIA
String? _lastContent;
const String notificationChannelId = 'oksigenia_sos_modular_v2'; 
// 🔥 NUEVO CANAL DE ALARMA (PRIORIDAD MÁXIMA)
const String alarmChannelId = 'oksigenia_sos_alarm_v1';

StreamSubscription? _serviceAccelerometerSubscription; 

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // 1. CANAL DE VIGILANCIA (Silencioso/Normal)
  const AndroidNotificationChannel channelMonitor = AndroidNotificationChannel(
    notificationChannelId, 
    'Oksigenia SOS Monitor',
    description: 'Notificación persistente de seguridad',
    importance: Importance.defaultImportance,
  );

  // 2. CANAL DE ALARMA (Ruidoso/Crítico)
  const AndroidNotificationChannel channelAlarm = AndroidNotificationChannel(
    alarmChannelId, 
    'Oksigenia SOS ALARM',
    description: 'Alertas críticas de impacto',
    importance: Importance.max, // 🔥 MÁXIMA PRIORIDAD
    playSound: false, // El sonido lo pone la app, pero la prioridad visual es máxima
  );
  
  // Creamos ambos canales
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channelMonitor);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channelAlarm);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true, 
      isForegroundMode: true, 
      notificationChannelId: notificationChannelId,       
      initialNotificationTitle: 'Oksigenia SOS',
      initialNotificationContent: 'System Ready',
      // 🔥 CRÍTICO: Ata el servicio a nuestra notificación ID 888
      foregroundServiceNotificationId: 888, 
      foregroundServiceTypes: [
        AndroidForegroundType.location,
        AndroidForegroundType.dataSync,
      ],
    ),
    iosConfiguration: IosConfiguration(),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  // 1. RECUPERACIÓN DE ESTADO INMEDIATA
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  
  bool fallActive = prefs.getBool('fall_detection_enabled') ?? false;
  bool inactActive = prefs.getBool('inactivity_monitor_enabled') ?? false;
  
  // Actualizamos la notificación visualmente YA
  await _updateNotificationText(service, force: true);

  // 2. ACTIVACIÓN DE SENSORES "HEADLESS" (SIN PANTALLA)
  if (fallActive || inactActive) {
    _startBackgroundSensorListener(service);
    print("SYLVIA: Reinicio detectado o servicio iniciado. Sensores activos.");
  }

  if (service is AndroidServiceInstance) {
    service.on('updateLanguage').listen((event) async {
      await _updateNotificationText(service, force: true);
      
      // Re-verificamos si debemos encender/apagar sensores tras un cambio de config
      final p = await SharedPreferences.getInstance();
      bool f = p.getBool('fall_detection_enabled') ?? false;
      bool i = p.getBool('inactivity_monitor_enabled') ?? false;
      
      if (f || i) {
        _startBackgroundSensorListener(service);
      } else {
        _serviceAccelerometerSubscription?.cancel();
        _serviceAccelerometerSubscription = null;
        print("SYLVIA: Sensores en segundo plano pausados.");
      }
    });

    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    _serviceAccelerometerSubscription?.cancel();
    service.stopSelf();
  });

  // Pulso cardíaco (60s)
  Timer.periodic(const Duration(seconds: 60), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        await _updateNotificationText(service);
      }
    }
  });
}

// 👂 OÍDO INTERNO DE SYLVIA (Lógica de respaldo para cuando no hay UI)
void _startBackgroundSensorListener(ServiceInstance service) {
  if (_serviceAccelerometerSubscription != null) return; 

  print("SYLVIA: Iniciando escucha de acelerómetro en Background Isolate...");
  
  _serviceAccelerometerSubscription = accelerometerEventStream(samplingPeriod: SensorInterval.gameInterval)
      .listen((AccelerometerEvent event) async {
        
        double gForce = sqrt(event.x * event.x + event.y * event.y + event.z * event.z) / 9.81;
        
        // Umbral de impacto
        if (gForce > 12.0) {
           print("SYLVIA (Background): 💥 IMPACTO DETECTADO ($gForce G)");
           
           // Cargar traducciones para la alerta
           final prefs = await SharedPreferences.getInstance();
           String lang = prefs.getString('language_code') ?? 'en';
           final t = await AppLocalizations.delegate.load(Locale(lang));

           final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
           
           // 🔥 USAMOS EL CANAL DE ALARMA (PRIORIDAD MÁXIMA)
           await flutterLocalNotificationsPlugin.show(
              id: 888,
              title: t.alertFallDetected, 
              body: t.alertFallBody,      
              notificationDetails: NotificationDetails(
                android: AndroidNotificationDetails(
                  alarmChannelId, // <--- AQUÍ ESTÁ LA CLAVE
                  'Oksigenia SOS ALARM',
                  importance: Importance.max,
                  priority: Priority.high,
                  color: const Color(0xFFFF0000),
                  colorized: true,
                  playSound: false, 
                  enableVibration: true,
                  fullScreenIntent: true, // Intento de pantalla completa
                  category: AndroidNotificationCategory.alarm,
                  visibility: NotificationVisibility.public,
                ),
              ),
           );
           
           // Intentamos despertar la UI también por el canal de servicio
           service.invoke("force_ui_wake"); 
        }
      }, onError: (e) {
        print("SYLVIA: Error en sensor background: $e");
      });
}


// 🛡️ SYLVIA V5.0: Notificación Internacionalizada
Future<void> _updateNotificationText(dynamic service, {bool force = false}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload(); 
    final langCode = prefs.getString('language_code') ?? 'en';

    // 🔥 CARGA DINÁMICA DEL ARB
    final t = await AppLocalizations.delegate.load(Locale(langCode));

    bool fallActive = prefs.getBool('fall_detection_enabled') ?? false; 
    bool inactActive = prefs.getBool('inactivity_monitor_enabled') ?? false;
    bool isProtecting = fallActive || inactActive;

    String title = "";
    String content = "";

    if (isProtecting) {
      // ESTADO: ACTIVO (Verde)
      // Título: El estado actual (Evita duplicar "Oksigenia SOS")
      if (langCode == 'es') title = "🛡️ Protección Activa";
      else if (langCode == 'fr') title = "🛡️ Protection Active";
      else if (langCode == 'pt') title = "🛡️ Proteção Ativa";
      else if (langCode == 'de') title = "🛡️ Schutz Aktiv";
      else title = "🛡️ Active Protection"; 

      if (fallActive) content = "${t.autoModeLabel} ON"; 
      else if (inactActive) content = "${t.inactivityModeLabel} ON";
      else content = "Sensors ON";

    } else {
      // ESTADO: PAUSA (Rojo/Gris)
      // Título: Claramente indica que NO está vigilando
      if (langCode == 'es') title = "⏸️ Sistema en Pausa";
      else if (langCode == 'fr') title = "⏸️ Système en Pause";
      else if (langCode == 'pt') title = "⏸️ Sistema em Pausa";
      else if (langCode == 'de') title = "⏸️ System Pausiert";
      else title = "⏸️ System Paused"; 

      // Cuerpo: Instrucción clara
      if (langCode == 'es') content = "Sensores detenidos.";
      else if (langCode == 'fr') content = "Capteurs arrêtés.";
      else if (langCode == 'pt') content = "Sensores parados.";
      else if (langCode == 'de') content = "Sensoren gestoppt.";
      else content = "Sensors stopped.";
    }

    if (!force && content == _lastContent) return; 
    _lastContent = content;

    String iconName;
    Color statusColor;

    if (isProtecting) {
      // Usamos los escudos XML que creamos antes (son infalibles)
      iconName = 'ic_stat_protected'; 
      statusColor = const Color(0xFF00C853); 
    } else {
      iconName = 'ic_stat_paused';    
      statusColor = const Color(0xFFD50000); 
    }

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // USAMOS EL CANAL DE MONITOR (NORMAL)
    await flutterLocalNotificationsPlugin.show(
      id: 888, 
      title: title,
      body: content,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          notificationChannelId, 
          'Oksigenia SOS Monitor',
          channelDescription: 'Estado del servicio de seguridad',
          icon: iconName,
          ongoing: true,
          autoCancel: false,
          importance: Importance.defaultImportance, 
          priority: Priority.defaultPriority,
          playSound: false,
          enableVibration: false,
          onlyAlertOnce: true, 
          showWhen: false,
          color: statusColor, 
          colorized: false, 
        ),
      ),
    );

    print("SYLVIA: Escudo actualizado -> $content ($iconName)");

  } catch (e) {
    print("Error crítico en el escudo de Sylvia: $e");
  }
}