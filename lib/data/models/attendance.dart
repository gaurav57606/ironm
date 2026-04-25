import 'package:isar/isar.dart';

part 'attendance.g.dart';

@collection
class Attendance {
  Id? isarId;

  @Index(unique: true)
  String attendanceId;

  @Index()
  String memberId;
  
  @Index()
  DateTime checkInTime;

  Attendance({
    this.isarId,
    required this.attendanceId,
    required this.memberId,
    required this.checkInTime,
  });

  Map<String, dynamic> toJson() => {
    'attendanceId': attendanceId,
    'memberId': memberId,
    'checkInTime': checkInTime.toIso8601String(),
  };

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    attendanceId: json['attendanceId'] ?? '',
    memberId: json['memberId'] ?? '',
    checkInTime: DateTime.parse(json['checkInTime'] ?? DateTime.now().toIso8601String()),
  );
}
