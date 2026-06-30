import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_kn.dart';

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

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('kn'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'BinGo'**
  String get appTitle;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'BinGo'**
  String get appName;

  /// No description provided for @smartWasteSegregation.
  ///
  /// In en, this message translates to:
  /// **'Smart Waste Segregation'**
  String get smartWasteSegregation;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connecting;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue managing waste smarter.'**
  String get loginSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @newToWasteWise.
  ///
  /// In en, this message translates to:
  /// **'New to BinGo?'**
  String get newToWasteWise;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get loginFailed;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In failed. Please try again.'**
  String get googleSignInFailed;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountTitle;

  /// No description provided for @joinWasteWise.
  ///
  /// In en, this message translates to:
  /// **'Join BinGo'**
  String get joinWasteWise;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account with a few simple details.'**
  String get registerSubtitle;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registrationFailed;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @scanWaste.
  ///
  /// In en, this message translates to:
  /// **'Scan Waste'**
  String get scanWaste;

  /// No description provided for @findRecyclingCenter.
  ///
  /// In en, this message translates to:
  /// **'Find Recycling Center'**
  String get findRecyclingCenter;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistory;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @noRecentReports.
  ///
  /// In en, this message translates to:
  /// **'No recent reports'**
  String get noRecentReports;

  /// No description provided for @newReportsAppearHere.
  ///
  /// In en, this message translates to:
  /// **'New reports will appear here.'**
  String get newReportsAppearHere;

  /// No description provided for @smartScanning.
  ///
  /// In en, this message translates to:
  /// **'Smart scanning'**
  String get smartScanning;

  /// No description provided for @comingInIteration2.
  ///
  /// In en, this message translates to:
  /// **'Coming in Iteration 2.'**
  String get comingInIteration2;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @recyclable.
  ///
  /// In en, this message translates to:
  /// **'Recyclable'**
  String get recyclable;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @impact.
  ///
  /// In en, this message translates to:
  /// **'Impact'**
  String get impact;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Logout failed. Please try again.'**
  String get logoutFailed;

  /// No description provided for @featureComingIteration2.
  ///
  /// In en, this message translates to:
  /// **'Feature coming in Iteration 2'**
  String get featureComingIteration2;

  /// No description provided for @wasteWiseUser.
  ///
  /// In en, this message translates to:
  /// **'BinGo user'**
  String get wasteWiseUser;

  /// No description provided for @noEmailAvailable.
  ///
  /// In en, this message translates to:
  /// **'No email available'**
  String get noEmailAvailable;

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String helloUser(Object name);

  /// No description provided for @monthJanuary.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get monthJanuary;

  /// No description provided for @monthFebruary.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get monthFebruary;

  /// No description provided for @monthMarch.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get monthMarch;

  /// No description provided for @monthApril.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get monthApril;

  /// No description provided for @monthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJune.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get monthJune;

  /// No description provided for @monthJuly.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get monthJuly;

  /// No description provided for @monthAugust.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get monthAugust;

  /// No description provided for @monthSeptember.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get monthSeptember;

  /// No description provided for @monthOctober.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get monthOctober;

  /// No description provided for @monthNovember.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get monthNovember;

  /// No description provided for @monthDecember.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get monthDecember;

  /// No description provided for @dateFormat.
  ///
  /// In en, this message translates to:
  /// **'{month} {day}, {year}'**
  String dateFormat(Object month, Object day, Object year);

  /// No description provided for @recyclingCenters.
  ///
  /// In en, this message translates to:
  /// **'Recycling Centers'**
  String get recyclingCenters;

  /// No description provided for @mapSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find nearby centers and location-based waste support.'**
  String get mapSubtitle;

  /// No description provided for @checkingLocationPermission.
  ///
  /// In en, this message translates to:
  /// **'Checking location permission...'**
  String get checkingLocationPermission;

  /// No description provided for @locationServicesOff.
  ///
  /// In en, this message translates to:
  /// **'Location services are turned off.'**
  String get locationServicesOff;

  /// No description provided for @locationPermissionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Location permission is not available.'**
  String get locationPermissionUnavailable;

  /// No description provided for @centeredOnCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Centered on your current location.'**
  String get centeredOnCurrentLocation;

  /// No description provided for @unableToAccessLocation.
  ///
  /// In en, this message translates to:
  /// **'Unable to access your current location.'**
  String get unableToAccessLocation;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @refreshLocation.
  ///
  /// In en, this message translates to:
  /// **'Refresh location'**
  String get refreshLocation;

  /// No description provided for @nearbyRecyclingCenters.
  ///
  /// In en, this message translates to:
  /// **'Nearby Recycling Centers'**
  String get nearbyRecyclingCenters;

  /// No description provided for @communityRecyclingHub.
  ///
  /// In en, this message translates to:
  /// **'Community Recycling Hub'**
  String get communityRecyclingHub;

  /// No description provided for @plasticPaperMetal.
  ///
  /// In en, this message translates to:
  /// **'Plastic, paper, metal'**
  String get plasticPaperMetal;

  /// No description provided for @greenDropOffPoint.
  ///
  /// In en, this message translates to:
  /// **'Green Drop-off Point'**
  String get greenDropOffPoint;

  /// No description provided for @eWasteDryWaste.
  ///
  /// In en, this message translates to:
  /// **'E-waste and dry waste'**
  String get eWasteDryWaste;

  /// No description provided for @municipalCollectionCenter.
  ///
  /// In en, this message translates to:
  /// **'Municipal Collection Center'**
  String get municipalCollectionCenter;

  /// No description provided for @mixedRecyclableWaste.
  ///
  /// In en, this message translates to:
  /// **'Mixed recyclable waste'**
  String get mixedRecyclableWaste;

  /// No description provided for @nearby.
  ///
  /// In en, this message translates to:
  /// **'Nearby'**
  String get nearby;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @userId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userId;

  /// No description provided for @provider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get provider;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @notComplete.
  ///
  /// In en, this message translates to:
  /// **'Not complete'**
  String get notComplete;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @kannada.
  ///
  /// In en, this message translates to:
  /// **'ಕನ್ನಡ'**
  String get kannada;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @iteration2.
  ///
  /// In en, this message translates to:
  /// **'Iteration 2'**
  String get iteration2;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @soon.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get soon;

  /// No description provided for @cameraPermissionPermanent.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is permanently denied. Enable it in app settings to scan waste.'**
  String get cameraPermissionPermanent;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to scan waste.'**
  String get cameraPermissionRequired;

  /// No description provided for @noCameraFound.
  ///
  /// In en, this message translates to:
  /// **'No camera was found on this device.'**
  String get noCameraFound;

  /// No description provided for @unableToInitializeCamera.
  ///
  /// In en, this message translates to:
  /// **'Unable to initialize the camera.'**
  String get unableToInitializeCamera;

  /// No description provided for @unableToCaptureImage.
  ///
  /// In en, this message translates to:
  /// **'Unable to capture image. Try again.'**
  String get unableToCaptureImage;

  /// No description provided for @cameraNotReady.
  ///
  /// In en, this message translates to:
  /// **'Camera is not ready.'**
  String get cameraNotReady;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @retake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retake;

  /// No description provided for @analyze.
  ///
  /// In en, this message translates to:
  /// **'Analyze'**
  String get analyze;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// No description provided for @analysisPending.
  ///
  /// In en, this message translates to:
  /// **'Analysis Pending'**
  String get analysisPending;

  /// No description provided for @analysisNextIteration.
  ///
  /// In en, this message translates to:
  /// **'Waste analysis will be implemented in the next iteration.'**
  String get analysisNextIteration;

  /// No description provided for @unableToLoadUserProfile.
  ///
  /// In en, this message translates to:
  /// **'Unable to load user profile. Please try again.'**
  String get unableToLoadUserProfile;

  /// No description provided for @unableToSaveUserProfile.
  ///
  /// In en, this message translates to:
  /// **'Unable to save user profile. Please try again.'**
  String get unableToSaveUserProfile;

  /// No description provided for @unableToSaveGoogleProfile.
  ///
  /// In en, this message translates to:
  /// **'Unable to save Google profile. Please try again.'**
  String get unableToSaveGoogleProfile;

  /// No description provided for @firebaseRegistrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get firebaseRegistrationFailed;

  /// No description provided for @googleUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In is not supported on this platform.'**
  String get googleUnsupported;

  /// No description provided for @googleMissingToken.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In did not return a valid ID token.'**
  String get googleMissingToken;

  /// No description provided for @firebaseAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Firebase authentication failed. Please try again.'**
  String get firebaseAuthFailed;

  /// No description provided for @googleLogoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Google logout failed. Please try again.'**
  String get googleLogoutFailed;

  /// No description provided for @noAccountExists.
  ///
  /// In en, this message translates to:
  /// **'No account exists with this email.'**
  String get noAccountExists;

  /// No description provided for @incorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password.'**
  String get incorrectPassword;

  /// No description provided for @emailAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get emailAlreadyRegistered;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address.'**
  String get invalidEmail;

  /// No description provided for @authenticationFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please try again.'**
  String get authenticationFailed;
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
      <String>['en', 'kn'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'kn':
      return AppLocalizationsKn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
