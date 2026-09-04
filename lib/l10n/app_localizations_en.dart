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
  String get alarmSendingNow => 'Sending alert…';

  @override
  String get alarmSendFailed => 'SOS NOT SENT';

  @override
  String get btnRetry => 'Retry';

  @override
  String get statusSendFailed => '⚠️ SOS NOT SENT';

  @override
  String get statusSendFailedBody =>
      'No SMS could be sent. Check signal and contacts, then retry.';

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
  String get menuX => '𝕏 (Twitter)';

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
      'Oksigenia SOS is a support tool, not a substitute for professional emergency services. Its operation depends on external factors: battery, GPS signal, and mobile coverage.\n\nBy activating this app, you accept that the software is provided \'as is\' and release the developers from legal liability for technical failures. You are responsible for your own safety.\n\nSMS Service Costs: All messaging costs are the responsibility of the user according to their mobile carrier\'s rates. Oksigenia does not cover or charge for these messages.';

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
  String get testModeWarning => 'TEST MODE ON: Alert will trigger in 30s.';

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

  @override
  String get permSmsText =>
      'Missing SMS permissions. The app cannot send alerts.';

  @override
  String get phoneLabel => 'Phone (e.g. +1...)';

  @override
  String get btnAdd => 'ADD';

  @override
  String get noContacts => 'No contacts configured.';

  @override
  String get inactivityTitle => 'Inactivity Time';

  @override
  String get invalidNumberWarning => 'Invalid or too short number';

  @override
  String get contactMain => 'Primary (Tracking / Battery)';

  @override
  String get inactivitySubtitle =>
      'Time without movement before calling for help.';

  @override
  String get dialogPermissionTitle => 'How to enable permissions';

  @override
  String get dialogPermissionStep1 => '1. Tap \'GO TO SETTINGS\' below.';

  @override
  String get dialogPermissionStep2 =>
      '2. On the new screen, tap the 3 dots (⠇) top right.';

  @override
  String get dialogPermissionStep3 =>
      '3. Select \'Allow restricted settings\' (if visible).';

  @override
  String get dialogPermissionStep4 => '4. Return to this app.';

  @override
  String get btnGoToSettings => 'GO TO SETTINGS';

  @override
  String get timerLabel => 'Timer';

  @override
  String get timerSeconds => 'sec';

  @override
  String get permSmsOk => 'SMS Permission Active';

  @override
  String get permSensorsOk => 'Sensors Active';

  @override
  String get permNotifOk => 'Notifications Active';

  @override
  String get permSmsMissing => 'Missing SMS Permission';

  @override
  String get permSensorsMissing => 'Missing Sensors';

  @override
  String get permNotifMissing => 'Missing Notifications';

  @override
  String get permOverlayMissing => 'Missing Overlay Permission';

  @override
  String get permDialogTitle => 'Permission Required';

  @override
  String get permSmsHelpTitle => 'SMS Help';

  @override
  String get permGoSettings => 'Go to Settings';

  @override
  String get gpsHelpTitle => 'About GPS';

  @override
  String get gpsHelpBody =>
      'Accuracy depends on your phone\'s physical chip and direct sky visibility.\n\nIndoors, in garages, or tunnels, satellite signal is blocked, and location may be approximate or null.\n\nOksigenia will always try to triangulate the best possible position.';

  @override
  String get holdToCancel => 'Hold to cancel';

  @override
  String get statusMonitorStopped => 'Monitor stopped.';

  @override
  String get statusScreenSleep => 'Screen sleeping soon.';

  @override
  String get btnRestartSystem => 'RESTART SYSTEM';

  @override
  String get smsDyingGasp => 'BATTERY <5%. System shutting down. Loc:';

  @override
  String get smsHelpMessage => 'HELP! I need assistance.';

  @override
  String get smsBeaconHeader => 'OKSIGENIA SOS - follow-up (NOT a new alarm):';

  @override
  String get batteryDialogTitle => 'Battery Restriction';

  @override
  String get btnDisableBatterySaver => 'DISABLE SAVER';

  @override
  String get batteryDialogBody =>
      'The system is restricting this app\'s battery. For SOS to work in the background, you must select \'Unrestricted\' or \'Don\'t Optimize\'.';

  @override
  String get permBgLocationTitle => 'GPS in background';

  @override
  String get bgLocationDialogBody =>
      'When the alarm fires, your phone is usually in your pocket with the screen off. For the SOS to leave with your exact position at that moment, Android needs location set to \'Allow all the time\'.\n\nYour location never leaves the phone: no internet, no cloud, no trackers — it only travels inside the SOS SMS to your own contacts.\n\nOn the next screen, choose \'Allow all the time\'.';

  @override
  String get whyPermsBgLocation =>
      'Gets your GPS position while the screen is off or the app is in the background — exactly when an SOS fires. The location is only ever sent inside the SOS SMS to your contacts; it never leaves your phone otherwise.';

  @override
  String get btnEnableBgLocation => 'Allow all the time';

  @override
  String get permLocMissing => 'Missing Location Permission';

  @override
  String get slideStopSystem => 'SLIDE TO STOP SYSTEM';

  @override
  String get onboardingTitle => 'Configure your safety system';

  @override
  String get onboardingSubtitle =>
      'These permissions are essential for Oksigenia SOS to protect you in the field.';

  @override
  String get onboardingGrant => 'GRANT';

  @override
  String get onboardingGranted => 'GRANTED ✓';

  @override
  String get onboardingNext => 'CONTINUE';

  @override
  String get onboardingFinish => 'ALL SET — START MONITORING';

  @override
  String get onboardingMandatory => 'Required to activate monitoring';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get fullScreenIntentTitle => 'Lock Screen Alarm';

  @override
  String get fullScreenIntentBody =>
      'Allows the alarm to appear on top of the lock screen. Without this, the alarm sounds but the screen does not wake. On Android 14+: Settings → Apps → Oksigenia SOS → Full-screen notifications.';

  @override
  String get btnEnableFullScreenIntent => 'ENABLE';

  @override
  String get pauseMonitoringSheet => 'Pause monitoring for...';

  @override
  String get pauseTitle => 'Monitoring paused';

  @override
  String pauseResumesIn(Object time) {
    return '⏸ Paused · $time remaining';
  }

  @override
  String get pauseResumeNow => 'Resume now';

  @override
  String get pauseResumedMsg => 'Monitoring resumed';

  @override
  String get pauseHoldHint => 'Hold to pause';

  @override
  String get pauseSec5 => '5 seconds';

  @override
  String get liveTrackingTitle => 'Live Tracking';

  @override
  String get liveTrackingSubtitle =>
      'Sends your GPS position by SMS at regular intervals.';

  @override
  String get liveTrackingInterval => 'Send interval';

  @override
  String get liveTrackingShutdownReminder => 'Shutdown reminder';

  @override
  String get liveTrackingNoReminder => '❌ No reminder';

  @override
  String get liveTrackingReminder2h => '⏰ After 2 hours';

  @override
  String get liveTrackingReminder3h => '⏰ After 3 hours';

  @override
  String get liveTrackingReminder4h => '⏰ After 4 hours';

  @override
  String get liveTrackingReminder5h => '⏰ After 5 hours';

  @override
  String get liveTrackingLegalTitle => '⚠️ SMS Costs';

  @override
  String get liveTrackingLegalBody =>
      'Live Tracking sends one SMS per interval to your primary contact. Your carrier\'s rates apply. You are solely responsible for all messaging costs.';

  @override
  String get liveTrackingActivate => 'ACTIVATE TRACKING';

  @override
  String get liveTrackingDeactivate => 'DEACTIVATE';

  @override
  String liveTrackingNextUpdate(Object time) {
    return 'Next update in $time';
  }

  @override
  String get liveTrackingCardTitle => 'Live Tracking Active';

  @override
  String get liveTrackingPausedSOS => 'Paused — SOS active';

  @override
  String get liveTrackingTest1m => '🧪 1 min (TEST)';

  @override
  String get liveTrackingTest2m => '🧪 2 min (TEST)';

  @override
  String liveTrackingTestWarning(Object time) {
    return 'TEST MODE: Live Tracking will send every $time.';
  }

  @override
  String get selectLanguage => 'Select language';

  @override
  String get whyPermsTitle => 'Why these permissions?';

  @override
  String get whyPermsSms =>
      'Sends emergency alerts by SMS to your contacts. Works without internet.';

  @override
  String get whyPermsLocation =>
      'Includes GPS coordinates in the alert so rescuers know exactly where you are.';

  @override
  String get whyPermsNotifications =>
      'Shows monitoring status and lets you cancel a false alarm from the lock screen.';

  @override
  String get whyPermsActivity =>
      'Detects movement patterns to avoid false alarms when walking or running.';

  @override
  String get whyPermsSensors =>
      'Reads the accelerometer to detect the G-force of a fall.';

  @override
  String get whyPermsBattery =>
      'Prevents Android from killing the app while it monitors in the background.';

  @override
  String get whyPermsFullScreen =>
      'Shows the alarm over the lock screen so you can respond without unlocking.';

  @override
  String get sentinelGreen => 'System active';

  @override
  String get sentinelYellow => 'Impact detected · analysing...';

  @override
  String get sentinelOrange => 'Alert imminent!';

  @override
  String get sentinelRed => 'ALARM ACTIVE';

  @override
  String get activityProfileTitle => 'Activity profile';

  @override
  String get activityProfileSubtitle =>
      'Tunes Smart Sentinel detection to your sport. Choose the closest match — wrong profiles cause false alarms or miss real falls.';

  @override
  String get profileTrekking => 'Trekking / Hiking';

  @override
  String get profileTrekkingDesc =>
      'Default. Walking outdoors with the phone in a pocket or backpack. Balanced sensitivity.';

  @override
  String get profileRunning => 'Running (road)';

  @override
  String get profileRunningDesc =>
      'Road running on asphalt or hard pavement. Higher impact threshold (10G) and adaptive cadence detector — handles the persistent horizontal-G of running gait that breaks the walk-baseline cadence check.';

  @override
  String get profileTrailMtb => 'Trail running / MTB';

  @override
  String get profileTrailMtbDesc =>
      'Higher impact threshold and more permissive cadence — constant vibration on uneven ground would otherwise trigger false alarms.';

  @override
  String get profileMountaineering => 'Mountaineering';

  @override
  String get profileMountaineeringDesc =>
      'Same baseline as trekking with a longer 90-second observation window after impact, accounting for slow recoveries on technical terrain.';

  @override
  String get profileParagliding => 'Paragliding';

  @override
  String get profileParaglidingDesc =>
      'Automatic fall detection is DISABLED — accelerometer cannot reliably distinguish flight manoeuvres from a fall. Manual SOS and inactivity monitor remain active.';

  @override
  String get profileKayak => 'Kayak / Watersports';

  @override
  String get profileKayakDesc =>
      'Automatic fall detection is DISABLED — water absorbs impact and floating motion is not informative. Use the inactivity monitor and manual SOS.';

  @override
  String get profileEquitation => 'Horse riding';

  @override
  String get profileEquitationDesc =>
      'Automatic fall detection is DISABLED — horse cadence (trot, canter) interferes with the human-walk detector. The inactivity monitor and manual SOS protect during the ride.';

  @override
  String get profileProfessional => 'Professional / Rescue';

  @override
  String get profileProfessionalDesc =>
      'Extended 120-second observation window for advanced operational use where recovery time after a fall may exceed standard timeouts.';

  @override
  String homeSummaryWithImpact(int imp, int obs, String gps) {
    return 'Impact ${imp}G · Observ ${obs}s · GPS $gps';
  }

  @override
  String homeSummaryNoImpact(String gps) {
    return 'Impact OFF · GPS $gps';
  }

  @override
  String get homeAlertNotArmed => 'NOT ARMED — tap a toggle below to activate';

  @override
  String get homeAlertSensorPermDenied => 'Sensor permission denied';

  @override
  String get homeConfirmTitleImpact => 'Impact detection';

  @override
  String get homeConfirmTitleObservation => 'Observation';

  @override
  String get homeConfirmTitleGps => 'GPS interval';

  @override
  String homeConfirmValueOn(int threshold) {
    return 'ON · ${threshold}G';
  }

  @override
  String get homeConfirmValueOff => 'OFF';

  @override
  String get homeProfileNoFallWarning =>
      'This profile does NOT detect falls. SOS must be triggered manually.';

  @override
  String get homeActionApply => 'Apply';

  @override
  String get smsBeaconDistance => 'from the SOS point.';

  @override
  String get homeBeaconBanner =>
      'Sending location updates to your contact after the SOS — tap to stop';

  @override
  String get beaconStopped => 'Movement alerts stopped';
}
