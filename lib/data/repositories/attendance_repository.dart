import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../core/providers/database_provider.dart';
import '../models/attendance.dart';

abstract class IAttendanceRepository {
  Future<List<Attendance>> getByMember(String memberId);
  Future<void> save(Attendance attendance);
  Future<List<Attendance>> getAll();
}

class IsarAttendanceRepository implements IAttendanceRepository {
  final Isar? _isar;

  IsarAttendanceRepository(this._isar);

  @override
  Future<List<Attendance>> getByMember(String memberId) async {
    if (_isar == null) return [];
    return await _isar!.attendances.where().memberIdEqualTo(memberId).sortByCheckInTimeDesc().findAll();
  }

  @override
  Future<void> save(Attendance attendance) async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async {
      await _isar!.attendances.put(attendance);
    });
  }

  @override
  Future<List<Attendance>> getAll() async {
    if (_isar == null) return [];
    return await _isar!.attendances.where().sortByCheckInTimeDesc().findAll();
  }
}

final attendanceRepositoryProvider = Provider<IAttendanceRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return IsarAttendanceRepository(isar);
});
