import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Nullable — returns null if Firebase failed to initialize.
/// All consumers MUST null-check before use.

final firebaseAuthProvider = Provider<FirebaseAuth?>((ref) {
  try {
    return FirebaseAuth.instance;
  } catch (e) {
    return null;
  }
});

final firestoreProvider = Provider<FirebaseFirestore?>((ref) {
  try {
    return FirebaseFirestore.instance;
  } catch (e) {
    return null;
  }
});

/// The currently signed-in Firebase user. Null if not signed in or Firebase down.
final firebaseUserProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  if (auth == null) return const Stream.empty();
  return auth.authStateChanges();
});
