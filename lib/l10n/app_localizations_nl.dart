// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Oksigenia SOS';

  @override
  String get sosButton => 'SOS';

  @override
  String get statusReady => 'Oksigenia Systeem Klaar.';

  @override
  String get statusConnecting => 'Verbinden met satellieten...';

  @override
  String get statusLocationFixed => 'LOCATIE VASTGESTELD';

  @override
  String get statusSent => 'Alarm succesvol verzonden.';

  @override
  String get alarmSendingNow => 'Alarm wordt verzonden…';

  @override
  String get alarmSendFailed => 'SOS NIET VERZONDEN';

  @override
  String get btnRetry => 'Opnieuw proberen';

  @override
  String get statusSendFailed => '⚠️ SOS NIET VERZONDEN';

  @override
  String get statusSendFailedBody =>
      'Er kon geen sms worden verzonden. Controleer bereik en contacten en probeer opnieuw.';

  @override
  String statusError(Object error) {
    return 'FOUT: $error';
  }

  @override
  String get menuWeb => 'Officiële Website';

  @override
  String get menuSupport => 'Technische Ondersteuning';

  @override
  String get menuLanguages => 'Taal';

  @override
  String get menuSettings => 'Instellingen';

  @override
  String get menuPrivacy => 'Privacy & Juridisch';

  @override
  String get menuDonate => 'Doneren';

  @override
  String get menuX => '𝕏 (Twitter)';

  @override
  String get menuInsta => 'Instagram';

  @override
  String get motto => 'Respira > Inspira > Crece;';

  @override
  String panicMessage(Object link) {
    return '🆘 *OKSIGENIA ALERT* 🆘\n\nIk heb dringend hulp nodig.\n📍 Locatie: $link\n\nRespira > Inspira > Crece;';
  }

  @override
  String get settingsTitle => 'SOS Instellingen';

  @override
  String get settingsLabel => 'Noodtelefoon';

  @override
  String get settingsHint => 'Bijv: +31 6 12345678';

  @override
  String get settingsSave => 'OPSLAAN';

  @override
  String get settingsSavedMsg => 'Contact succesvol opgeslagen';

  @override
  String get errorNoContact => '⚠️ Configureer eerst een contact!';

  @override
  String get autoModeLabel => 'Valdetectie';

  @override
  String get autoModeDescription => 'Bewaakt zware schokken.';

  @override
  String get inactivityModeLabel => 'Inactiviteitsmonitor';

  @override
  String get inactivityModeDescription =>
      'Waarschuwt als er geen beweging wordt gedetecteerd.';

  @override
  String get alertFallDetected => 'SCHOK GEDETECTEERD!';

  @override
  String get alertFallBody => 'Zware val gedetecteerd. Ben je in orde?';

  @override
  String get alertInactivityDetected => 'INACTIVITEIT GEDETECTEERD!';

  @override
  String get alertInactivityBody =>
      'Geen beweging gedetecteerd. Ben je in orde?';

  @override
  String get btnImOkay => 'IK BEN OKÉ';

  @override
  String get disclaimerTitle => '⚠️ JURIDISCHE KENNISGEVING & PRIVACY';

  @override
  String get disclaimerText =>
      'Oksigenia SOS is een hulpmiddel, geen vervanging voor professionele hulpdiensten. De werking hangt af van externe factoren: batterij, GPS-signaal en mobiel bereik.\n\nDoor deze app te activeren, accepteert u dat de software \'as is\' wordt geleverd en ontheft u de ontwikkelaars van wettelijke aansprakelijkheid voor technische storingen. U bent verantwoordelijk voor uw eigen veiligheid.\n\nSMS-kosten: Alle berichtkosten zijn de verantwoordelijkheid van de gebruiker volgens de tarieven van de provider. Oksigenia dekt of berekent deze kosten niet.';

  @override
  String get btnAccept => 'IK ACCEPTEER HET RISICO';

  @override
  String get btnDecline => 'AFSLUITEN';

  @override
  String get privacyTitle => 'Voorwaarden & Privacy';

  @override
  String get privacyPolicyContent =>
      'PRIVACYBELEID & VOORWAARDEN\n\n1. GEEN GEGEVENSVERZAMELING\nOksigenia SOS werkt lokaal. We uploaden geen gegevens naar de cloud en verkopen uw informatie niet.\n\n2. TOESTEMMINGEN\n- Locatie: Voor coördinaten in geval van alarm.\n- SMS: Uitsluitend om het noodbericht te verzenden.\n\n3. BEPERKING VAN AANSPRAKELIJKHEID\nApp geleverd \'as is\'. Wij zijn niet verantwoordelijk voor dekkings- of hardwarestoringen.';

  @override
  String get advSettingsTitle => 'Geavanceerde Functies';

  @override
  String get advSettingsSubtitle => 'Multi-contact, GPS Tracking...';

  @override
  String get dialogCommunityTitle => '💎 Oksigenia Gemeenschap';

  @override
  String get dialogCommunityBody => 'Dit is de COMMUNITY-versie (Gratis).';

  @override
  String get dialogStoreTitle => '🔒 Oksigenia Pro';

  @override
  String get dialogStoreBody =>
      'Abonneer op PRO om meerdere contacten en real-time tracking te ontgrendelen.';

  @override
  String get btnDonate => 'Koop een koffie voor ons ☕';

  @override
  String get btnSubscribe => 'Abonneren';

  @override
  String get btnClose => 'Sluiten';

  @override
  String get permSmsTitle => 'GEVAAR! SMS-toestemming Geblokkeerd';

  @override
  String get permSmsBody =>
      'App KAN GEEN alarmen verzenden, zelfs met opgeslagen contacten.';

  @override
  String get permSmsButton => 'SMS inschakelen in Instellingen';

  @override
  String get restrictedSettingsTitle => 'Beperkte Instellingen';

  @override
  String get restrictedSettingsBody =>
      'Android heeft deze toestemming beperkt omdat de app handmatig is geïnstalleerd.';

  @override
  String get contactsTitle => 'Noodcontacten';

  @override
  String get contactsSubtitle => 'De eerste (Hoofd) ontvangt GPS-tracking.';

  @override
  String get contactsAddHint => 'Nummer toevoegen';

  @override
  String get contactsEmpty => '⚠️ Geen contacten. Alarm wordt niet verzonden.';

  @override
  String get messageTitle => 'Aangepast Bericht';

  @override
  String get messageSubtitle => 'Verzonden VOOR de coördinaten.';

  @override
  String get messageHint => 'Bijv: Diabeet. Noordelijke route...';

  @override
  String get trackingTitle => 'GPS Tracking';

  @override
  String get trackingSubtitle =>
      'Stuurt positie naar Hoofdcontact elke X tijd.';

  @override
  String get trackOff => '❌ Uitgeschakeld';

  @override
  String get track30 => '⏱️ Elke 30 min';

  @override
  String get track60 => '⏱️ Elk uur';

  @override
  String get track120 => '⏱️ Elke 2 uur';

  @override
  String get inactivityTimeTitle => 'Tijd voor Alarm';

  @override
  String get inactivityTimeSubtitle => 'Hoe lang zonder beweging voor alarm?';

  @override
  String get ina30s => '🧪 30 sec (TEST Modus)';

  @override
  String get ina1h => '⏱️ 1 uur (Aanbevolen)';

  @override
  String get ina2h => '⏱️ 2 uur (Lange pauze)';

  @override
  String get testModeWarning => 'TESTMODUS AAN: Alarm gaat af in 30s.';

  @override
  String get toastHoldToSOS => 'Houd knop ingedrukt voor SOS';

  @override
  String get donateDialogTitle => '💎 Steun het Project';

  @override
  String get donateDialogBody =>
      'Deze app is gratis en open source. Als het je veilig houdt, koop een koffie voor ons.';

  @override
  String get donateBtn => 'Doneren via PayPal';

  @override
  String get donateClose => 'SLUITEN';

  @override
  String get alertSendingIn => 'Alarm verzenden over...';

  @override
  String get alertCancel => 'ANNULEREN';

  @override
  String get warningKeepAlive =>
      '⚠️ BELANGRIJK: Sluit de app niet door te vegen. Laat het op de achtergrond zodat het automatisch kan herstarten.';

  @override
  String get aboutTitle => 'Over';

  @override
  String get aboutVersion => 'Versie';

  @override
  String get aboutDisclaimer => 'Juridische Disclaimer';

  @override
  String get aboutPrivacy => 'Privacybeleid';

  @override
  String get aboutSourceCode => 'Broncode (GitHub)';

  @override
  String get aboutLicenses => 'Softwarelicenties';

  @override
  String get aboutDevelopedBy => 'Ontwikkeld met ❤️ door Oksigenia';

  @override
  String get dialogClose => 'Sluiten';

  @override
  String get permSmsText =>
      'SMS-toestemmingen ontbreken. App kan geen alarmen verzenden.';

  @override
  String get phoneLabel => 'Telefoon (bijv. +31...)';

  @override
  String get btnAdd => 'TOEVOEGEN';

  @override
  String get noContacts => 'Geen contacten geconfigureerd.';

  @override
  String get inactivityTitle => 'Inactiviteitstijd';

  @override
  String get invalidNumberWarning => 'Ongeldig of te kort nummer';

  @override
  String get contactMain => 'Primair (Tracking / Batterij)';

  @override
  String get inactivitySubtitle =>
      'Tijd zonder beweging voordat hulp wordt ingeroepen.';

  @override
  String get dialogPermissionTitle => 'Hoe toestemmingen in te schakelen';

  @override
  String get dialogPermissionStep1 =>
      '1. Tik hieronder op \'GA NAAR INSTELLINGEN\'.';

  @override
  String get dialogPermissionStep2 =>
      '2. Tik op het nieuwe scherm op de 3 puntjes (⠇) rechtsboven.';

  @override
  String get dialogPermissionStep3 =>
      '3. Selecteer \'Beperkte instellingen toestaan\' (indien zichtbaar).';

  @override
  String get dialogPermissionStep4 => '4. Keer terug naar deze app.';

  @override
  String get btnGoToSettings => 'GA NAAR INSTELLINGEN';

  @override
  String get timerLabel => 'Timer';

  @override
  String get timerSeconds => 'sec';

  @override
  String get permSmsOk => 'SMS-toestemming actief';

  @override
  String get permSensorsOk => 'Sensoren actief';

  @override
  String get permNotifOk => 'Meldingen actief';

  @override
  String get permSmsMissing => 'SMS-toestemming ontbreekt';

  @override
  String get permSensorsMissing => 'Sensoren ontbreken';

  @override
  String get permNotifMissing => 'Meldingen ontbreken';

  @override
  String get permOverlayMissing => 'Overlay ontbreekt';

  @override
  String get permDialogTitle => 'Toestemming vereist';

  @override
  String get permSmsHelpTitle => 'SMS Hulp';

  @override
  String get permGoSettings => 'Ga naar Instellingen';

  @override
  String get gpsHelpTitle => 'Over GPS';

  @override
  String get gpsHelpBody =>
      'De nauwkeurigheid hangt af van de fysieke chip in uw telefoon en direct zicht op de hemel.\n\nBinnenshuis, in garages of tunnels wordt het satellietsignaal geblokkeerd en kan de locatie onnauwkeurig of niet beschikbaar zijn.\n\nOksigenia zal altijd proberen de best mogelijke positie te bepalen.';

  @override
  String get holdToCancel => 'Ingedrukt houden om te annuleren';

  @override
  String get statusMonitorStopped => 'Monitor gestopt.';

  @override
  String get statusScreenSleep => 'Scherm gaat uit...';

  @override
  String get btnRestartSystem => 'SYSTEEM HERSTARTEN';

  @override
  String get smsDyingGasp => 'BATTERIJ <5%. Systeem sluit af. Loc:';

  @override
  String get smsHelpMessage => 'HELP! Ik heb dringend hulp nodig.';

  @override
  String get smsBeaconHeader => 'OKSIGENIA SOS - update (GEEN nieuw alarm):';

  @override
  String get batteryDialogTitle => 'Batterij Beperking';

  @override
  String get btnDisableBatterySaver => 'BESPARING UIT';

  @override
  String get batteryDialogBody =>
      'Het systeem beperkt de batterij. Om SOS op de achtergrond te laten werken, selecteer \'Onbeperkt\' of \'Niet optimaliseren\'.';

  @override
  String get permBgLocationTitle => 'GPS op de achtergrond';

  @override
  String get bgLocationDialogBody =>
      'Wanneer het alarm afgaat, zit de telefoon meestal in je zak met het scherm uit. Om de SOS op dat moment met je exacte positie te versturen, vereist Android het locatieniveau \'Altijd toestaan\'.\n\nJe locatie verlaat de telefoon nooit: geen internet, geen cloud, geen trackers — ze reist alleen mee in de SOS-sms naar je eigen contacten.\n\nKies op het volgende scherm \'Altijd toestaan\'.';

  @override
  String get whyPermsBgLocation =>
      'Bepaalt je GPS-positie terwijl het scherm uit is of de app op de achtergrond draait — precies wanneer een SOS afgaat. De locatie wordt alleen verzonden in de SOS-sms naar je contacten; ze verlaat je telefoon verder nooit.';

  @override
  String get btnEnableBgLocation => 'Altijd toestaan';

  @override
  String get permLocMissing => 'Locatietoestemming ontbreekt';

  @override
  String get slideStopSystem => 'VEEG OM TE STOPPEN';

  @override
  String get onboardingTitle => 'Configureer uw veiligheidssysteem';

  @override
  String get onboardingSubtitle =>
      'Deze toestemmingen zijn essentieel om u te beschermen in het veld.';

  @override
  String get onboardingGrant => 'VERLENEN';

  @override
  String get onboardingGranted => 'VERLEEND ✓';

  @override
  String get onboardingNext => 'DOORGAAN';

  @override
  String get onboardingFinish => 'KLAAR — MONITORING STARTEN';

  @override
  String get onboardingMandatory => 'Vereist om monitoring te activeren';

  @override
  String get onboardingSkip => 'Overslaan';

  @override
  String get fullScreenIntentTitle => 'Alarm op vergrendeld scherm';

  @override
  String get fullScreenIntentBody =>
      'Hiermee kan het alarm boven het vergrendelscherm verschijnen. Zonder dit klinkt het alarm maar wordt het scherm niet gewekt. Op Android 14+: Instellingen → Apps → Oksigenia SOS → Volledig scherm meldingen.';

  @override
  String get btnEnableFullScreenIntent => 'INSCHAKELEN';

  @override
  String get pauseMonitoringSheet => 'Bewaking pauzeren voor...';

  @override
  String get pauseTitle => 'Bewaking gepauzeerd';

  @override
  String pauseResumesIn(Object time) {
    return '⏸ Gepauzeerd · hervat in $time';
  }

  @override
  String get pauseResumeNow => 'Nu hervatten';

  @override
  String get pauseResumedMsg => 'Bewaking hervat';

  @override
  String get pauseHoldHint => 'Houd ingedrukt om te pauzeren';

  @override
  String get pauseSec5 => '5 seconden';

  @override
  String get liveTrackingTitle => 'Live Tracking';

  @override
  String get liveTrackingSubtitle =>
      'Verzendt uw GPS-positie per SMS met regelmatige tussenpozen.';

  @override
  String get liveTrackingInterval => 'Verzendinterval';

  @override
  String get liveTrackingShutdownReminder => 'Uitschakelherinnering';

  @override
  String get liveTrackingNoReminder => '❌ Geen herinnering';

  @override
  String get liveTrackingReminder2h => '⏰ Na 2 uur';

  @override
  String get liveTrackingReminder3h => '⏰ Na 3 uur';

  @override
  String get liveTrackingReminder4h => '⏰ Na 4 uur';

  @override
  String get liveTrackingReminder5h => '⏰ Na 5 uur';

  @override
  String get liveTrackingLegalTitle => '⚠️ SMS-kosten';

  @override
  String get liveTrackingLegalBody =>
      'Live Tracking stuurt één SMS per interval naar uw hoofdcontact. De tarieven van uw provider zijn van toepassing. U bent als enige verantwoordelijk voor alle berichtenkosten.';

  @override
  String get liveTrackingActivate => 'TRACKING ACTIVEREN';

  @override
  String get liveTrackingDeactivate => 'DEACTIVEREN';

  @override
  String liveTrackingNextUpdate(Object time) {
    return 'Volgende update in $time';
  }

  @override
  String get liveTrackingCardTitle => 'Live Tracking Actief';

  @override
  String get liveTrackingPausedSOS => 'Gepauzeerd — SOS actief';

  @override
  String get liveTrackingTest1m => '🧪 1 min (TEST)';

  @override
  String get liveTrackingTest2m => '🧪 2 min (TEST)';

  @override
  String liveTrackingTestWarning(Object time) {
    return 'TESTMODUS: Live Tracking verzendt elke $time.';
  }

  @override
  String get selectLanguage => 'Taal selecteren';

  @override
  String get whyPermsTitle => 'Waarom deze machtigingen?';

  @override
  String get whyPermsSms =>
      'Stuurt nood-SMS naar uw contacten. Werkt zonder internet.';

  @override
  String get whyPermsLocation =>
      'Voegt GPS-coördinaten toe aan het alarm zodat hulpverleners precies weten waar u bent.';

  @override
  String get whyPermsNotifications =>
      'Toont de bewakingsstatus en laat u een vals alarm annuleren vanaf het vergrendelingsscherm.';

  @override
  String get whyPermsActivity =>
      'Detecteert bewegingspatronen om valse alarmen te voorkomen bij lopen of rennen.';

  @override
  String get whyPermsSensors =>
      'Leest de versnellingsmeter om de G-kracht van een val te detecteren.';

  @override
  String get whyPermsBattery =>
      'Voorkomt dat Android de app stopt tijdens achtergrondmonitoring.';

  @override
  String get whyPermsFullScreen =>
      'Toont het alarm over het vergrendelingsscherm zodat u kunt reageren zonder te ontgrendelen.';

  @override
  String get sentinelGreen => 'Systeem actief';

  @override
  String get sentinelYellow => 'Impact gedetecteerd · analyseren...';

  @override
  String get sentinelOrange => 'Alarm nadert!';

  @override
  String get sentinelRed => 'ALARM ACTIEF';

  @override
  String get activityProfileTitle => 'Activiteitsprofiel';

  @override
  String get activityProfileSubtitle =>
      'Stemt Smart Sentinel-detectie af op je sport. Kies het meest passende — een verkeerd profiel veroorzaakt valse alarmen of mist echte vallen.';

  @override
  String get profileTrekking => 'Trekken / Wandelen';

  @override
  String get profileTrekkingDesc =>
      'Standaard. Buiten wandelen met de telefoon in een zak of rugzak. Evenwichtige gevoeligheid.';

  @override
  String get profileRunning => 'Hardlopen (weg)';

  @override
  String get profileRunningDesc =>
      'Hardlopen op asfalt of harde ondergrond. Hogere impactdrempel (10G) en adaptieve cadansdetector — verwerkt het aanhoudende horizontale G-regime van hardlopen dat de standaard cadansdetector breekt.';

  @override
  String get profileTrailMtb => 'Trail / MTB';

  @override
  String get profileTrailMtbDesc =>
      'Hogere impactdrempel en meer toegeeflijke cadans — constante trillingen op oneffen terrein zouden anders valse alarmen veroorzaken.';

  @override
  String get profileMountaineering => 'Bergbeklimmen';

  @override
  String get profileMountaineeringDesc =>
      'Zelfde basis als trekken met een verlengd observatievenster van 90 seconden voor langzame herstellingen in technisch terrein.';

  @override
  String get profileParagliding => 'Paragliden';

  @override
  String get profileParaglidingDesc =>
      'Automatische valdetectie is UITGESCHAKELD — de versnellingsmeter kan vluchtmanoeuvres niet betrouwbaar onderscheiden van een val. Handmatige SOS en inactiviteitsmonitor blijven actief.';

  @override
  String get profileKayak => 'Kajak / Watersport';

  @override
  String get profileKayakDesc =>
      'Automatische valdetectie is UITGESCHAKELD — water dempt impact en drijvende beweging is niet informatief. Gebruik de inactiviteitsmonitor en handmatige SOS.';

  @override
  String get profileEquitation => 'Paardrijden';

  @override
  String get profileEquitationDesc =>
      'Automatische valdetectie is UITGESCHAKELD — de cadans van het paard (draf, galop) verstoort de detector voor menselijke loopbeweging. De inactiviteitsmonitor en handmatige SOS beschermen je tijdens de rit.';

  @override
  String get profileProfessional => 'Professioneel / Reddingsdienst';

  @override
  String get profileProfessionalDesc =>
      'Verlengd observatievenster van 120 seconden voor geavanceerd operationeel gebruik waarbij herstel na een val de standaard time-outs kan overschrijden.';

  @override
  String homeSummaryWithImpact(int imp, int obs, String gps) {
    return 'Impact ${imp}G · Obs ${obs}s · GPS $gps';
  }

  @override
  String homeSummaryNoImpact(String gps) {
    return 'Impact UIT · GPS $gps';
  }

  @override
  String get homeAlertNotArmed =>
      'NIET GEACTIVEERD — tik hieronder op een schakelaar om te activeren';

  @override
  String get homeAlertSensorPermDenied => 'Sensortoegang geweigerd';

  @override
  String get homeConfirmTitleImpact => 'Impactdetectie';

  @override
  String get homeConfirmTitleObservation => 'Observatie';

  @override
  String get homeConfirmTitleGps => 'GPS-interval';

  @override
  String homeConfirmValueOn(int threshold) {
    return 'AAN · ${threshold}G';
  }

  @override
  String get homeConfirmValueOff => 'UIT';

  @override
  String get homeProfileNoFallWarning =>
      'Dit profiel detecteert GEEN vallen. SOS moet handmatig worden geactiveerd.';

  @override
  String get homeActionApply => 'Toepassen';

  @override
  String get smsBeaconDistance => 'vanaf het SOS-punt.';

  @override
  String get homeBeaconBanner =>
      'Locatie-updates naar je contact na de SOS — tik om te stoppen';

  @override
  String get beaconStopped => 'Bewegingsmeldingen gestopt';
}
