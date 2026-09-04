import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sv.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('nb'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('sv')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Oksigenia SOS'**
  String get appTitle;

  /// No description provided for @sosButton.
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get sosButton;

  /// No description provided for @statusReady.
  ///
  /// In en, this message translates to:
  /// **'Oksigenia System Ready.'**
  String get statusReady;

  /// No description provided for @statusConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting satellites...'**
  String get statusConnecting;

  /// No description provided for @statusLocationFixed.
  ///
  /// In en, this message translates to:
  /// **'LOCATION FIXED'**
  String get statusLocationFixed;

  /// No description provided for @statusSent.
  ///
  /// In en, this message translates to:
  /// **'Alert sent successfully.'**
  String get statusSent;

  /// No description provided for @alarmSendingNow.
  ///
  /// In en, this message translates to:
  /// **'Sending alert…'**
  String get alarmSendingNow;

  /// No description provided for @alarmSendFailed.
  ///
  /// In en, this message translates to:
  /// **'SOS NOT SENT'**
  String get alarmSendFailed;

  /// No description provided for @btnRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get btnRetry;

  /// No description provided for @statusSendFailed.
  ///
  /// In en, this message translates to:
  /// **'⚠️ SOS NOT SENT'**
  String get statusSendFailed;

  /// No description provided for @statusSendFailedBody.
  ///
  /// In en, this message translates to:
  /// **'No SMS could be sent. Check signal and contacts, then retry.'**
  String get statusSendFailedBody;

  /// No description provided for @statusError.
  ///
  /// In en, this message translates to:
  /// **'ERROR: {error}'**
  String statusError(Object error);

  /// No description provided for @menuWeb.
  ///
  /// In en, this message translates to:
  /// **'Official Website'**
  String get menuWeb;

  /// No description provided for @menuSupport.
  ///
  /// In en, this message translates to:
  /// **'Tech Support'**
  String get menuSupport;

  /// No description provided for @menuLanguages.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get menuLanguages;

  /// No description provided for @menuSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menuSettings;

  /// No description provided for @menuPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Legal'**
  String get menuPrivacy;

  /// No description provided for @menuDonate.
  ///
  /// In en, this message translates to:
  /// **'Donar / Donate'**
  String get menuDonate;

  /// No description provided for @menuX.
  ///
  /// In en, this message translates to:
  /// **'𝕏 (Twitter)'**
  String get menuX;

  /// No description provided for @menuInsta.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get menuInsta;

  /// No description provided for @motto.
  ///
  /// In en, this message translates to:
  /// **'Respira > Inspira > Crece;'**
  String get motto;

  /// No description provided for @panicMessage.
  ///
  /// In en, this message translates to:
  /// **'🆘 *OKSIGENIA ALERT* 🆘\n\nI need urgent help.\n📍 Location: {link}\n\nRespira > Inspira > Crece;'**
  String panicMessage(Object link);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'SOS Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Emergency Phone'**
  String get settingsLabel;

  /// No description provided for @settingsHint.
  ///
  /// In en, this message translates to:
  /// **'Ex: +1 555 123 456'**
  String get settingsHint;

  /// No description provided for @settingsSave.
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get settingsSave;

  /// No description provided for @settingsSavedMsg.
  ///
  /// In en, this message translates to:
  /// **'Contact saved successfully'**
  String get settingsSavedMsg;

  /// No description provided for @errorNoContact.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Configure a contact first!'**
  String get errorNoContact;

  /// No description provided for @autoModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Fall Detection'**
  String get autoModeLabel;

  /// No description provided for @autoModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Monitors severe impacts.'**
  String get autoModeDescription;

  /// No description provided for @inactivityModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Inactivity Monitor'**
  String get inactivityModeLabel;

  /// No description provided for @inactivityModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Alerts if no movement is detected.'**
  String get inactivityModeDescription;

  /// No description provided for @alertFallDetected.
  ///
  /// In en, this message translates to:
  /// **'IMPACT DETECTED!'**
  String get alertFallDetected;

  /// No description provided for @alertFallBody.
  ///
  /// In en, this message translates to:
  /// **'Severe fall detected. Are you okay?'**
  String get alertFallBody;

  /// No description provided for @alertInactivityDetected.
  ///
  /// In en, this message translates to:
  /// **'INACTIVITY DETECTED!'**
  String get alertInactivityDetected;

  /// No description provided for @alertInactivityBody.
  ///
  /// In en, this message translates to:
  /// **'No movement detected. Are you okay?'**
  String get alertInactivityBody;

  /// No description provided for @btnImOkay.
  ///
  /// In en, this message translates to:
  /// **'I\'M OKAY'**
  String get btnImOkay;

  /// No description provided for @disclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'⚠️ LEGAL NOTICE & PRIVACY'**
  String get disclaimerTitle;

  /// No description provided for @disclaimerText.
  ///
  /// In en, this message translates to:
  /// **'Oksigenia SOS is a support tool, not a substitute for professional emergency services. Its operation depends on external factors: battery, GPS signal, and mobile coverage.\n\nBy activating this app, you accept that the software is provided \'as is\' and release the developers from legal liability for technical failures. You are responsible for your own safety.\n\nSMS Service Costs: All messaging costs are the responsibility of the user according to their mobile carrier\'s rates. Oksigenia does not cover or charge for these messages.'**
  String get disclaimerText;

  /// No description provided for @btnAccept.
  ///
  /// In en, this message translates to:
  /// **'I ACCEPT THE RISK'**
  String get btnAccept;

  /// No description provided for @btnDecline.
  ///
  /// In en, this message translates to:
  /// **'EXIT'**
  String get btnDecline;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms & Privacy'**
  String get privacyTitle;

  /// No description provided for @privacyPolicyContent.
  ///
  /// In en, this message translates to:
  /// **'PRIVACY POLICY & TERMS\n\n1. NO DATA COLLECTION\nOksigenia SOS operates locally. We do not upload data to the cloud nor sell your information.\n\n2. PERMISSIONS\n- Location: For coordinates in case of alert.\n- SMS: Exclusively to send the distress message.\n\n3. LIMITATION OF LIABILITY\nApp provided \'as is\'. We are not responsible for coverage or hardware failures.'**
  String get privacyPolicyContent;

  /// No description provided for @advSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced Features'**
  String get advSettingsTitle;

  /// No description provided for @advSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Multi-contact, GPS Tracking...'**
  String get advSettingsSubtitle;

  /// No description provided for @dialogCommunityTitle.
  ///
  /// In en, this message translates to:
  /// **'💎 Oksigenia Community'**
  String get dialogCommunityTitle;

  /// No description provided for @dialogCommunityBody.
  ///
  /// In en, this message translates to:
  /// **'This is the COMMUNITY version (Free).'**
  String get dialogCommunityBody;

  /// No description provided for @dialogStoreTitle.
  ///
  /// In en, this message translates to:
  /// **'🔒 Oksigenia Pro'**
  String get dialogStoreTitle;

  /// No description provided for @dialogStoreBody.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to PRO to unlock multiple contacts and real-time tracking.'**
  String get dialogStoreBody;

  /// No description provided for @btnDonate.
  ///
  /// In en, this message translates to:
  /// **'Buy me a coffee ☕'**
  String get btnDonate;

  /// No description provided for @btnSubscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get btnSubscribe;

  /// No description provided for @btnClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get btnClose;

  /// No description provided for @permSmsTitle.
  ///
  /// In en, this message translates to:
  /// **'DANGER! SMS Permission Blocked'**
  String get permSmsTitle;

  /// No description provided for @permSmsBody.
  ///
  /// In en, this message translates to:
  /// **'App CANNOT send alerts even with saved contacts.'**
  String get permSmsBody;

  /// No description provided for @permSmsButton.
  ///
  /// In en, this message translates to:
  /// **'Enable SMS in Settings'**
  String get permSmsButton;

  /// No description provided for @restrictedSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Restricted Settings'**
  String get restrictedSettingsTitle;

  /// No description provided for @restrictedSettingsBody.
  ///
  /// In en, this message translates to:
  /// **'Android has restricted this permission because the app was installed manually (side-loaded).'**
  String get restrictedSettingsBody;

  /// No description provided for @contactsTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get contactsTitle;

  /// No description provided for @contactsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The first one (Main) will receive GPS tracking.'**
  String get contactsSubtitle;

  /// No description provided for @contactsAddHint.
  ///
  /// In en, this message translates to:
  /// **'Add number'**
  String get contactsAddHint;

  /// No description provided for @contactsEmpty.
  ///
  /// In en, this message translates to:
  /// **'⚠️ No contacts. Alert will not be sent.'**
  String get contactsEmpty;

  /// No description provided for @messageTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom Message'**
  String get messageTitle;

  /// No description provided for @messageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sent BEFORE the coordinates.'**
  String get messageSubtitle;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'Ex: Diabetic. North Route...'**
  String get messageHint;

  /// No description provided for @trackingTitle.
  ///
  /// In en, this message translates to:
  /// **'GPS Tracking'**
  String get trackingTitle;

  /// No description provided for @trackingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sends position to Main contact every X time.'**
  String get trackingSubtitle;

  /// No description provided for @trackOff.
  ///
  /// In en, this message translates to:
  /// **'❌ Disabled'**
  String get trackOff;

  /// No description provided for @track30.
  ///
  /// In en, this message translates to:
  /// **'⏱️ Every 30 min'**
  String get track30;

  /// No description provided for @track60.
  ///
  /// In en, this message translates to:
  /// **'⏱️ Every 1 hour'**
  String get track60;

  /// No description provided for @track120.
  ///
  /// In en, this message translates to:
  /// **'⏱️ Every 2 hours'**
  String get track120;

  /// No description provided for @inactivityTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Time before Alert'**
  String get inactivityTimeTitle;

  /// No description provided for @inactivityTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How long without movement before alerting?'**
  String get inactivityTimeSubtitle;

  /// No description provided for @ina30s.
  ///
  /// In en, this message translates to:
  /// **'🧪 30 sec (TEST Mode)'**
  String get ina30s;

  /// No description provided for @ina1h.
  ///
  /// In en, this message translates to:
  /// **'⏱️ 1 hour (Recommended)'**
  String get ina1h;

  /// No description provided for @ina2h.
  ///
  /// In en, this message translates to:
  /// **'⏱️ 2 hours (Long break)'**
  String get ina2h;

  /// No description provided for @testModeWarning.
  ///
  /// In en, this message translates to:
  /// **'TEST MODE ON: Alert will trigger in 30s.'**
  String get testModeWarning;

  /// No description provided for @toastHoldToSOS.
  ///
  /// In en, this message translates to:
  /// **'Hold button to SOS'**
  String get toastHoldToSOS;

  /// No description provided for @donateDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'💎 Support the Project'**
  String get donateDialogTitle;

  /// No description provided for @donateDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This app is Free & Open Source Software. If it keeps you safe, buy us a coffee.'**
  String get donateDialogBody;

  /// No description provided for @donateBtn.
  ///
  /// In en, this message translates to:
  /// **'Donate via PayPal'**
  String get donateBtn;

  /// No description provided for @donateClose.
  ///
  /// In en, this message translates to:
  /// **'CLOSE'**
  String get donateClose;

  /// No description provided for @alertSendingIn.
  ///
  /// In en, this message translates to:
  /// **'Sending alert in...'**
  String get alertSendingIn;

  /// No description provided for @alertCancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get alertCancel;

  /// No description provided for @warningKeepAlive.
  ///
  /// In en, this message translates to:
  /// **'⚠️ IMPORTANT: Do not swipe-close the app (Task Manager). Leave it in background so it can auto-restart.'**
  String get warningKeepAlive;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get aboutVersion;

  /// No description provided for @aboutDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Legal Disclaimer'**
  String get aboutDisclaimer;

  /// No description provided for @aboutPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get aboutPrivacy;

  /// No description provided for @aboutSourceCode.
  ///
  /// In en, this message translates to:
  /// **'Source Code (GitHub)'**
  String get aboutSourceCode;

  /// No description provided for @aboutLicenses.
  ///
  /// In en, this message translates to:
  /// **'Software Licenses'**
  String get aboutLicenses;

  /// No description provided for @aboutDevelopedBy.
  ///
  /// In en, this message translates to:
  /// **'Developed with ❤️ by Oksigenia'**
  String get aboutDevelopedBy;

  /// No description provided for @dialogClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get dialogClose;

  /// No description provided for @permSmsText.
  ///
  /// In en, this message translates to:
  /// **'Missing SMS permissions. The app cannot send alerts.'**
  String get permSmsText;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone (e.g. +1...)'**
  String get phoneLabel;

  /// No description provided for @btnAdd.
  ///
  /// In en, this message translates to:
  /// **'ADD'**
  String get btnAdd;

  /// No description provided for @noContacts.
  ///
  /// In en, this message translates to:
  /// **'No contacts configured.'**
  String get noContacts;

  /// No description provided for @inactivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Inactivity Time'**
  String get inactivityTitle;

  /// No description provided for @invalidNumberWarning.
  ///
  /// In en, this message translates to:
  /// **'Invalid or too short number'**
  String get invalidNumberWarning;

  /// No description provided for @contactMain.
  ///
  /// In en, this message translates to:
  /// **'Primary (Tracking / Battery)'**
  String get contactMain;

  /// No description provided for @inactivitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Time without movement before calling for help.'**
  String get inactivitySubtitle;

  /// No description provided for @dialogPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'How to enable permissions'**
  String get dialogPermissionTitle;

  /// No description provided for @dialogPermissionStep1.
  ///
  /// In en, this message translates to:
  /// **'1. Tap \'GO TO SETTINGS\' below.'**
  String get dialogPermissionStep1;

  /// No description provided for @dialogPermissionStep2.
  ///
  /// In en, this message translates to:
  /// **'2. On the new screen, tap the 3 dots (⠇) top right.'**
  String get dialogPermissionStep2;

  /// No description provided for @dialogPermissionStep3.
  ///
  /// In en, this message translates to:
  /// **'3. Select \'Allow restricted settings\' (if visible).'**
  String get dialogPermissionStep3;

  /// No description provided for @dialogPermissionStep4.
  ///
  /// In en, this message translates to:
  /// **'4. Return to this app.'**
  String get dialogPermissionStep4;

  /// No description provided for @btnGoToSettings.
  ///
  /// In en, this message translates to:
  /// **'GO TO SETTINGS'**
  String get btnGoToSettings;

  /// No description provided for @timerLabel.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timerLabel;

  /// No description provided for @timerSeconds.
  ///
  /// In en, this message translates to:
  /// **'sec'**
  String get timerSeconds;

  /// No description provided for @permSmsOk.
  ///
  /// In en, this message translates to:
  /// **'SMS Permission Active'**
  String get permSmsOk;

  /// No description provided for @permSensorsOk.
  ///
  /// In en, this message translates to:
  /// **'Sensors Active'**
  String get permSensorsOk;

  /// No description provided for @permNotifOk.
  ///
  /// In en, this message translates to:
  /// **'Notifications Active'**
  String get permNotifOk;

  /// No description provided for @permSmsMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing SMS Permission'**
  String get permSmsMissing;

  /// No description provided for @permSensorsMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing Sensors'**
  String get permSensorsMissing;

  /// No description provided for @permNotifMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing Notifications'**
  String get permNotifMissing;

  /// No description provided for @permOverlayMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing Overlay Permission'**
  String get permOverlayMissing;

  /// No description provided for @permDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permDialogTitle;

  /// No description provided for @permSmsHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'SMS Help'**
  String get permSmsHelpTitle;

  /// No description provided for @permGoSettings.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings'**
  String get permGoSettings;

  /// No description provided for @gpsHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'About GPS'**
  String get gpsHelpTitle;

  /// No description provided for @gpsHelpBody.
  ///
  /// In en, this message translates to:
  /// **'Accuracy depends on your phone\'s physical chip and direct sky visibility.\n\nIndoors, in garages, or tunnels, satellite signal is blocked, and location may be approximate or null.\n\nOksigenia will always try to triangulate the best possible position.'**
  String get gpsHelpBody;

  /// No description provided for @holdToCancel.
  ///
  /// In en, this message translates to:
  /// **'Hold to cancel'**
  String get holdToCancel;

  /// No description provided for @statusMonitorStopped.
  ///
  /// In en, this message translates to:
  /// **'Monitor stopped.'**
  String get statusMonitorStopped;

  /// No description provided for @statusScreenSleep.
  ///
  /// In en, this message translates to:
  /// **'Screen sleeping soon.'**
  String get statusScreenSleep;

  /// No description provided for @btnRestartSystem.
  ///
  /// In en, this message translates to:
  /// **'RESTART SYSTEM'**
  String get btnRestartSystem;

  /// No description provided for @smsDyingGasp.
  ///
  /// In en, this message translates to:
  /// **'BATTERY <5%. System shutting down. Loc:'**
  String get smsDyingGasp;

  /// No description provided for @smsHelpMessage.
  ///
  /// In en, this message translates to:
  /// **'HELP! I need assistance.'**
  String get smsHelpMessage;

  /// No description provided for @smsBeaconHeader.
  ///
  /// In en, this message translates to:
  /// **'OKSIGENIA SOS - follow-up (NOT a new alarm):'**
  String get smsBeaconHeader;

  /// No description provided for @batteryDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Battery Restriction'**
  String get batteryDialogTitle;

  /// No description provided for @btnDisableBatterySaver.
  ///
  /// In en, this message translates to:
  /// **'DISABLE SAVER'**
  String get btnDisableBatterySaver;

  /// No description provided for @batteryDialogBody.
  ///
  /// In en, this message translates to:
  /// **'The system is restricting this app\'s battery. For SOS to work in the background, you must select \'Unrestricted\' or \'Don\'t Optimize\'.'**
  String get batteryDialogBody;

  /// No description provided for @permBgLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'GPS in background'**
  String get permBgLocationTitle;

  /// No description provided for @bgLocationDialogBody.
  ///
  /// In en, this message translates to:
  /// **'When the alarm fires, your phone is usually in your pocket with the screen off. For the SOS to leave with your exact position at that moment, Android needs location set to \'Allow all the time\'.\n\nYour location never leaves the phone: no internet, no cloud, no trackers — it only travels inside the SOS SMS to your own contacts.\n\nOn the next screen, choose \'Allow all the time\'.'**
  String get bgLocationDialogBody;

  /// No description provided for @whyPermsBgLocation.
  ///
  /// In en, this message translates to:
  /// **'Gets your GPS position while the screen is off or the app is in the background — exactly when an SOS fires. The location is only ever sent inside the SOS SMS to your contacts; it never leaves your phone otherwise.'**
  String get whyPermsBgLocation;

  /// No description provided for @btnEnableBgLocation.
  ///
  /// In en, this message translates to:
  /// **'Allow all the time'**
  String get btnEnableBgLocation;

  /// No description provided for @permLocMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing Location Permission'**
  String get permLocMissing;

  /// No description provided for @slideStopSystem.
  ///
  /// In en, this message translates to:
  /// **'SLIDE TO STOP SYSTEM'**
  String get slideStopSystem;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Configure your safety system'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'These permissions are essential for Oksigenia SOS to protect you in the field.'**
  String get onboardingSubtitle;

  /// No description provided for @onboardingGrant.
  ///
  /// In en, this message translates to:
  /// **'GRANT'**
  String get onboardingGrant;

  /// No description provided for @onboardingGranted.
  ///
  /// In en, this message translates to:
  /// **'GRANTED ✓'**
  String get onboardingGranted;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE'**
  String get onboardingNext;

  /// No description provided for @onboardingFinish.
  ///
  /// In en, this message translates to:
  /// **'ALL SET — START MONITORING'**
  String get onboardingFinish;

  /// No description provided for @onboardingMandatory.
  ///
  /// In en, this message translates to:
  /// **'Required to activate monitoring'**
  String get onboardingMandatory;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @fullScreenIntentTitle.
  ///
  /// In en, this message translates to:
  /// **'Lock Screen Alarm'**
  String get fullScreenIntentTitle;

  /// No description provided for @fullScreenIntentBody.
  ///
  /// In en, this message translates to:
  /// **'Allows the alarm to appear on top of the lock screen. Without this, the alarm sounds but the screen does not wake. On Android 14+: Settings → Apps → Oksigenia SOS → Full-screen notifications.'**
  String get fullScreenIntentBody;

  /// No description provided for @btnEnableFullScreenIntent.
  ///
  /// In en, this message translates to:
  /// **'ENABLE'**
  String get btnEnableFullScreenIntent;

  /// No description provided for @pauseMonitoringSheet.
  ///
  /// In en, this message translates to:
  /// **'Pause monitoring for...'**
  String get pauseMonitoringSheet;

  /// No description provided for @pauseTitle.
  ///
  /// In en, this message translates to:
  /// **'Monitoring paused'**
  String get pauseTitle;

  /// No description provided for @pauseResumesIn.
  ///
  /// In en, this message translates to:
  /// **'⏸ Paused · {time} remaining'**
  String pauseResumesIn(Object time);

  /// No description provided for @pauseResumeNow.
  ///
  /// In en, this message translates to:
  /// **'Resume now'**
  String get pauseResumeNow;

  /// No description provided for @pauseResumedMsg.
  ///
  /// In en, this message translates to:
  /// **'Monitoring resumed'**
  String get pauseResumedMsg;

  /// No description provided for @pauseHoldHint.
  ///
  /// In en, this message translates to:
  /// **'Hold to pause'**
  String get pauseHoldHint;

  /// No description provided for @pauseSec5.
  ///
  /// In en, this message translates to:
  /// **'5 seconds'**
  String get pauseSec5;

  /// No description provided for @liveTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Tracking'**
  String get liveTrackingTitle;

  /// No description provided for @liveTrackingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sends your GPS position by SMS at regular intervals.'**
  String get liveTrackingSubtitle;

  /// No description provided for @liveTrackingInterval.
  ///
  /// In en, this message translates to:
  /// **'Send interval'**
  String get liveTrackingInterval;

  /// No description provided for @liveTrackingShutdownReminder.
  ///
  /// In en, this message translates to:
  /// **'Shutdown reminder'**
  String get liveTrackingShutdownReminder;

  /// No description provided for @liveTrackingNoReminder.
  ///
  /// In en, this message translates to:
  /// **'❌ No reminder'**
  String get liveTrackingNoReminder;

  /// No description provided for @liveTrackingReminder2h.
  ///
  /// In en, this message translates to:
  /// **'⏰ After 2 hours'**
  String get liveTrackingReminder2h;

  /// No description provided for @liveTrackingReminder3h.
  ///
  /// In en, this message translates to:
  /// **'⏰ After 3 hours'**
  String get liveTrackingReminder3h;

  /// No description provided for @liveTrackingReminder4h.
  ///
  /// In en, this message translates to:
  /// **'⏰ After 4 hours'**
  String get liveTrackingReminder4h;

  /// No description provided for @liveTrackingReminder5h.
  ///
  /// In en, this message translates to:
  /// **'⏰ After 5 hours'**
  String get liveTrackingReminder5h;

  /// No description provided for @liveTrackingLegalTitle.
  ///
  /// In en, this message translates to:
  /// **'⚠️ SMS Costs'**
  String get liveTrackingLegalTitle;

  /// No description provided for @liveTrackingLegalBody.
  ///
  /// In en, this message translates to:
  /// **'Live Tracking sends one SMS per interval to your primary contact. Your carrier\'s rates apply. You are solely responsible for all messaging costs.'**
  String get liveTrackingLegalBody;

  /// No description provided for @liveTrackingActivate.
  ///
  /// In en, this message translates to:
  /// **'ACTIVATE TRACKING'**
  String get liveTrackingActivate;

  /// No description provided for @liveTrackingDeactivate.
  ///
  /// In en, this message translates to:
  /// **'DEACTIVATE'**
  String get liveTrackingDeactivate;

  /// No description provided for @liveTrackingNextUpdate.
  ///
  /// In en, this message translates to:
  /// **'Next update in {time}'**
  String liveTrackingNextUpdate(Object time);

  /// No description provided for @liveTrackingCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Tracking Active'**
  String get liveTrackingCardTitle;

  /// No description provided for @liveTrackingPausedSOS.
  ///
  /// In en, this message translates to:
  /// **'Paused — SOS active'**
  String get liveTrackingPausedSOS;

  /// No description provided for @liveTrackingTest1m.
  ///
  /// In en, this message translates to:
  /// **'🧪 1 min (TEST)'**
  String get liveTrackingTest1m;

  /// No description provided for @liveTrackingTest2m.
  ///
  /// In en, this message translates to:
  /// **'🧪 2 min (TEST)'**
  String get liveTrackingTest2m;

  /// No description provided for @liveTrackingTestWarning.
  ///
  /// In en, this message translates to:
  /// **'TEST MODE: Live Tracking will send every {time}.'**
  String liveTrackingTestWarning(Object time);

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @whyPermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Why these permissions?'**
  String get whyPermsTitle;

  /// No description provided for @whyPermsSms.
  ///
  /// In en, this message translates to:
  /// **'Sends emergency alerts by SMS to your contacts. Works without internet.'**
  String get whyPermsSms;

  /// No description provided for @whyPermsLocation.
  ///
  /// In en, this message translates to:
  /// **'Includes GPS coordinates in the alert so rescuers know exactly where you are.'**
  String get whyPermsLocation;

  /// No description provided for @whyPermsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Shows monitoring status and lets you cancel a false alarm from the lock screen.'**
  String get whyPermsNotifications;

  /// No description provided for @whyPermsActivity.
  ///
  /// In en, this message translates to:
  /// **'Detects movement patterns to avoid false alarms when walking or running.'**
  String get whyPermsActivity;

  /// No description provided for @whyPermsSensors.
  ///
  /// In en, this message translates to:
  /// **'Reads the accelerometer to detect the G-force of a fall.'**
  String get whyPermsSensors;

  /// No description provided for @whyPermsBattery.
  ///
  /// In en, this message translates to:
  /// **'Prevents Android from killing the app while it monitors in the background.'**
  String get whyPermsBattery;

  /// No description provided for @whyPermsFullScreen.
  ///
  /// In en, this message translates to:
  /// **'Shows the alarm over the lock screen so you can respond without unlocking.'**
  String get whyPermsFullScreen;

  /// No description provided for @sentinelGreen.
  ///
  /// In en, this message translates to:
  /// **'System active'**
  String get sentinelGreen;

  /// No description provided for @sentinelYellow.
  ///
  /// In en, this message translates to:
  /// **'Impact detected · analysing...'**
  String get sentinelYellow;

  /// No description provided for @sentinelOrange.
  ///
  /// In en, this message translates to:
  /// **'Alert imminent!'**
  String get sentinelOrange;

  /// No description provided for @sentinelRed.
  ///
  /// In en, this message translates to:
  /// **'ALARM ACTIVE'**
  String get sentinelRed;

  /// No description provided for @activityProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity profile'**
  String get activityProfileTitle;

  /// No description provided for @activityProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tunes Smart Sentinel detection to your sport. Choose the closest match — wrong profiles cause false alarms or miss real falls.'**
  String get activityProfileSubtitle;

  /// No description provided for @profileTrekking.
  ///
  /// In en, this message translates to:
  /// **'Trekking / Hiking'**
  String get profileTrekking;

  /// No description provided for @profileTrekkingDesc.
  ///
  /// In en, this message translates to:
  /// **'Default. Walking outdoors with the phone in a pocket or backpack. Balanced sensitivity.'**
  String get profileTrekkingDesc;

  /// No description provided for @profileRunning.
  ///
  /// In en, this message translates to:
  /// **'Running (road)'**
  String get profileRunning;

  /// No description provided for @profileRunningDesc.
  ///
  /// In en, this message translates to:
  /// **'Road running on asphalt or hard pavement. Higher impact threshold (10G) and adaptive cadence detector — handles the persistent horizontal-G of running gait that breaks the walk-baseline cadence check.'**
  String get profileRunningDesc;

  /// No description provided for @profileTrailMtb.
  ///
  /// In en, this message translates to:
  /// **'Trail running / MTB'**
  String get profileTrailMtb;

  /// No description provided for @profileTrailMtbDesc.
  ///
  /// In en, this message translates to:
  /// **'Higher impact threshold and more permissive cadence — constant vibration on uneven ground would otherwise trigger false alarms.'**
  String get profileTrailMtbDesc;

  /// No description provided for @profileMountaineering.
  ///
  /// In en, this message translates to:
  /// **'Mountaineering'**
  String get profileMountaineering;

  /// No description provided for @profileMountaineeringDesc.
  ///
  /// In en, this message translates to:
  /// **'Same baseline as trekking with a longer 90-second observation window after impact, accounting for slow recoveries on technical terrain.'**
  String get profileMountaineeringDesc;

  /// No description provided for @profileParagliding.
  ///
  /// In en, this message translates to:
  /// **'Paragliding'**
  String get profileParagliding;

  /// No description provided for @profileParaglidingDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatic fall detection is DISABLED — accelerometer cannot reliably distinguish flight manoeuvres from a fall. Manual SOS and inactivity monitor remain active.'**
  String get profileParaglidingDesc;

  /// No description provided for @profileKayak.
  ///
  /// In en, this message translates to:
  /// **'Kayak / Watersports'**
  String get profileKayak;

  /// No description provided for @profileKayakDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatic fall detection is DISABLED — water absorbs impact and floating motion is not informative. Use the inactivity monitor and manual SOS.'**
  String get profileKayakDesc;

  /// No description provided for @profileEquitation.
  ///
  /// In en, this message translates to:
  /// **'Horse riding'**
  String get profileEquitation;

  /// No description provided for @profileEquitationDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatic fall detection is DISABLED — horse cadence (trot, canter) interferes with the human-walk detector. The inactivity monitor and manual SOS protect during the ride.'**
  String get profileEquitationDesc;

  /// No description provided for @profileProfessional.
  ///
  /// In en, this message translates to:
  /// **'Professional / Rescue'**
  String get profileProfessional;

  /// No description provided for @profileProfessionalDesc.
  ///
  /// In en, this message translates to:
  /// **'Extended 120-second observation window for advanced operational use where recovery time after a fall may exceed standard timeouts.'**
  String get profileProfessionalDesc;

  /// No description provided for @homeSummaryWithImpact.
  ///
  /// In en, this message translates to:
  /// **'Impact {imp}G · Observ {obs}s · GPS {gps}'**
  String homeSummaryWithImpact(int imp, int obs, String gps);

  /// No description provided for @homeSummaryNoImpact.
  ///
  /// In en, this message translates to:
  /// **'Impact OFF · GPS {gps}'**
  String homeSummaryNoImpact(String gps);

  /// No description provided for @homeAlertNotArmed.
  ///
  /// In en, this message translates to:
  /// **'NOT ARMED — tap a toggle below to activate'**
  String get homeAlertNotArmed;

  /// No description provided for @homeAlertSensorPermDenied.
  ///
  /// In en, this message translates to:
  /// **'Sensor permission denied'**
  String get homeAlertSensorPermDenied;

  /// No description provided for @homeConfirmTitleImpact.
  ///
  /// In en, this message translates to:
  /// **'Impact detection'**
  String get homeConfirmTitleImpact;

  /// No description provided for @homeConfirmTitleObservation.
  ///
  /// In en, this message translates to:
  /// **'Observation'**
  String get homeConfirmTitleObservation;

  /// No description provided for @homeConfirmTitleGps.
  ///
  /// In en, this message translates to:
  /// **'GPS interval'**
  String get homeConfirmTitleGps;

  /// No description provided for @homeConfirmValueOn.
  ///
  /// In en, this message translates to:
  /// **'ON · {threshold}G'**
  String homeConfirmValueOn(int threshold);

  /// No description provided for @homeConfirmValueOff.
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get homeConfirmValueOff;

  /// No description provided for @homeProfileNoFallWarning.
  ///
  /// In en, this message translates to:
  /// **'This profile does NOT detect falls. SOS must be triggered manually.'**
  String get homeProfileNoFallWarning;

  /// No description provided for @homeActionApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get homeActionApply;

  /// No description provided for @smsBeaconDistance.
  ///
  /// In en, this message translates to:
  /// **'from the SOS point.'**
  String get smsBeaconDistance;

  /// No description provided for @homeBeaconBanner.
  ///
  /// In en, this message translates to:
  /// **'Sending location updates to your contact after the SOS — tap to stop'**
  String get homeBeaconBanner;

  /// No description provided for @beaconStopped.
  ///
  /// In en, this message translates to:
  /// **'Movement alerts stopped'**
  String get beaconStopped;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'it',
        'nb',
        'nl',
        'pl',
        'pt',
        'ru',
        'sv'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'nb':
      return AppLocalizationsNb();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'sv':
      return AppLocalizationsSv();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
