import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firestore_user_service.dart';

class AuthServiceException implements Exception {
  const AuthServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}

// Centralizes Firebase Authentication flows used by the auth screens.
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  Future<void>? _googleInitialization;

  Future<void> _initializeGoogleSignIn() {
    return _googleInitialization ??= _googleSignIn.initialize();
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      throw AuthServiceException(_messageForFirebaseAuthError(error));
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;

      if (user == null) {
        throw const AuthServiceException(
          'Registration failed. Please try again.',
        );
      }

      await FirestoreUserService.instance.createEmailUserDocument(
        user: user,
        name: name,
      );

      return credential;
    } on FirebaseAuthException catch (error) {
      throw AuthServiceException(_messageForFirebaseAuthError(error));
    } on FirestoreUserServiceException catch (error) {
      throw AuthServiceException(error.message);
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    await _initializeGoogleSignIn();

    if (!_googleSignIn.supportsAuthenticate()) {
      throw const AuthServiceException(
        'Google Sign-In is not supported on this platform.',
      );
    }

    try {
      final googleUser = await _googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw const AuthServiceException(
          'Google Sign-In did not return a valid ID token.',
        );
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user == null) {
        throw const AuthServiceException(
          'Google Sign-In failed. Please try again.',
        );
      }

      await FirestoreUserService.instance.createGoogleUserDocumentIfNeeded(
        user: user,
      );

      return userCredential;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }

      throw AuthServiceException(
        error.description ?? 'Google Sign-In failed. Please try again.',
      );
    } on FirebaseAuthException catch (error) {
      throw AuthServiceException(
        error.message ?? 'Firebase authentication failed. Please try again.',
      );
    } on FirestoreUserServiceException catch (error) {
      throw AuthServiceException(error.message);
    }
  }

  Future<void> signOut() async {
    final signedInWithGoogle =
        _firebaseAuth.currentUser?.providerData.any(
          (provider) => provider.providerId == GoogleAuthProvider.PROVIDER_ID,
        ) ??
        false;

    try {
      if (signedInWithGoogle) {
        await _initializeGoogleSignIn();
        await _googleSignIn.signOut();
      }

      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (error) {
      throw AuthServiceException(
        error.message ?? 'Logout failed. Please try again.',
      );
    } on GoogleSignInException catch (error) {
      throw AuthServiceException(
        error.description ?? 'Google logout failed. Please try again.',
      );
    }
  }

  String _messageForFirebaseAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
        return 'No account exists with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Invalid email address.';
      default:
        return error.message ?? 'Authentication failed. Please try again.';
    }
  }
}
