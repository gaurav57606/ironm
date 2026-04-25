import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/database_provider.dart';
import '../firebase/firebase_providers.dart';
import 'sync_queue.dart';
import 'sync_worker.dart';
import 'sync_coordinator.dart';

final syncQueueProvider = Provider<SyncQueue?>((ref) {
  final isar = ref.watch(isarProvider);
  if (isar == null) return null;
  return SyncQueue(isar);
});

final syncCoordinatorProvider = Provider<SyncCoordinator?>((ref) {
  final isar = ref.watch(isarProvider);
  if (isar == null) return null;
  return SyncCoordinator(isar);
});

final syncWorkerProvider = Provider<SyncWorker?>((ref) {
  final queue     = ref.watch(syncQueueProvider);
  final firestore = ref.watch(firestoreProvider);
  final auth      = ref.watch(firebaseAuthProvider);
  if (queue == null) return null;
  return SyncWorker(queue, firestore, auth);
});
