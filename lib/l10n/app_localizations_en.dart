// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Oksigenia SOS';

  @override
  String get sosButton => 'SOS';

  @override
  String get statusReady => 'Oksigenia System Ready.';

  @override
  String get statusConnecting => 'Connecting satellites...';

  @override
  String get statusSent => 'Alert sent successfully.';

  @override
  String statusError(Object error) {
    return 'ERROR: $error';
  }

  @override
  String get menuWeb => 'Official Website';

  @override
  String get menuSupport => 'Tech Support';

  @override
  String get menuLanguages => 'Language';

  @override
  String get menuSettings => 'Settings';

  @override
  String get motto => 'Respira > Inspira > Crece;';

  @override
  String panicMessage(Object link) {
    return '🆘 *OKSIGENIA ALERT* 🆘\n\nI need urgent help.\n📍 Location: $link\n\nRespira > Inspira > Crece;';
  }

  @override
  String get settingsTitle => 'SOS Settings';

  @override
  String get settingsLabel => 'Emergency Phone Number';

  @override
  String get settingsHint => 'Ex: +1 555-0199';

  @override
  String get settingsSave => 'SAVE';

  @override
  String get settingsSavedMsg => 'Contact saved successfully';

  @override
  String get errorNoContact => '⚠️ Configure a contact first!';

  @override
  String get autoModeLabel => 'Fall Detection';

  @override
  String get autoModeDescription => 'Monitors severe impacts.';

  @override
  String get alertFallDetected => 'IMPACT DETECTED!';

  @override
  String get alertFallBody => 'Severe fall detected. Are you okay?';
}
