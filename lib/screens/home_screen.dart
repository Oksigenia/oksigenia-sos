import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:permission_handler/permission_handler.dart'; 
import 'package:oksigenia_sos/l10n/app_localizations.dart';
import 'package:oksigenia_sos/logic/sos_logic.dart';
import 'package:oksigenia_sos/widgets/main_drawer.dart';
import 'package:oksigenia_sos/services/remote_config_service.dart';
import 'package:oksigenia_sos/screens/update_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final SOSLogic _sosLogic = SOSLogic();
  bool _hasShownWarning = false; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); 
    
    _sosLogic.init();
    WakelockPlus.enable();
    
    // BACKUP DE SEGURIDAD (v3.8.3 Logic)
    Future.delayed(const Duration(seconds: 1), () {
      FlutterBackgroundService().isRunning().then((isRunning) {
        if (!isRunning) {
          print("SYLVIA: Arrancando servicio forzosamente desde UI");
          FlutterBackgroundService().startService();
        }
      });
    });

    _checkRemoteConfig();
  }

  void _checkRemoteConfig() async {
    final result = await RemoteConfigService().checkStatus();
    if (!mounted) return;

    if (result['block'] == true) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => UpdateScreen(updateUrl: result['update_url']))
      );
      return;
    }

    String msgEs = result['message_es'] ?? "";
    if (msgEs.isNotEmpty && !msgEs.contains("Sistema Oksigenia SOS Activo")) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text("📢 $msgEs"),
           backgroundColor: Colors.blue[800],
           duration: const Duration(seconds: 5),
           action: SnackBarAction(label: "OK", textColor: Colors.white, onPressed: (){}),
         )
       );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("🔄 APP RESUMED: Verificando servicio tras volver de ajustes...");
      FlutterBackgroundService().isRunning().then((isRunning) {
        if (!isRunning) {
          FlutterBackgroundService().startService();
        } else {
           FlutterBackgroundService().invoke("updateLanguage");
        }
      });
      _sosLogic.init(); 
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sosLogic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _sosLogic,
      builder: (context, child) {
        return Scaffold(
          // AppBar limpia: sin color de fondo, toma el del Theme (Main.dart)
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.appTitle),
            centerTitle: true,
            elevation: 0,
          ),
          drawer: MainDrawer(sosLogic: _sosLogic),
          body: _buildBody(context),
        );
      }
    );
  }

  Widget _buildBody(BuildContext context) {
    // Pantallas de Emergencia (Colores Fijos SIEMPRE)
    if (_sosLogic.status == SOSStatus.preAlert) {
      return _buildPreAlertUI(context);
    }
    
    if (_sosLogic.status == SOSStatus.sent) {
      return _buildSentUI(context);
    }

    final l10n = AppLocalizations.of(context)!;
    
    // UI Normal (Se adapta a Claro/Oscuro)
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // STATUS PILL (Pastilla de estado)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                // Usamos colores con transparencia para que se vean bien en negro y blanco
                color: _sosLogic.status == SOSStatus.locationFixed 
                    ? Colors.green.withOpacity(0.1) 
                    : Colors.grey.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _sosLogic.status == SOSStatus.locationFixed 
                      ? Colors.green 
                      : Colors.grey
                )
              ),
              child: Text(
                _sosLogic.status == SOSStatus.locationFixed 
                    ? l10n.statusLocationFixed 
                    : (_sosLogic.status == SOSStatus.scanning 
                        ? l10n.statusConnecting 
                        : l10n.statusReady),
                style: TextStyle(
                  // El texto gris se ve bien en ambos modos
                  color: _sosLogic.status == SOSStatus.locationFixed ? Colors.green : Colors.grey,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            
            const SizedBox(height: 25),

            // HEALTH DASHBOARD (Iconos y Datos)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // G-Force
                  Column(
                    children: [
                      const Icon(Icons.speed, color: Colors.grey, size: 48),
                      const SizedBox(height: 6),
                      Text(
                        "${_sosLogic.currentGForce.toStringAsFixed(2)}G",
                        // Sin color fijo: será Negro en día, Blanco en noche
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)
                      ),
                    ],
                  ),
                  // Batería
                  Column(
                    children: [
                      Icon(
                        _sosLogic.batteryLevel > 20 ? Icons.battery_std : Icons.battery_alert, 
                        color: _sosLogic.batteryLevel > 20 ? Colors.green : Colors.red, 
                        size: 48 
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${_sosLogic.batteryLevel}%", 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)
                      ),
                    ],
                  ),
                  // GPS
                  Column(
                    children: [
                      Icon(
                        Icons.gps_fixed, 
                        color: _sosLogic.gpsAccuracy > 0 ? Colors.green : Colors.grey, 
                        size: 48
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _sosLogic.gpsAccuracy > 0 ? "${_sosLogic.gpsAccuracy.toStringAsFixed(0)}m" : "--", 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // BOTÓN SOS (Siempre rojo, diseño de marca)
            GestureDetector(
              onLongPress: _sosLogic.sendSOS,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.red.withOpacity(0.5), blurRadius: 30, spreadRadius: 5),
                  ],
                ),
                child: Center(
                  child: Text(
                    l10n.sosButton,
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(l10n.toastHoldToSOS, style: const TextStyle(color: Colors.grey)),
            
            const SizedBox(height: 30),

            // AVISO MODO TEST
            // MANTENEMOS los colores fijos aquí (Fondo claro + Texto negro)
            // para garantizar legibilidad incluso en modo noche.
            if (_sosLogic.currentInactivityLimit == 30) 
              Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 30, right: 30),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber)
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber, color: Colors.orange),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.testModeWarning, 
                          style: const TextStyle(color: Colors.black87, fontSize: 13)
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // INTERRUPTORES (Texto automático según tema)
            _buildQuickToggle(
              context, 
              l10n.autoModeLabel, 
              _sosLogic.isFallDetectionActive, 
              (v) {
                _sosLogic.toggleFallDetection(v);
                if (v && !_hasShownWarning) {
                   _showKeepAliveWarning(context, l10n);
                   _hasShownWarning = true;
                }
              },
              Icons.directions_run
            ),
            _buildQuickToggle(
              context, 
              l10n.inactivityModeLabel, 
              _sosLogic.isInactivityMonitorActive, 
              (v) {
                _sosLogic.toggleInactivityMonitor(v);
                if (v && !_hasShownWarning) {
                   _showKeepAliveWarning(context, l10n);
                   _hasShownWarning = true;
                }
              },
              Icons.accessibility_new
            ),
            
            // MENSAJES DE ERROR
            if (_sosLogic.status == SOSStatus.error) ...[
               const SizedBox(height: 20),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Text(
                      _sosLogic.errorMessage == "NO_CONTACT" 
                          ? l10n.errorNoContact 
                          : _sosLogic.errorMessage, 
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                    const SizedBox(height: 10),
                    if (_sosLogic.errorMessage == "NO_CONTACT" || _sosLogic.errorMessage.contains("Configura")) 
                      ElevatedButton.icon(
                        icon: const Icon(Icons.settings),
                        label: Text(l10n.menuSettings.toUpperCase()),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                        onPressed: () => _sosLogic.openSettings(context),
                      )
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildQuickToggle(BuildContext context, String label, bool value, Function(bool) onChanged, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: SwitchListTile(
        title: Text(label), // Texto sin estilo: hereda color del Theme
        secondary: Icon(icon, color: value ? Colors.redAccent : Colors.grey),
        value: value, 
        onChanged: (newValue) async {
          if (newValue) {
            bool restricted = await _sosLogic.arePermissionsRestricted();
            if (restricted) {
               if (mounted) _showRestrictedDialog(context);
               return; 
            }
          }
          onChanged(newValue);
        },
        activeColor: Colors.redAccent,
      ),
    );
  }

  void _showRestrictedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.lock_person, color: Colors.orange),
            SizedBox(width: 10),
            Expanded(child: Text("Permisos Bloqueados", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Android ha restringido los permisos de seguridad (SMS o GPS).",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                openAppSettings(); 
              },
              child: const Text("IR A AJUSTES"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPreAlertUI(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String cause = _sosLogic.lastTrigger == AlertCause.fall 
        ? l10n.alertFallDetected 
        : l10n.alertInactivityDetected;

    return Scaffold(
      backgroundColor: const Color(0xFFB71C1C),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber_rounded, size: 80, color: Colors.white),
              Column(
                children: [
                  Text(cause, textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 10),
                  Text(l10n.alertSendingIn, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 18)),
                ],
              ),
              Text("${_sosLogic.countdownSeconds}", style: const TextStyle(fontSize: 90, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFB71C1C),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                  ),
                  onPressed: _sosLogic.cancelAlert, 
                  icon: const Icon(Icons.close, size: 30),
                  label: Text(l10n.alertCancel, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSentUI(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF2196F3), 
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                padding: const EdgeInsets.all(20),
                child: const Icon(Icons.check, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 40),
              
              Text(
                l10n.statusSent, 
                textAlign: TextAlign.center, 
                style: const TextStyle(
                  fontSize: 26, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.white
                )
              ),
              
              const SizedBox(height: 20),
              
              const Text(
                "Monitor detenido / Monitor stopped.\nPantalla apagada en breve / Screen sleeping soon.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              
              const Spacer(),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _sosLogic.cancelAlert, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, 
                    foregroundColor: const Color(0xFF1976D2), 
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 5,
                  ), 
                  child: const Text(
                    "REINICIAR SISTEMA", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  )
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showKeepAliveWarning(BuildContext context, AppLocalizations l10n) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.warningKeepAlive, 
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange[900],
        duration: const Duration(seconds: 6),
        action: SnackBarAction(
          label: "OK",
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}