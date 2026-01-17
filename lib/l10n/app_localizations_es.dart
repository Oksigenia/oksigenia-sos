// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Oksigenia SOS';

  @override
  String get sosButton => 'SOS';

  @override
  String get statusReady => 'Sistema Oksigenia listo.';

  @override
  String get statusConnecting => 'Conectando satélites...';

  @override
  String get statusSent => 'Alerta enviada correctamente.';

  @override
  String statusError(Object error) {
    return 'ERROR: $error';
  }

  @override
  String get menuWeb => 'Web Oficial';

  @override
  String get menuSupport => 'Soporte Técnico';

  @override
  String get menuLanguages => 'Idioma';

  @override
  String get menuSettings => 'Configuración';

  @override
  String get motto => 'Respira > Inspira > Crece;';

  @override
  String panicMessage(Object link) {
    return '🆘 *ALERTA OKSIGENIA* 🆘\n\nNecesito ayuda urgente.\n📍 Ubicación: $link\n\nRespira > Inspira > Crece;';
  }

  @override
  String get settingsTitle => 'Configuración SOS';

  @override
  String get settingsLabel => 'Teléfono de Emergencia';

  @override
  String get settingsHint => 'Ej: 600123456';

  @override
  String get settingsSave => 'GUARDAR';

  @override
  String get settingsSavedMsg => 'Contacto guardado correctamente';

  @override
  String get errorNoContact => '⚠️ ¡Configura un contacto primero!';

  @override
  String get autoModeLabel => 'Detección de Caídas';

  @override
  String get autoModeDescription => 'Monitoriza impactos fuertes.';

  @override
  String get alertFallDetected => '¡IMPACTO DETECTADO!';

  @override
  String get alertFallBody => 'Se ha detectado una caída grave. ¿Estás bien?';
}
