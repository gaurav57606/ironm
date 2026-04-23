import 'package:isar/isar.dart';
import '../../main.dart';
import '../models/attendance.dart';

class AttendanceRepository {
  Future<List<Attendance>> getAllAttendance() async {
    return isar.attendances.where().findAll();
  }

  Future<int> markAttendance(Attendance attendance) async {
    return isar.writeTxn(() => isar.attendances.put(attendance));
  }

  Stream<List<Attendance>> watchAllAttendance() {
    return isar.attendances.where().watch(fireImmediately: true);
  }
}
