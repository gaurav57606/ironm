import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'entitlement_guard.dart';
import '../firebase/firebase_providers.dart';
import '../providers/security_providers.dart';

/// The guard instance — one per app lifetime.
final entitlementGuardProvider = Provider<EntitlementGuard>((ref) {
  final storage   = ref.watch(appSecureStorageProvider);
  final auth      = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firestoreProvider);
  return EntitlementGuard(storage, auth, firestore);
});

/// Result of the entitlement check.
/// Re-evaluated whenever firebaseUserProvider changes (login/logout).
/// Defaults to [EntitlementStatus.grace] while loading or on error.
final entitlementProvider = FutureProvider<EntitlementStatus>((ref) async {
  // Re-run when auth state changes
  ref.watch(firebaseUserProvider);
  final guard = ref.watch(entitlementGuardProvider);
  return guard.check();
});
