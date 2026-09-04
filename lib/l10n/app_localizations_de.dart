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
  String get alarmSendingNow => 'Alarm wird gesendet…';

  @override
  String get alarmSendFailed => 'SOS NICHT GESENDET';

  @override
  String get btnRetry => 'Erneut versuchen';

  @override
  String get statusSendFailed => '⚠️ SOS NICHT GESENDET';

  @override
  String get statusSendFailedBody =>
      'Es konnte keine SMS gesendet werden. Prüfe Empfang und Kontakte, dann erneut versuchen.';

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
  String get menuX => '𝕏 (Twitter)';

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
      'Oksigenia SOS ist ein unterstützendes Tool und kein Ersatz für professionelle Rettungsdienste. Der Betrieb hängt von externen Faktoren ab: Batterie, GPS-Signal und Mobilfunkabdeckung.\n\nDurch die Aktivierung dieser App akzeptieren Sie, dass die Software \'wie besehen\' bereitgestellt wird, und stellen die Entwickler von der rechtlichen Haftung für technische Fehler frei. Sie sind für Ihre eigene Sicherheit verantwortlich.\n\nSMS-Servicekosten: Alle Verbindungskosten liegen in der Verantwortung des Nutzers gemäß den Tarifen seines Mobilfunkanbieters. Oksigenia übernimmt keine Kosten und erhebt keine Gebühren für diese Nachrichten.';

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
  String get testModeWarning => 'TESTMODUS: 30s.';

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

  @override
  String get permSmsText =>
      'SMS-Berechtigung fehlt. App kann keine Warnung senden.';

  @override
  String get phoneLabel => 'Telefon (z.B. +49...)';

  @override
  String get btnAdd => 'HINZUFÜGEN';

  @override
  String get noContacts => 'Keine Kontakte konfiguriert.';

  @override
  String get inactivityTitle => 'Inaktivitätszeit';

  @override
  String get invalidNumberWarning => 'Ungültige oder zu kurze Nummer';

  @override
  String get contactMain => 'Hauptkontakt (Tracking / Akku)';

  @override
  String get inactivitySubtitle => 'Zeit ohne Bewegung vor dem Notruf.';

  @override
  String get dialogPermissionTitle => 'Berechtigungen aktivieren';

  @override
  String get dialogPermissionStep1 =>
      '1. Tippen Sie unten auf \'EINSTELLUNGEN\'.';

  @override
  String get dialogPermissionStep2 =>
      '2. Tippen Sie im neuen Bildschirm oben rechts auf die 3 Punkte (⠇).';

  @override
  String get dialogPermissionStep3 =>
      '3. Wählen Sie \'Eingeschränkte Einstellungen zulassen\' (falls sichtbar).';

  @override
  String get dialogPermissionStep4 => '4. Kehren Sie zu dieser App zurück.';

  @override
  String get btnGoToSettings => 'ZU DEN EINSTELLUNGEN';

  @override
  String get timerLabel => 'Timer';

  @override
  String get timerSeconds => 'Sek';

  @override
  String get permSmsOk => 'SMS-Erlaubnis aktiv';

  @override
  String get permSensorsOk => 'Sensoren aktiv';

  @override
  String get permNotifOk => 'Benachrichtigungen aktiv';

  @override
  String get permSmsMissing => 'SMS-Erlaubnis fehlt';

  @override
  String get permSensorsMissing => 'Sensoren fehlen';

  @override
  String get permNotifMissing => 'Benachrichtigungen fehlen';

  @override
  String get permOverlayMissing => 'Überlagerung fehlt';

  @override
  String get permDialogTitle => 'Erlaubnis erforderlich';

  @override
  String get permSmsHelpTitle => 'SMS Hilfe';

  @override
  String get permGoSettings => 'Zu den Einstellungen';

  @override
  String get gpsHelpTitle => 'Über das GPS';

  @override
  String get gpsHelpBody =>
      'Die Genauigkeit hängt vom physischen Chip Ihres Handys und der direkten Sicht zum Himmel ab.\n\nIn Innenräumen, Garagen oder Tunneln wird das Satellitensignal blockiert und der Standort kann ungenau oder gar nicht verfügbar sein.\n\nOksigenia wird immer versuchen, die bestmögliche Position zu triangulieren.';

  @override
  String get holdToCancel => 'Gedrückt halten zum Abbrechen';

  @override
  String get statusMonitorStopped => 'Überwachung gestoppt.';

  @override
  String get statusScreenSleep => 'Bildschirm schaltet ab...';

  @override
  String get btnRestartSystem => 'SYSTEM NEUSTARTEN';

  @override
  String get smsDyingGasp => 'AKKU <5%. System schaltet ab. Standort:';

  @override
  String get smsHelpMessage => 'HILFE! Ich brauche dringend Unterstützung.';

  @override
  String get smsBeaconHeader =>
      'OKSIGENIA SOS - Folgemeldung (KEIN neuer Alarm):';

  @override
  String get batteryDialogTitle => 'Akku-Einschränkung';

  @override
  String get btnDisableBatterySaver => 'SPARMODUS AUS';

  @override
  String get batteryDialogBody =>
      'Das System schränkt den Akku ein. Damit SOS im Hintergrund läuft, wählen Sie \'Keine Einschränkung\' oder \'Nicht optimieren\'.';

  @override
  String get permBgLocationTitle => 'GPS im Hintergrund';

  @override
  String get bgLocationDialogBody =>
      'Wenn der Alarm auslöst, steckt das Handy meist mit ausgeschaltetem Bildschirm in der Tasche. Damit das SOS in diesem Moment mit deiner genauen Position rausgeht, verlangt Android die Standortstufe „Immer zulassen“.\n\nDein Standort verlässt das Telefon nie: kein Internet, keine Cloud, keine Tracker — er reist nur in der SOS-SMS an deine eigenen Kontakte.\n\nWähle auf dem nächsten Bildschirm „Immer zulassen“.';

  @override
  String get whyPermsBgLocation =>
      'Ermittelt deine GPS-Position bei ausgeschaltetem Bildschirm oder App im Hintergrund — genau dann, wenn ein SOS auslöst. Der Standort wird ausschließlich in der SOS-SMS an deine Kontakte gesendet und verlässt das Telefon sonst nie.';

  @override
  String get btnEnableBgLocation => 'Immer zulassen';

  @override
  String get permLocMissing => 'Standortberechtigung fehlt';

  @override
  String get slideStopSystem => 'WISCHEN ZUM STOPPEN';

  @override
  String get onboardingTitle => 'Sicherheitssystem einrichten';

  @override
  String get onboardingSubtitle =>
      'Diese Berechtigungen sind notwendig, damit Oksigenia SOS Sie schützen kann.';

  @override
  String get onboardingGrant => 'ERLAUBEN';

  @override
  String get onboardingGranted => 'ERLAUBT ✓';

  @override
  String get onboardingNext => 'WEITER';

  @override
  String get onboardingFinish => 'BEREIT — ÜBERWACHUNG STARTEN';

  @override
  String get onboardingMandatory => 'Erforderlich zur Aktivierung';

  @override
  String get onboardingSkip => 'Überspringen';

  @override
  String get fullScreenIntentTitle => 'Sperrbildschirm-Alarm';

  @override
  String get fullScreenIntentBody =>
      'Ermöglicht die Anzeige des Alarms auf dem Sperrbildschirm. Ohne diese Berechtigung ertönt der Alarm, aber der Bildschirm wacht nicht auf. Ab Android 14: Einstellungen → Apps → Oksigenia SOS → Vollbild-Benachrichtigungen.';

  @override
  String get btnEnableFullScreenIntent => 'AKTIVIEREN';

  @override
  String get pauseMonitoringSheet => 'Überwachung pausieren für...';

  @override
  String get pauseTitle => 'Überwachung pausiert';

  @override
  String pauseResumesIn(Object time) {
    return '⏸ Pausiert · noch $time';
  }

  @override
  String get pauseResumeNow => 'Jetzt fortsetzen';

  @override
  String get pauseResumedMsg => 'Überwachung fortgesetzt';

  @override
  String get pauseHoldHint => 'Halten zum Pausieren';

  @override
  String get pauseSec5 => '5 Sekunden';

  @override
  String get liveTrackingTitle => 'Live-Tracking';

  @override
  String get liveTrackingSubtitle =>
      'Sendet Ihre GPS-Position per SMS in regelmäßigen Abständen.';

  @override
  String get liveTrackingInterval => 'Sendeintervall';

  @override
  String get liveTrackingShutdownReminder => 'Abschalterinnerung';

  @override
  String get liveTrackingNoReminder => '❌ Keine Erinnerung';

  @override
  String get liveTrackingReminder2h => '⏰ Nach 2 Stunden';

  @override
  String get liveTrackingReminder3h => '⏰ Nach 3 Stunden';

  @override
  String get liveTrackingReminder4h => '⏰ Nach 4 Stunden';

  @override
  String get liveTrackingReminder5h => '⏰ Nach 5 Stunden';

  @override
  String get liveTrackingLegalTitle => '⚠️ SMS-Kosten';

  @override
  String get liveTrackingLegalBody =>
      'Live-Tracking sendet pro Intervall eine SMS an Ihren Hauptkontakt. Es gelten die Tarife Ihres Mobilfunkanbieters. Sie sind allein für alle Nachrichtenkosten verantwortlich.';

  @override
  String get liveTrackingActivate => 'TRACKING AKTIVIEREN';

  @override
  String get liveTrackingDeactivate => 'DEAKTIVIEREN';

  @override
  String liveTrackingNextUpdate(Object time) {
    return 'Nächste Aktualisierung in $time';
  }

  @override
  String get liveTrackingCardTitle => 'Live-Tracking Aktiv';

  @override
  String get liveTrackingPausedSOS => 'Pausiert — SOS aktiv';

  @override
  String get liveTrackingTest1m => '🧪 1 Min. (TEST)';

  @override
  String get liveTrackingTest2m => '🧪 2 Min. (TEST)';

  @override
  String liveTrackingTestWarning(Object time) {
    return 'TESTMODUS: Live-Tracking sendet alle $time.';
  }

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get whyPermsTitle => 'Warum diese Berechtigungen?';

  @override
  String get whyPermsSms =>
      'Sendet Notfall-SMS an Ihre Kontakte. Funktioniert ohne Internet.';

  @override
  String get whyPermsLocation =>
      'Fügt GPS-Koordinaten in die Meldung ein, damit Retter genau wissen, wo Sie sind.';

  @override
  String get whyPermsNotifications =>
      'Zeigt den Überwachungsstatus und ermöglicht das Abbrechen eines Fehlalarms vom Sperrbildschirm.';

  @override
  String get whyPermsActivity =>
      'Erkennt Bewegungsmuster, um Fehlalarme beim Gehen oder Laufen zu vermeiden.';

  @override
  String get whyPermsSensors =>
      'Liest den Beschleunigungssensor, um die G-Kraft eines Sturzes zu erkennen.';

  @override
  String get whyPermsBattery =>
      'Verhindert, dass Android die App während der Hintergrundüberwachung beendet.';

  @override
  String get whyPermsFullScreen =>
      'Zeigt den Alarm über dem Sperrbildschirm, damit Sie reagieren können, ohne zu entsperren.';

  @override
  String get sentinelGreen => 'System aktiv';

  @override
  String get sentinelYellow => 'Aufprall erkannt · wird analysiert...';

  @override
  String get sentinelOrange => 'Alarm unmittelbar bevorstehend!';

  @override
  String get sentinelRed => 'ALARM AKTIV';

  @override
  String get activityProfileTitle => 'Aktivitätsprofil';

  @override
  String get activityProfileSubtitle =>
      'Passt die Smart-Sentinel-Erkennung an deinen Sport an. Wähle das ähnlichste — falsches Profil verursacht Fehlalarme oder verpasst echte Stürze.';

  @override
  String get profileTrekking => 'Wandern / Trekking';

  @override
  String get profileTrekkingDesc =>
      'Standard. Outdoor-Wandern mit dem Handy in Tasche oder Rucksack. Ausgewogene Empfindlichkeit.';

  @override
  String get profileRunning => 'Running (Straße)';

  @override
  String get profileRunningDesc =>
      'Laufen auf Asphalt oder hartem Belag. Höhere Aufprallschwelle (10G) und adaptiver Kadenz-Detektor — bewältigt den anhaltenden horizontalen G-Modus des Laufens, der den Standard-Kadenz-Detektor stört.';

  @override
  String get profileTrailMtb => 'Trail / MTB';

  @override
  String get profileTrailMtbDesc =>
      'Höhere Aufprallschwelle und tolerantere Kadenz — die ständige Vibration auf unebenem Gelände würde sonst Fehlalarme auslösen.';

  @override
  String get profileMountaineering => 'Bergsteigen';

  @override
  String get profileMountaineeringDesc =>
      'Gleiche Basis wie Wandern mit verlängertem 90-Sekunden-Beobachtungsfenster für langsame Erholung in technischem Gelände.';

  @override
  String get profileParagliding => 'Gleitschirmfliegen';

  @override
  String get profileParaglidingDesc =>
      'Automatische Sturzerkennung ist DEAKTIVIERT — der Beschleunigungssensor kann Flugmanöver nicht zuverlässig von einem Sturz unterscheiden. Manueller SOS und Inaktivitätsmonitor bleiben aktiv.';

  @override
  String get profileKayak => 'Kajak / Wassersport';

  @override
  String get profileKayakDesc =>
      'Automatische Sturzerkennung ist DEAKTIVIERT — Wasser dämpft Aufprälle und Schwimmbewegung ist nicht aussagekräftig. Nutze den Inaktivitätsmonitor und manuellen SOS.';

  @override
  String get profileEquitation => 'Reiten';

  @override
  String get profileEquitationDesc =>
      'Automatische Sturzerkennung ist DEAKTIVIERT — der Pferdetakt (Trab, Galopp) stört den menschlichen Gangerkenner. Inaktivitätsmonitor und manueller SOS schützen während des Ritts.';

  @override
  String get profileProfessional => 'Professionell / Rettung';

  @override
  String get profileProfessionalDesc =>
      'Erweitertes 120-Sekunden-Beobachtungsfenster für fortgeschrittene Einsätze, bei denen die Erholungszeit nach einem Sturz die Standard-Timeouts überschreiten kann.';

  @override
  String homeSummaryWithImpact(int imp, int obs, String gps) {
    return 'Impact ${imp}G · Beob ${obs}s · GPS $gps';
  }

  @override
  String homeSummaryNoImpact(String gps) {
    return 'Impact AUS · GPS $gps';
  }

  @override
  String get homeAlertNotArmed =>
      'NICHT BEREIT — Schalter unten antippen zum Aktivieren';

  @override
  String get homeAlertSensorPermDenied => 'Sensor-Berechtigung verweigert';

  @override
  String get homeConfirmTitleImpact => 'Aufprallerkennung';

  @override
  String get homeConfirmTitleObservation => 'Beobachtung';

  @override
  String get homeConfirmTitleGps => 'GPS-Intervall';

  @override
  String homeConfirmValueOn(int threshold) {
    return 'AN · ${threshold}G';
  }

  @override
  String get homeConfirmValueOff => 'AUS';

  @override
  String get homeProfileNoFallWarning =>
      'Dieses Profil erkennt KEINE Stürze. SOS muss manuell ausgelöst werden.';

  @override
  String get homeActionApply => 'Anwenden';

  @override
  String get smsBeaconDistance => 'vom SOS-Punkt entfernt.';

  @override
  String get homeBeaconBanner =>
      'Standort-Updates an deinen Kontakt nach dem SOS — zum Stoppen tippen';

  @override
  String get beaconStopped => 'Bewegungsmeldungen gestoppt';
}
