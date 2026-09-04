// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Oksigenia SOS';

  @override
  String get sosButton => 'SOS';

  @override
  String get statusReady => 'Oksigenia System Redo.';

  @override
  String get statusConnecting => 'Ansluter satelliter...';

  @override
  String get statusLocationFixed => 'PLATS FASTSTÄLLD';

  @override
  String get statusSent => 'Varning skickad.';

  @override
  String get alarmSendingNow => 'Skickar larm…';

  @override
  String get alarmSendFailed => 'SOS EJ SKICKAT';

  @override
  String get btnRetry => 'Försök igen';

  @override
  String get statusSendFailed => '⚠️ SOS EJ SKICKAT';

  @override
  String get statusSendFailedBody =>
      'Inget SMS kunde skickas. Kontrollera täckning och kontakter och försök igen.';

  @override
  String statusError(Object error) {
    return 'FEL: $error';
  }

  @override
  String get menuWeb => 'Officiell Webbplats';

  @override
  String get menuSupport => 'Teknisk Support';

  @override
  String get menuLanguages => 'Språk';

  @override
  String get menuSettings => 'Inställningar';

  @override
  String get menuPrivacy => 'Sekretess & Juridik';

  @override
  String get menuDonate => 'Donera';

  @override
  String get menuX => '𝕏 (Twitter)';

  @override
  String get menuInsta => 'Instagram';

  @override
  String get motto => 'Respira > Inspira > Crece;';

  @override
  String panicMessage(Object link) {
    return '🆘 *OKSIGENIA ALERT* 🆘\n\nJag behöver akut hjälp.\n📍 Plats: $link\n\nRespira > Inspira > Crece;';
  }

  @override
  String get settingsTitle => 'SOS Inställningar';

  @override
  String get settingsLabel => 'Nödtelefon';

  @override
  String get settingsHint => 'Ex: +46 70 123 4567';

  @override
  String get settingsSave => 'SPARA';

  @override
  String get settingsSavedMsg => 'Kontakt sparad';

  @override
  String get errorNoContact => '⚠️ Konfigurera en kontakt först!';

  @override
  String get autoModeLabel => 'Falldetektering';

  @override
  String get autoModeDescription => 'Övervakar svåra stötar.';

  @override
  String get inactivityModeLabel => 'Inaktivitetsmonitor';

  @override
  String get inactivityModeDescription => 'Varnar om ingen rörelse upptäcks.';

  @override
  String get alertFallDetected => 'STÖT UPPTÄCKT!';

  @override
  String get alertFallBody => 'Svårt fall upptäckt. Är du okej?';

  @override
  String get alertInactivityDetected => 'INAKTIVITET UPPTÄCKT!';

  @override
  String get alertInactivityBody => 'Ingen rörelse upptäckt. Är du okej?';

  @override
  String get btnImOkay => 'JAG ÄR OKEJ';

  @override
  String get disclaimerTitle => '⚠️ JURIDISKT MEDDELANDE & SEKRETESS';

  @override
  String get disclaimerText =>
      'Oksigenia SOS är ett stödverktyg, inte en ersättning för professionella nödtjänster. Dess funktion beror på externa faktorer: batteri, GPS-signal och mobiltäckning.\n\nGenom att aktivera denna app accepterar du att programvaran tillhandahålls \'i befintligt skick\' och friskriver utvecklarna från juridiskt ansvar för tekniska fel. Du ansvarar för din egen säkerhet.\n\nSMS-kostnader: Alla meddelandekostnader är användarens ansvar enligt mobiloperatörens taxor. Oksigenia täcker inte eller tar betalt för dessa meddelanden.';

  @override
  String get btnAccept => 'JAG ACCEPTERAR RISKEN';

  @override
  String get btnDecline => 'AVSLUTA';

  @override
  String get privacyTitle => 'Villkor & Sekretess';

  @override
  String get privacyPolicyContent =>
      'SEKRETESSPOLICY & VILLKOR\n\n1. INGEN DATAINSAMLING\nOksigenia SOS fungerar lokalt. Vi laddar inte upp data till molnet eller säljer din information.\n\n2. BEHÖRIGHETER\n- Plats: För koordinater vid larm.\n- SMS: Endast för att skicka nödmeddelandet.\n\n3. ANSVARSBEGRÄNSNING\nAppen tillhandahålls \'i befintligt skick\'. Vi ansvarar inte för täckning eller hårdvarufel.';

  @override
  String get advSettingsTitle => 'Avancerade Funktioner';

  @override
  String get advSettingsSubtitle => 'Flerkontakter, GPS-spårning...';

  @override
  String get dialogCommunityTitle => '💎 Oksigenia Gemenskap';

  @override
  String get dialogCommunityBody => 'Detta är COMMUNITY-versionen (Gratis).';

  @override
  String get dialogStoreTitle => '🔒 Oksigenia Pro';

  @override
  String get dialogStoreBody =>
      'Prenumerera på PRO för att låsa upp flera kontakter och spårning i realtid.';

  @override
  String get btnDonate => 'Köp mig en kaffe ☕';

  @override
  String get btnSubscribe => 'Prenumerera';

  @override
  String get btnClose => 'Stäng';

  @override
  String get permSmsTitle => 'FARA! SMS-behörighet Blockerad';

  @override
  String get permSmsBody =>
      'Appen KAN INTE skicka larm även med sparade kontakter.';

  @override
  String get permSmsButton => 'Aktivera SMS i Inställningar';

  @override
  String get restrictedSettingsTitle => 'Begränsade Inställningar';

  @override
  String get restrictedSettingsBody =>
      'Android har begränsat denna behörighet eftersom appen installerades manuellt.';

  @override
  String get contactsTitle => 'Nödkontakter';

  @override
  String get contactsSubtitle => 'Den första (Huvud) tar emot GPS-spårning.';

  @override
  String get contactsAddHint => 'Lägg till nummer';

  @override
  String get contactsEmpty =>
      '⚠️ Inga kontakter. Larm kommer inte att skickas.';

  @override
  String get messageTitle => 'Anpassat Meddelande';

  @override
  String get messageSubtitle => 'Skickas FÖRE koordinaterna.';

  @override
  String get messageHint => 'Ex: Diabetiker. Norra rutten...';

  @override
  String get trackingTitle => 'GPS-spårning';

  @override
  String get trackingSubtitle =>
      'Skickar position till Huvudkontakt varje X tid.';

  @override
  String get trackOff => '❌ Inaktiverad';

  @override
  String get track30 => '⏱️ Var 30:e min';

  @override
  String get track60 => '⏱️ Varje timme';

  @override
  String get track120 => '⏱️ Varannan timme';

  @override
  String get inactivityTimeTitle => 'Tid före Larm';

  @override
  String get inactivityTimeSubtitle => 'Hur länge utan rörelse innan larm?';

  @override
  String get ina30s => '🧪 30 sek (TEST-läge)';

  @override
  String get ina1h => '⏱️ 1 timme (Rekommenderas)';

  @override
  String get ina2h => '⏱️ 2 timmar (Lång paus)';

  @override
  String get testModeWarning => 'TESTLÄGE PÅ: Larm utlöses om 30s.';

  @override
  String get toastHoldToSOS => 'Håll knappen för SOS';

  @override
  String get donateDialogTitle => '💎 Stöd Projektet';

  @override
  String get donateDialogBody =>
      'Denna app är fri och öppen källkod. Om den håller dig säker, köp oss en kaffe.';

  @override
  String get donateBtn => 'Donera via PayPal';

  @override
  String get donateClose => 'STÄNG';

  @override
  String get alertSendingIn => 'Skickar larm om...';

  @override
  String get alertCancel => 'AVBRYT';

  @override
  String get warningKeepAlive =>
      '⚠️ VIKTIGT: Stäng inte appen genom att svepa bort den. Lämna den i bakgrunden så den kan starta om automatiskt.';

  @override
  String get aboutTitle => 'Om';

  @override
  String get aboutVersion => 'Version';

  @override
  String get aboutDisclaimer => 'Juridisk Friskrivning';

  @override
  String get aboutPrivacy => 'Sekretesspolicy';

  @override
  String get aboutSourceCode => 'Källkod (GitHub)';

  @override
  String get aboutLicenses => 'Programvarulicenser';

  @override
  String get aboutDevelopedBy => 'Utvecklad med ❤️ av Oksigenia';

  @override
  String get dialogClose => 'Stäng';

  @override
  String get permSmsText =>
      'SMS-behörigheter saknas. Appen kan inte skicka larm.';

  @override
  String get phoneLabel => 'Telefon (t.ex. +46...)';

  @override
  String get btnAdd => 'LÄGG TILL';

  @override
  String get noContacts => 'Inga kontakter konfigurerade.';

  @override
  String get inactivityTitle => 'Inaktivitetstid';

  @override
  String get invalidNumberWarning => 'Ogiltigt eller för kort nummer';

  @override
  String get contactMain => 'Primär (Spårning / Batteri)';

  @override
  String get inactivitySubtitle => 'Tid utan rörelse innan hjälp tillkallas.';

  @override
  String get dialogPermissionTitle => 'Hur man aktiverar behörigheter';

  @override
  String get dialogPermissionStep1 =>
      '1. Tryck på \'GÅ TILL INSTÄLLNINGAR\' nedan.';

  @override
  String get dialogPermissionStep2 =>
      '2. På nya skärmen, tryck på de 3 prickarna (⠇) uppe till höger.';

  @override
  String get dialogPermissionStep3 =>
      '3. Välj \'Tillåt begränsade inställningar\' (om synligt).';

  @override
  String get dialogPermissionStep4 => '4. Återgå till denna app.';

  @override
  String get btnGoToSettings => 'GÅ TILL INSTÄLLNINGAR';

  @override
  String get timerLabel => 'Timer';

  @override
  String get timerSeconds => 'sek';

  @override
  String get permSmsOk => 'SMS-behörighet aktiv';

  @override
  String get permSensorsOk => 'Sensorer aktiva';

  @override
  String get permNotifOk => 'Aviseringar aktiva';

  @override
  String get permSmsMissing => 'SMS-behörighet saknas';

  @override
  String get permSensorsMissing => 'Sensorer saknas';

  @override
  String get permNotifMissing => 'Aviseringar saknas';

  @override
  String get permOverlayMissing => 'Överlagring saknas';

  @override
  String get permDialogTitle => 'Behörighet krävs';

  @override
  String get permSmsHelpTitle => 'SMS Hjälp';

  @override
  String get permGoSettings => 'Gå till Inställningar';

  @override
  String get gpsHelpTitle => 'Om GPS';

  @override
  String get gpsHelpBody =>
      'Noggrannheten beror på telefonens fysiska chip och fri sikt mot himlen.\n\nInomhus, i garage eller tunnlar blockeras satellitsignalen och platsen kan vara ungefärlig eller saknas.\n\nOksigenia kommer alltid att försöka triangulera bästa möjliga position.';

  @override
  String get holdToCancel => 'Håll intryckt för att avbryta';

  @override
  String get statusMonitorStopped => 'Övervakning stoppad.';

  @override
  String get statusScreenSleep => 'Skärmen släcks snart...';

  @override
  String get btnRestartSystem => 'STARTA OM SYSTEMET';

  @override
  String get smsDyingGasp => 'BATTERI <5%. Systemet stängs av. Plats:';

  @override
  String get smsHelpMessage => 'HJÄLP! Jag behöver assistans.';

  @override
  String get smsBeaconHeader =>
      'OKSIGENIA SOS - uppföljning (INTE ett nytt larm):';

  @override
  String get batteryDialogTitle => 'Batteribegränsning';

  @override
  String get btnDisableBatterySaver => 'INAKTIVERA SPARLÄGE';

  @override
  String get batteryDialogBody =>
      'Systemet begränsar batteriet. För att SOS ska fungera i bakgrunden, välj \'Ingen begränsning\' eller \'Optimera inte\'.';

  @override
  String get permBgLocationTitle => 'GPS i bakgrunden';

  @override
  String get bgLocationDialogBody =>
      'När larmet utlöses ligger telefonen oftast i fickan med släckt skärm. För att SOS:et ska skickas med din exakta position i det ögonblicket kräver Android platsnivån \'Tillåt alltid\'.\n\nDin plats lämnar aldrig telefonen: inget internet, inget moln, inga spårare — den färdas bara i SOS-sms:et till dina egna kontakter.\n\nVälj \'Tillåt alltid\' på nästa skärm.';

  @override
  String get whyPermsBgLocation =>
      'Hämtar din GPS-position när skärmen är släckt eller appen är i bakgrunden — precis när ett SOS utlöses. Platsen skickas endast i SOS-sms:et till dina kontakter; den lämnar aldrig telefonen på annat sätt.';

  @override
  String get btnEnableBgLocation => 'Tillåt alltid';

  @override
  String get permLocMissing => 'Platsbehörighet saknas';

  @override
  String get slideStopSystem => 'DRA FÖR ATT STOPPA';

  @override
  String get onboardingTitle => 'Konfigurera ditt säkerhetssystem';

  @override
  String get onboardingSubtitle =>
      'Dessa behörigheter är nödvändiga för att Oksigenia SOS ska kunna skydda dig i fält.';

  @override
  String get onboardingGrant => 'BEVILJA';

  @override
  String get onboardingGranted => 'BEVILJAD ✓';

  @override
  String get onboardingNext => 'FORTSÄTT';

  @override
  String get onboardingFinish => 'KLART — STARTA ÖVERVAKNING';

  @override
  String get onboardingMandatory => 'Krävs för att aktivera övervakning';

  @override
  String get onboardingSkip => 'Hoppa över';

  @override
  String get fullScreenIntentTitle => 'Larm på låsskärmen';

  @override
  String get fullScreenIntentBody =>
      'Tillåter larmet att visas ovanpå låsskärmen. Utan detta låter larmet men skärmen vaknar inte. På Android 14+: Inställningar → Appar → Oksigenia SOS → Helskärmsaviseringar.';

  @override
  String get btnEnableFullScreenIntent => 'AKTIVERA';

  @override
  String get pauseMonitoringSheet => 'Pausa övervakning i...';

  @override
  String get pauseTitle => 'Övervakning pausad';

  @override
  String pauseResumesIn(Object time) {
    return '⏸ Pausad · återupptas om $time';
  }

  @override
  String get pauseResumeNow => 'Återuppta nu';

  @override
  String get pauseResumedMsg => 'Övervakning återupptagen';

  @override
  String get pauseHoldHint => 'Håll för att pausa';

  @override
  String get pauseSec5 => '5 sekunder';

  @override
  String get liveTrackingTitle => 'Livespårning';

  @override
  String get liveTrackingSubtitle =>
      'Skickar din GPS-position via SMS med jämna intervall.';

  @override
  String get liveTrackingInterval => 'Sändningsintervall';

  @override
  String get liveTrackingShutdownReminder => 'Avstängningspåminnelse';

  @override
  String get liveTrackingNoReminder => '❌ Ingen påminnelse';

  @override
  String get liveTrackingReminder2h => '⏰ Efter 2 timmar';

  @override
  String get liveTrackingReminder3h => '⏰ Efter 3 timmar';

  @override
  String get liveTrackingReminder4h => '⏰ Efter 4 timmar';

  @override
  String get liveTrackingReminder5h => '⏰ Efter 5 timmar';

  @override
  String get liveTrackingLegalTitle => '⚠️ SMS-kostnader';

  @override
  String get liveTrackingLegalBody =>
      'Livespårning skickar ett SMS per intervall till din primära kontakt. Din operatörs taxor gäller. Du är ensam ansvarig för alla meddelandekostnader.';

  @override
  String get liveTrackingActivate => 'AKTIVERA SPÅRNING';

  @override
  String get liveTrackingDeactivate => 'INAKTIVERA';

  @override
  String liveTrackingNextUpdate(Object time) {
    return 'Nästa uppdatering om $time';
  }

  @override
  String get liveTrackingCardTitle => 'Livespårning Aktiv';

  @override
  String get liveTrackingPausedSOS => 'Pausad — SOS aktiv';

  @override
  String get liveTrackingTest1m => '🧪 1 min (TEST)';

  @override
  String get liveTrackingTest2m => '🧪 2 min (TEST)';

  @override
  String liveTrackingTestWarning(Object time) {
    return 'TESTLÄGE: Livespårning skickar var $time.';
  }

  @override
  String get selectLanguage => 'Välj språk';

  @override
  String get whyPermsTitle => 'Varför dessa behörigheter?';

  @override
  String get whyPermsSms =>
      'Skickar nödmeddelanden via SMS till dina kontakter. Fungerar utan internet.';

  @override
  String get whyPermsLocation =>
      'Inkluderar GPS-koordinater i larmet så att räddare vet exakt var du är.';

  @override
  String get whyPermsNotifications =>
      'Visar övervakningsstatus och låter dig avbryta falskt larm från låsskärmen.';

  @override
  String get whyPermsActivity =>
      'Identifierar rörelsemönster för att undvika falsklarm vid gång eller löpning.';

  @override
  String get whyPermsSensors =>
      'Läser accelerometern för att upptäcka G-kraften vid ett fall.';

  @override
  String get whyPermsBattery =>
      'Hindrar Android från att avsluta appen under bakgrundsövervakning.';

  @override
  String get whyPermsFullScreen =>
      'Visar larmet över låsskärmen så att du kan svara utan att låsa upp.';

  @override
  String get sentinelGreen => 'System aktivt';

  @override
  String get sentinelYellow => 'Stöt upptäckt · analyserar...';

  @override
  String get sentinelOrange => 'Larm omedelbart förestående!';

  @override
  String get sentinelRed => 'LARM AKTIVT';

  @override
  String get activityProfileTitle => 'Aktivitetsprofil';

  @override
  String get activityProfileSubtitle =>
      'Anpassar Smart Sentinels detektering till din sport. Välj den närmast matchande — fel profil orsakar falska larm eller missar verkliga fall.';

  @override
  String get profileTrekking => 'Trekking / Vandring';

  @override
  String get profileTrekkingDesc =>
      'Standard. Vandring utomhus med telefonen i ficka eller ryggsäck. Balanserad känslighet.';

  @override
  String get profileRunning => 'Löpning (väg)';

  @override
  String get profileRunningDesc =>
      'Löpning på asfalt eller hård beläggning. Högre stöttröskel (10G) och adaptiv kadensdetektor — hanterar löpningens ihållande horisontella G-regim som bryter standardkadensdetektorn.';

  @override
  String get profileTrailMtb => 'Trail / MTB';

  @override
  String get profileTrailMtbDesc =>
      'Högre tröskel för stötar och mer tolerant kadens — den ständiga vibrationen på ojämn terräng skulle annars utlösa falska larm.';

  @override
  String get profileMountaineering => 'Bergsklättring';

  @override
  String get profileMountaineeringDesc =>
      'Samma bas som trekking med ett förlängt observationsfönster på 90 sekunder för långsam återhämtning i teknisk terräng.';

  @override
  String get profileParagliding => 'Skärmflygning';

  @override
  String get profileParaglidingDesc =>
      'Automatisk falldetektering är AVSTÄNGD — accelerometern kan inte tillförlitligt skilja flygmanövrer från ett verkligt fall. Manuellt SOS och inaktivitetsmonitor förblir aktiva.';

  @override
  String get profileKayak => 'Kajak / Vattensport';

  @override
  String get profileKayakDesc =>
      'Automatisk falldetektering är AVSTÄNGD — vatten dämpar stötar och flytrörelser är inte informativa. Använd inaktivitetsmonitor och manuellt SOS.';

  @override
  String get profileEquitation => 'Ridning';

  @override
  String get profileEquitationDesc =>
      'Automatisk falldetektering är AVSTÄNGD — hästens kadens (trav, galopp) stör detektorn för mänsklig gång. Inaktivitetsmonitor och manuellt SOS skyddar under ritten.';

  @override
  String get profileProfessional => 'Professionell / Räddning';

  @override
  String get profileProfessionalDesc =>
      'Förlängt observationsfönster på 120 sekunder för avancerad operativ användning där återhämtning efter ett fall kan överskrida standardtidsgränserna.';

  @override
  String homeSummaryWithImpact(int imp, int obs, String gps) {
    return 'Stöt ${imp}G · Obs ${obs}s · GPS $gps';
  }

  @override
  String homeSummaryNoImpact(String gps) {
    return 'Stöt AV · GPS $gps';
  }

  @override
  String get homeAlertNotArmed =>
      'EJ AKTIVERAD — tryck på en knapp nedan för att aktivera';

  @override
  String get homeAlertSensorPermDenied => 'Sensorbehörighet nekad';

  @override
  String get homeConfirmTitleImpact => 'Stötdetektering';

  @override
  String get homeConfirmTitleObservation => 'Observation';

  @override
  String get homeConfirmTitleGps => 'GPS-intervall';

  @override
  String homeConfirmValueOn(int threshold) {
    return 'PÅ · ${threshold}G';
  }

  @override
  String get homeConfirmValueOff => 'AV';

  @override
  String get homeProfileNoFallWarning =>
      'Denna profil upptäcker INTE fall. SOS måste utlösas manuellt.';

  @override
  String get homeActionApply => 'Tillämpa';

  @override
  String get smsBeaconDistance => 'från SOS-punkten.';

  @override
  String get homeBeaconBanner =>
      'Skickar platsuppdateringar till din kontakt efter SOS — tryck för att stoppa';

  @override
  String get beaconStopped => 'Rörelseaviseringar stoppade';
}
