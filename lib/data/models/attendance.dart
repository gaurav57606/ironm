import 'package:isar/isar.dart';

part 'attendance.g.dart';

@collection
class Attendance {
  Id? isarId;

  @Index()
  late String memberId;
  
  @Index()
  late DateTime checkInTime;

  Attendance({
    required this.memberId,
    required this.checkInTime,
  });
}
