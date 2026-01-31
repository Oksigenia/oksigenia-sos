import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
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
  static const platform = MethodChannel('com.oksigenia.sos/sms'); 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); 
    
    _sosLogic.init();
    WakelockPlus.enable();
    
    Future.delayed(const Duration(seconds: 1), () {
      FlutterBackgroundService().isRunning().then((isRunning) {
        if (!isRunning) {
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

  Future<void> _minimizeApp() async {
    try {
      await platform.invokeMethod('minimizeApp');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("🛡️ App minimizada. Oksigenia sigue vigilando."),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          )
        );
      }
    } catch (e) {
      debugPrint("Error minimizando: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, 
      onPopInvoked: (didPop) {
        if (didPop) return;
        _minimizeApp(); 
      },
      child: AnimatedBuilder(
        animation: _sosLogic,
        builder: (context, child) {
          if (_sosLogic.status == SOSStatus.preAlert) {
            return _buildPreAlertUI(context);
          }
          
          if (_sosLogic.status == SOSStatus.sent) {
            return _buildSentUI(context);
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.appTitle),
              centerTitle: true,
              elevation: 0,
            ),
            drawer: MainDrawer(sosLogic: _sosLogic),
            body: _buildBody(context),
          );
        }
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Color gForceColor = Colors.grey; 

    if (_sosLogic.sensorsPermissionOk) { 
      double g = _sosLogic.currentGForce;
      if (g <= 1.05) gForceColor = Colors.green;   
      else if (g > 1.05 && g <= 2.0) gForceColor = Colors.yellow;  
      else if (g > 2.0 && g <= 8.0) gForceColor = Colors.orange;  
      else gForceColor = Colors.red;     
    }

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
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
                  color: _sosLogic.status == SOSStatus.locationFixed ? Colors.green : Colors.grey,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.white.withOpacity(0.05) 
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatusIcon(
                      icon: Icons.sms_failed,
                      activeIcon: Icons.sms,
                      isOk: _sosLogic.smsPermissionOk,
                      isWarning: false,
                      onTap: () => _handlePermissionClick('sms', _sosLogic.smsPermissionOk),
                    ),
                    _buildStatusIcon(
                      icon: Icons.notifications_off,
                      activeIcon: Icons.notifications_active,
                      isOk: _sosLogic.notifPermissionOk,
                      isWarning: false,
                      onTap: () => _handlePermissionClick('notif', _sosLogic.notifPermissionOk),
                    ),
                    _buildStatusIcon(
                      icon: Icons.graphic_eq,
                      isOk: _sosLogic.sensorsPermissionOk,
                      isWarning: false,
                      onTap: () => _handlePermissionClick('sensors', _sosLogic.sensorsPermissionOk),
                    ),
                    // 🔥 ICONO DE SUPERPOSICIÓN (Solo si falta)
                    if (!_sosLogic.overlayPermissionOk)
                      _buildStatusIcon(
                        icon: Icons.layers_clear, 
                        isOk: false,
                        isWarning: true, 
                        onTap: () => _handlePermissionClick('overlay', false),
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Icon(Icons.speed, color: gForceColor, size: 40),
                      const SizedBox(height: 6),
                      Text("${_sosLogic.currentGForce.toStringAsFixed(2)}G", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        _sosLogic.batteryLevel > 20 ? Icons.battery_std : Icons.battery_alert, 
                        color: _sosLogic.batteryLevel > 20 ? Colors.green : Colors.red, 
                        size: 40
                      ),
                      const SizedBox(height: 6),
                      Text("${_sosLogic.batteryLevel}%", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.gps_fixed, 
                        color: _sosLogic.gpsPermissionOk ? Colors.green : Colors.grey, 
                        size: 40
                      ),
                      const SizedBox(height: 6),
                      Text(_sosLogic.gpsAccuracy > 0 ? "${_sosLogic.gpsAccuracy.toStringAsFixed(0)}m" : "--", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            GestureDetector(
              onLongPress: _sosLogic.sendSOS,
              child: Container(
                width: 200,
                height: 200,
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
              Icons.accessibility_new,
              subtitle: _sosLogic.isInactivityMonitorActive 
                  ? "${l10n.timerLabel}: ${_sosLogic.currentInactivityLimit < 60 ? '${_sosLogic.currentInactivityLimit} ${l10n.timerSeconds}' : '${_sosLogic.currentInactivityLimit ~/ 3600} h'}" 
                  : null
            ),
            
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

  Widget _buildStatusIcon({
    required IconData icon, 
    IconData? activeIcon,
    required bool isOk, 
    required bool isWarning,
    required VoidCallback onTap
  }) {
    Color color = isOk 
        ? Colors.greenAccent 
        : (isWarning ? Colors.orangeAccent : Colors.redAccent);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            isOk ? (activeIcon ?? icon) : icon, 
            color: color, 
            size: 28
          ),
          const SizedBox(height: 4),
          Container(
            width: 6, height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [BoxShadow(color: color.withOpacity(0.6), blurRadius: 6, spreadRadius: 1)]
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQuickToggle(BuildContext context, String label, bool value, Function(bool) onChanged, IconData icon, {String? subtitle}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: SwitchListTile(
        title: Text(label), 
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)) : null,
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

  void _handlePermissionClick(String type, bool isOk) {
    final l10n = AppLocalizations.of(context)!;
    
    if (isOk) {
      String msg = "";
      if (type == 'sms') msg = l10n.permSmsOk;
      else if (type == 'sensors') msg = l10n.permSensorsOk;
      else if (type == 'notif') msg = l10n.permNotifOk;

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [const Icon(Icons.check_circle, color: Colors.white), const SizedBox(width: 10), Expanded(child: Text(msg))]),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
      ));
    } 
    else {
      String msg = "";
      if (type == 'sms') msg = l10n.permSmsMissing;
      else if (type == 'sensors') msg = l10n.permSensorsMissing;
      else if (type == 'notif') msg = l10n.permNotifMissing;
      
      // 🔥 NUEVO: Mensaje para Overlay usando la clave ARB
      if (type == 'overlay') {
        msg = l10n.permOverlayMissing;
      }

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Row(children: [
            const Icon(Icons.info_outline, color: Colors.orange), 
            const SizedBox(width: 10), 
            Expanded(child: Text(l10n.permDialogTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)))
          ]),
          content: Text(msg, style: const TextStyle(fontSize: 15)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK")),
            ElevatedButton(
              onPressed: () { 
                Navigator.pop(ctx); 
                if (type == 'overlay') {
                  Permission.systemAlertWindow.request();
                } else {
                  openAppSettings(); 
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
              child: Text(l10n.permGoSettings)
            )
          ],
        )
      );
    }
  }
  void _showRestrictedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [Icon(Icons.lock_person, color: Colors.orange), SizedBox(width: 10), Expanded(child: Text("Permisos Bloqueados", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Android ha restringido los permisos de seguridad (SMS o GPS).", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 15),
            ElevatedButton(onPressed: () { Navigator.pop(ctx); openAppSettings(); }, child: const Text("IR A AJUSTES"))
          ],
        ),
      ),
    );
  }

  Widget _buildPreAlertUI(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String titleText = "";
    if (_sosLogic.lastTrigger == AlertCause.fall) {
      titleText = l10n.alertFallDetected; 
    } else if (_sosLogic.lastTrigger == AlertCause.inactivity) {
      titleText = l10n.alertInactivityDetected;
    } else {
      titleText = "SOS"; 
    }

    final String subTitle = l10n.alertSendingIn; 
    final String txtCancel = l10n.alertCancel;   

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final trackColor = isDark ? Colors.grey[800] : Colors.grey[200];

    return Scaffold(
      backgroundColor: bgColor, 
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            if (_sosLogic.lastTrigger != AlertCause.manual) ...[
              Icon(
                Icons.warning_amber_rounded, 
                size: 60, 
                color: isDark ? Colors.amber : Colors.red[700]
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  titleText.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 5),
            ] else ...[
               Text(
                 titleText,
                 textAlign: TextAlign.center,
                 style: TextStyle(
                   fontSize: 40,
                   fontWeight: FontWeight.w900,
                   color: textColor,
                   letterSpacing: 2.0
                 ),
               ),
               const SizedBox(height: 10),
            ],

            Text(
              subTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: textColor.withOpacity(0.7),
                letterSpacing: 1.1,
              ),
            ),
            
            const Spacer(),
            
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 250, height: 250,
                  child: CircularProgressIndicator(
                    value: 1.0, strokeWidth: 20, color: trackColor,
                  ),
                ),
                SizedBox(
                  width: 250, height: 250,
                  child: CircularProgressIndicator(
                    value: _sosLogic.countdownSeconds / 30.0,
                    strokeWidth: 20,
                    strokeCap: StrokeCap.round,
                    color: const Color(0xFFB71C1C), 
                  ),
                ),
                Text(
                  "${_sosLogic.countdownSeconds}",
                  style: const TextStyle(
                    fontSize: 80, fontWeight: FontWeight.bold, color: Color(0xFFB71C1C),
                  ),
                ),
              ],
            ),
            
            const Spacer(),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: _sosLogic.cancelAlert,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                    foregroundColor: isDark ? Colors.white : Colors.black, 
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  icon: const Icon(Icons.close, size: 30),
                  label: Text(txtCancel, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
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
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)),
                padding: const EdgeInsets.all(20),
                child: const Icon(Icons.check, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 40),
              Text(l10n.statusSent, textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 20),
              const Text(
                "Monitor detenido. / Monitor stopped.\nPulsa abajo para reiniciar.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const Spacer(),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _sosLogic.cancelAlert(); 
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, 
                    foregroundColor: const Color(0xFF1976D2), 
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 5,
                  ), 
                  child: const Text("REARMAR SISTEMA", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
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
        content: Text(l10n.warningKeepAlive, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange[900],
        duration: const Duration(seconds: 6),
        action: SnackBarAction(label: "OK", textColor: Colors.white, onPressed: () {}),
      ),
    );
  }
}