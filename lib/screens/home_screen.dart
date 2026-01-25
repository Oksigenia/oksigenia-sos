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

class _HomeScreenState extends State<HomeScreen> {
  final SOSLogic _sosLogic = SOSLogic();
  bool _hasShownWarning = false; 

  @override
  void initState() {
    super.initState();
    _sosLogic.init();
    WakelockPlus.enable();
    
    // 1. Verificación de Servicio Local
    Future.delayed(const Duration(seconds: 1), () {
      FlutterBackgroundService().isRunning().then((isRunning) {
        if (!isRunning) {
          FlutterBackgroundService().startService();
        }
      });
    });

    // 2. Verificación Remota
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
  void dispose() {
    _sosLogic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _sosLogic,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.appTitle),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          drawer: MainDrawer(sosLogic: _sosLogic),
          body: _buildBody(context),
        );
      }
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_sosLogic.status == SOSStatus.preAlert) {
      return _buildPreAlertUI(context);
    }
    
    if (_sosLogic.status == SOSStatus.sent) {
      return _buildSentUI(context);
    }

    final l10n = AppLocalizations.of(context)!;
    
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // STATUS PILL
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: _sosLogic.status == SOSStatus.locationFixed 
                    ? Colors.green.withOpacity(0.1) 
                    : Colors.grey.withOpacity(0.1),
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
                  color: _sosLogic.status == SOSStatus.locationFixed ? Colors.green : Colors.grey,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            
            const SizedBox(height: 25),

            // HEALTH DASHBOARD MEJORADO (Iconos Grandes + Decimales)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // G-Force
                  Column(
                    children: [
                      const Icon(Icons.speed, color: Colors.grey, size: 36), // Aumentado a 36
                      const SizedBox(height: 6),
                      Text(
                        "${_sosLogic.currentGForce.toStringAsFixed(2)}G", // 2 Decimales
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
                        size: 36 // Aumentado a 36
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
                        size: 36 // Aumentado a 36
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

            // BOTÓN SOS
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

            // INTERRUPTORES INTELIGENTES
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
        title: Text(label),
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