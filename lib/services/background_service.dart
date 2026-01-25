import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      icon: 'ic_stat_oksigenia',
      autoStart: false, 
      isForegroundMode: false, 
      notificationChannelId: 'oksigenia_sos_modular_v1', 
      initialNotificationTitle: 'OKSIGENIA SOS',
      initialNotificationContent: 'Iniciando...',
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

  if (service is AndroidServiceInstance) {
    // 1. AUTO-PROMOCIÓN AL INICIO
    Timer(const Duration(seconds: 1), () async {
      await _updateNotificationText(service);
      service.setAsForegroundService();
      print("SYLVIA: Uniforme puesto al arrancar.");
    });

    // 2. ESCUCHA CAMBIOS DE IDIOMA (NUEVO)
    // Cuando la App principal nos grite 'updateLanguage', actualizamos el texto al instante.
    service.on('updateLanguage').listen((event) async {
      print("SYLVIA: Recibida orden de cambio de idioma.");
      await _updateNotificationText(service);
    });

    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // 3. PULSO CARDÍACO (60s)
  Timer.periodic(const Duration(seconds: 60), (timer) async {
    if (service is AndroidServiceInstance) {
      bool isForeground = await service.isForegroundService();
      print("SYLVIA PULSO: ¿Sigo en Foreground? $isForeground");
      
      if (!isForeground) {
        print("SYLVIA: Recuperando rango...");
        service.setAsForegroundService();
        await _updateNotificationText(service);
      }
    }
  });
}

// Función auxiliar para no repetir código
Future<void> _updateNotificationText(AndroidServiceInstance service) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    // Forzamos la recarga de preferencias por si acaso estaban en caché
    await prefs.reload(); 
    final langCode = prefs.getString('language_code') ?? 'es';
    
    String title = "Oksigenia SOS";
    String content = "Protección activada"; // Español por defecto

    if (langCode == 'en') { content = "Protection active"; }
    else if (langCode == 'fr') { content = "Protection active"; }
    else if (langCode == 'pt') { content = "Proteção ativa"; }
    else if (langCode == 'de') { content = "Schutz aktiv"; }

    service.setForegroundNotificationInfo(
      title: title,
      content: content,
    );
  } catch (e) {
    print("SYLVIA ERROR al traducir: $e");
  }
}
