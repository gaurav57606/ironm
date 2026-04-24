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

  Map<String, dynamic> toJson() => {
    'memberId': memberId,
    'checkInTime': checkInTime.toIso8601String(),
  };

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    memberId: json['memberId'] ?? '',
    checkInTime: DateTime.parse(json['checkInTime']),
  );
}
