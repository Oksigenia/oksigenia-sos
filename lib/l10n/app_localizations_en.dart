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
  String get statusLocationFixed => 'LOCATION FIXED';

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
  String get menuPrivacy => 'Privacy & Legal';

  @override
  String get menuDonate => 'Donar / Donate';

  @override
  String get menuX => 'X (Twitter)';

  @override
  String get menuInsta => 'Instagram';

  @override
  String get motto => 'Respira > Inspira > Crece;';

  @override
  String panicMessage(Object link) {
    return '🆘 *OKSIGENIA ALERT* 🆘\n\nI need urgent help.\n📍 Location: $link\n\nRespira > Inspira > Crece;';
  }

  @override
  String get settingsTitle => 'SOS Settings';

  @override
  String get settingsLabel => 'Emergency Phone';

  @override
  String get settingsHint => 'Ex: +1 555 123 456';

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
  String get inactivityModeLabel => 'Inactivity Monitor';

  @override
  String get inactivityModeDescription => 'Alerts if no movement is detected.';

  @override
  String get alertFallDetected => 'IMPACT DETECTED!';

  @override
  String get alertFallBody => 'Severe fall detected. Are you okay?';

  @override
  String get alertInactivityDetected => 'INACTIVITY DETECTED!';

  @override
  String get alertInactivityBody => 'No movement detected. Are you okay?';

  @override
  String get btnImOkay => 'I\'M OKAY';

  @override
  String get disclaimerTitle => '⚠️ LEGAL NOTICE & PRIVACY';

  @override
  String get disclaimerText =>
      'Oksigenia SOS is a support tool, not a substitute for professional emergency services. Its operation depends on external factors: battery, GPS signal, and mobile coverage.\n\nBy activating this app, you accept that the software is provided \'as is\' and release the developers from legal liability for technical failures. You are responsible for your own safety.';

  @override
  String get btnAccept => 'I ACCEPT THE RISK';

  @override
  String get btnDecline => 'EXIT';

  @override
  String get privacyTitle => 'Terms & Privacy';

  @override
  String get privacyPolicyContent =>
      'PRIVACY POLICY & TERMS\n\n1. NO DATA COLLECTION\nOksigenia SOS operates locally. We do not upload data to the cloud nor sell your information.\n\n2. PERMISSIONS\n- Location: For coordinates in case of alert.\n- SMS: Exclusively to send the distress message.\n\n3. LIMITATION OF LIABILITY\nApp provided \'as is\'. We are not responsible for coverage or hardware failures.';

  @override
  String get advSettingsTitle => 'Advanced Features';

  @override
  String get advSettingsSubtitle => 'Multi-contact, GPS Tracking...';

  @override
  String get dialogCommunityTitle => '💎 Oksigenia Community';

  @override
  String get dialogCommunityBody => 'This is the COMMUNITY version (Free).';

  @override
  String get dialogStoreTitle => '🔒 Oksigenia Pro';

  @override
  String get dialogStoreBody =>
      'Subscribe to PRO to unlock multiple contacts and real-time tracking.';

  @override
  String get btnDonate => 'Buy me a coffee ☕';

  @override
  String get btnSubscribe => 'Subscribe';

  @override
  String get btnClose => 'Close';

  @override
  String get permSmsTitle => 'DANGER! SMS Permission Blocked';

  @override
  String get permSmsBody => 'App CANNOT send alerts even with saved contacts.';

  @override
  String get permSmsButton => 'Enable SMS in Settings';

  @override
  String get restrictedSettingsTitle => 'Restricted Settings';

  @override
  String get restrictedSettingsBody =>
      'Android has restricted this permission because the app was installed manually (side-loaded).';

  @override
  String get btnGoToSettings => 'GO TO SETTINGS';

  @override
  String get contactsTitle => 'Emergency Contacts';

  @override
  String get contactsSubtitle =>
      'The first one (Main) will receive GPS tracking.';

  @override
  String get contactsAddHint => 'Add number';

  @override
  String get contactsEmpty => '⚠️ No contacts. Alert will not be sent.';

  @override
  String get messageTitle => 'Custom Message';

  @override
  String get messageSubtitle => 'Sent BEFORE the coordinates.';

  @override
  String get messageHint => 'Ex: Diabetic. North Route...';

  @override
  String get trackingTitle => 'GPS Tracking';

  @override
  String get trackingSubtitle => 'Sends position to Main contact every X time.';

  @override
  String get trackOff => '❌ Disabled';

  @override
  String get track30 => '⏱️ Every 30 min';

  @override
  String get track60 => '⏱️ Every 1 hour';

  @override
  String get track120 => '⏱️ Every 2 hours';

  @override
  String get contactMain => 'Main';

  @override
  String get inactivityTimeTitle => 'Time before Alert';

  @override
  String get inactivityTimeSubtitle =>
      'How long without movement before alerting?';

  @override
  String get ina30s => '🧪 30 sec (TEST Mode)';

  @override
  String get ina1h => '⏱️ 1 hour (Recommended)';

  @override
  String get ina2h => '⏱️ 2 hours (Long break)';

  @override
  String get testModeWarning => '⚠️ TEST MODE ON: Alert will trigger in 30s.';

  @override
  String get toastHoldToSOS => 'Hold button to SOS';

  @override
  String get donateDialogTitle => '💎 Support the Project';

  @override
  String get donateDialogBody =>
      'This app is Free & Open Source Software. If it keeps you safe, buy us a coffee.';

  @override
  String get donateBtn => 'Donate via PayPal';

  @override
  String get donateClose => 'CLOSE';

  @override
  String get alertSendingIn => 'Sending alert in...';

  @override
  String get alertCancel => 'CANCEL';

  @override
  String get warningKeepAlive =>
      '⚠️ IMPORTANT: Do not swipe-close the app (Task Manager). Leave it in background so it can auto-restart.';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutVersion => 'Version';

  @override
  String get aboutDisclaimer => 'Legal Disclaimer';

  @override
  String get aboutPrivacy => 'Privacy Policy';

  @override
  String get aboutSourceCode => 'Source Code (GitHub)';

  @override
  String get aboutLicenses => 'Software Licenses';

  @override
  String get aboutDevelopedBy => 'Developed with ❤️ by Oksigenia';

  @override
  String get dialogClose => 'Close';
}
