import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  static const String _url = "https://oksigenia.com/app_status.json";

  Future<Map<String, dynamic>> checkStatus() async {
    try {
      // 1. Obtener versión actual de la App (ej: 3.8.0)
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version; 

      // 2. Descargar JSON con timeout de 5 segundos
      final response = await http.get(Uri.parse(_url)).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        String minVersion = data['min_version'] ?? "0.0.0";
        bool blockApp = _isVersionOlder(currentVersion, minVersion);
        
        return {
          "block": blockApp,
          "message_es": data['message_es'],
          "message_en": data['message_en'],
          "update_url": data['update_url'] ?? "https://oksigenia.com"
        };
      }
    } catch (e) {
      debugPrint("Remote Config Error: $e");
    }
    // Si falla internet o el servidor, dejamos pasar (Fail Open)
    return {"block": false};
  }

  // Compara si 'current' es más vieja que 'min'
  bool _isVersionOlder(String current, String min) {
    try {
      // Limpiamos sufijos como +24 para comparar solo números principales
      String cleanCurrent = current.split('+')[0];
      String cleanMin = min.split('+')[0];

      List<int> currParts = cleanCurrent.split('.').map(int.parse).toList();
      List<int> minParts = cleanMin.split('.').map(int.parse).toList();

      for (int i = 0; i < minParts.length; i++) {
        int cPart = i < currParts.length ? currParts[i] : 0;
        int mPart = minParts[i];

        if (cPart < mPart) return true; // Es vieja -> Bloquear
        if (cPart > mPart) return false; // Es nueva -> Pasar
      }
      return false; 
    } catch (e) {
      return false; // Ante la duda, no bloquear
    }
  }
}
