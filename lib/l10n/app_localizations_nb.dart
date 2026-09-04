// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appTitle => 'Oksigenia SOS';

  @override
  String get sosButton => 'SOS';

  @override
  String get statusReady => 'Oksigenia-systemet klart.';

  @override
  String get statusConnecting => 'Kobler til satellitter...';

  @override
  String get statusLocationFixed => 'POSISJON FASTSATT';

  @override
  String get statusSent => 'Varsel sendt.';

  @override
  String get alarmSendingNow => 'Sender alarm…';

  @override
  String get alarmSendFailed => 'SOS IKKE SENDT';

  @override
  String get btnRetry => 'Prøv igjen';

  @override
  String get statusSendFailed => '⚠️ SOS IKKE SENDT';

  @override
  String get statusSendFailedBody =>
      'Ingen SMS kunne sendes. Sjekk dekning og kontakter, og prøv igjen.';

  @override
  String statusError(Object error) {
    return 'FEIL: $error';
  }

  @override
  String get menuWeb => 'Offisielt nettsted';

  @override
  String get menuSupport => 'Teknisk støtte';

  @override
  String get menuLanguages => 'Språk';

  @override
  String get menuSettings => 'Innstillinger';

  @override
  String get menuPrivacy => 'Personvern og juridisk';

  @override
  String get menuDonate => 'Støtt / Donate';

  @override
  String get menuX => '𝕏 (Twitter)';

  @override
  String get menuInsta => 'Instagram';

  @override
  String get motto => 'Respira > Inspira > Crece;';

  @override
  String panicMessage(Object link) {
    return '🆘 *OKSIGENIA-VARSEL* 🆘\n\nJeg trenger akutt hjelp.\n📍 Posisjon: $link\n\nRespira > Inspira > Crece;';
  }

  @override
  String get settingsTitle => 'SOS-innstillinger';

  @override
  String get settingsLabel => 'Nødtelefon';

  @override
  String get settingsHint => 'F.eks.: +47 900 12 345';

  @override
  String get settingsSave => 'LAGRE';

  @override
  String get settingsSavedMsg => 'Kontakt lagret';

  @override
  String get errorNoContact => '⚠️ Konfigurer en kontakt først!';

  @override
  String get autoModeLabel => 'Falldeteksjon';

  @override
  String get autoModeDescription => 'Overvåker kraftige støt.';

  @override
  String get inactivityModeLabel => 'Inaktivitetsmonitor';

  @override
  String get inactivityModeDescription =>
      'Varsler hvis ingen bevegelse oppdages.';

  @override
  String get alertFallDetected => 'STØT OPPDAGET!';

  @override
  String get alertFallBody => 'Alvorlig fall oppdaget. Er du i orden?';

  @override
  String get alertInactivityDetected => 'INAKTIVITET OPPDAGET!';

  @override
  String get alertInactivityBody => 'Ingen bevegelse oppdaget. Er du i orden?';

  @override
  String get btnImOkay => 'JEG ER OK';

  @override
  String get disclaimerTitle => '⚠️ JURIDISK MERKNAD OG PERSONVERN';

  @override
  String get disclaimerText =>
      'Oksigenia SOS er et støtteverktøy, ikke en erstatning for profesjonelle nødetater. Driften avhenger av eksterne faktorer: batteri, GPS-signal og mobildekning.\n\nVed å aktivere denne appen aksepterer du at programvaren leveres «som den er», og fritar utviklerne for juridisk ansvar for tekniske feil. Du er selv ansvarlig for din sikkerhet.\n\nSMS-kostnader: alle meldingskostnader er brukerens ansvar i henhold til mobiloperatørens takster. Oksigenia dekker eller belaster ikke disse meldingene.';

  @override
  String get btnAccept => 'JEG GODTAR RISIKOEN';

  @override
  String get btnDecline => 'AVSLUTT';

  @override
  String get privacyTitle => 'Vilkår og personvern';

  @override
  String get privacyPolicyContent =>
      'PERSONVERNSPOLICY OG VILKÅR\n\n1. INGEN DATAINNSAMLING\nOksigenia SOS fungerer lokalt. Vi laster ikke opp data til skyen og selger ikke informasjonen din.\n\n2. TILLATELSER\n- Posisjon: for koordinater ved varsel.\n- SMS: utelukkende for å sende nødmeldingen.\n\n3. ANSVARSBEGRENSNING\nApp levert «som den er». Vi er ikke ansvarlige for dekning eller maskinvarefeil.';

  @override
  String get advSettingsTitle => 'Avanserte funksjoner';

  @override
  String get advSettingsSubtitle => 'Flerkontakter, GPS-sporing...';

  @override
  String get dialogCommunityTitle => '💎 Oksigenia-fellesskap';

  @override
  String get dialogCommunityBody => 'Dette er COMMUNITY-versjonen (gratis).';

  @override
  String get dialogStoreTitle => '🔒 Oksigenia Pro';

  @override
  String get dialogStoreBody =>
      'Abonner på PRO for å låse opp flere kontakter og sanntidssporing.';

  @override
  String get btnDonate => 'Spander en kaffe ☕';

  @override
  String get btnSubscribe => 'Abonner';

  @override
  String get btnClose => 'Lukk';

  @override
  String get permSmsTitle => 'FARE! SMS-tillatelse blokkert';

  @override
  String get permSmsBody =>
      'Appen KAN IKKE sende varsler selv med lagrede kontakter.';

  @override
  String get permSmsButton => 'Aktiver SMS i innstillinger';

  @override
  String get restrictedSettingsTitle => 'Begrensede innstillinger';

  @override
  String get restrictedSettingsBody =>
      'Android har begrenset denne tillatelsen fordi appen ble installert manuelt (sideload).';

  @override
  String get contactsTitle => 'Nødkontakter';

  @override
  String get contactsSubtitle => 'Den første (hoved) får GPS-sporing.';

  @override
  String get contactsAddHint => 'Legg til nummer';

  @override
  String get contactsEmpty => '⚠️ Ingen kontakter. Varsel sendes ikke.';

  @override
  String get messageTitle => 'Tilpasset melding';

  @override
  String get messageSubtitle => 'Sendes FØR koordinatene.';

  @override
  String get messageHint => 'F.eks.: Diabetiker. Nordrute...';

  @override
  String get trackingTitle => 'GPS-sporing';

  @override
  String get trackingSubtitle => 'Sender posisjon til hovedkontakt hver X.';

  @override
  String get trackOff => '❌ Deaktivert';

  @override
  String get track30 => '⏱️ Hvert 30. min';

  @override
  String get track60 => '⏱️ Hver time';

  @override
  String get track120 => '⏱️ Hver 2. time';

  @override
  String get inactivityTimeTitle => 'Tid før varsel';

  @override
  String get inactivityTimeSubtitle => 'Hvor lenge uten bevegelse før varsel?';

  @override
  String get ina30s => '🧪 30 sek (TEST-modus)';

  @override
  String get ina1h => '⏱️ 1 time (anbefalt)';

  @override
  String get ina2h => '⏱️ 2 timer (lang pause)';

  @override
  String get testModeWarning => 'TEST-MODUS PÅ: varsel utløses om 30 s.';

  @override
  String get toastHoldToSOS => 'Hold knappen for SOS';

  @override
  String get donateDialogTitle => '💎 Støtt prosjektet';

  @override
  String get donateDialogBody =>
      'Denne appen er fri og åpen kildekode. Hvis den holder deg trygg, kjøp oss en kaffe.';

  @override
  String get donateBtn => 'Doner via PayPal';

  @override
  String get donateClose => 'LUKK';

  @override
  String get alertSendingIn => 'Sender varsel om...';

  @override
  String get alertCancel => 'AVBRYT';

  @override
  String get warningKeepAlive =>
      '⚠️ VIKTIG: Ikke sveip-lukk appen (Oppgavebehandling). La den ligge i bakgrunnen så den kan starte automatisk.';

  @override
  String get aboutTitle => 'Om';

  @override
  String get aboutVersion => 'Versjon';

  @override
  String get aboutDisclaimer => 'Juridisk merknad';

  @override
  String get aboutPrivacy => 'Personvernpolicy';

  @override
  String get aboutSourceCode => 'Kildekode (GitHub)';

  @override
  String get aboutLicenses => 'Programvarelisenser';

  @override
  String get aboutDevelopedBy => 'Utviklet med ❤️ av Oksigenia';

  @override
  String get dialogClose => 'Lukk';

  @override
  String get permSmsText =>
      'Mangler SMS-tillatelser. Appen kan ikke sende varsler.';

  @override
  String get phoneLabel => 'Telefon (f.eks. +47...)';

  @override
  String get btnAdd => 'LEGG TIL';

  @override
  String get noContacts => 'Ingen kontakter konfigurert.';

  @override
  String get inactivityTitle => 'Inaktivitetstid';

  @override
  String get invalidNumberWarning => 'Ugyldig eller for kort nummer';

  @override
  String get contactMain => 'Hoved (Sporing / Batteri)';

  @override
  String get inactivitySubtitle => 'Tid uten bevegelse før hjelp tilkalles.';

  @override
  String get dialogPermissionTitle => 'Slik aktiverer du tillatelser';

  @override
  String get dialogPermissionStep1 =>
      '1. Trykk «GÅ TIL INNSTILLINGER» nedenfor.';

  @override
  String get dialogPermissionStep2 =>
      '2. På den nye skjermen, trykk de 3 prikkene (⠇) øverst til høyre.';

  @override
  String get dialogPermissionStep3 =>
      '3. Velg «Tillat begrensede innstillinger» (hvis synlig).';

  @override
  String get dialogPermissionStep4 => '4. Gå tilbake til denne appen.';

  @override
  String get btnGoToSettings => 'GÅ TIL INNSTILLINGER';

  @override
  String get timerLabel => 'Tidtaker';

  @override
  String get timerSeconds => 'sek';

  @override
  String get permSmsOk => 'SMS-tillatelse aktiv';

  @override
  String get permSensorsOk => 'Sensorer aktive';

  @override
  String get permNotifOk => 'Varsler aktive';

  @override
  String get permSmsMissing => 'Mangler SMS-tillatelse';

  @override
  String get permSensorsMissing => 'Mangler sensorer';

  @override
  String get permNotifMissing => 'Mangler varsler';

  @override
  String get permOverlayMissing => 'Mangler overlegg';

  @override
  String get permDialogTitle => 'Tillatelse kreves';

  @override
  String get permSmsHelpTitle => 'SMS-hjelp';

  @override
  String get permGoSettings => 'Gå til innstillinger';

  @override
  String get gpsHelpTitle => 'Om GPS';

  @override
  String get gpsHelpBody =>
      'Nøyaktigheten avhenger av telefonens fysiske brikke og direkte sikt mot himmelen.\n\nInnendørs, i garasjer eller tunneler blokkeres satellittsignalet, og posisjonen kan være omtrentlig eller mangle.\n\nOksigenia vil alltid prøve å triangulere best mulig posisjon.';

  @override
  String get holdToCancel => 'Hold for å avbryte';

  @override
  String get statusMonitorStopped => 'Monitor stoppet.';

  @override
  String get statusScreenSleep => 'Skjermen slukker snart.';

  @override
  String get btnRestartSystem => 'START SYSTEM PÅ NYTT';

  @override
  String get smsDyingGasp => 'BATTERI <5%. Systemet slår seg av. Pos:';

  @override
  String get smsHelpMessage => 'HJELP! Jeg trenger assistanse.';

  @override
  String get smsBeaconHeader =>
      'OKSIGENIA SOS - oppfølging (IKKE en ny alarm):';

  @override
  String get batteryDialogTitle => 'Batteribegrensning';

  @override
  String get btnDisableBatterySaver => 'DEAKTIVER SPARING';

  @override
  String get batteryDialogBody =>
      'Systemet begrenser appens batteri. For at SOS skal fungere i bakgrunnen, velg «Ubegrenset» eller «Ikke optimaliser».';

  @override
  String get permBgLocationTitle => 'GPS i bakgrunnen';

  @override
  String get bgLocationDialogBody =>
      'Når alarmen utløses, ligger telefonen som regel i lomma med skjermen av. For at SOS-en skal sendes med din nøyaktige posisjon i det øyeblikket, krever Android posisjonsnivået «Tillat alltid».\n\nPosisjonen din forlater aldri telefonen: ingen internett, ingen sky, ingen sporere — den reiser bare i SOS-SMS-en til dine egne kontakter.\n\nVelg «Tillat alltid» på neste skjerm.';

  @override
  String get whyPermsBgLocation =>
      'Henter GPS-posisjonen din når skjermen er av eller appen er i bakgrunnen — akkurat når en SOS utløses. Posisjonen sendes kun i SOS-SMS-en til kontaktene dine; den forlater aldri telefonen på annen måte.';

  @override
  String get btnEnableBgLocation => 'Tillat alltid';

  @override
  String get permLocMissing => 'Mangler posisjonstillatelse';

  @override
  String get slideStopSystem => 'DRA FOR Å STOPPE SYSTEM';

  @override
  String get onboardingTitle => 'Konfigurer sikkerhetssystemet';

  @override
  String get onboardingSubtitle =>
      'Disse tillatelsene er nødvendige for at Oksigenia SOS skal beskytte deg ute.';

  @override
  String get onboardingGrant => 'GI TILGANG';

  @override
  String get onboardingGranted => 'GITT ✓';

  @override
  String get onboardingNext => 'FORTSETT';

  @override
  String get onboardingFinish => 'KLART — START OVERVÅKING';

  @override
  String get onboardingMandatory => 'Kreves for å aktivere overvåking';

  @override
  String get onboardingSkip => 'Hopp over';

  @override
  String get fullScreenIntentTitle => 'Alarm på låseskjerm';

  @override
  String get fullScreenIntentBody =>
      'Lar alarmen vises over låseskjermen. Uten dette lyder alarmen, men skjermen våkner ikke. På Android 14+: Innstillinger → Apper → Oksigenia SOS → Fullskjermvarsler.';

  @override
  String get btnEnableFullScreenIntent => 'AKTIVER';

  @override
  String get pauseMonitoringSheet => 'Sett overvåking på pause i...';

  @override
  String get pauseTitle => 'Overvåking på pause';

  @override
  String pauseResumesIn(Object time) {
    return '⏸ Pause · $time igjen';
  }

  @override
  String get pauseResumeNow => 'Gjenoppta nå';

  @override
  String get pauseResumedMsg => 'Overvåking gjenopptatt';

  @override
  String get pauseHoldHint => 'Hold for å pause';

  @override
  String get pauseSec5 => '5 sekunder';

  @override
  String get liveTrackingTitle => 'Live Tracking';

  @override
  String get liveTrackingSubtitle =>
      'Sender GPS-posisjon via SMS med jevne mellomrom.';

  @override
  String get liveTrackingInterval => 'Sendeintervall';

  @override
  String get liveTrackingShutdownReminder => 'Påminnelse om å skru av';

  @override
  String get liveTrackingNoReminder => '❌ Ingen påminnelse';

  @override
  String get liveTrackingReminder2h => '⏰ Etter 2 timer';

  @override
  String get liveTrackingReminder3h => '⏰ Etter 3 timer';

  @override
  String get liveTrackingReminder4h => '⏰ Etter 4 timer';

  @override
  String get liveTrackingReminder5h => '⏰ Etter 5 timer';

  @override
  String get liveTrackingLegalTitle => '⚠️ SMS-kostnader';

  @override
  String get liveTrackingLegalBody =>
      'Live Tracking sender én SMS per intervall til hovedkontakten din. Operatørens takster gjelder. Du er alene ansvarlig for alle meldingskostnader.';

  @override
  String get liveTrackingActivate => 'AKTIVER SPORING';

  @override
  String get liveTrackingDeactivate => 'DEAKTIVER';

  @override
  String liveTrackingNextUpdate(Object time) {
    return 'Neste oppdatering om $time';
  }

  @override
  String get liveTrackingCardTitle => 'Live Tracking aktiv';

  @override
  String get liveTrackingPausedSOS => 'Pause — SOS aktiv';

  @override
  String get liveTrackingTest1m => '🧪 1 min (TEST)';

  @override
  String get liveTrackingTest2m => '🧪 2 min (TEST)';

  @override
  String liveTrackingTestWarning(Object time) {
    return 'TEST-MODUS: Live Tracking sender hvert $time.';
  }

  @override
  String get selectLanguage => 'Velg språk';

  @override
  String get whyPermsTitle => 'Hvorfor disse tillatelsene?';

  @override
  String get whyPermsSms =>
      'Sender nødvarsler via SMS til kontaktene dine. Fungerer uten internett.';

  @override
  String get whyPermsLocation =>
      'Inkluderer GPS-koordinater i varselet så redningsmannskap vet hvor du er.';

  @override
  String get whyPermsNotifications =>
      'Viser overvåkingsstatus og lar deg avbryte falsk alarm fra låseskjermen.';

  @override
  String get whyPermsActivity =>
      'Oppdager bevegelsesmønstre for å unngå falske alarmer ved gange eller løping.';

  @override
  String get whyPermsSensors =>
      'Leser akselerometeret for å oppdage G-kraften av et fall.';

  @override
  String get whyPermsBattery =>
      'Hindrer at Android dreper appen mens den overvåker i bakgrunnen.';

  @override
  String get whyPermsFullScreen =>
      'Viser alarmen over låseskjermen så du kan reagere uten å låse opp.';

  @override
  String get sentinelGreen => 'System aktivt';

  @override
  String get sentinelYellow => 'Støt oppdaget · analyserer...';

  @override
  String get sentinelOrange => 'Alarm rett rundt hjørnet!';

  @override
  String get sentinelRed => 'ALARM AKTIV';

  @override
  String get activityProfileTitle => 'Aktivitetsprofil';

  @override
  String get activityProfileSubtitle =>
      'Tilpasser Smart Sentinel-deteksjon til sporten din. Velg det nærmeste — feil profil gir falske alarmer eller overser ekte fall.';

  @override
  String get profileTrekking => 'Tursti / Fjelltur';

  @override
  String get profileTrekkingDesc =>
      'Standard. Gange ute med telefonen i lomme eller sekk. Balansert følsomhet.';

  @override
  String get profileRunning => 'Løping (asfalt)';

  @override
  String get profileRunningDesc =>
      'Løping på asfalt eller hardt underlag. Høyere støtterskel (10G) og adaptiv kadensdetektor — håndterer det vedvarende horisontale G-regimet i løping som bryter standardkadensdetektoren.';

  @override
  String get profileTrailMtb => 'Stiløping / MTB';

  @override
  String get profileTrailMtbDesc =>
      'Høyere støtterskel og mer tolerant kadens — konstant vibrasjon på ujevnt underlag ville ellers utløse falske alarmer.';

  @override
  String get profileMountaineering => 'Tindebestigning';

  @override
  String get profileMountaineeringDesc =>
      'Samme grunnlag som tursti, men med lengre observasjonsvindu på 90 sekunder etter støt, for sakte gjenoppretting i teknisk terreng.';

  @override
  String get profileParagliding => 'Paragliding';

  @override
  String get profileParaglidingDesc =>
      'Automatisk falldeteksjon er DEAKTIVERT — akselerometeret kan ikke pålitelig skille flymanøvre fra fall. Manuell SOS og inaktivitetsmonitor er fortsatt aktive.';

  @override
  String get profileKayak => 'Kajakk / Vannsport';

  @override
  String get profileKayakDesc =>
      'Automatisk falldeteksjon er DEAKTIVERT — vann demper støt og flytebevegelser er ikke informative. Bruk inaktivitetsmonitor og manuell SOS.';

  @override
  String get profileEquitation => 'Ridning';

  @override
  String get profileEquitationDesc =>
      'Automatisk falldeteksjon er DEAKTIVERT — hestens kadens (trav, galopp) forstyrrer detektoren for menneskelig gange. Inaktivitetsmonitor og manuell SOS beskytter under ridningen.';

  @override
  String get profileProfessional => 'Profesjonell / Redning';

  @override
  String get profileProfessionalDesc =>
      'Utvidet observasjonsvindu på 120 sekunder for avansert operativ bruk der gjenopprettingstid etter et fall kan overskride standard tidsgrenser.';

  @override
  String homeSummaryWithImpact(int imp, int obs, String gps) {
    return 'Støt ${imp}G · Obs ${obs}s · GPS $gps';
  }

  @override
  String homeSummaryNoImpact(String gps) {
    return 'Støt AV · GPS $gps';
  }

  @override
  String get homeAlertNotArmed =>
      'IKKE AKTIVERT — trykk på en bryter nedenfor for å aktivere';

  @override
  String get homeAlertSensorPermDenied => 'Sensortillatelse avslått';

  @override
  String get homeConfirmTitleImpact => 'Støtdeteksjon';

  @override
  String get homeConfirmTitleObservation => 'Observasjon';

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
      'Denne profilen oppdager IKKE fall. SOS må utløses manuelt.';

  @override
  String get homeActionApply => 'Bruk';

  @override
  String get smsBeaconDistance => 'fra SOS-punktet.';

  @override
  String get homeBeaconBanner =>
      'Sender posisjonsoppdateringer til kontakten din etter SOS — trykk for å stoppe';

  @override
  String get beaconStopped => 'Bevegelsesvarsler stoppet';
}
