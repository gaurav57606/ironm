import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/event_payload_keys.dart';
import '../../core/services/hmac_service.dart';
import '../../core/utils/clock.dart';
import '../../core/utils/date_utils.dart';
import '../models/domain_event.dart';
import '../models/member.dart';
import '../models/plan.dart';
import '../repositories/event_repository.dart';
import '../repositories/i_event_repository.dart';
import '../repositories/member_repository.dart';
import '../services/snapshot_builder.dart';
import 'plans_notifier.dart';
import '../repositories/attendance_repository.dart';
import '../models/attendance.dart';


class MembersNotifier extends StateNotifier<List<Member>> {
  final IMemberRepository _memberRepo;
  final IEventRepository _eventRepo;
  final IAttendanceRepository _attendanceRepo;
  final HmacService _hmac;
  final IClock _clock;

  final Ref _ref;
  String _deviceId = 'device-unknown';

  MembersNotifier(this._memberRepo, this._eventRepo, this._attendanceRepo, this._hmac, this._clock, this._ref) : super([]) {

    _init();
  }

  Future<void> _init() async {
    _deviceId = await _hmac.getInstallationId();
    await refresh();

    // Listen for events to update state reactively
    _eventRepo.watch().listen((event) async {
      final current = await _memberRepo.getById(event.entityId);
      
      // Skip if already up-to-date
      if (current != null && current.lastUpdated.isAtSameMomentAs(event.deviceTimestamp)) {
        return;
      }

      final updated = SnapshotBuilder.apply(current, event);
      if (updated != null) {
        await _memberRepo.save(updated);
        await refresh();
      } else if (event.eventType == EventType.memberArchived) {
        await _memberRepo.delete(event.entityId);
        await refresh();
      }
    });
  }

  Future<void> refresh() async {
    final members = await _memberRepo.getAll();
    state = members;
  }

  Future<String> addMember({
    required String name,
    required String phone,
    required String planId,
    required DateTime joinDate,
  }) async {
    final memberId = const Uuid().v4();
    final now = _clock.now;
    
    final plan = _ref.read(plansProvider).firstWhere((p) => p.id == planId);
    final expiryDate = AppDateUtils.addMonths(joinDate, plan.durationMonths);

    final payload = {
      EventPayloadKeys.memberId: memberId,
      EventPayloadKeys.name: name,
      EventPayloadKeys.phone: phone,
      EventPayloadKeys.planId: planId,
      EventPayloadKeys.planName: plan.name,
      EventPayloadKeys.joinDate: joinDate.toUtc().toIso8601String(),
      EventPayloadKeys.newExpiry: expiryDate.toUtc().toIso8601String(),
    };

    final memberEvent = DomainEvent(
      entityId: memberId,
      eventType: EventType.memberCreated,
      deviceId: _deviceId,
      deviceTimestamp: now,
      payloadJson: jsonEncode(payload),
    );

    // 1. Persist Event (Source of Truth)
    await _eventRepo.persist(memberEvent);

    // 2. Update Snapshot (Near-atomic cache update)
    final member = Member(
      memberId: memberId,
      name: name,
      phone: phone,
      joinDate: joinDate,
      expiryDate: expiryDate,
      planId: planId,
      planName: plan.name,
      lastUpdated: now,
    );
    
    await _memberRepo.save(member);
    await refresh();

    return memberId;
  }

  Future<void> recordAttendance(String memberId) async {
    final now = _clock.now;
    final checkInEvent = DomainEvent(
      entityId: memberId,
      eventType: EventType.checkInRecorded,
      deviceId: _deviceId,
      deviceTimestamp: now,
      payloadJson: jsonEncode({
        EventPayloadKeys.memberId: memberId,
        EventPayloadKeys.updatedAt: now.toUtc().toIso8601String(),
      }),
    );

    await _eventRepo.persist(checkInEvent);
    
    // 2. Persist Attendance Snapshot
    final attendance = Attendance(memberId: memberId, checkInTime: now);
    await _attendanceRepo.save(attendance);

    // 3. Update Member Snapshot (Last Check-in)
    final current = await _memberRepo.getById(memberId);
    final updated = SnapshotBuilder.apply(current, checkInEvent);
    if (updated != null) {
      await _memberRepo.save(updated);
      await refresh();
    }

  }

  Future<void> deleteMember(String memberId) async {
    final deleteEvent = DomainEvent(
      entityId: memberId,
      eventType: EventType.memberArchived,
      deviceId: _deviceId,
      deviceTimestamp: _clock.now,
      payloadJson: jsonEncode({'memberId': memberId}),
    );

    await _eventRepo.persist(deleteEvent);
    await _memberRepo.delete(memberId);
    await refresh();
  }
}

final membersProvider = StateNotifierProvider<MembersNotifier, List<Member>>((ref) {
  final memberRepo = ref.watch(memberRepositoryProvider);
  final eventRepo = ref.watch(eventRepositoryProvider);
  final attendanceRepo = ref.watch(attendanceRepositoryProvider);
  final hmac = ref.watch(hmacServiceProvider);
  final clock = ref.watch(clockProvider);
  return MembersNotifier(memberRepo, eventRepo, attendanceRepo, hmac, clock, ref);
});

final memberAttendanceProvider = FutureProvider.family<List<Attendance>, String>((ref, memberId) async {
  final repo = ref.watch(attendanceRepositoryProvider);
  return await repo.getByMember(memberId);
});


final memberSearchQueryProvider = StateProvider<String>((ref) => '');
final memberTabProvider = StateProvider<int>((ref) => 0); // 0: All, 1: Active, 2: Expiring, 3: Expired

final filteredMembersProvider = Provider<List<Member>>((ref) {
  final members = ref.watch(membersProvider);
  final query = ref.watch(memberSearchQueryProvider).toLowerCase();
  final tabIndex = ref.watch(memberTabProvider);
  final now = ref.watch(clockProvider).now;

  return members.where((m) {
    final matchesSearch = m.name.toLowerCase().contains(query) ||
        (m.phone?.contains(query) ?? false);
    
    if (!matchesSearch) return false;

    if (tabIndex == 0) return true; // All
    final status = m.getStatus(now);
    if (tabIndex == 1) return status == MemberStatus.active;
    if (tabIndex == 2) return status == MemberStatus.expiring;
    if (tabIndex == 3) return status == MemberStatus.expired;
    return true;
  }).toList();
});
