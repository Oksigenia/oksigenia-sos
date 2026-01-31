import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oksigenia_sos/logic/sos_logic.dart';
import 'package:oksigenia_sos/l10n/app_localizations.dart';

class AlarmScreen extends StatelessWidget {
  const AlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Evitamos que el usuario pueda volver atrás con el botón físico
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFD50000), // Rojo Alerta
        body: Consumer<SOSLogic>(
          builder: (context, sosLogic, child) {
            // Si el estado ya no es preAlert (ej: se canceló), cerramos la pantalla
            if (sosLogic.status != SOSStatus.preAlert) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (Navigator.canPop(context)) Navigator.pop(context);
              });
            }

            final l10n = AppLocalizations.of(context)!;
            
            // Determinamos el texto según la causa
            String title = l10n.alertFallDetected; // "IMPACT DETECTED!"
            String body = l10n.alertFallBody;      // "Severe fall detected..."
            
            if (sosLogic.lastTrigger == AlertCause.inactivity) {
              title = l10n.alertInactivityDetected;
              body = l10n.alertInactivityBody;
            }

            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 100, color: Colors.white),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      body,
                      style: const TextStyle(fontSize: 18, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(),
                  // CONTADOR GIGANTE
                  Text(
                    "${sosLogic.countdownSeconds}",
                    style: const TextStyle(
                      fontSize: 120, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white
                    ),
                  ),
                  Text(
                    l10n.alertSendingIn, // "Sending alert in..."
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const Spacer(),
                  // BOTÓN DE CANCELAR (Deslizar o Pulsar)
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFD50000),
                        ),
                        onPressed: () {
                          sosLogic.cancelAlert();
                        },
                        child: Text(
                          l10n.alertCancel.toUpperCase(), // "CANCEL"
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
