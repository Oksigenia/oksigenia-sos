// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Oksigenia SOS';

  @override
  String get sosButton => 'SOS';

  @override
  String get statusReady => 'Système Oksigenia prêt.';

  @override
  String get statusConnecting => 'Connexion aux satellites...';

  @override
  String get statusSent => 'Alerte envoyée avec succès.';

  @override
  String statusError(Object error) {
    return 'ERREUR: $error';
  }

  @override
  String get menuWeb => 'Site Officiel';

  @override
  String get menuSupport => 'Support Technique';

  @override
  String get menuLanguages => 'Langue';

  @override
  String get menuSettings => 'Paramètres';

  @override
  String get motto => 'Respira > Inspira > Crece;';

  @override
  String panicMessage(Object link) {
    return '🆘 *ALERTE OKSIGENIA* 🆘\n\nJ\'ai besoin d\'une aide urgente.\n📍 Localisation: $link\n\nRespira > Inspira > Crece;';
  }

  @override
  String get settingsTitle => 'Paramètres SOS';

  @override
  String get settingsLabel => 'Téléphone d\'urgence';

  @override
  String get settingsHint => 'Ex: +33 6 12 34 56 78';

  @override
  String get settingsSave => 'ENREGISTRER';

  @override
  String get settingsSavedMsg => 'Contact enregistré avec succès';

  @override
  String get errorNoContact => '⚠️ Configurez d\'abord un contact !';

  @override
  String get autoModeLabel => 'Détection de Chute';

  @override
  String get autoModeDescription => 'Surveille les impacts violents.';

  @override
  String get alertFallDetected => 'IMPACT DÉTECTÉ !';

  @override
  String get alertFallBody => 'Chute grave détectée. Ça va ?';
}
