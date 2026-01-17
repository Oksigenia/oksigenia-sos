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
    Locale('pt'),
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
  /// **'Emergency Phone Number'**
  String get settingsLabel;

  /// No description provided for @settingsHint.
  ///
  /// In en, this message translates to:
  /// **'Ex: +1 555-0199'**
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

  /// No description provided for @disclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'⚠️ LEGAL DISCLAIMER & PRIVACY'**
  String get disclaimerTitle;

  /// No description provided for @disclaimerText.
  ///
  /// In en, this message translates to:
  /// **'This app is a support tool and DOES NOT replace professional emergency services (112, 911).\n\nPRIVACY: Oksigenia DOES NOT collect personal data. Your location and contacts remain exclusively on your device.\n\nFunctionality depends on device health, battery, and coverage. Use at your own risk.'**
  String get disclaimerText;

  /// No description provided for @btnAccept.
  ///
  /// In en, this message translates to:
  /// **'ACCEPT'**
  String get btnAccept;

  /// No description provided for @btnDecline.
  ///
  /// In en, this message translates to:
  /// **'EXIT'**
  String get btnDecline;

  /// No description provided for @menuPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Legal'**
  String get menuPrivacy;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms & Privacy'**
  String get privacyTitle;

  /// No description provided for @privacyPolicyContent.
  ///
  /// In en, this message translates to:
  /// **'PRIVACY POLICY & TERMS OF USE\n\n1. NO DATA COLLECTION\nOksigenia SOS is built on a privacy-by-design principle. The application operates entirely locally. We do not upload your data to any cloud, do not use tracking servers, and do not sell your information to third parties. Your emergency contacts and location history remain strictly on your device.\n\n2. PERMISSION USAGE\n- Location: Used strictly to retrieve GPS coordinates in the event of an impact or manual activation. No background tracking occurs when monitoring is disabled.\n- SMS: Used exclusively to send the alert message to your defined contact. The app does not read your personal messages.\n\n3. LIMITATION OF LIABILITY\nThis application is provided \'as is\', without warranty of any kind. Oksigenia and its developers are not liable for damages, injuries, or death resulting from software failure, including but not limited to: lack of cellular coverage, battery drain, operating system failures, or GPS hardware errors.\n\nThis tool is a safety supplement and should never be considered an infallible substitute for professional emergency services.'**
  String get privacyPolicyContent;
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
    'that was used.',
  );
}
