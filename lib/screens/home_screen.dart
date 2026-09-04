import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart'; 
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:permission_handler/permission_handler.dart'; 
import 'package:oksigenia_sos/l10n/app_localizations.dart';
import 'package:oksigenia_sos/logic/sos_logic.dart';
import 'package:oksigenia_sos/logic/activity_profile.dart';
import 'package:oksigenia_sos/services/preferences_service.dart';
import 'package:oksigenia_sos/widgets/main_drawer.dart';
import 'package:oksigenia_sos/services/remote_config_service.dart';
import 'package:oksigenia_sos/screens/update_screen.dart';
import 'package:oksigenia_sos/screens/sent_screen.dart';
import 'package:vibration/vibration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver, TickerProviderStateMixin {
  late SOSLogic _sosLogic; 
  bool _hasShownWarning = false;
  late AnimationController _sosHoldController;
  late AnimationController _stopHoldController;
  late AnimationController _liveTrackingHoldController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); 
    
    _sosLogic = context.read<SOSLogic>();
    _sosLogic.init();
    WakelockPlus.enable();
    
    _sosHoldController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), 
    );

    _sosHoldController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _triggerHaptic();
        _sosHoldController.reset();
        _sosLogic.sendSOS();
      }
    });

    _stopHoldController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _stopHoldController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        _triggerHaptic();
        await _sosLogic.stopSystem();
        if (mounted) SystemNavigator.pop();
      }
    });

    _liveTrackingHoldController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _liveTrackingHoldController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _triggerHaptic();
        _liveTrackingHoldController.reset();
        _sosLogic.disableLiveTracking();
      }
    });

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _sosLogic.addListener(_updatePulseAnimation);
    
    Future.delayed(const Duration(seconds: 1), () {
      FlutterBackgroundService().isRunning().then((isRunning) {
        if (!isRunning) {
          FlutterBackgroundService().startService();
        }
      });
    });

    _checkRemoteConfig();
  }

  Future<void> _triggerHaptic() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [0, 50, 50, 50]);
    }
  }

  Future<void> _triggerErrorHaptic() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [0, 50, 50, 50, 50, 50]);
    }
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
      if (_sosLogic.status == SOSStatus.preAlert || _sosLogic.status == SOSStatus.sent) return;

      // init() ya re-sincroniza config+textos con Sylvia vía setConfig; el
      // antiguo invoke("updateLanguage") no tenía handler en el servicio.
      FlutterBackgroundService().isRunning().then((isRunning) {
        if (!isRunning) {
          FlutterBackgroundService().startService();
        }
      });
      _sosLogic.init();
    }
  }

  late AnimationController _pulseController;
  SentinelState? _lastPulseState;

  void _updatePulseAnimation() {
    final state = _sosLogic.sentinelState;
    // El beacon también pulsa (aunque el sentinel esté verde): es la señal de
    // que se está enviando la posición y de que se puede tocar para parar.
    final bool active = state == SentinelState.yellow ||
        state == SentinelState.orange ||
        _sosLogic.beaconActive;

    if (!active) {
      _pulseController.stop();
      _pulseController.reset();
      _lastPulseState = state;
      return;
    }

    final int ms = state == SentinelState.orange
        ? 500
        : state == SentinelState.yellow
            ? 900
            : 1100; // beacon: pulso más lento, informativo
    if (!_pulseController.isAnimating ||
        _pulseController.duration?.inMilliseconds != ms) {
      _pulseController.stop();
      _pulseController.duration = Duration(milliseconds: ms);
      _pulseController.repeat(reverse: true);
    }
    _lastPulseState = state;
  }

  @override
  void dispose() {
    _sosLogic.removeListener(_updatePulseAnimation);
    _pulseController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _sosHoldController.dispose();
    _stopHoldController.dispose();
    _liveTrackingHoldController.dispose();
    // No WakelockPlus.disable() aquí: en pushAndRemoveUntil(HomeScreen) el
    // initState del Home nuevo (enable) corre ANTES que este dispose, así que
    // el disable ganaba y la pantalla volvía a dormirse tras cancelar una
    // alarma. El wakelock muere con el engine al cerrar la app.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _sosLogic,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.black, // 🟢 FONDO NEGRO TOTAL
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.appTitle),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.black, // 🟢 ENCABEZADO NEGRO
            iconTheme: const IconThemeData(color: Colors.white), // Icono menú blanco
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), // Texto blanco
          ),
          drawer: MainDrawer(sosLogic: _sosLogic),
          body: _buildBody(context),
        );
      }
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_sosLogic.status == SOSStatus.sent) {
      return SentScreen();
    }

    final l10n = AppLocalizations.of(context)!;

    // --- VISUAL FUERZA G ---
    Color gForceColor = Colors.grey; 
    IconData gForceIcon = Icons.speed;
    String gForceText = "${_sosLogic.currentGForce.toStringAsFixed(2)}G";

    if (!_sosLogic.sensorsPermissionOk) {
      gForceColor = Colors.redAccent;
      gForceIcon = Icons.warning_amber_rounded;
      gForceText = "---";
    } else {
      double g = _sosLogic.currentGForce;
      if (g > 0.0) { 
        if (g <= 1.05) gForceColor = Colors.green;   
        else if (g > 1.05 && g <= 2.0) gForceColor = Colors.yellow;  
        else if (g > 2.0 && g <= 8.0) gForceColor = Colors.orange;  
        else gForceColor = Colors.red;     
      }
    }

    // --- VISUAL BATERÍA ---
    Color battColor = _sosLogic.batteryLevel > 20 ? Colors.green : Colors.red;
    IconData battIcon = _sosLogic.batteryLevel > 20 ? Icons.battery_std : Icons.battery_alert;
    
    if (!_sosLogic.batteryOptimizationOk) {
       battColor = Colors.orange; 
       battIcon = Icons.battery_alert;
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const SizedBox(height: 10),

            // ACTIVITY PROFILE HERO — the screen's primary anchor. Tells the
            // user at a glance what mode is armed and what it does. Replaces
            // the old three-pill header so the most important configuration
            // can't blend in with auxiliary state.
            _buildProfileHero(l10n),

            // ALERT BANNER — single conditional row covering permissions,
            // monitoring-off (NO ARMED), and sentinel state. Silent when all
            // is well; loud only when something needs attention.
            _buildAlertBanner(l10n),

            // LIVE TRACKING CARD — arriba para separarlo del Stop y el SOS
            _buildLiveTrackingCard(l10n),

            const SizedBox(height: 8),

            // DASHBOARD INFERIOR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Fuerza G
                  GestureDetector(
                    onTap: !_sosLogic.sensorsPermissionOk ? () {
                      _showSensorErrorDialog(context, l10n);
                    } : null,
                    child: Column(
                      children: [
                        Icon(gForceIcon, color: gForceColor, size: 48),
                        const SizedBox(height: 6),
                        Text(
                          gForceText,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)
                        ),
                      ],
                    ),
                  ),

                  // Batería
                  GestureDetector(
                    onTap: !_sosLogic.batteryOptimizationOk ? () {
                       _showBatteryDialog(context, l10n);
                    } : null,
                    child: Column(
                      children: [
                        Icon(battIcon, color: battColor, size: 48),
                        const SizedBox(height: 6),
                        Text(
                          "${_sosLogic.batteryLevel}%", 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)
                        ),
                      ],
                    ),
                  ),

                  // GPS
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Row(
                            children: [
                              const Icon(Icons.info_outline, color: Colors.blue),
                              const SizedBox(width: 10),
                              Text(l10n.gpsHelpTitle),
                            ],
                          ),
                          content: Text(l10n.gpsHelpBody),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text("OK"),
                            )
                          ],
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.gps_fixed, 
                          color: _sosLogic.gpsAccuracy > 0 ? Colors.green : Colors.grey, 
                          size: 48
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _sosLogic.gpsAccuracy > 0 ? "${_sosLogic.gpsAccuracy.toStringAsFixed(0)}m" : "--", 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // BOTÓN SOS
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanDown: (_) {
                if (_sosLogic.emergencyContact == null) {
                  _triggerErrorHaptic();
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.white),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              l10n.errorNoContact,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.redAccent.shade700,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      duration: const Duration(seconds: 4),
                      action: SnackBarAction(
                        label: l10n.menuSettings.toUpperCase(),
                        textColor: Colors.white,
                        backgroundColor: Colors.white24,
                        onPressed: () {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          _sosLogic.openSettings(context);
                        }
                      ),
                    )
                  );
                  return; 
                }
                _sosHoldController.forward();
              },
              onPanEnd: (_) {
                if (_sosHoldController.status != AnimationStatus.completed) {
                  _sosHoldController.reverse();
                }
              },
              onPanCancel: () => _sosHoldController.reverse(),
              
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      final bool monitoring = _sosLogic.isFallDetectionActive || _sosLogic.isInactivityMonitorActive;
                      final Color glowColor = monitoring ? _sosLogic.sentinelColor : Colors.red;
                      final double glowSpread = monitoring && _sosLogic.sentinelState != SentinelState.green
                          ? 5 + (_pulseController.value * 8)
                          : 5;
                      return Container(
                        width: 195,
                        height: 195,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: glowColor.withOpacity(0.55),
                              blurRadius: 30,
                              spreadRadius: glowSpread,
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  SizedBox(
                    width: 200,
                    height: 200,
                    child: AnimatedBuilder(
                      animation: _sosHoldController,
                      builder: (context, child) {
                        return CircularProgressIndicator(
                          value: _sosHoldController.value,
                          strokeWidth: 10,
                          backgroundColor: Colors.transparent, 
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        );
                      },
                    ),
                  ),

                  Center(
                    child: Text(
                      l10n.sosButton,
                      style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),
            Text(
              "${l10n.toastHoldToSOS} (3s)", 
              style: const TextStyle(color: Colors.grey)
            ),
            
            // TEST MODE BANNER
            if (_sosLogic.currentInactivityLimit < 60) ...[
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.shade200,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade800),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange.shade900, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        l10n.testModeWarning,
                        style: TextStyle(
                          color: Colors.orange.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 12),

            // INTERRUPTORES
            _buildQuickToggle(
              context, 
              l10n.autoModeLabel, 
              _sosLogic.isFallDetectionActive, 
              (v) {
                if (v && !_sosLogic.smsPermissionOk) {
                   _showSmsRequiredError(context, l10n);
                   return; 
                }
                _sosLogic.toggleFallDetection(v);
                if (v && !_hasShownWarning) {
                   _showKeepAliveWarning(context, l10n);
                   _hasShownWarning = true;
                }
              },
              Icons.health_and_safety 
            ),
            _buildQuickToggle(
              context,
              l10n.inactivityModeLabel,
              _sosLogic.isInactivityMonitorActive,
              (v) {
                if (v && !_sosLogic.smsPermissionOk) {
                   _showSmsRequiredError(context, l10n);
                   return;
                }
                _sosLogic.toggleInactivityMonitor(v);
                if (v && !_hasShownWarning) {
                   _showKeepAliveWarning(context, l10n);
                   _hasShownWarning = true;
                }
              },
              Icons.airline_seat_flat,
            ),
            _buildTelemetryPanel(l10n),

            // HOLD TO STOP — separación generosa respecto a los interruptores
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanDown: (_) => _stopHoldController.forward(),
                onPanEnd: (_) {
                  if (_stopHoldController.status != AnimationStatus.completed) {
                    _stopHoldController.reverse();
                  }
                },
                onPanCancel: () => _stopHoldController.reverse(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 54,
                    child: AnimatedBuilder(
                      animation: _stopHoldController,
                      builder: (context, child) {
                        return Stack(
                          children: [
                            Container(color: Colors.white10),
                            FractionallySizedBox(
                              widthFactor: _stopHoldController.value,
                              child: Container(color: Colors.redAccent),
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.power_settings_new, color: Colors.white, size: 20),
                                  const SizedBox(width: 10),
                                  Text(
                                    l10n.slideStopSystem,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),

            if (_sosLogic.status == SOSStatus.error) ...[
               const SizedBox(height: 20),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Text(
                      _sosLogic.errorMessage == "NO_CONTACT"
                          ? l10n.errorNoContact
                          : _sosLogic.errorMessage == "SMS_FAILED"
                              ? l10n.statusSendFailed
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

  Widget _buildQuickToggle(BuildContext context, String label, bool value, Function(bool) onChanged, IconData icon, {String? subtitle}) {
    final l10n = AppLocalizations.of(context)!;
    final isPaused = value && _sosLogic.isMonitoringPaused;

    String? effectiveSubtitle = subtitle;
    if (isPaused) {
      final remaining = _sosLogic.pauseRemainingSeconds;
      final mins = remaining ~/ 60;
      final secs = (remaining % 60).toString().padLeft(2, '0');
      effectiveSubtitle = l10n.pauseResumesIn("${mins}m ${secs}s");
    } else if (value) {
      effectiveSubtitle = l10n.pauseHoldHint;
    }

    return GestureDetector(
      onLongPress: value ? () => _showPauseSheet(context, l10n) : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: SwitchListTile(
          title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
          subtitle: effectiveSubtitle != null
              ? Text(
                  effectiveSubtitle,
                  style: TextStyle(
                    color: isPaused ? Colors.orange : Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
          secondary: Icon(
            isPaused ? Icons.pause_circle_filled : icon,
            color: isPaused ? Colors.orange : (value ? Colors.redAccent : Colors.grey),
          ),
          value: value,
          onChanged: (newValue) async {
            if (!newValue && isPaused) {
              // Tapped while paused → resume
              _sosLogic.resumeMonitoring();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(l10n.pauseResumedMsg, style: const TextStyle(color: Colors.white)),
                  backgroundColor: Colors.green[700],
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ));
              }
              return;
            }
            if (newValue) {
              bool smsGranted = await Permission.sms.isGranted;
              if (!mounted) return;
              if (!smsGranted) {
                _showErrorSnackBar(context, l10n.permSmsMissing,
                    actionLabel: l10n.menuSettings.toUpperCase(),
                    onAction: () => _showRestrictedPermissionGuide(context, l10n.permSmsMissing));
                return;
              }
              bool locGranted = await Permission.location.isGranted;
              if (!mounted) return;
              if (!locGranted) {
                _showErrorSnackBar(context, l10n.permLocMissing,
                    actionLabel: l10n.btnGoToSettings.toUpperCase(),
                    onAction: () => openAppSettings());
                return;
              }
              bool restricted = await _sosLogic.arePermissionsRestricted();
              if (restricted) {
                if (mounted) _showRestrictedPermissionGuide(context, l10n.permDialogTitle);
                return;
              }
              if (!_sosLogic.batteryOptimizationOk) {
                if (mounted) _showBatteryDialog(context, l10n);
                return;
              }
              if (!_sosLogic.fullScreenIntentOk) {
                if (mounted) _showFullScreenIntentDialog(context, l10n);
                return;
              }
            }
            onChanged(newValue);
          },
          activeColor: isPaused ? Colors.orange : Colors.redAccent,
        ),
      ),
    );
  }

  void _showPauseSheet(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(l10n.pauseMonitoringSheet,
                    style: const TextStyle(color: Colors.white70, fontSize: 14)),
              ),
              const SizedBox(height: 8),
              if (_sosLogic.currentInactivityLimit < 60)
                _pauseOption(ctx, l10n, l10n.pauseSec5, const Duration(seconds: 5)),
              _pauseOption(ctx, l10n, "15 min", const Duration(minutes: 15)),
              _pauseOption(ctx, l10n, "30 min", const Duration(minutes: 30)),
              _pauseOption(ctx, l10n, "1 h", const Duration(hours: 1)),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _pauseOption(BuildContext ctx, AppLocalizations l10n, String label, Duration duration) {
    return ListTile(
      leading: const Icon(Icons.pause_circle_outline, color: Colors.orange),
      title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
      onTap: () {
        Navigator.pop(ctx);
        _sosLogic.pauseMonitoring(duration);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: [
            const Icon(Icons.pause_circle_filled, color: Colors.white),
            const SizedBox(width: 10),
            Text("⏸ $label", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ]),
          backgroundColor: Colors.orange[900],
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ));
      },
    );
  }

  // Single conditional banner — replaces the old StatusPill + SentinelBadge
  // pair. Stays silent when everything is fine (the hero card already proves
  // the app is configured). Shouts only when there's something to act on:
  // missing permissions, monitoring off (NO ARMED), or sentinel in yellow/
  // orange/red. Ordered by criticality so the most urgent wins on conflicts.
  Widget _buildAlertBanner(AppLocalizations l10n) {
    final bool monitoring =
        _sosLogic.isFallDetectionActive || _sosLogic.isInactivityMonitorActive;

    _AlertLevel? level;
    String text = '';
    IconData icon = Icons.info_outline;
    VoidCallback? onTap;
    bool isBeacon = false;

    // Order matters: emergency > permissions > sentinel state > idle.
    if (_sosLogic.status == SOSStatus.preAlert) {
      level = _AlertLevel.critical;
      text = "🚨 SOS";
      icon = Icons.emergency_rounded;
    } else if (_sosLogic.sentinelState == SentinelState.orange) {
      level = _AlertLevel.critical;
      text = l10n.sentinelOrange;
      icon = Icons.notification_important_rounded;
    } else if (_sosLogic.sentinelState == SentinelState.yellow) {
      level = _AlertLevel.warning;
      text = l10n.sentinelYellow;
      icon = Icons.warning_amber_rounded;
    } else if (!_sosLogic.smsPermissionOk) {
      level = _AlertLevel.critical;
      text = l10n.permSmsMissing;
      icon = Icons.sms_failed_outlined;
    } else if (!_sosLogic.sensorsPermissionOk) {
      level = _AlertLevel.critical;
      text = l10n.homeAlertSensorPermDenied;
      icon = Icons.sensors_off;
    } else if (_sosLogic.beaconActive) {
      // Post-SOS: el beacon manda la posición al contacto cuando te mueves.
      // Banner siempre visible y pulsante para poder cortarlo de un toque
      // (antes era imposible pararlo desde la app).
      level = _AlertLevel.warning;
      isBeacon = true;
      text = l10n.homeBeaconBanner;
      icon = Icons.podcasts;
      onTap = () async {
        await _sosLogic.stopBeacon();
        if (mounted) _showSuccessToast(context, l10n.beaconStopped);
      };
    } else if (!_sosLogic.batteryOptimizationOk) {
      level = _AlertLevel.warning;
      text = l10n.batteryDialogTitle;
      icon = Icons.battery_alert;
      onTap = () => _showBatteryDialog(context, l10n);
    } else if (!_sosLogic.bgLocationOk) {
      level = _AlertLevel.warning;
      text = l10n.permBgLocationTitle;
      icon = Icons.location_off_outlined;
      onTap = () => _showBgLocationDialog(context, l10n);
    } else if (!_sosLogic.fullScreenIntentOk) {
      level = _AlertLevel.warning;
      text = l10n.fullScreenIntentTitle;
      icon = Icons.warning_amber_rounded;
    } else if (!monitoring) {
      level = _AlertLevel.warning;
      text = l10n.homeAlertNotArmed;
      icon = Icons.shield_outlined;
    }

    if (level == null) return const SizedBox.shrink();

    final Color color = isBeacon
        ? const Color(0xFF29B6F6) // azul: transmisión activa, no es una alarma
        : (level == _AlertLevel.critical ? Colors.redAccent : Colors.orangeAccent);
    final bool pulse = level == _AlertLevel.critical || isBeacon;

    final Widget banner = Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.65), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );

    // Pulse the urgent ones and the active beacon; plain warnings stay calm.
    if (pulse) {
      return AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Opacity(
            // Si el controller no está animando (sólo corre en yellow/orange),
            // el banner crítico debe verse a plena opacidad — congelado en
            // 0.7 quedaba más tenue que un simple warning.
            opacity: _pulseController.isAnimating
                ? 0.7 + (_pulseController.value * 0.3)
                : 1.0,
            child: onTap != null
                ? InkWell(onTap: onTap, child: child)
                : child,
          );
        },
        child: banner,
      );
    }

    return onTap != null
        ? InkWell(onTap: onTap, child: banner)
        : banner;
  }

  IconData _profileIcon(ActivityProfile p) {
    switch (p) {
      case ActivityProfile.trekking: return Icons.hiking;
      case ActivityProfile.running: return Icons.directions_run;
      case ActivityProfile.trailMtb: return Icons.directions_bike;
      case ActivityProfile.mountaineering: return Icons.terrain;
      case ActivityProfile.paragliding: return Icons.paragliding;
      case ActivityProfile.kayak: return Icons.kayaking;
      case ActivityProfile.equitation: return Icons.pets;
      case ActivityProfile.professional: return Icons.health_and_safety;
    }
  }

  Color _profileColor(ActivityProfile p) {
    switch (p) {
      case ActivityProfile.trekking: return const Color(0xFF66BB6A); // green — baseline outdoors
      case ActivityProfile.running: return const Color(0xFFEC407A); // pink — road running
      case ActivityProfile.trailMtb: return const Color(0xFFFF9800); // orange — high energy
      case ActivityProfile.mountaineering: return const Color(0xFF42A5F5); // blue — alpine
      case ActivityProfile.paragliding: return const Color(0xFFAB47BC); // purple — flight
      case ActivityProfile.kayak: return const Color(0xFF26C6DA); // cyan — water
      case ActivityProfile.equitation: return const Color(0xFF8D6E63); // saddle brown — equestrian
      case ActivityProfile.professional: return const Color(0xFFEF5350); // red — emergency-grade
    }
  }

  String _profileLabel(AppLocalizations l10n, ActivityProfile p) {
    switch (p) {
      case ActivityProfile.trekking: return l10n.profileTrekking;
      case ActivityProfile.running: return l10n.profileRunning;
      case ActivityProfile.trailMtb: return l10n.profileTrailMtb;
      case ActivityProfile.mountaineering: return l10n.profileMountaineering;
      case ActivityProfile.paragliding: return l10n.profileParagliding;
      case ActivityProfile.kayak: return l10n.profileKayak;
      case ActivityProfile.equitation: return l10n.profileEquitation;
      case ActivityProfile.professional: return l10n.profileProfessional;
    }
  }

  String _profileDescription(AppLocalizations l10n, ActivityProfile p) {
    switch (p) {
      case ActivityProfile.trekking: return l10n.profileTrekkingDesc;
      case ActivityProfile.running: return l10n.profileRunningDesc;
      case ActivityProfile.trailMtb: return l10n.profileTrailMtbDesc;
      case ActivityProfile.mountaineering: return l10n.profileMountaineeringDesc;
      case ActivityProfile.paragliding: return l10n.profileParaglidingDesc;
      case ActivityProfile.kayak: return l10n.profileKayakDesc;
      case ActivityProfile.equitation: return l10n.profileEquitationDesc;
      case ActivityProfile.professional: return l10n.profileProfessionalDesc;
    }
  }

  // Compact one-line summary of what the profile actually does, shown under the
  // hero label so the user can verify behavior at a glance — the missing-signal
  // that caused the wrong-profile incident on 2026-05-13.
  String _profileSummary(AppLocalizations l10n, ActivityProfile p) {
    final cfg = activityProfileConfigs[p]!;
    final String gps = cfg.gpsIntervalSeconds < 60
        ? "${cfg.gpsIntervalSeconds}s"
        : "${cfg.gpsIntervalSeconds ~/ 60}m";

    if (!cfg.impactDetectionEnabled) {
      return l10n.homeSummaryNoImpact(gps);
    }
    return l10n.homeSummaryWithImpact(
      cfg.yellowThreshold.toInt(),
      cfg.observationSeconds,
      gps,
    );
  }

  Widget _buildProfileHero(AppLocalizations l10n) {
    final ActivityProfile current = PreferencesService().getActivityProfile();
    final Color accent = _profileColor(current);
    final bool hasImpact = activityProfileConfigs[current]!.impactDetectionEnabled;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showProfilePicker(l10n),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: accent.withOpacity(0.55), width: 1.5),
            ),
            child: Row(
              children: [
                Icon(_profileIcon(current), size: 36, color: accent),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _profileLabel(l10n, current).toUpperCase(),
                        style: TextStyle(
                          color: accent,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (!hasImpact) ...[
                            const Icon(Icons.warning_amber_rounded,
                                size: 14, color: Colors.orangeAccent),
                            const SizedBox(width: 4),
                          ],
                          Expanded(
                            child: Text(
                              _profileSummary(l10n, current),
                              style: TextStyle(
                                color: hasImpact
                                    ? Colors.white70
                                    : Colors.orangeAccent,
                                fontSize: 12.5,
                                fontWeight: hasImpact
                                    ? FontWeight.w400
                                    : FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.expand_more, size: 26, color: accent.withOpacity(0.85)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showProfilePicker(AppLocalizations l10n) async {
    final ActivityProfile current = PreferencesService().getActivityProfile();
    final ActivityProfile? picked = await showModalBottomSheet<ActivityProfile>(
      context: context,
      backgroundColor: Colors.grey[900],
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  l10n.activityProfileTitle,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  l10n.activityProfileSubtitle,
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ),
              const SizedBox(height: 12),
              ...ActivityProfile.values.map((p) {
                final bool selected = p == current;
                final Color rowAccent = _profileColor(p);
                return InkWell(
                  onTap: () => Navigator.pop(ctx, p),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    color: selected ? rowAccent.withOpacity(0.10) : null,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          _profileIcon(p),
                          color: selected ? rowAccent : Colors.white70,
                          size: 22,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _profileLabel(l10n, p),
                                style: TextStyle(
                                  color: selected ? rowAccent : Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _profileDescription(l10n, p),
                                style: const TextStyle(color: Colors.white60, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        if (selected)
                          Padding(
                            padding: const EdgeInsets.only(left: 8, top: 2),
                            child: Icon(Icons.check_circle, color: rowAccent, size: 20),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );

    if (picked == null || picked == current || !mounted) return;

    final bool confirmed = await _confirmProfileSwitch(l10n, picked);
    if (!confirmed || !mounted) return;

    await PreferencesService().saveActivityProfile(picked);
    if (!mounted) return;
    await _sosLogic.reapplyMonitoringConfig();
    if (mounted) setState(() {});
  }

  // Confirmation dialog shown when the user picks a different profile from
  // the bottom sheet. Profiles without impact detection
  // (paragliding/kayak/equitation) get a high-contrast warning since the user
  // is silently giving up automatic fall detection.
  Future<bool> _confirmProfileSwitch(
      AppLocalizations l10n, ActivityProfile target) async {
    final cfg = activityProfileConfigs[target]!;
    final Color accent = _profileColor(target);
    final bool hasImpact = cfg.impactDetectionEnabled;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Row(
          children: [
            Icon(_profileIcon(target), color: accent, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _profileLabel(l10n, target).toUpperCase(),
                style: TextStyle(
                    color: accent,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _kv(l10n.homeConfirmTitleImpact,
                hasImpact
                    ? l10n.homeConfirmValueOn(cfg.yellowThreshold.toInt())
                    : l10n.homeConfirmValueOff,
                emphasize: !hasImpact),
            if (hasImpact)
              _kv(l10n.homeConfirmTitleObservation, "${cfg.observationSeconds}s"),
            _kv(l10n.homeConfirmTitleGps,
                cfg.gpsIntervalSeconds < 60
                    ? "${cfg.gpsIntervalSeconds}s"
                    : "${cfg.gpsIntervalSeconds ~/ 60}min"),
            if (!hasImpact) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withOpacity(0.12),
                  border: Border.all(color: Colors.orangeAccent, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Colors.orangeAccent, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.homeProfileNoFallWarning,
                        style: const TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.alertCancel,
                style: const TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.homeActionApply.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Widget _kv(String k, String v, {bool emphasize = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(k,
                style: const TextStyle(color: Colors.white60, fontSize: 14)),
          ),
          Expanded(
            flex: 2,
            child: Text(
              v,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: emphasize ? Colors.orangeAccent : Colors.white,
                fontSize: 14,
                fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryPanel(AppLocalizations l10n) {
    if (!_sosLogic.isInactivityMonitorActive) return const SizedBox.shrink();

    final elapsed = _sosLogic.inactivityElapsedSeconds;
    final limit = _sosLogic.currentInactivityLimit;
    final progress = (elapsed / limit).clamp(0.0, 1.0);

    String fmt(int s) {
      if (s < 60) return "$s ${l10n.timerSeconds}";
      if (s < 3600) return "${s ~/ 60} min";
      return "${s ~/ 3600} h";
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.inactivityTitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Text("${fmt(elapsed)} / ${fmt(limit)}",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(
                  progress > 0.8 ? Colors.orange : Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveTrackingCard(AppLocalizations l10n) {
    if (!_sosLogic.isLiveTrackingActive) return const SizedBox.shrink();

    final nextSecs = _sosLogic.liveTrackingNextSendSeconds;
    final mins = nextSecs ~/ 60;
    final secs = (nextSecs % 60).toString().padLeft(2, '0');
    final timeStr = "${mins}m ${secs}s";
    final isTestMode = _sosLogic.liveTrackingIntervalMinutes <= 2;
    final accentColor = isTestMode ? Colors.amber[700]! : Colors.blueAccent;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) => _liveTrackingHoldController.forward(),
      onPanEnd: (_) {
        if (_liveTrackingHoldController.status != AnimationStatus.completed) {
          _liveTrackingHoldController.reverse();
        }
      },
      onPanCancel: () => _liveTrackingHoldController.reverse(),
      child: AnimatedBuilder(
        animation: _liveTrackingHoldController,
        builder: (context, _) {
          final isHolding = _liveTrackingHoldController.value > 0;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isTestMode
                  ? Colors.amber[900]!.withOpacity(0.25)
                  : Colors.blue[900]!.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isHolding
                    ? Colors.redAccent.withOpacity(0.8)
                    : isTestMode
                        ? Colors.amber.withOpacity(0.7)
                        : Colors.blueAccent.withOpacity(0.6),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isTestMode)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Icon(Icons.science, color: accentColor, size: 13),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            l10n.liveTrackingTestWarning("${_sosLogic.liveTrackingIntervalMinutes} min"),
                            style: TextStyle(color: accentColor, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    Icon(Icons.my_location, color: accentColor, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        l10n.liveTrackingCardTitle,
                        style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _liveTrackingHoldController.reset();
                        _sosLogic.disableLiveTracking();
                      },
                      child: const Icon(Icons.stop_circle, color: Colors.redAccent, size: 22),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.liveTrackingNextUpdate(timeStr),
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _sosLogic.sendLiveCheckin(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[700],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          l10n.btnImOkay,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ),
                  ],
                ),
                if (isHolding) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: _liveTrackingHoldController.value,
                      minHeight: 4,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusIcon({required IconData icon, required Color color, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }

  void _showRestrictedPermissionGuide(BuildContext context, String introText) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.dialogPermissionTitle), 
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(introText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 10),
            Text(l10n.dialogPermissionStep1),
            const SizedBox(height: 8),
            Text(l10n.dialogPermissionStep2, style: const TextStyle(fontWeight: FontWeight.bold)), 
            const SizedBox(height: 8),
            Text(l10n.dialogPermissionStep3),
            const SizedBox(height: 8),
            Text(l10n.dialogPermissionStep4),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK")),
          ElevatedButton(
            onPressed: () { Navigator.pop(ctx); openAppSettings(); },
            child: Text(l10n.btnGoToSettings),
          ),
        ],
      ),
    );
  }

  void _showSimplePermissionDialog(BuildContext context, String reason) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(context: context, builder: (ctx) => AlertDialog(
        title: Row(children: [const Icon(Icons.notifications_off, color: Colors.orange), const SizedBox(width: 10), Expanded(child: Text(l10n.permDialogTitle))]),
        content: Text(reason), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK")), ElevatedButton(onPressed: () { Navigator.pop(ctx); openAppSettings(); }, child: Text(l10n.btnGoToSettings))]
      ));
  }

  void _showSensorErrorDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
        title: Row(children: [const Icon(Icons.run_circle, color: Colors.orange), const SizedBox(width: 10), Expanded(child: Text(l10n.permDialogTitle))]),
        content: Text(l10n.permSensorsMissing), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK")), ElevatedButton(onPressed: () { Navigator.pop(ctx); openAppSettings(); }, child: Text(l10n.btnGoToSettings))]
      ));
  }

  void _showBatteryDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
        title: Row(children: [const Icon(Icons.battery_alert, color: Colors.orange), const SizedBox(width: 10), Expanded(child: Text(l10n.batteryDialogTitle))]),
        content: Text(l10n.batteryDialogBody), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK")), ElevatedButton(onPressed: () { Navigator.pop(ctx); _sosLogic.requestBatteryOptimizationIgnore(); }, child: Text(l10n.btnDisableBatterySaver))]
      ));
  }

  void _showBgLocationDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
        title: Row(children: [const Icon(Icons.location_off_outlined, color: Colors.orange), const SizedBox(width: 10), Expanded(child: Text(l10n.permBgLocationTitle))]),
        content: SingleChildScrollView(child: Text(l10n.bgLocationDialogBody)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK")),
          ElevatedButton(onPressed: () { Navigator.pop(ctx); _sosLogic.requestBackgroundLocation(); }, child: Text(l10n.btnEnableBgLocation)),
        ]
      ));
  }

  void _showFullScreenIntentDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
        title: Row(children: [const Icon(Icons.lock_open, color: Colors.orange), const SizedBox(width: 10), Expanded(child: Text(l10n.fullScreenIntentTitle))]),
        content: SingleChildScrollView(child: Text(l10n.fullScreenIntentBody)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK")),
          ElevatedButton(onPressed: () { Navigator.pop(ctx); _sosLogic.requestFullScreenIntentPermission(); }, child: Text(l10n.btnEnableFullScreenIntent)),
        ]
      ));
  }

  void _showSuccessToast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [const Icon(Icons.check_circle, color: Colors.white), const SizedBox(width: 10), Text(msg, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white))]),
        backgroundColor: Colors.green[700], behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 2)));
  }

  void _showSmsRequiredError(BuildContext context, AppLocalizations l10n) {
    _triggerErrorHaptic();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l10n.permSmsMissing, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red[800], behavior: SnackBarBehavior.floating,
        action: SnackBarAction(label: l10n.menuSettings.toUpperCase(), textColor: Colors.white, onPressed: () => _showRestrictedPermissionGuide(context, l10n.permSmsMissing))));
  }

  void _showErrorSnackBar(BuildContext context, String msg, {required String actionLabel, required VoidCallback onAction}) {
    _triggerErrorHaptic();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [const Icon(Icons.error_outline, color: Colors.white), const SizedBox(width: 10), Expanded(child: Text(msg, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis))]), 
        backgroundColor: Colors.red[800], behavior: SnackBarBehavior.floating,
        action: SnackBarAction(label: actionLabel, textColor: Colors.white, onPressed: onAction)));
  }

  void _showKeepAliveWarning(BuildContext context, AppLocalizations l10n) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    // El auto-cierre interno del SnackBar solo arranca al terminar su animación
    // de entrada; los rebuilds continuos de la telemetría (GPS/batería) lo
    // interrumpen y el temporizador de 6s nunca se arma → el banner se queda
    // pegado tapando los toggles. Lo cerramos con un Timer propio (reloj de
    // pared), inmune a los rebuilds, y damos al SnackBar duración larga para que
    // su timer frágil no compita. Ver deuda técnica B3 (throttle notifyListeners).
    final controller = messenger.showSnackBar(SnackBar(
        content: Text(l10n.warningKeepAlive, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange[900], behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16), duration: const Duration(days: 1),
        action: SnackBarAction(label: "OK", textColor: Colors.white, onPressed: () { messenger.clearSnackBars(); })));
    Timer(const Duration(seconds: 12), () { controller.close(); });
  }
}

enum _AlertLevel { warning, critical }