import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const OksigeniaSOSApp());
}

class OksigeniaSOSApp extends StatelessWidget {
  const OksigeniaSOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oksigenia SOS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB71C1C), // Rojo Emergencia
          brightness: Brightness.dark, // Modo oscuro para ahorrar batería
        ),
        useMaterial3: true,
      ),
      home: const SOSScreen(),
    );
  }
}

class SOSScreen extends StatefulWidget {
  const SOSScreen({super.key});

  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {
  bool _isLoading = false;
  String _statusMessage = "Sistema listo. Esperando activación.";

  /// Función Principal: Obtener GPS y Lanzar WhatsApp
  Future<void> _activarProtocoloSOS() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "Obteniendo ubicación satelital...";
    });

    try {
      // 1. Verificar Permisos (Básico para MVP)
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Permisos de ubicación denegados.';
        }
      }

      // 2. Obtener Posición (Precisión Alta)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 3. Generar Enlace de Google Maps
      String mapsLink = "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";
      
      // 4. Crear Mensaje de Texto
      String mensaje = "¡AYUDA! Necesito asistencia inmediata. \n\n"
          "📍 Mi ubicación: $mapsLink \n"
          "🔋 Batería: (Pendiente)";

      // 5. Preparar URL para WhatsApp (Universal)
      // Nota: En Linux abrirá el navegador, en Android abrirá la App.
      final Uri whatsappUrl = Uri.parse("https://wa.me/?text=${Uri.encodeComponent(mensaje)}");

      // 6. Lanzar
      setState(() => _statusMessage = "Abriendo canal de emergencia...");
      if (!await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication)) {
        throw 'No se pudo abrir WhatsApp/Navegador.';
      }

      setState(() {
        _isLoading = false;
        _statusMessage = "Alerta generada con éxito.";
      });

    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = "ERROR: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Icono de Oksigenia (Placeholder)
              const Icon(Icons.shield_outlined, size: 60, color: Colors.white54),
              const SizedBox(height: 40),
              
              // EL BOTÓN DE PÁNICO
              GestureDetector(
                onTap: _isLoading ? null : _activarProtocoloSOS,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _isLoading 
                        ? [Colors.grey, Colors.black45]
                        : [const Color(0xFFD32F2F), const Color(0xFFB71C1C)],
                    ),
                    boxShadow: [
                      if (!_isLoading)
                        BoxShadow(
                          color: const Color(0xFFD32F2F).withOpacity(0.6),
                          blurRadius: 30,
                          spreadRadius: 5,
                        )
                    ],
                  ),
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "SOS",
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                  ),
                ),
              ),
              
              const SizedBox(height: 50),
              
              // Consola de Estado
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white24),
                ),
                child: Text(
                  _statusMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70, 
                    fontFamily: 'Courier', // Estilo "Hacker/Terminal"
                    fontSize: 14
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}