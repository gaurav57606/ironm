import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/ac_strings.dart';
import '../core/firebase/firebase_providers.dart';

enum AdminAuthStatus { loading, loggedIn, loggedOut, unauthorized }

class AdminAuthNotifier extends StateNotifier<AdminAuthStatus> {
  AdminAuthNotifier(this._auth) : super(AdminAuthStatus.loading) {
    _auth?.authStateChanges().listen((user) {
      if (user == null) {
        state = AdminAuthStatus.loggedOut;
      } else if (user.uid == AcStrings.adminUid) {
        state = AdminAuthStatus.loggedIn;
      } else {
        // Signed in but not the admin — boot them out
        _auth.signOut();
        state = AdminAuthStatus.unauthorized;
      }
    });

    // Firebase unavailable
    if (_auth == null) state = AdminAuthStatus.loggedOut;
  }

  final FirebaseAuth? _auth;

  // Returns null on success, error message on failure
  Future<String?> login(String email, String password) async {
    if (_auth == null) return 'Firebase unavailable.';
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      // Auth state listener will update state automatically
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Login failed. Check credentials.';
    } catch (e) {
      return 'Unexpected error: $e';
    }
  }

  Future<void> logout() async {
    try { await _auth?.signOut(); } catch (_) {}
  }
}

final adminAuthProvider =
    StateNotifierProvider<AdminAuthNotifier, AdminAuthStatus>((ref) {
  return AdminAuthNotifier(ref.watch(firebaseAuthProvider));
});
