import 'dart:async';
import 'package:flutter/material.dart';
import 'package:oksigenia_sos/l10n/app_localizations.dart';
import 'package:oksigenia_sos/logic/sos_logic.dart'; 

class CountdownScreen extends StatefulWidget {
  final int duration;
  final AlertCause? cause; 

  const CountdownScreen({
    super.key, 
    this.duration = 10,
    this.cause, 
  });

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> with TickerProviderStateMixin {
  late int _remainingSeconds;
  Timer? _timer;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );

    _controller.reverse(from: 1.0);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          if (mounted) Navigator.of(context).pop(true);
        }
      });
    });
  }

  void _cancelSOS() {
    _timer?.cancel();
    _controller.stop();
    if (mounted) Navigator.of(context).pop(false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // 🌍 GESTIÓN RIGUROSA DE IDIOMAS
    // Nada de textos "a fuego". Todo viene de los archivos .arb
    String titleText = "";
    
    if (widget.cause == AlertCause.fall) {
      titleText = l10n.alertFallDetected; 
    } else if (widget.cause == AlertCause.inactivity) {
      titleText = l10n.alertInactivityDetected;
    } else {
      // Para manual, usamos simplemente "SOS" (Universal)
      titleText = "SOS"; 
    }

    final String subTitle = l10n.alertSendingIn; 
    final String txtCancel = l10n.alertCancel;   

    // 🌙 COLORES
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

            // ICONO Y TÍTULO
            if (widget.cause != AlertCause.manual && widget.cause != null) ...[
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
               // Si es manual, mostramos SOS grande
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

            // SUBTÍTULO
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
            
            // CÍRCULO
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
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CircularProgressIndicator(
                        value: _controller.value,
                        strokeWidth: 20,
                        strokeCap: StrokeCap.round,
                        color: const Color(0xFFB71C1C),
                      );
                    },
                  ),
                ),
                Text(
                  "$_remainingSeconds",
                  style: const TextStyle(
                    fontSize: 80, fontWeight: FontWeight.bold, color: Color(0xFFB71C1C),
                  ),
                ),
              ],
            ),
            
            const Spacer(),
            
            // BOTÓN CANCELAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: _cancelSOS,
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
}