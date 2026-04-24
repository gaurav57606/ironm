import 'package:isar/isar.dart';

part 'member.g.dart';

@collection
class Member {
  Id? isarId;

  @Index(unique: true)
  late String memberId;

  @Index()
  late String name;

  @Index()
  String? phone;

  late DateTime joinDate;

  String? planId;
  String? planName;
  DateTime? expiryDate;

  late int totalPaid; // in paise or cents (integer)
  
  late List<String> paymentIds;
  
  late List<JoinDateChange> joinDateHistory;

  @Index()
  late bool archived;

  late DateTime lastUpdated;

  String? gender;
  int? age;
  String? profileImageUrl;
  String? checkInPin;
  DateTime? lastCheckIn;
  String? lastCheckInDevice;

  double? planPrice;
  late String hmacSignature;

  Member({
    required this.memberId,
    required this.name,
    this.phone,
    required this.joinDate,
    this.planId,
    this.planName,
    this.planPrice,
    this.expiryDate,
    this.totalPaid = 0,
    this.paymentIds = const [],
    this.joinDateHistory = const [],
    this.archived = false,
    required this.lastUpdated,
    this.gender,
    this.age,
    this.profileImageUrl,
    this.checkInPin,
    this.lastCheckIn,
    this.lastCheckInDevice,
    this.hmacSignature = '',
  });

  Map<String, dynamic> toJson() => {
    'memberId': memberId,
    'name': name,
    'phone': phone,
    'joinDate': joinDate.toIso8601String(),
    'planId': planId,
    'planName': planName,
    'planPrice': planPrice,
    'expiryDate': expiryDate?.toIso8601String(),
    'totalPaid': totalPaid,
    'paymentIds': paymentIds,
    'joinDateHistory': joinDateHistory.map((e) => e.toJson()).toList(),
    'archived': archived,
    'lastUpdated': lastUpdated.toIso8601String(),
    'gender': gender,
    'age': age,
    'profileImageUrl': profileImageUrl,
    'checkInPin': checkInPin,
    'lastCheckIn': lastCheckIn?.toIso8601String(),
    'lastCheckInDevice': lastCheckInDevice,
    'hmacSignature': hmacSignature,
  };

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    memberId: json['memberId'] ?? '',
    name: json['name'] ?? '',
    phone: json['phone'],
    joinDate: DateTime.parse(json['joinDate']),
    planId: json['planId'],
    planName: json['planName'],
    planPrice: (json['planPrice'] as num?)?.toDouble(),
    expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
    totalPaid: json['totalPaid'] ?? 0,
    paymentIds: (json['paymentIds'] as List?)?.cast<String>() ?? [],
    joinDateHistory: (json['joinDateHistory'] as List?)?.map((e) => JoinDateChange.fromJson(e)).toList() ?? [],
    archived: json['archived'] ?? false,
    lastUpdated: DateTime.parse(json['lastUpdated']),
    gender: json['gender'],
    age: json['age'],
    profileImageUrl: json['profileImageUrl'],
    checkInPin: json['checkInPin'],
    lastCheckIn: json['lastCheckIn'] != null ? DateTime.parse(json['lastCheckIn']) : null,
    lastCheckInDevice: json['lastCheckInDevice'],
    hmacSignature: json['hmacSignature'] ?? '',
  );

  // UI convenience
  @ignore
  MemberStatus get status => getStatus(DateTime.now());

  @ignore
  int get daysRemaining => getDaysRemaining(DateTime.now());

  int getDaysRemaining(DateTime now) {
    if (expiryDate == null) return -1;
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(expiryDate!.year, expiryDate!.month, expiryDate!.day);
    return expiry.difference(today).inDays;
  }

  MemberStatus getStatus(DateTime now) {
    final days = getDaysRemaining(now);
    if (days < 0) return MemberStatus.expired;
    if (days <= 7) return MemberStatus.expiring;
    return MemberStatus.active;
  }
}

@embedded
class JoinDateChange {
  DateTime? previousDate;
  DateTime? newDate;
  String? reason;
  DateTime? changedAt;

  JoinDateChange({
    this.previousDate,
    this.newDate,
    this.reason,
    this.changedAt,
  });

  Map<String, dynamic> toJson() => {
    'previousDate': previousDate?.toIso8601String(),
    'newDate': newDate?.toIso8601String(),
    'reason': reason,
    'changedAt': changedAt?.toIso8601String(),
  };

  factory JoinDateChange.fromJson(Map<String, dynamic> json) => JoinDateChange(
    previousDate: json['previousDate'] != null ? DateTime.parse(json['previousDate']) : null,
    newDate: json['newDate'] != null ? DateTime.parse(json['newDate']) : null,
    reason: json['reason'],
    changedAt: json['changedAt'] != null ? DateTime.parse(json['changedAt']) : null,
  );
}

enum MemberStatus { pending, active, expiring, expired }
