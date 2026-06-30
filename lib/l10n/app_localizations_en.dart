// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BinGo';

  @override
  String get appName => 'BinGo';

  @override
  String get smartWasteSegregation => 'Smart Waste Segregation';

  @override
  String get or => 'OR';

  @override
  String get connecting => 'Connecting...';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to continue managing waste smarter.';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign In';

  @override
  String get newToWasteWise => 'New to BinGo?';

  @override
  String get createAccount => 'Create account';

  @override
  String get loginFailed => 'Login failed. Please try again.';

  @override
  String get googleSignInFailed => 'Google Sign-In failed. Please try again.';

  @override
  String get createAccountTitle => 'Create Account';

  @override
  String get joinWasteWise => 'Join BinGo';

  @override
  String get registerSubtitle =>
      'Create your account with a few simple details.';

  @override
  String get name => 'Name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match.';

  @override
  String get registrationFailed => 'Registration failed. Please try again.';

  @override
  String get home => 'Home';

  @override
  String get scan => 'Scan';

  @override
  String get map => 'Map';

  @override
  String get profile => 'Profile';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get scanWaste => 'Scan Waste';

  @override
  String get findRecyclingCenter => 'Find Recycling Center';

  @override
  String get viewHistory => 'View History';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get noRecentReports => 'No recent reports';

  @override
  String get newReportsAppearHere => 'New reports will appear here.';

  @override
  String get smartScanning => 'Smart scanning';

  @override
  String get comingInIteration2 => 'Coming in Iteration 2.';

  @override
  String get statistics => 'Statistics';

  @override
  String get recyclable => 'Recyclable';

  @override
  String get reports => 'Reports';

  @override
  String get points => 'Points';

  @override
  String get impact => 'Impact';

  @override
  String get logout => 'Logout';

  @override
  String get logoutFailed => 'Logout failed. Please try again.';

  @override
  String get featureComingIteration2 => 'Feature coming in Iteration 2';

  @override
  String get wasteWiseUser => 'BinGo user';

  @override
  String get noEmailAvailable => 'No email available';

  @override
  String helloUser(Object name) {
    return 'Hello, $name';
  }

  @override
  String get monthJanuary => 'January';

  @override
  String get monthFebruary => 'February';

  @override
  String get monthMarch => 'March';

  @override
  String get monthApril => 'April';

  @override
  String get monthMay => 'May';

  @override
  String get monthJune => 'June';

  @override
  String get monthJuly => 'July';

  @override
  String get monthAugust => 'August';

  @override
  String get monthSeptember => 'September';

  @override
  String get monthOctober => 'October';

  @override
  String get monthNovember => 'November';

  @override
  String get monthDecember => 'December';

  @override
  String dateFormat(Object month, Object day, Object year) {
    return '$month $day, $year';
  }

  @override
  String get recyclingCenters => 'Recycling Centers';

  @override
  String get mapSubtitle =>
      'Find nearby centers and location-based waste support.';

  @override
  String get checkingLocationPermission => 'Checking location permission...';

  @override
  String get locationServicesOff => 'Location services are turned off.';

  @override
  String get locationPermissionUnavailable =>
      'Location permission is not available.';

  @override
  String get centeredOnCurrentLocation => 'Centered on your current location.';

  @override
  String get unableToAccessLocation =>
      'Unable to access your current location.';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get refreshLocation => 'Refresh location';

  @override
  String get nearbyRecyclingCenters => 'Nearby Recycling Centers';

  @override
  String get communityRecyclingHub => 'Community Recycling Hub';

  @override
  String get plasticPaperMetal => 'Plastic, paper, metal';

  @override
  String get greenDropOffPoint => 'Green Drop-off Point';

  @override
  String get eWasteDryWaste => 'E-waste and dry waste';

  @override
  String get municipalCollectionCenter => 'Municipal Collection Center';

  @override
  String get mixedRecyclableWaste => 'Mixed recyclable waste';

  @override
  String get nearby => 'Nearby';

  @override
  String get account => 'Account';

  @override
  String get userId => 'User ID';

  @override
  String get provider => 'Provider';

  @override
  String get complete => 'Complete';

  @override
  String get notComplete => 'Not complete';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get english => 'English';

  @override
  String get kannada => 'ಕನ್ನಡ';

  @override
  String get notifications => 'Notifications';

  @override
  String get iteration2 => 'Iteration 2';

  @override
  String get privacy => 'Privacy';

  @override
  String get soon => 'Soon';

  @override
  String get cameraPermissionPermanent =>
      'Camera permission is permanently denied. Enable it in app settings to scan waste.';

  @override
  String get cameraPermissionRequired =>
      'Camera permission is required to scan waste.';

  @override
  String get noCameraFound => 'No camera was found on this device.';

  @override
  String get unableToInitializeCamera => 'Unable to initialize the camera.';

  @override
  String get unableToCaptureImage => 'Unable to capture image. Try again.';

  @override
  String get cameraNotReady => 'Camera is not ready.';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get preview => 'Preview';

  @override
  String get retake => 'Retake';

  @override
  String get analyze => 'Analyze';

  @override
  String get result => 'Result';

  @override
  String get analysisPending => 'Analysis Pending';

  @override
  String get analysisNextIteration =>
      'Waste analysis will be implemented in the next iteration.';

  @override
  String get unableToLoadUserProfile =>
      'Unable to load user profile. Please try again.';

  @override
  String get unableToSaveUserProfile =>
      'Unable to save user profile. Please try again.';

  @override
  String get unableToSaveGoogleProfile =>
      'Unable to save Google profile. Please try again.';

  @override
  String get firebaseRegistrationFailed =>
      'Registration failed. Please try again.';

  @override
  String get googleUnsupported =>
      'Google Sign-In is not supported on this platform.';

  @override
  String get googleMissingToken =>
      'Google Sign-In did not return a valid ID token.';

  @override
  String get firebaseAuthFailed =>
      'Firebase authentication failed. Please try again.';

  @override
  String get googleLogoutFailed => 'Google logout failed. Please try again.';

  @override
  String get noAccountExists => 'No account exists with this email.';

  @override
  String get incorrectPassword => 'Incorrect password.';

  @override
  String get emailAlreadyRegistered => 'This email is already registered.';

  @override
  String get invalidEmail => 'Invalid email address.';

  @override
  String get authenticationFailed => 'Authentication failed. Please try again.';
}
