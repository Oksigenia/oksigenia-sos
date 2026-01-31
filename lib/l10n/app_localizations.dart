import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

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
    Locale('pt')
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
  /// **'X (Twitter)'**
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

  /// No description provided for @btnGoToSettings.
  ///
  /// In en, this message translates to:
  /// **'GO TO SETTINGS'**
  String get btnGoToSettings;

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

  /// No description provided for @contactMain.
  ///
  /// In en, this message translates to:
  /// **'Primary (Tracking / Battery)'**
  String get contactMain;

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
  /// **'⚠️ TEST MODE ON: Alert will trigger in 30s.'**
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

  /// No description provided for @timerLabel.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timerLabel;

  /// No description provided for @timerSeconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get timerSeconds;

  /// No description provided for @permDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission Check'**
  String get permDialogTitle;

  /// No description provided for @permGoSettings.
  ///
  /// In en, this message translates to:
  /// **'GO TO SETTINGS'**
  String get permGoSettings;

  /// No description provided for @permSmsOk.
  ///
  /// In en, this message translates to:
  /// **'SMS permission is active.'**
  String get permSmsOk;

  /// No description provided for @permSmsMissing.
  ///
  /// In en, this message translates to:
  /// **'We need SMS permission to send emergency alerts to your contacts.'**
  String get permSmsMissing;

  /// No description provided for @permSensorsOk.
  ///
  /// In en, this message translates to:
  /// **'Sensors are active.'**
  String get permSensorsOk;

  /// No description provided for @permSensorsMissing.
  ///
  /// In en, this message translates to:
  /// **'We need access to Sensors and Activity Recognition to detect falls and inactivity.'**
  String get permSensorsMissing;

  /// No description provided for @permNotifOk.
  ///
  /// In en, this message translates to:
  /// **'Notifications are active.'**
  String get permNotifOk;

  /// No description provided for @permNotifMissing.
  ///
  /// In en, this message translates to:
  /// **'We need Notification permission to keep the system running in the background.'**
  String get permNotifMissing;

  /// No description provided for @permOverlayMissing.
  ///
  /// In en, this message translates to:
  /// **'Required to show the alarm over other apps (Telegram, WhatsApp).'**
  String get permOverlayMissing;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'pt'].contains(locale.languageCode);

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
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
