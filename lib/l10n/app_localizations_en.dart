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

  @override
  String get disclaimerTitle => '⚠️ LEGAL DISCLAIMER & PRIVACY';

  @override
  String get disclaimerText =>
      'This app is a support tool and DOES NOT replace professional emergency services (112, 911).\n\nPRIVACY: Oksigenia DOES NOT collect personal data. Your location and contacts remain exclusively on your device.\n\nFunctionality depends on device health, battery, and coverage. Use at your own risk.';

  @override
  String get btnAccept => 'ACCEPT';

  @override
  String get btnDecline => 'EXIT';

  @override
  String get menuPrivacy => 'Privacy & Legal';

  @override
  String get privacyTitle => 'Terms & Privacy';

  @override
  String get privacyPolicyContent =>
      'PRIVACY POLICY & TERMS OF USE\n\n1. NO DATA COLLECTION\nOksigenia SOS is built on a privacy-by-design principle. The application operates entirely locally. We do not upload your data to any cloud, do not use tracking servers, and do not sell your information to third parties. Your emergency contacts and location history remain strictly on your device.\n\n2. PERMISSION USAGE\n- Location: Used strictly to retrieve GPS coordinates in the event of an impact or manual activation. No background tracking occurs when monitoring is disabled.\n- SMS: Used exclusively to send the alert message to your defined contact. The app does not read your personal messages.\n\n3. LIMITATION OF LIABILITY\nThis application is provided \'as is\', without warranty of any kind. Oksigenia and its developers are not liable for damages, injuries, or death resulting from software failure, including but not limited to: lack of cellular coverage, battery drain, operating system failures, or GPS hardware errors.\n\nThis tool is a safety supplement and should never be considered an infallible substitute for professional emergency services.';
}
