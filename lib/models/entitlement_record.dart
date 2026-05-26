import 'package:cloud_firestore/cloud_firestore.dart';

class EntitlementRecord {
  final String userId;
  final String appId;
  final String status;          // 'active' | 'suspended' | 'expired'
  final DateTime expiresAt;
  final DateTime startDate;
  final String planId;
  final int gracePeriodDays;
  final bool killSwitchActive;
  final String ownerName;
  final String businessName;
  final String phone;
  final String notes;
  final DateTime createdAt;
  final DateTime? lastSyncedAt;

  const EntitlementRecord({
    required this.userId,
    required this.appId,
    required this.status,
    required this.expiresAt,
    required this.startDate,
    required this.planId,
    required this.gracePeriodDays,
    required this.killSwitchActive,
    required this.ownerName,
    required this.businessName,
    required this.phone,
    required this.notes,
    required this.createdAt,
    this.lastSyncedAt,
  });

  // Computed helpers — never stored in Firestore
  bool get isEffectivelyExpired =>
      killSwitchActive ||
      status == 'suspended' ||
      status == 'expired' ||
      expiresAt.isBefore(DateTime.now());

  int get daysUntilExpiry =>
      expiresAt.difference(DateTime.now()).inDays;

  bool get isExpiringSoon =>
      !isEffectivelyExpired && daysUntilExpiry >= 0 && daysUntilExpiry <= 7;

  factory EntitlementRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EntitlementRecord(
      userId: doc.id,
      appId: data['appId'] as String? ?? 'ironm',
      status: data['status'] as String? ?? 'active',
      expiresAt: data['expiresAt'] != null
          ? (data['expiresAt'] as Timestamp).toDate()
          : DateTime.now(),
      startDate: data['startDate'] != null
          ? (data['startDate'] as Timestamp).toDate()
          : DateTime.now(),
      planId: data['planId'] as String? ?? '',
      gracePeriodDays: data['gracePeriodDays'] as int? ?? 7,
      killSwitchActive: data['killSwitchActive'] as bool? ?? false,
      ownerName: data['ownerName'] as String? ?? '',
      businessName: data['businessName'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      notes: data['notes'] as String? ?? '',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      lastSyncedAt: data['lastSyncedAt'] != null
          ? (data['lastSyncedAt'] as Timestamp).toDate()
          : null,
    );
  }

  // toFirestore — NEVER includes lastSyncedAt (written only by client app)
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'appId': appId,
      'status': status,
      'expiresAt': Timestamp.fromDate(expiresAt),
      'startDate': Timestamp.fromDate(startDate),
      'planId': planId,
      'gracePeriodDays': gracePeriodDays,
      'killSwitchActive': killSwitchActive,
      'ownerName': ownerName,
      'businessName': businessName,
      'phone': phone,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  EntitlementRecord copyWith({
    String? status,
    DateTime? expiresAt,
    bool? killSwitchActive,
    String? notes,
    String? planId,
    int? gracePeriodDays,
    String? ownerName,
    String? businessName,
    String? phone,
  }) {
    return EntitlementRecord(
      userId: userId,
      appId: appId,
      status: status ?? this.status,
      expiresAt: expiresAt ?? this.expiresAt,
      startDate: startDate,
      planId: planId ?? this.planId,
      gracePeriodDays: gracePeriodDays ?? this.gracePeriodDays,
      killSwitchActive: killSwitchActive ?? this.killSwitchActive,
      ownerName: ownerName ?? this.ownerName,
      businessName: businessName ?? this.businessName,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      lastSyncedAt: lastSyncedAt,
    );
  }
}
