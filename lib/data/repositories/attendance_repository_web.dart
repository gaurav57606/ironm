import '../models/attendance.dart';

class AttendanceRepository {
  final List<Attendance> _attendance = [];

  Future<List<Attendance>> getAllAttendance() async => _attendance;
  
  Future<int> markAttendance(Attendance attendance) async {
    attendance.id = _attendance.length + 1;
    _attendance.add(attendance);
    return attendance.id;
  }

  Stream<List<Attendance>> watchAllAttendance() => Stream.value(_attendance);
}
