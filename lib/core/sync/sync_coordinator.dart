import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../../data/models/sync_job.dart';

/// Cross-isolate lock using Isar to prevent foreground/background
/// sync from running simultaneously and creating write conflicts.
class SyncCoordinator {
  final Isar _isar;

  SyncCoordinator(this._isar);

  static const String _lockDocId = '__sync_lock__';

  /// Try to acquire the sync lock.
  /// Returns true if acquired, false if already held by another.
  Future<bool> acquireLock(String holderId) async {
    try {
      final existing = await _isar.syncJobs
          .filter()
          .docIdEqualTo(_lockDocId)
          .findFirst();
      if (existing != null && existing.payloadJson != holderId) {
        debugPrint('SyncCoordinator: Lock held by ${existing.payloadJson}');
        return false;
      }
      final lock = SyncJob(
        docId: _lockDocId,
        collection: SyncCollection.members,
        operation: SyncOperation.upsert,
        payloadJson: holderId,
        createdAt: DateTime.now(),
      );
      await _isar.writeTxn(() async {
        await _isar.syncJobs.put(lock);
      });
      return true;
    } catch (e) {
      debugPrint('SyncCoordinator.acquireLock error: $e');
      return false;
    }
  }

  /// Release the lock.
  Future<void> releaseLock(String holderId) async {
    try {
      final existing = await _isar.syncJobs
          .filter()
          .docIdEqualTo(_lockDocId)
          .findFirst();
      if (existing != null && existing.payloadJson == holderId) {
        await _isar.writeTxn(() async {
          await _isar.syncJobs.delete(existing.isarId);
        });
        debugPrint('SyncCoordinator: Lock released by $holderId');
      }
    } catch (e) {
      debugPrint('SyncCoordinator.releaseLock error: $e');
    }
  }

  /// Force-clear stale locks on app boot.
  Future<void> clearAllLocks() async {
    try {
      final existing = await _isar.syncJobs
          .filter()
          .docIdEqualTo(_lockDocId)
          .findFirst();
      if (existing != null) {
        await _isar.writeTxn(() async {
          await _isar.syncJobs.delete(existing.isarId);
        });
        debugPrint('SyncCoordinator: Stale lock cleared on boot.');
      }
    } catch (e) {
      debugPrint('SyncCoordinator.clearAllLocks error: $e');
    }
  }
}
