// ═══════════════════════════════════════════════════════════════════
// 🔒 LOCKED — DashboardViewModel | Verified: 2026-04-24 | DO NOT EDIT
// ═══════════════════════════════════════════════════════════════════
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:isar/isar.dart';
import '../../../data/models/member.dart';
import '../../../data/models/attendance.dart';
import '../../../data/models/payment.dart';
import '../../../data/repositories/member_repository.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../core/providers/database_provider.dart';

class PlanStat {
  final String name;
  final int count;
  final double percent;
  PlanStat({required this.name, required this.count, required this.percent});
}

class DashboardStats {
  final int totalMembers;
  final int activeMembers;
  final int expiringMembers;
  final int expiredMembers;
  final double monthlyRevenue;
  final double totalRevenue;
  final List<double> weeklyRevenue;
  final List<PlanStat> topPlans;
  final double revenueGrowth;
  final double memberGrowth;
  final List<double> attendanceTrends;

  const DashboardStats({
    this.totalMembers    = 0,
    this.activeMembers   = 0,
    this.expiringMembers = 0,
    this.expiredMembers  = 0,
    this.monthlyRevenue  = 0,
    this.totalRevenue    = 0,
    this.weeklyRevenue   = const [0, 0, 0, 0, 0, 0, 0],
    this.topPlans        = const [],
    this.revenueGrowth   = 0,
    this.memberGrowth    = 0,
    this.attendanceTrends = const [0, 0, 0, 0, 0, 0, 0],
  });
}


final dashboardStatsProvider = StreamProvider.autoDispose<DashboardStats>((ref) {
  final isar = ref.watch(isarProvider);
  if (isar == null) return Stream.value(const DashboardStats());

  final membersStream = isar.members.where().watch(fireImmediately: true);
  final paymentsStream = isar.payments.where().watch(fireImmediately: true);
  final attendanceStream = isar.attendances.where().watch(fireImmediately: true);

  return Rx.combineLatest3(membersStream, paymentsStream, attendanceStream, (members, payments, attendances) {
    final nonArchived = members.where((m) => !m.archived).toList();
    final now = DateTime.now();

    final active   = nonArchived.where((m) => m.getStatus(now) == MemberStatus.active).length;
    final expiring = nonArchived.where((m) => m.getStatus(now) == MemberStatus.expiring).length;
    final expired  = nonArchived.where((m) => m.getStatus(now) == MemberStatus.expired).length;

    final monthlyRev = payments
        .where((p) => p.date.month == now.month && p.date.year == now.year)
        .fold(0.0, (s, p) => s + p.amount);

    final totalRev = payments.fold(0.0, (s, p) => s + p.amount);

    // Compute weekly revenue (last 7 days)
    final weekly = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return payments
          .where((p) => p.date.day == date.day && p.date.month == date.month && p.date.year == date.year)
          .fold(0.0, (s, p) => s + p.amount);
    });

    // Compute Top Plans
    final planCounts = <String, int>{};
    for (final p in payments) {
      planCounts[p.planName] = (planCounts[p.planName] ?? 0) + 1;
    }
    final sortedPlans = planCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final totalPaymentCount = payments.length;
    final topPlans = sortedPlans.take(3).map((e) => PlanStat(
      name: e.key,
      count: e.value,
      percent: totalPaymentCount > 0 ? e.value / totalPaymentCount : 0,
    )).toList();

    // Compute Growth (Placeholder logic: vs last month)
    final lastMonth = now.month == 1 ? 12 : now.month - 1;
    final lastMonthYear = now.month == 1 ? now.year - 1 : now.year;
    final lastMonthRev = payments
        .where((p) => p.date.month == lastMonth && p.date.year == lastMonthYear)
        .fold(0.0, (s, p) => s + p.amount);
    
    final revGrowth = lastMonthRev > 0 ? ((monthlyRev - lastMonthRev) / lastMonthRev) * 100 : 0.0;
    
    final lastMonthMembers = nonArchived.where((m) => m.joinDate.isBefore(DateTime(now.year, now.month, 1))).length;
    final memGrowth = lastMonthMembers > 0 ? ((active - lastMonthMembers) / lastMonthMembers) * 100 : 0.0;

    // Compute Attendance Trends (last 7 days)
    final attendanceTrend = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return attendances
          .where((a) => a.checkInTime.day == date.day && a.checkInTime.month == date.month && a.checkInTime.year == date.year)
          .length.toDouble();
    });

    return DashboardStats(
      totalMembers:    nonArchived.length,
      activeMembers:   active,
      expiringMembers: expiring,
      expiredMembers:  expired,
      monthlyRevenue:  monthlyRev,
      totalRevenue:    totalRev,
      weeklyRevenue:   weekly,
      topPlans:        topPlans,
      revenueGrowth:   revGrowth,
      memberGrowth:    memGrowth,
      attendanceTrends: attendanceTrend,
    );
  });
});
