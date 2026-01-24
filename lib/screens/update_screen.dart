import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateScreen extends StatelessWidget {
  final String updateUrl;

  const UpdateScreen({super.key, required this.updateUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB71C1C), // Rojo Alerta
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.system_security_update, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              "ACTUALIZACIÓN REQUERIDA\nUPDATE REQUIRED",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Esta versión es antigua y ha dejado de funcionar por seguridad. Por favor, actualiza ahora.\n\n"
              "This version is obsolete and disabled for security. Please update now.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red[900],
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)
              ),
              onPressed: () {
                final Uri uri = Uri.parse(updateUrl);
                launchUrl(uri, mode: LaunchMode.externalApplication);
              },
              icon: const Icon(Icons.download),
              label: const Text("DESCARGAR / DOWNLOAD"),
            ),
          ],
        ),
      ),
    );
  }
}
