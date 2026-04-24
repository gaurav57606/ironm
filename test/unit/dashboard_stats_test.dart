import 'package:flutter_test/flutter_test.dart';
import 'package:ironm/data/models/member.dart';
import 'package:ironm/data/models/payment.dart';
import 'package:ironm/data/models/attendance.dart';
import 'package:ironm/features/dashboard/viewmodel/dashboard_viewmodel.dart';

// Pure function extracted from dashboardStatsProvider logic
DashboardStats calculateDashboardStats({
  required List<Member> members,
  required List<Payment> payments,
  required List<Attendance> attendances,
  required DateTime now,
}) {
  final nonArchived = members.where((m) => !m.archived).toList();

  final active = nonArchived.where((m) => m.getStatus(now) == MemberStatus.active).length;
  final expiring = nonArchived.where((m) => m.getStatus(now) == MemberStatus.expiring).length;
  final expired = nonArchived.where((m) => m.getStatus(now) == MemberStatus.expired).length;

  final monthlyRev = payments
      .where((p) => p.date.month == now.month && p.date.year == now.year)
      .fold(0.0, (s, p) => s + p.amount);

  final totalRev = payments.fold(0.0, (s, p) => s + p.amount);

  final weekly = List.generate(7, (index) {
    final date = now.subtract(Duration(days: 6 - index));
    return payments
        .where((p) => p.date.day == date.day && p.date.month == date.month && p.date.year == date.year)
        .fold(0.0, (s, p) => s + p.amount);
  });

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

  final lastMonth = now.month == 1 ? 12 : now.month - 1;
  final lastMonthYear = now.month == 1 ? now.year - 1 : now.year;
  final lastMonthRev = payments
      .where((p) => p.date.month == lastMonth && p.date.year == lastMonthYear)
      .fold(0.0, (s, p) => s + p.amount);

  final revGrowth = lastMonthRev > 0 ? ((monthlyRev - lastMonthRev) / lastMonthRev) * 100 : 0.0;

  final lastMonthMembers =
      nonArchived.where((m) => m.joinDate.isBefore(DateTime(now.year, now.month, 1))).length;
  final memGrowth = lastMonthMembers > 0 ? ((active - lastMonthMembers) / lastMonthMembers) * 100 : 0.0;

  final attendanceTrend = List.generate(7, (index) {
    final date = now.subtract(Duration(days: 6 - index));
    return attendances
        .where((a) =>
            a.checkInTime.day == date.day &&
            a.checkInTime.month == date.month &&
            a.checkInTime.year == date.year)
        .length
        .toDouble();
  });

  return DashboardStats(
    totalMembers: nonArchived.length,
    activeMembers: active,
    expiringMembers: expiring,
    expiredMembers: expired,
    monthlyRevenue: monthlyRev,
    totalRevenue: totalRev,
    weeklyRevenue: weekly,
    topPlans: topPlans,
    revenueGrowth: revGrowth,
    memberGrowth: memGrowth,
    attendanceTrends: attendanceTrend,
  );
}

void main() {
  group('Dashboard Stats Logic Tests', () {
    final now = DateTime(2026, 4, 24);

    test('monthlyRevenue sums payments in current month only', () {
      final payments = [
        Payment(id: '1', memberId: 'm1', date: now, amount: 1000, method: 'Cash', planId: 'p1', planName: 'Gold', invoiceNumber: '001', subtotal: 847, gstAmount: 153, gstRate: 18, durationMonths: 1),
        Payment(id: '2', memberId: 'm1', date: now.subtract(const Duration(days: 1)), amount: 500, method: 'Cash', planId: 'p1', planName: 'Gold', invoiceNumber: '002', subtotal: 423, gstAmount: 77, gstRate: 18, durationMonths: 1),
        Payment(id: '3', memberId: 'm1', date: now.subtract(const Duration(days: 40)), amount: 2000, method: 'Cash', planId: 'p1', planName: 'Gold', invoiceNumber: '003', subtotal: 1694, gstAmount: 306, gstRate: 18, durationMonths: 1),
      ];

      final stats = calculateDashboardStats(members: [], payments: payments, attendances: [], now: now);
      expect(stats.monthlyRevenue, 1500.0);
    });

    test('growth returns 0.0 when last month data is 0', () {
      final payments = [
        Payment(id: '1', memberId: 'm1', date: now, amount: 1000, method: 'Cash', planId: 'p1', planName: 'Gold', invoiceNumber: '001', subtotal: 847, gstAmount: 153, gstRate: 18, durationMonths: 1),
      ];
      final stats = calculateDashboardStats(members: [], payments: payments, attendances: [], now: now);
      expect(stats.revenueGrowth, 0.0);
      expect(stats.memberGrowth, 0.0);
    });

    test('topPlans shows max 3 plans sorted by count DESC', () {
      final payments = [
        for (var i = 0; i < 5; i++) Payment(id: 'a$i', memberId: 'm', date: now, amount: 100, method: 'C', planId: '1', planName: 'PlanA', invoiceNumber: 'i', subtotal: 80, gstAmount: 20, gstRate: 18, durationMonths: 1),
        for (var i = 0; i < 3; i++) Payment(id: 'b$i', memberId: 'm', date: now, amount: 100, method: 'C', planId: '2', planName: 'PlanB', invoiceNumber: 'i', subtotal: 80, gstAmount: 20, gstRate: 18, durationMonths: 1),
        for (var i = 0; i < 1; i++) Payment(id: 'c$i', memberId: 'm', date: now, amount: 100, method: 'C', planId: '3', planName: 'PlanC', invoiceNumber: 'i', subtotal: 80, gstAmount: 20, gstRate: 18, durationMonths: 1),
        for (var i = 0; i < 1; i++) Payment(id: 'd$i', memberId: 'm', date: now, amount: 100, method: 'C', planId: '4', planName: 'PlanD', invoiceNumber: 'i', subtotal: 80, gstAmount: 20, gstRate: 18, durationMonths: 1),
      ];

      final stats = calculateDashboardStats(members: [], payments: payments, attendances: [], now: now);
      expect(stats.topPlans.length, 3);
      expect(stats.topPlans[0].name, 'PlanA');
      expect(stats.topPlans[1].name, 'PlanB');
    });

    test('weeklyRevenue maps payment 6 days ago to index 0', () {
      final payments = [
        Payment(id: '1', memberId: 'm1', date: now.subtract(const Duration(days: 6)), amount: 1000, method: 'Cash', planId: 'p1', planName: 'Gold', invoiceNumber: '001', subtotal: 847, gstAmount: 153, gstRate: 18, durationMonths: 1),
      ];
      final stats = calculateDashboardStats(members: [], payments: payments, attendances: [], now: now);
      expect(stats.weeklyRevenue[0], 1000.0);
      expect(stats.weeklyRevenue[6], 0.0);
    });

    test('attendanceTrends maps 4 check-ins today to index 6', () {
      final attendances = [
        for (var i = 0; i < 4; i++) Attendance(memberId: 'm$i', checkInTime: now),
      ];
      final stats = calculateDashboardStats(members: [], payments: [], attendances: attendances, now: now);
      expect(stats.attendanceTrends[6], 4.0);
      expect(stats.attendanceTrends[0], 0.0);
    });
  });
}
