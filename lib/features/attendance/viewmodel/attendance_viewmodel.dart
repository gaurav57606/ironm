import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/attendance.dart';
import '../../../data/repositories/attendance_repository.dart';

part 'attendance_viewmodel.g.dart';

@riverpod
class AttendanceViewModel extends _$AttendanceViewModel {
  @override
  Stream<List<Attendance>> build() {
    final repo = ref.watch(attendanceRepositoryProvider);
    return repo.watchAll();
  }

  Future<void> markAttendance(Attendance attendance) async {
    final repo = ref.read(attendanceRepositoryProvider);
    await repo.save(attendance);
  }
}

// Alias for compatibility with older UI
final attendanceProvider = Provider.autoDispose<List<Attendance>>((ref) {
  return ref.watch(attendanceViewModelProvider).value ?? [];
});


final memberAttendanceProvider = StreamProvider.autoDispose.family<List<Attendance>, String>((ref, memberId) {
  final repo = ref.watch(attendanceRepositoryProvider);
  return repo.watchMember(memberId);
});

