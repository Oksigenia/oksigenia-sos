import 'dart:io'; 
import 'dart:math' as math; 
import 'dart:async'; 
import 'dart:convert'; // Para leer JSON remoto
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sensors_plus/sensors_plus.dart'; 
import 'package:permission_handler/permission_handler.dart'; 
import 'package:vibration/vibration.dart'; 
import 'package:http/http.dart' as http; // El cartero para el Kill Switch
import 'l10n/app_localizations.dart';

// --- CONFIGURACIÓN DE SABORES (FLAVORS) ---
enum AppFlavor { community, store }

class AppConfig {
  // Cuando compiles para la Store, cambia esto manualmente si no usas entry-points separados
  static AppFlavor flavor = AppFlavor.community; 
  
  static bool get isCommunity => flavor == AppFlavor.community;
  static bool get isStore => flavor == AppFlavor.store;
  
  // URL DE CONTROL REMOTO (KILL SWITCH)
  static const String remoteStatusUrl = "https://oksigenia.com/app_status.json";
}

void main() {
  runApp(const OksigeniaSOSApp());
}

class OksigeniaSOSApp extends StatefulWidget {
  const OksigeniaSOSApp({super.key});

  @override
  State<OksigeniaSOSApp> createState() => _OksigeniaSOSAppState();
}

class _OksigeniaSOSAppState extends State<OksigeniaSOSApp> {
  Locale? _locale;

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Oksigenia SOS',
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), 
        Locale('es'), 
        Locale('fr'), 
        Locale('pt'), 
        Locale('de'), 
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB71C1C),
          brightness: Brightness.dark,
          primary: const Color(0xFFD32F2F),
          surface: const Color(0xFF121212),
        ),
        useMaterial3: true,
      ),
      home: SOSScreen(onLanguageChanged: _changeLanguage),
    );
  }
}

class SOSScreen extends StatefulWidget {
  final Function(Locale) onLanguageChanged;
  
  const SOSScreen({super.key, required this.onLanguageChanged});

  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {
  bool _isLoading = false;
  String? _customStatusMessage;

  // Canal Nativo (Kotlin)
  static const platform = MethodChannel('com.oksigenia.oksigenia_sos/sms');

  // Sensores y Lógica
  bool _isMonitoring = false; 
  StreamSubscription? _accelerometerSubscription; 
  bool _isAlertActive = false; 
  Timer? _countdownTimer; 
  Position? _cachedPosition; 
  double _currentForce = 0.0; 
  
  // UMBRAL DE IMPACTO (Ajustado a 30G para uso real)
  final double _impactThreshold = 30.0; 

  @override
  void initState() {
    super.initState();
    // 1. Verificar mensajes remotos (Kill Switch)
    _verificarMensajesRemotos();
    // 2. Mostrar Disclaimer Legal si no se ha aceptado
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkDisclaimer());
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  // --- DISCLAIMER LEGAL ---
  Future<void> _checkDisclaimer() async {
    final prefs = await SharedPreferences.getInstance();
    final bool accepted = prefs.getBool('disclaimer_accepted') ?? false;

    if (!accepted && mounted) {
      String title = "⚠️ AVISO LEGAL / DISCLAIMER";
      String content = """
Esta aplicación es una herramienta de ayuda y NO sustituye a los servicios de emergencia profesionales (112, 911).

El funcionamiento depende del estado del dispositivo, batería, cobertura GPS/SMS y permisos.

Oksigenia no se hace responsable de fallos en el envío o errores de localización.

Úsala bajo tu propia responsabilidad.
      """;

      // Versión Inglés simple si el móvil está en inglés
      if (Localizations.localeOf(context).languageCode == 'en') {
        title = "⚠️ LIABILITY WAIVER";
        content = """
This app is a support tool and DOES NOT replace professional emergency services (112, 911).

Functionality depends on device health, battery, GPS/SMS coverage, and permissions.

Oksigenia is not liable for transmission failures or consequences resulting from use.

Use at your own risk.
        """;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: Text(title, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(child: Text(content, style: const TextStyle(color: Colors.white))),
          actions: [
            TextButton(
              onPressed: () => SystemNavigator.pop(), // Cierra la app
              child: const Text("SALIR / EXIT", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                await prefs.setBool('disclaimer_accepted', true);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text("ACEPTAR / ACCEPT", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
  }

  // --- KILL SWITCH ---
  Future<void> _verificarMensajesRemotos() async {
    try {
      final response = await http.get(Uri.parse(AppConfig.remoteStatusUrl)).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['active'] == true) {
          final prefs = await SharedPreferences.getInstance();
          final int lastSeen = prefs.getInt('last_msg_version') ?? 0;
          final int current = data['version'] ?? 0;

          if (current > lastSeen || data['kill'] == true) {
             if (mounted) _mostrarAlertaRemota(data['title'], data['message'], data['kill'] == true, current);
          }
        }
      }
    } catch (e) {
      // Sin internet, ignoramos
    }
  }

  void _mostrarAlertaRemota(String? title, String? body, bool isKillSwitch, int version) {
    showDialog(
      context: context,
      barrierDismissible: !isKillSwitch,
      builder: (context) => AlertDialog(
        backgroundColor: isKillSwitch ? Colors.red.shade900 : Colors.grey.shade900,
        title: Text(title ?? "Aviso", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(body ?? "", style: const TextStyle(color: Colors.white)),
        actions: [
          if (!isKillSwitch)
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setInt('last_msg_version', version);
                Navigator.pop(context);
              },
              child: const Text("Entendido"),
            ),
        ],
      ),
    );
  }

  // --- ACTIVAR MONITORIZACIÓN ---
  Future<void> _toggleMonitoring(bool value) async {
    final l10n = AppLocalizations.of(context)!;

    if (value) {
      final prefs = await SharedPreferences.getInstance();
      final String? contacto = prefs.getString('sos_contact');
      if (contacto == null || contacto.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.errorNoContact), backgroundColor: Colors.red));
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfigScreen()));
        }
        return; 
      }

      if (Platform.isAndroid) {
        if (!await Permission.sms.isGranted) {
          await Permission.sms.request();
          if (!await Permission.sms.isGranted) {
             _showPermissionError("Se requiere permiso SMS");
             return;
          }
        }
      }

      LocationPermission locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.denied) {
           _showPermissionError("Se requiere permiso de Ubicación");
           return;
        }
      }
      if (locationPermission == LocationPermission.deniedForever) {
          _showPermissionError("Ubicación bloqueada. Actívala en Ajustes.");
          await Geolocator.openAppSettings();
          return;
      }
    }

    setState(() {
      _isMonitoring = value;
      if (!value) _currentForce = 0.0; 
    });

    if (_isMonitoring) {
      _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
        double force = math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
        if (mounted) setState(() { _currentForce = force; });
        if (_isAlertActive) return; 
        if (force > _impactThreshold) {
          _triggerFallAlert();
        }
      });
    } else {
      _accelerometerSubscription?.cancel();
      _accelerometerSubscription = null;
    }
  }

  void _showPermissionError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("⚠️ $msg"), backgroundColor: Colors.orange));
    }
  }

  // --- ALERTA Y CUENTA ATRÁS ---
  void _triggerFallAlert() async {
    setState(() { _isAlertActive = true; });

    _iniciarGPSEnSegundoPlano(); 

    int secondsRemaining = 60; 
    
    if (await Vibration.hasVibrator() ?? false) {
       Vibration.vibrate(duration: 1000); 
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            _countdownTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
              
              Vibration.vibrate(duration: 500);

              if (secondsRemaining > 0) {
                setStateDialog(() { secondsRemaining--; });
              } else {
                _pararTimer();
                Navigator.pop(context); 
                setState(() { _isAlertActive = false; });
                _activarProtocoloSOS(autoMode: true); 
              }
            });

            bool gpsLocked = _cachedPosition != null;

            return AlertDialog(
              backgroundColor: const Color(0xFFB71C1C),
              title: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.white, size: 40),
                  SizedBox(width: 10),
                  Expanded(child: Text("IMPACTO / IMPACT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("SOS en / in...", style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 10),
                  Text("$secondsRemaining", style: const TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: gpsLocked ? Colors.green : Colors.black26,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(gpsLocked ? Icons.gps_fixed : Icons.gps_not_fixed, color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          gpsLocked ? "UBICACIÓN FIJADA" : "Buscando satélites...", 
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text("Pulsa CANCELAR si estás bien.", style: TextStyle(color: Colors.white70), textAlign: TextAlign.center),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _pararTimer();
                    Navigator.pop(context);
                    setState(() { _isAlertActive = false; });
                    _activarProtocoloSOS(autoMode: false);
                  },
                  child: const Text("ENVIAR AHORA", style: TextStyle(color: Colors.white70)),
                ),
                ElevatedButton(
                  onPressed: () {
                    _pararTimer();
                    Navigator.pop(context);
                    setState(() { _isAlertActive = false; });
                    _cachedPosition = null; 
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Text("ESTOY BIEN (CANCELAR)", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
        _pararTimer();
        if (mounted) setState(() { _isAlertActive = false; });
    });
  }

  void _pararTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    Vibration.cancel(); 
  }

  Future<void> _iniciarGPSEnSegundoPlano() async {
    _cachedPosition = null; 
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return; 
      _cachedPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 55), 
      );
    } catch (e) {
      debugPrint("GPS Background Error: $e");
    }
  }

  Future<void> _activarProtocoloSOS({bool autoMode = false}) async {
    final l10n = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();
    final String? contactoEmergencia = prefs.getString('sos_contact');

    if (contactoEmergencia == null || contactoEmergencia.isEmpty) {
      if (mounted && !autoMode) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfigScreen()));
      }
      return; 
    }

    setState(() {
      _isLoading = true;
      _customStatusMessage = l10n.statusConnecting;
    });

    String mensajeFinal = "";
    Position? finalPosition;

    try {
      if (_cachedPosition != null) {
        finalPosition = _cachedPosition;
      } else {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled && !autoMode) {
          await Geolocator.openLocationSettings();
          setState(() { _isLoading = false; _customStatusMessage = "⚠️ GPS OFF"; });
          return; 
        }
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
           if (!autoMode) permission = await Geolocator.requestPermission();
        }
        finalPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 15), 
        );
      }
      String link = "http://maps.google.com/?q=${finalPosition!.latitude},${finalPosition.longitude}";
      mensajeFinal = l10n.panicMessage(link);
    } catch (e) {
      mensajeFinal = l10n.panicMessage("N/A (GPS Error/Timeout)");
    }

    try {
      if (Platform.isAndroid && autoMode) {
        try {
          await platform.invokeMethod('sendBackgroundSms', {
            'phone': contactoEmergencia,
            'msg': mensajeFinal,
          });
          if (mounted) setState(() { _isLoading = false; _customStatusMessage = "⚡ AUTO-SOS SENT (NATIVE) ⚡"; });
        } on PlatformException catch (e) {
           setState(() { _isLoading = false; _customStatusMessage = "❌ ERROR NATIVO: ${e.message}"; });
        }
      } else {
        final Uri smsUri = Uri(
          scheme: 'sms', path: contactoEmergencia, queryParameters: <String, String>{ 'body': mensajeFinal },
        );
        if (await canLaunchUrl(smsUri)) {
          await launchUrl(smsUri, mode: LaunchMode.platformDefault);
          setState(() { _isLoading = false; _customStatusMessage = l10n.statusSent; });
        } else {
          throw 'NO_SMS_APP';
        }
      }
    } catch (e) {
      final Uri smsUri = Uri(
          scheme: 'sms', path: contactoEmergencia, queryParameters: <String, String>{ 'body': mensajeFinal },
      );
      await launchUrl(smsUri, mode: LaunchMode.platformDefault);
      setState(() { _isLoading = false; _customStatusMessage = l10n.statusError("SMS ERROR"); });
    }
    _cachedPosition = null; 
  }

  Future<void> _abrirLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) debugPrint("Error $url");
  }

  Future<void> _enviarEmail() async {
    final Uri emailLaunchUri = Uri(scheme: 'mailto', path: 'contacto@oksigenia.com');
    await launchUrl(emailLaunchUri);
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold(context);
  }

  Widget _buildScaffold(BuildContext context) {
     final l10n = AppLocalizations.of(context);
    if (l10n == null) return const CircularProgressIndicator();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(l10n.appTitle, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2.0)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_isMonitoring)
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: const Icon(Icons.monitor_heart, color: Colors.greenAccent), 
            )
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF181818),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1F1F1F), Color(0xFF000000)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/OksigeniaAlfa.png', height: 80, color: Colors.white),
                    const SizedBox(height: 15),
                    Text(l10n.motto, style: const TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.redAccent),
              title: Text(l10n.menuSettings, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfigScreen()));
              },
            ),
             const Divider(color: Colors.white10),
            ExpansionTile(
              leading: const Icon(Icons.translate, color: Colors.orangeAccent),
              title: Text(l10n.menuLanguages, style: const TextStyle(color: Colors.white)),
              children: [
                _buildLanguageItem(context, "ES", "Español", const Locale('es')),
                _buildLanguageItem(context, "EN", "English", const Locale('en')),
                _buildLanguageItem(context, "FR", "Français", const Locale('fr')),
                _buildLanguageItem(context, "PT", "Português", const Locale('pt')),
                _buildLanguageItem(context, "DE", "Deutsch", const Locale('de')),
              ],
            ),
            const Divider(color: Colors.white10),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.globe, color: Colors.blueAccent),
              title: Text(l10n.menuWeb, style: const TextStyle(color: Colors.white)),
              onTap: () => _abrirLink('https://oksigenia.com'),
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.instagram, color: Colors.purpleAccent),
              title: const Text('Instagram', style: TextStyle(color: Colors.white)),
              onTap: () => _abrirLink('https://instagram.com/oksigenia'),
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.xTwitter, color: Colors.white),
              title: const Text('X', style: TextStyle(color: Colors.white)),
              onTap: () => _abrirLink('https://x.com/oksigeniaX'),
            ),
            const Divider(color: Colors.white10),
            ListTile(
              leading: const Icon(Icons.support_agent, color: Colors.greenAccent),
              title: Text(l10n.menuSupport, style: const TextStyle(color: Colors.white)),
              onTap: _enviarEmail,
            ),
             const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("© 2026 Oksigenia v2.0 RC", style: TextStyle(color: Colors.white24), textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: _isMonitoring ? Colors.greenAccent.withOpacity(0.5) : Colors.transparent),
                ),
                child: SwitchListTile(
                  title: Text(l10n.autoModeLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(l10n.autoModeDescription, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  value: _isMonitoring,
                  activeColor: Colors.greenAccent,
                  secondary: Icon(
                    _isMonitoring ? Icons.local_hospital : Icons.local_hospital_outlined, 
                    color: _isMonitoring ? Colors.greenAccent : Colors.grey
                  ),
                  onChanged: (val) => _toggleMonitoring(val), 
                ),
              ),
              const SizedBox(height: 20),
              if (_isMonitoring)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: _currentForce > 13.0 ? Colors.red : Colors.greenAccent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "FORCE: ${_currentForce.toStringAsFixed(2)} m/s²",
                    style: TextStyle(
                      fontFamily: 'Monospace',
                      fontSize: 24,
                      color: _currentForce > 13.0 ? Colors.red : Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _isLoading ? null : () => _activarProtocoloSOS(autoMode: false),
                child: Container(
                  width: 240, height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: _isLoading ? [Colors.grey.shade800, Colors.grey.shade900] : [const Color(0xFFE53935), const Color(0xFFB71C1C)],
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                    ),
                    boxShadow: [if (!_isLoading) BoxShadow(color: const Color(0xFFB71C1C).withOpacity(0.5), blurRadius: 30, spreadRadius: 5)],
                    border: Border.all(color: Colors.white12, width: 3),
                  ),
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(l10n.sosButton, style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20)),
                child: Text(
                  _customStatusMessage ?? l10n.statusReady,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontFamily: 'Monospace', fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageItem(BuildContext context, String code, String label, Locale locale) {
    return ListTile(
      leading: Container(
        width: 34, height: 34,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24, width: 1.5),
        ),
        child: Center(child: Text(code, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
      ),
      title: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      onTap: () {
        widget.onLanguageChanged(locale);
        Navigator.pop(context);
      },
    );
  }
}

// -----------------------------------------------------------------------------
// PANTALLA DE CONFIGURACIÓN
// -----------------------------------------------------------------------------
class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});
  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadSavedNumber();
  }

  Future<void> _loadSavedNumber() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedNumber = prefs.getString('sos_contact');
    if (savedNumber == null || savedNumber.isEmpty) savedNumber = _getSmartPrefix();
    setState(() { _phoneController.text = savedNumber ?? ''; });
  }

   String _getSmartPrefix() {
    try {
      final String systemLocale = Platform.localeName; 
      final List<String> parts = systemLocale.split('_');
      if (parts.length < 2) return '+'; 
      String countryCode = parts[1].toUpperCase(); 
      switch (countryCode) {
        case 'ES': return '+34 '; case 'FR': return '+33 '; case 'PT': return '+351 '; case 'DE': return '+49 ';
        case 'US': return '+1 '; case 'MX': return '+52 '; case 'AR': return '+54 '; case 'GB': return '+44 '; 
        default: return '+'; 
      }
    } catch (e) { return '+'; }
  }

  Future<void> _saveNumber() async {
    if (_phoneController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("⚠️ Número demasiado corto"), backgroundColor: Colors.red));
      return;
    }
    setState(() { _isSaving = true; });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sos_contact', _phoneController.text.trim());
    
    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.settingsSavedMsg), backgroundColor: Colors.green));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(l10n.settingsTitle, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.settingsLabel, style: const TextStyle(color: Colors.white70, fontSize: 16)),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: l10n.settingsHint, filled: true, fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.phone, color: Colors.redAccent),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveNumber,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD32F2F), foregroundColor: Colors.white),
                  child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : Text(l10n.settingsSave, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              
              // --- ZONA FUNCIONES AVANZADAS ---
              const SizedBox(height: 40),
              const Divider(color: Colors.white24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Funciones Avanzadas", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: const Text("Multi-contacto, Tracking GPS...", style: TextStyle(color: Colors.white54)),
                trailing: const Icon(Icons.lock_open, color: Colors.amber),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: Colors.grey.shade900,
                      title: Text(
                        AppConfig.isCommunity ? "💎 Oksigenia Community" : "🔒 Oksigenia Pro",
                        style: const TextStyle(color: Colors.white)
                      ),
                      content: Text(
                        AppConfig.isCommunity 
                          ? "Esta es la versión COMMUNITY (Libre).\n\nTodas las funciones están desbloqueadas gracias al código abierto.\n\nSi te es útil, considera una donación voluntaria para mantener los servidores (¡aunque no tenemos!)."
                          : "Suscríbete a la versión PRO para desbloquear múltiples contactos y seguimiento en tiempo real.",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cerrar")),
                        if (AppConfig.isCommunity)
                          ElevatedButton(
                            onPressed: () => _abrirWebDonar(), 
                            child: const Text("Invitar a un café ☕"),
                          ),
                        if (AppConfig.isStore)
                          ElevatedButton(
                            onPressed: () {}, 
                            child: const Text("Suscribirse"),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _abrirWebDonar() async {
    final Uri uri = Uri.parse("https://oksigenia.com/donar");
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) debugPrint("Error $uri");
  }
}