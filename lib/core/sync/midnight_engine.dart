import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';

import '../../data/models/member.dart';
import '../../data/models/payment.dart';
import '../../data/models/attendance.dart';
import '../../data/models/plan.dart';
import '../../data/models/domain_event.dart';
import '../../data/models/product.dart';
import '../../data/models/sale.dart';
import '../../data/models/owner_profile.dart';
import '../../data/models/invoice_sequence.dart';
import '../../data/models/app_settings.dart';
import '../../data/models/sync_job.dart';
import '../../firebase_options.dart';
import 'sync_queue.dart';
import 'sync_worker.dart';
import 'sync_coordinator.dart';

const _taskName = 'ironm.midnight_sync';

class MidnightEngine {
  /// Register the WorkManager periodic task.
  /// Call once on app boot AFTER Firebase init.
  static Future<void> register() async {
    try {
      await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
      await Workmanager().registerPeriodicTask(
        _taskName,
        _taskName,
        frequency: const Duration(hours: 12),
        constraints: Constraints(networkType: NetworkType.connected),
        existingWorkPolicy: ExistingWorkPolicy.keep,
      );
      debugPrint('MidnightEngine: Periodic task registered.');
    } catch (e) {
      debugPrint('MidnightEngine.register error (non-fatal): $e');
    }
  }

  /// WorkManager callback — runs in a NEW isolate with NO shared state.
  @pragma('vm:entry-point')
  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      debugPrint('MidnightEngine: Background task started → $task');

      Isar? isar;
      try {
        // 1. Re-init Firebase in background isolate
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );

        // 2. Re-open Isar in background isolate
        final dir = await getApplicationDocumentsDirectory();
        isar = await Isar.open(
          [
            MemberSchema, PaymentSchema, AttendanceSchema,
            PlanSchema, DomainEventSchema, ProductSchema,
            SaleSchema, OwnerProfileSchema, InvoiceSequenceSchema,
            AppSettingsSchema, SyncJobSchema,
          ],
          directory: dir.path,
        );

        final queue       = SyncQueue(isar);
        final coordinator = SyncCoordinator(isar);
        final auth        = FirebaseAuth.instance;
        final firestore   = FirebaseFirestore.instance;
        final worker      = SyncWorker(queue, firestore, auth);

        // 3. Acquire lock
        const holderId = 'background_midnight_engine';
        if (!await coordinator.acquireLock(holderId)) {
          debugPrint('MidnightEngine: Lock busy — aborting.');
          return true;
        }

        try {
          // 4. Flush pending queue
          await worker.flush();

          // 5. Weekly backup on Sundays
          final now = DateTime.now();
          if (now.weekday == DateTime.sunday) {
            final uid = auth.currentUser?.uid;
            if (uid != null) {
              await worker.weeklyBackup(isar: isar, uid: uid);
            }
          }
        } finally {
          await coordinator.releaseLock(holderId);
        }
      } catch (e) {
        debugPrint('MidnightEngine: Top-level error → $e');
      } finally {
        await isar?.close();
      }
      return true;
    });
  }
}
