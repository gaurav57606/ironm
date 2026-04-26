import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum EntitlementStatus { valid, grace, expired }

/// Checks whether this installation has a valid paid subscription.
///
/// Three-tier check:
///   Tier 1 — Local heartbeat: if >gracePeriod days since last cloud contact → expired
///   Tier 2 — Local cache: if expiry still in future → valid (skip cloud hit)
///   Tier 3 — Firestore live: fetch expiresAt, refresh cache + heartbeat
///
/// On ANY network/auth error → grace (never hard-lock due to connectivity)
/// On heartbeat stale (offline >gracePeriod days) → expired (hard lock enforced)

class EntitlementGuard {
  final FlutterSecureStorage _storage;
  final FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;

  static const _keyExpiry     = 'ent_expiry';
  static const _keyHeartbeat  = 'lease_heartbeat';
  static const _keyGraceDays  = 'ent_grace_days';
  static const int _graceDays = 7;

  EntitlementGuard(this._storage, this._auth, this._firestore);

  Future<EntitlementStatus> check() async {
    try {
      final now = DateTime.now();

      final expiryRaw     = await _storage.read(key: _keyExpiry);
      final heartbeatRaw  = await _storage.read(key: _keyHeartbeat);

      final expiry        = expiryRaw    != null ? DateTime.tryParse(expiryRaw)    : null;
      final lastHeartbeat = heartbeatRaw != null ? DateTime.tryParse(heartbeatRaw) : null;

      // ── Tier 1: Heartbeat staleness check ──────────────────────────
      if (lastHeartbeat != null) {
        final graceDaysRaw = await _storage.read(key: _keyGraceDays);
        final graceDays = int.tryParse(graceDaysRaw ?? '') ?? _graceDays;
        
        final staleDays = now.difference(lastHeartbeat).inDays;
        if (staleDays >= graceDays) {
          debugPrint('EntitlementGuard: Heartbeat stale ($staleDays days) → expired');
          return EntitlementStatus.expired;
        }
      }

      // ── Tier 2: Fresh local cache ───────────────────────────────────
      if (expiry != null && lastHeartbeat != null && expiry.isAfter(now)) {
        return EntitlementStatus.valid;
      }

      // ── Web bypass (admin / dev web builds) ────────────────────────
      if (kIsWeb) return EntitlementStatus.valid;

      // ── Tier 3: Firestore live check ────────────────────────────────
      final user = _auth?.currentUser;
      if (user == null) {
        // Not signed in yet — grant grace so login can proceed
        return EntitlementStatus.grace;
      }

      final doc = await _firestore
          ?.collection('entitlements')
          .doc(user.uid)
          .get();

      if (doc != null && doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final freshExpiry = (data['expiresAt'] as Timestamp).toDate();
        final killSwitchActive = data['killSwitchActive'] as bool? ?? false;
        final gracePeriodDays = data['gracePeriodDays'] as int? ?? 7;
        final status = data['status'] as String? ?? 'active';

        // 1. Kill switch logic
        if (killSwitchActive) {
          await _storage.delete(key: _keyExpiry);
          await _storage.delete(key: _keyHeartbeat);
          debugPrint('EntitlementGuard: Kill switch active → storage wiped, expired');
          return EntitlementStatus.expired;
        }

        // 2. Status check
        if (status == 'suspended') {
          debugPrint('EntitlementGuard: Status is suspended → expired');
          return EntitlementStatus.expired;
        }

        // Refresh cache keys
        await _storage.write(key: _keyExpiry,    value: freshExpiry.toIso8601String());
        await _storage.write(key: _keyHeartbeat, value: now.toIso8601String());
        await _storage.write(key: _keyGraceDays, value: gracePeriodDays.toString());

        debugPrint('EntitlementGuard: Cloud check → expires ${freshExpiry.toIso8601String()}');
        return freshExpiry.isAfter(now)
            ? EntitlementStatus.valid
            : EntitlementStatus.expired;
      }

      // No entitlement doc found — grace (new user, not yet provisioned)
      return EntitlementStatus.grace;

    } catch (e) {
      debugPrint('EntitlementGuard: Exception (granting grace) → $e');
      // Never hard-lock on exceptions — only on confirmed expiry
      return EntitlementStatus.grace;
    }
  }

  /// Call this on signOut to clear cached entitlement.
  Future<void> clear() async {
    await _storage.delete(key: _keyExpiry);
    await _storage.delete(key: _keyHeartbeat);
    await _storage.delete(key: _keyGraceDays);
  }
}
