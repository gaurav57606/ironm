import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/ac_strings.dart';
import '../core/firebase/firebase_providers.dart';
import '../models/entitlement_record.dart';

// ── READ — real-time stream of all entitlements for targetAppId ─────────────

final allEntitlementsProvider = StreamProvider<List<EntitlementRecord>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  if (firestore == null) {
    return Stream.error(
      StateError('Firestore is not available. Check Firebase initialization in main.dart.'),
    );
  }
  return firestore
      .collection('entitlements')
      .where('appId', isEqualTo: AcStrings.targetAppId)
      .snapshots()
      .map((snap) =>
          snap.docs.map(EntitlementRecord.fromFirestore).toList());
});

// ── WRITE — all Firestore writes go through this service only ───────────────

class EntitlementWriteService {
  EntitlementWriteService(this._firestore);
  final FirebaseFirestore? _firestore;

  CollectionReference get _col {
    if (_firestore == null) {
      throw StateError('Firestore is not initialized. Check Firebase setup.');
    }
    return _firestore.collection('entitlements');
  }

  Future<void> setKillSwitch(String userId, bool active) async {
    if (_firestore == null) throw StateError('Firestore is not initialized.');
    await _col.doc(userId).update({'killSwitchActive': active});
  }

  Future<void> setStatus(String userId, String status) async {
    if (_firestore == null) throw StateError('Firestore is not initialized.');
    await _col.doc(userId).update({'status': status});
  }

  // Extends from current expiresAt or today — whichever is later
  Future<void> extendExpiry(
      String userId, DateTime currentExpiry, int days) async {
    if (_firestore == null) throw StateError('Firestore is not initialized.');
    final base =
        currentExpiry.isAfter(DateTime.now()) ? currentExpiry : DateTime.now();
    final newExpiry = base.add(Duration(days: days));
    await _col.doc(userId).update({
      'expiresAt': Timestamp.fromDate(newExpiry),
      'status': 'active',
      'killSwitchActive': false,
    });
  }

  Future<void> updateNotes(String userId, String notes) async {
    if (_firestore == null) throw StateError('Firestore is not initialized.');
    await _col.doc(userId).update({'notes': notes});
  }

  Future<void> createEntitlement(EntitlementRecord record) async {
    if (_firestore == null) throw StateError('Firestore is not initialized.');
    final existing = await _col.doc(record.userId).get();
    if (existing.exists) {
      throw Exception(
        'A subscriber with UID "${record.userId}" already exists. '
        'Use the subscriber detail screen to edit their record instead.',
      );
    }
    await _col.doc(record.userId).set(record.toFirestore());
  }

  Future<void> updateGracePeriod(String userId, int days) async {
    if (_firestore == null) throw StateError('Firestore is not initialized.');
    await _col.doc(userId).update({'gracePeriodDays': days});
  }

  Future<void> deleteEntitlement(String userId) async {
    if (_firestore == null) throw StateError('Firestore is not initialized.');
    await _col.doc(userId).delete();
  }
}

final entitlementWriteServiceProvider =
    Provider<EntitlementWriteService>((ref) {
  return EntitlementWriteService(ref.watch(firestoreProvider));
});
