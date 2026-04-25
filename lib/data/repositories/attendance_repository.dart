import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../core/providers/database_provider.dart';
import '../models/attendance.dart';
import 'dart:async' show unawaited;
import '../../core/sync/sync_queue.dart';
import '../../core/sync/sync_providers.dart';
import '../../data/models/sync_job.dart';
// import 'web/web_attendance_repository.dart';
// import '../../core/providers/web_data_store.dart';

abstract class IAttendanceRepository {
  Future<List<Attendance>> getByMember(String memberId);
  Future<void> save(Attendance attendance);
  Future<List<Attendance>> getAll();
  Stream<List<Attendance>> watchAll();
  Stream<List<Attendance>> watchMember(String memberId);
}


class IsarAttendanceRepository implements IAttendanceRepository {
  final Isar? _isar;
  final SyncQueue? _syncQueue;

  IsarAttendanceRepository(this._isar, [this._syncQueue]);

  @override
  Future<List<Attendance>> getByMember(String memberId) async {
    if (_isar == null) return [];
    return await _isar.attendances.where().memberIdEqualTo(memberId).sortByCheckInTimeDesc().findAll();
  }

  @override
  Future<void> save(Attendance attendance) async {
    if (_isar == null) return;
    await _isar.writeTxn(() async {
      await _isar.attendances.put(attendance);
    });
    unawaited(_syncQueue?.enqueueUpsert(
      collection: SyncCollection.attendance,
      docId: attendance.attendanceId,
      payload: attendance.toJson(),
    ));
  }

  @override
  Future<List<Attendance>> getAll() async {
    if (_isar == null) return [];
    return await _isar.attendances.where().sortByCheckInTimeDesc().findAll();
  }

  @override
  Stream<List<Attendance>> watchAll() {
    if (_isar == null) return const Stream.empty();
    return _isar.attendances.where().sortByCheckInTimeDesc().watch(fireImmediately: true);
  }

  @override
  Stream<List<Attendance>> watchMember(String memberId) {
    if (_isar == null) return const Stream.empty();
    return _isar.attendances.where().memberIdEqualTo(memberId).sortByCheckInTimeDesc().watch(fireImmediately: true);
  }
}


final attendanceRepositoryProvider = Provider<IAttendanceRepository>((ref) {
  final isar = ref.watch(isarProvider);
  if (isar == null) {
    final webStore = ref.watch(webDataStoreProvider);
    if (webStore != null) {
      // return WebAttendanceRepository(webStore);
    }
  }
  final syncQueue = ref.watch(syncQueueProvider);
  return IsarAttendanceRepository(isar, syncQueue);
});
