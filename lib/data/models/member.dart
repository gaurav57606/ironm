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

  // UI convenience
  @ignore
  MemberStatus get status {
    if (expiryDate == null) return MemberStatus.pending;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(expiryDate!.year, expiryDate!.month, expiryDate!.day);
    final diff = expiry.difference(today).inDays;
    
    if (diff < 0) return MemberStatus.expired;
    if (diff <= 7) return MemberStatus.expiring;
    return MemberStatus.active;
  }

  @ignore
  int get daysRemaining {
    if (expiryDate == null) return 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(expiryDate!.year, expiryDate!.month, expiryDate!.day);
    return expiry.difference(today).inDays;
  }

  int getDaysRemaining(DateTime now) {
    if (expiryDate == null) return -1;
    return expiryDate!.difference(now).inDays;
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
}

enum MemberStatus { pending, active, expiring, expired }
