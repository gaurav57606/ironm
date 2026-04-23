import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/attendance.dart';
import '../repositories/attendance_repository.dart';

class AttendanceNotifier extends StateNotifier<List<Attendance>> {
  final IAttendanceRepository _repo;

  AttendanceNotifier(this._repo) : super([]) {
    refresh();
  }

  Future<void> refresh() async {
    final attendance = await _repo.getAll();
    state = attendance;
  }
}

final attendanceProvider = StateNotifierProvider<AttendanceNotifier, List<Attendance>>((ref) {
  final repo = ref.watch(attendanceRepositoryProvider);
  return AttendanceNotifier(repo);
});

final todayAttendanceProvider = Provider<List<Attendance>>((ref) {
  final attendance = ref.watch(attendanceProvider);
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  return attendance.where((a) => a.checkInTime.isAfter(startOfDay)).toList();
});
