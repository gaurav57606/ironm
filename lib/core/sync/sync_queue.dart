import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../../data/models/sync_job.dart';

/// Durable write-behind queue stored in Isar.
/// Survives app kills. Capped at 500 entries.
class SyncQueue {
  static const int _cap = 500;
  final Isar _isar;

  SyncQueue(this._isar);

  /// Enqueue an upsert job for [collection] with [docId] and [payload].
  /// Fire-and-forget — caller must NOT await this in the UI path.
  Future<void> enqueueUpsert({
    required SyncCollection collection,
    required String docId,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final job = SyncJob(
        docId: docId,
        collection: collection,
        operation: SyncOperation.upsert,
        payloadJson: jsonEncode(payload),
        createdAt: DateTime.now(),
      );
      await _isar.writeTxn(() async {
        await _isar.syncJobs.put(job);
      });
      await _pruneIfNeeded();
    } catch (e) {
      debugPrint('SyncQueue.enqueueUpsert error (non-fatal): $e');
    }
  }

  /// Enqueue a delete job.
  Future<void> enqueueDelete({
    required SyncCollection collection,
    required String docId,
  }) async {
    try {
      final job = SyncJob(
        docId: docId,
        collection: collection,
        operation: SyncOperation.delete,
        payloadJson: '{}',
        createdAt: DateTime.now(),
      );
      await _isar.writeTxn(() async {
        await _isar.syncJobs.put(job);
      });
    } catch (e) {
      debugPrint('SyncQueue.enqueueDelete error (non-fatal): $e');
    }
  }

  /// Return all pending jobs ordered oldest-first.
  Future<List<SyncJob>> getPending() async {
    try {
      return await _isar.syncJobs
          .where()
          .sortByCreatedAt()
          .findAll();
    } catch (e) {
      debugPrint('SyncQueue.getPending error: $e');
      return [];
    }
  }

  /// Remove a job after successful upload.
  Future<void> remove(Id isarId) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.syncJobs.delete(isarId);
      });
    } catch (e) {
      debugPrint('SyncQueue.remove error: $e');
    }
  }

  /// Prune oldest jobs when over cap.
  Future<void> _pruneIfNeeded() async {
    final count = await _isar.syncJobs.count();
    if (count <= _cap) return;
    final overflow = count - _cap;
    final oldest = await _isar.syncJobs
        .where()
        .sortByCreatedAt()
        .limit(overflow)
        .findAll();
    final ids = oldest.map((j) => j.isarId).toList();
    await _isar.writeTxn(() async {
      await _isar.syncJobs.deleteAll(ids);
    });
    debugPrint('SyncQueue: Pruned $overflow old jobs (cap=$_cap)');
  }
}
