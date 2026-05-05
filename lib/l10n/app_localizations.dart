import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sw.dart';

/// Callers can lookup localized strings using an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the i18n-related iOS/Android build
/// settings. See the README for details.
///
/// ## Update pubspec.yaml
///
/// Please run:
///
/// ```bash
/// flutter pub get
/// ```
///
/// ## iOS/macOS
///
/// iOS and macOS bundle the translations into the app bundle.
/// To add a new locale, reference the file in the pubspec.yaml
/// file as described in the previous section.
///
/// To add to the list of iOS/macOS languages, you'll need to edit the
/// CFBundleLocalizations array in the Info.plist at
/// `ios/Runner/Info.plist` an add the new locale you're going to enable.
/// Whenever a new locale is added, run the same runner command above and
/// re-open your Xcode project by running `flutter clean && flutter create .`
/// in the ios folder to refresh the native platform specific files.
/// Likewise, update `macos/Runner/Info.plist` if adding a macos language.
///
/// ## Android
///
/// Android locales should be defined in `android/app/src/main/res/values-<locale>/strings.xml`.
/// It's important to note that the new Gradle-based Android project structure
/// places string resources in `android/app/src/main/res/values<locale>/strings.xml`.
/// You must create new directories at `android/app/src/main/res/values-<locale>/` for
/// each locale.
///
/// The packaged `Localizations` Dialog is not used by a simple string lookup.
/// Instead a Map and an extension method have been generated.
/// To add a new locale:
///
/// * Create a new file `android/app/src/main/res/values-<locale>/strings.xml`.
/// * Open this file and type a name for the new locale, e.g. `sv` for Swedish.
/// * Modify `plurals` in `lib/l10n/app_localizations_<new_locale>.dart` to add a new AppLocalizations subclass
/// for the new locale and update the `map` in the generated `AppLocalizations` class.
/// * Create the JSON files with translations for the new locale in `lib/l10n/` and name them
/// using the BCP47 language tag: e.g. `lib/l10n/app_sv.arb`.
///
/// For help getting started, visit the Flutter Localization page:
/// https://flutter.dev/to/internationalization

abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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

  /// A list of this localizations' supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sw', 'TZ'),
  ];

  String get fullName;

  String get email;

  String get phoneNumber;

  var height;

  var targetWeight;

  String get language;

  var swahili;

  var english;

  String get darkMode;

  String get notifications;

  String get privacyPolicy;

  String get termsOfService;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  var version;

  String get alreadyHaveAccount;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Lishe AI'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @meals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get meals;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @logMeal.
  ///
  /// In en, this message translates to:
  /// **'Log Meal'**
  String get logMeal;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @selectCohort.
  ///
  /// In en, this message translates to:
  /// **'Select Your Nutrition Cohort'**
  String get selectCohort;

  /// No description provided for @cohortDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the group that best describes you for personalized nutrition recommendations'**
  String get cohortDescription;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(_lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sw'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations _lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sw':
      return AppLocalizationsSw();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with the relevant source files.');
}
