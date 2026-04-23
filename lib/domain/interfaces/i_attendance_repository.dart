import '../../data/models/attendance.dart';

abstract class IAttendanceRepository {
  Future<List<Attendance>> getAllAttendance();
  Future<int> markAttendance(Attendance attendance);
  Future<List<Attendance>> getAttendanceByMember(int memberId);
}
