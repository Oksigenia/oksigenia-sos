import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 🧠 MEMORIA DE SYLVIA (Variable global para el aislamiento)
String? _lastContent;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      
      // Mantenemos esto en false como lo estaba (arranca con el toggle)
      autoStart: true, 
      isForegroundMode: false, 
      
      notificationChannelId: 'oksigenia_sos_modular_v1',       
      initialNotificationTitle: 'OKSIGENIA SOS',
      initialNotificationContent: 'Iniciando...',
      
      // Mantiene los tipos de servicio (vital para GPS)
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
      await _updateNotificationText(service, force: true); // Forzamos la primera vez
      service.setAsForegroundService();
      print("SYLVIA: Uniforme puesto al arrancar.");
    });

    // 2. ESCUCHA CAMBIOS DE IDIOMA
    service.on('updateLanguage').listen((event) async {
      print("SYLVIA: Recibida orden de cambio de idioma.");
      // Aquí forzamos actualización porque el idioma ha cambiado
      await _updateNotificationText(service, force: true);
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
      // Solo 'debug print' si realmente pasa algo raro, para no ensuciar la consola
      if (!isForeground) {
        print("SYLVIA: Recuperando rango...");
        service.setAsForegroundService();
        // Si hemos perdido el foreground, forzamos la notificación para recuperarlo
        await _updateNotificationText(service, force: true);
      } else {
        // Si todo está bien, intentamos actualizar pero "sin molestar"
        // (Solo actualizará si el texto cambió por alguna razón externa)
        await _updateNotificationText(service, force: false);
      }
    }
  });
}

// 🧠 FUNCIÓN OPTIMIZADA: Solo notifica si hay cambios
Future<void> _updateNotificationText(AndroidServiceInstance service, {bool force = false}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload(); 
    final langCode = prefs.getString('language_code') ?? 'es';
    
    String title = "Oksigenia SOS";
    String content = "Protección activada"; 

    if (langCode == 'en') { content = "Protection active"; }
    else if (langCode == 'fr') { content = "Protection active"; }
    else if (langCode == 'pt') { content = "Proteção ativa"; }
    else if (langCode == 'de') { content = "Schutz aktiv"; }

    // ✨ LA MAGIA: Si el texto es igual al anterior y no nos obligan, NO HACEMOS NADA.
    // Esto evita que Android pite o parpadee innecesariamente.
    if (!force && content == _lastContent) {
      return; 
    }

    // Si cambió o es forzado, actualizamos y guardamos en memoria
    _lastContent = content;

    service.setForegroundNotificationInfo(
      title: title,
      content: content,
    );
    print("SYLVIA: Notificación actualizada a ($langCode)");
    
  } catch (e) {
    print("SYLVIA ERROR al traducir: $e");
  }
}