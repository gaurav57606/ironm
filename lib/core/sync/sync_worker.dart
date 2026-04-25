import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../../data/models/sync_job.dart';
import 'sync_queue.dart';

/// Drains the SyncQueue by uploading jobs to Firestore.
/// Each job is isolated — one failure does NOT stop others.
/// Batch size = 20 to avoid Firestore write limits.
class SyncWorker {
  final SyncQueue _queue;
  final FirebaseFirestore? _firestore;
  final FirebaseAuth? _auth;

  static const int _batchSize = 20;

  SyncWorker(this._queue, this._firestore, this._auth);

  /// Flush pending queue jobs to Firestore.
  /// Returns count of successfully synced jobs.
  Future<int> flush() async {
    if (_firestore == null || _auth == null) {
      debugPrint('SyncWorker: Firestore/Auth null — skipping flush.');
      return 0;
    }

    final uid = _auth!.currentUser?.uid;
    if (uid == null) {
      debugPrint('SyncWorker: No signed-in user — skipping flush.');
      return 0;
    }

    final jobs = await _queue.getPending();
    if (jobs.isEmpty) return 0;

    int synced = 0;
    final batch = jobs.take(_batchSize).toList();

    for (final job in batch) {
      try {
        final collectionPath = _collectionPath(uid, job.collection);

        if (job.operation == SyncOperation.upsert) {
          final payload = jsonDecode(job.payloadJson) as Map<String, dynamic>;
          await _firestore!
              .collection(collectionPath)
              .doc(job.docId)
              .set(payload, SetOptions(merge: true));
        } else if (job.operation == SyncOperation.delete) {
          await _firestore!
              .collection(collectionPath)
              .doc(job.docId)
              .delete();
        }

        await _queue.remove(job.isarId);
        synced++;
      } catch (e) {
        // Increment retry — leave in queue for next flush
        debugPrint('SyncWorker: Failed job ${job.docId} → $e');
        job.retryCount++;
        // If retried >5 times, discard to avoid infinite queue buildup
        if (job.retryCount > 5) {
          await _queue.remove(job.isarId);
          debugPrint('SyncWorker: Discarded job ${job.docId} after 5 retries.');
        }
      }
    }

    debugPrint('SyncWorker: Flushed $synced/${batch.length} jobs.');
    return synced;
  }

  /// Full weekly snapshot — writes ALL Isar collections to
  /// Firestore backups/{uid}/weekly/{date}/
  Future<void> weeklyBackup({
    required Isar isar,
    required String uid,
  }) async {
    if (_firestore == null) return;
    try {
      final dateKey = _todayKey();
      final basePath = 'gyms/$uid/backups/weekly/$dateKey';

      // Members snapshot
      final members = await isar.members.where().findAll();
      final memberBatch = _firestore!.batch();
      for (final m in members) {
        memberBatch.set(
          _firestore!.collection('$basePath/members').doc(m.memberId),
          m.toJson(),
        );
      }
      await memberBatch.commit();

      // Payments snapshot
      final payments = await isar.payments.where().findAll();
      final paymentBatch = _firestore!.batch();
      for (final p in payments) {
        paymentBatch.set(
          _firestore!.collection('$basePath/payments').doc(p.paymentId),
          p.toJson(),
        );
      }
      await paymentBatch.commit();

      // Plans snapshot
      final plans = await isar.plans.where().findAll();
      final planBatch = _firestore!.batch();
      for (final pl in plans) {
        planBatch.set(
          _firestore!.collection('$basePath/plans').doc(pl.planId),
          pl.toJson(),
        );
      }
      await planBatch.commit();

      debugPrint('SyncWorker: Weekly backup completed → $basePath');
    } catch (e) {
      debugPrint('SyncWorker: Weekly backup failed (non-fatal) → $e');
    }
  }

  String _collectionPath(String uid, SyncCollection col) {
    switch (col) {
      case SyncCollection.members:    return 'gyms/$uid/members';
      case SyncCollection.payments:   return 'gyms/$uid/payments';
      case SyncCollection.attendance: return 'gyms/$uid/attendance';
      case SyncCollection.plans:      return 'gyms/$uid/plans';
    }
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2,'0')}'
           '-${now.day.toString().padLeft(2,'0')}';
  }
}
