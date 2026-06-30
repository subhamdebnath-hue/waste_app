import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreUserServiceException implements Exception {
  const FirestoreUserServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}

// Handles all Firestore writes for user profile documents.
class FirestoreUserService {
  FirestoreUserService._();

  static final FirestoreUserService instance = FirestoreUserService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCollection {
    return _firestore.collection('users');
  }

  Future<Map<String, dynamic>?> getUserDocument(String uid) async {
    try {
      final snapshot = await _usersCollection.doc(uid).get();
      return snapshot.data();
    } on FirebaseException catch (error) {
      throw FirestoreUserServiceException(
        error.message ?? 'Unable to load user profile. Please try again.',
      );
    }
  }

  Future<void> createEmailUserDocument({
    required User user,
    required String name,
  }) async {
    try {
      await _usersCollection.doc(user.uid).set({
        'uid': user.uid,
        'name': name.trim(),
        'email': user.email ?? '',
        'authProvider': 'email',
        'createdAt': FieldValue.serverTimestamp(),
        'profileCompleted': false,
      });
    } on FirebaseException catch (error) {
      throw FirestoreUserServiceException(
        error.message ?? 'Unable to save user profile. Please try again.',
      );
    }
  }

  Future<void> createGoogleUserDocumentIfNeeded({required User user}) async {
    try {
      final userDocument = _usersCollection.doc(user.uid);

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(userDocument);

        if (snapshot.exists) {
          return;
        }

        transaction.set(userDocument, {
          'uid': user.uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'authProvider': 'google',
          'createdAt': FieldValue.serverTimestamp(),
          'profileCompleted': false,
        });
      });
    } on FirebaseException catch (error) {
      throw FirestoreUserServiceException(
        error.message ?? 'Unable to save Google profile. Please try again.',
      );
    }
  }
}
