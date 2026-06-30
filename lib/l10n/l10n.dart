import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  String localizedErrorMessage(String message) {
    return switch (message) {
      'Unable to load user profile. Please try again.' =>
        l10n.unableToLoadUserProfile,
      'Unable to save user profile. Please try again.' =>
        l10n.unableToSaveUserProfile,
      'Unable to save Google profile. Please try again.' =>
        l10n.unableToSaveGoogleProfile,
      'Registration failed. Please try again.' =>
        l10n.firebaseRegistrationFailed,
      'Google Sign-In failed. Please try again.' => l10n.googleSignInFailed,
      'Google Sign-In is not supported on this platform.' =>
        l10n.googleUnsupported,
      'Google Sign-In did not return a valid ID token.' =>
        l10n.googleMissingToken,
      'Firebase authentication failed. Please try again.' =>
        l10n.firebaseAuthFailed,
      'Logout failed. Please try again.' => l10n.logoutFailed,
      'Google logout failed. Please try again.' => l10n.googleLogoutFailed,
      'No account exists with this email.' => l10n.noAccountExists,
      'Incorrect password.' => l10n.incorrectPassword,
      'This email is already registered.' => l10n.emailAlreadyRegistered,
      'Invalid email address.' => l10n.invalidEmail,
      'Authentication failed. Please try again.' => l10n.authenticationFailed,
      _ => message,
    };
  }
}
