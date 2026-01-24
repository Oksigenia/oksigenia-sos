// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Oksigenia SOS';

  @override
  String get sosButton => 'SOS';

  @override
  String get statusReady => 'Oksigenia System Bereit.';

  @override
  String get statusConnecting => 'Verbinde Satelliten...';

  @override
  String get statusLocationFixed => 'STANDORT FIXIERT';

  @override
  String get statusSent => 'Alarm erfolgreich gesendet.';

  @override
  String statusError(Object error) {
    return 'FEHLER: $error';
  }

  @override
  String get menuWeb => 'Offizielle Webseite';

  @override
  String get menuSupport => 'Support';

  @override
  String get menuLanguages => 'Sprache';

  @override
  String get menuSettings => 'Einstellungen';

  @override
  String get menuPrivacy => 'Datenschutz';

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
    return '🆘 *OKSIGENIA ALARM* 🆘\n\nBrauche Hilfe.\n📍 Standort: $link\n\nRespira > Inspira > Crece;';
  }

  @override
  String get settingsTitle => 'SOS Konfiguration';

  @override
  String get settingsLabel => 'Notrufnummer';

  @override
  String get settingsHint => 'Bsp: +49 170 0000000';

  @override
  String get settingsSave => 'SPEICHERN';

  @override
  String get settingsSavedMsg => 'Kontakt gespeichert';

  @override
  String get errorNoContact => '⚠️ Kontakt konfigurieren!';

  @override
  String get autoModeLabel => 'Sturzerkennung';

  @override
  String get autoModeDescription => 'Überwacht Stürze.';

  @override
  String get inactivityModeLabel => 'Inaktivitätsmonitor';

  @override
  String get inactivityModeDescription => 'Alarm bei Ruhe.';

  @override
  String get alertFallDetected => 'STURZ ERKANNT!';

  @override
  String get alertFallBody => 'Sturz erkannt. Alles okay?';

  @override
  String get alertInactivityDetected => 'INAKTIVITÄT!';

  @override
  String get alertInactivityBody => 'Keine Bewegung. Alles okay?';

  @override
  String get btnImOkay => 'MIR GEHT ES GUT';

  @override
  String get disclaimerTitle => '⚠️ RECHTLICHER HINWEIS & DATENSCHUTZ';

  @override
  String get disclaimerText =>
      'Oksigenia SOS ist ein Hilfsmittel, kein Ersatz für professionelle Rettungsdienste. Der Betrieb hängt von externen Faktoren ab: Batterie, GPS-Signal und Mobilfunkabdeckung.\n\nDurch die Aktivierung dieser App akzeptieren Sie, dass die Software \'wie besehen\' bereitgestellt wird, und befreien die Entwickler von der rechtlichen Haftung für technische Ausfälle. Sie sind für Ihre eigene Sicherheit verantwortlich.';

  @override
  String get btnAccept => 'AKZEPTIEREN';

  @override
  String get btnDecline => 'BEENDEN';

  @override
  String get privacyTitle => 'Nutzungsbedingungen & Datenschutz';

  @override
  String get privacyPolicyContent =>
      'DATENSCHUTZRICHTLINIE & BEDINGUNGEN\n\n1. KEINE DATENSAMMLUNG\nOksigenia SOS arbeitet lokal. Wir laden keine Daten in die Cloud hoch und verkaufen Ihre Informationen nicht.\n\n2. BERECHTIGUNGEN\n- Standort: Für Koordinaten im Alarmfall.\n- SMS: Ausschließlich zum Senden der Notrufnachricht.\n\n3. HAFTUNGSBESCHRÄNKUNG\nDie App wird \'wie besehen\' bereitgestellt. Wir haften nicht für Netzabdeckungs- oder Hardwarefehler.';

  @override
  String get advSettingsTitle => 'Erweiterte Funktionen';

  @override
  String get advSettingsSubtitle => 'GPS-Tracking...';

  @override
  String get dialogCommunityTitle => '💎 Oksigenia Community';

  @override
  String get dialogCommunityBody => 'COMMUNITY-Version (Gratis).';

  @override
  String get dialogStoreTitle => '🔒 Oksigenia Pro';

  @override
  String get dialogStoreBody => 'PRO abonnieren.';

  @override
  String get btnDonate => 'Kaffee spendieren ☕';

  @override
  String get btnSubscribe => 'Abonnieren';

  @override
  String get btnClose => 'Schließen';

  @override
  String get permSmsTitle => 'GEFAHR! SMS blockiert';

  @override
  String get permSmsBody => 'Die App kann keine Alarme senden.';

  @override
  String get permSmsButton => 'SMS aktivieren';

  @override
  String get restrictedSettingsTitle => 'Einstellungen';

  @override
  String get restrictedSettingsBody =>
      'Android hat die Berechtigung eingeschränkt.';

  @override
  String get btnGoToSettings => 'EINSTELLUNGEN';

  @override
  String get contactsTitle => 'Notfallkontakte';

  @override
  String get contactsSubtitle => 'Hauptkontakt erhält GPS.';

  @override
  String get contactsAddHint => 'Nummer hinzufügen';

  @override
  String get contactsEmpty => '⚠️ Keine Kontakte.';

  @override
  String get messageTitle => 'Eigene Nachricht';

  @override
  String get messageSubtitle => 'Vor Koordinaten gesendet.';

  @override
  String get messageHint => 'Z.B.: Diabetiker...';

  @override
  String get trackingTitle => 'GPS-Tracking';

  @override
  String get trackingSubtitle => 'Sendet Position.';

  @override
  String get trackOff => '❌ Deaktiviert';

  @override
  String get track30 => '⏱️ 30 Min.';

  @override
  String get track60 => '⏱️ 1 Std.';

  @override
  String get track120 => '⏱️ 2 Std.';

  @override
  String get contactMain => 'Hauptkontakt';

  @override
  String get inactivityTimeTitle => 'Zeit vor Alarm';

  @override
  String get inactivityTimeSubtitle => 'Zeit ohne Bewegung?';

  @override
  String get ina30s => '🧪 30 Sek.';

  @override
  String get ina1h => '⏱️ 1 Std.';

  @override
  String get ina2h => '⏱️ 2 Std.';

  @override
  String get testModeWarning => '⚠️ TESTMODUS: 30s.';

  @override
  String get toastHoldToSOS => 'Gedrückt halten';

  @override
  String get donateDialogTitle => '💎 Unterstützung';

  @override
  String get donateDialogBody => 'Kaffee spendieren.';

  @override
  String get donateBtn => 'PayPal';

  @override
  String get donateClose => 'SCHLIESSEN';

  @override
  String get alertSendingIn => 'Warnung wird gesendet...';

  @override
  String get alertCancel => 'ABBRECHEN';

  @override
  String get warningKeepAlive =>
      '⚠️ WICHTIG: Schließen Sie die App (Task-Manager) nicht durch Wischen. Lassen Sie sie im Hintergrund, damit sie automatisch neu gestartet werden kann.';

  @override
  String get aboutTitle => 'Über';

  @override
  String get aboutVersion => 'Version';

  @override
  String get aboutDisclaimer => 'Rechtliche Hinweise';

  @override
  String get aboutPrivacy => 'Datenschutzerklärung';

  @override
  String get aboutSourceCode => 'Quellcode (GitHub)';

  @override
  String get aboutLicenses => 'Softwarelizenzen';

  @override
  String get aboutDevelopedBy => 'Entwickelt mit ❤️ von Oksigenia';

  @override
  String get dialogClose => 'Schließen';
}
