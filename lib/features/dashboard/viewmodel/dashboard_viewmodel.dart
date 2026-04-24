// ═══════════════════════════════════════════════════════════════════
// 🔒 LOCKED — DashboardViewModel | Verified: 2026-04-24 | DO NOT EDIT
// ═══════════════════════════════════════════════════════════════════
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:isar/isar.dart';
import '../../../data/models/member.dart';
import '../../../data/repositories/member_repository.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../core/providers/database_provider.dart';

class DashboardStats {
  final int totalMembers;
  final int activeMembers;
  final int expiringMembers;  // ≤7 days
  final int expiredMembers;
  final double monthlyRevenue;
  final double totalRevenue;

  const DashboardStats({
    this.totalMembers    = 0,
    this.activeMembers   = 0,
    this.expiringMembers = 0,
    this.expiredMembers  = 0,
    this.monthlyRevenue  = 0,
    this.totalRevenue    = 0,
  });
}


final dashboardStatsProvider = StreamProvider.autoDispose<DashboardStats>((ref) {
  final isar = ref.watch(isarProvider);
  if (isar == null) return Stream.value(const DashboardStats());

  final membersStream = isar.members.where().watch(fireImmediately: true);
  final paymentsStream = isar.payments.where().watch(fireImmediately: true);

  return Rx.combineLatest2(membersStream, paymentsStream, (members, payments) {
    final nonArchived = members.where((m) => !m.archived).toList();
    final now = DateTime.now();

    final active   = nonArchived.where((m) => m.getStatus(now) == MemberStatus.active).length;
    final expiring = nonArchived.where((m) => m.getStatus(now) == MemberStatus.expiring).length;
    final expired  = nonArchived.where((m) => m.getStatus(now) == MemberStatus.expired).length;

    final monthlyRev = payments
        .where((p) => p.date.month == now.month && p.date.year == now.year)
        .fold(0.0, (s, p) => s + p.amount);

    final totalRev = payments.fold(0.0, (s, p) => s + p.amount);

    return DashboardStats(
      totalMembers:    nonArchived.length,
      activeMembers:   active,
      expiringMembers: expiring,
      expiredMembers:  expired,
      monthlyRevenue:  monthlyRev,
      totalRevenue:    totalRev,
    );
  });
});
