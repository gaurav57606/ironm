import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:isar/isar.dart';
import 'package:ironm/features/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:ironm/core/providers/database_provider.dart';
import 'package:ironm/data/models/member.dart';
import 'package:ironm/data/models/payment.dart';
import 'package:ironm/data/models/attendance.dart';

class MockIsar extends Mock implements Isar {}
class MockMemberCollection extends Mock implements IsarCollection<Member> {}
class MockPaymentCollection extends Mock implements IsarCollection<Payment> {}
class MockAttendanceCollection extends Mock implements IsarCollection<Attendance> {}
class MockMemberQueryBuilder extends Mock implements QueryBuilder<Member, Member, QWhere> {}
class MockPaymentQueryBuilder extends Mock implements QueryBuilder<Payment, Payment, QWhere> {}
class MockAttendanceQueryBuilder extends Mock implements QueryBuilder<Attendance, Attendance, QWhere> {}

void main() {
  late MockIsar mockIsar;
  late MockMemberCollection mockMemberCol;
  late MockPaymentCollection mockPaymentCol;
  late MockAttendanceCollection mockAttendanceCol;
  late MockMemberQueryBuilder mockMemberQB;
  late MockPaymentQueryBuilder mockPaymentQB;
  late MockAttendanceQueryBuilder mockAttendanceQB;

  setUp(() {
    mockIsar = MockIsar();
    mockMemberCol = MockMemberCollection();
    mockPaymentCol = MockPaymentCollection();
    mockAttendanceCol = MockAttendanceCollection();
    mockMemberQB = MockMemberQueryBuilder();
    mockPaymentQB = MockPaymentQueryBuilder();
    mockAttendanceQB = MockAttendanceQueryBuilder();

    when(() => mockIsar.members).thenReturn(mockMemberCol);
    when(() => mockIsar.payments).thenReturn(mockPaymentCol);
    when(() => mockIsar.attendances).thenReturn(mockAttendanceCol);

    when(() => mockMemberCol.where()).thenReturn(mockMemberQB);
    when(() => mockPaymentCol.where()).thenReturn(mockPaymentQB);
    when(() => mockAttendanceCol.where()).thenReturn(mockAttendanceQB);
  });

  group('Dashboard Provider Tests', skip: 'Mocking Isar watch() is not supported with mocktail', () {
    test('Calculates DashboardStats correctly from Isar streams', () async {
      final now = DateTime.now();
      
      final List<Member> members = [
        Member(memberId: '1', name: 'Active', joinDate: now, lastUpdated: now, expiryDate: now.add(const Duration(days: 10))),
        Member(memberId: '2', name: 'Expiring', joinDate: now, lastUpdated: now, expiryDate: now.add(const Duration(days: 2))),
        Member(memberId: '3', name: 'Expired', joinDate: now.subtract(const Duration(days: 40)), lastUpdated: now, expiryDate: now.subtract(const Duration(days: 1))),
      ];

      final List<Payment> payments = [
        Payment(
          id: 'p1', memberId: '1', amount: 1000, date: now, method: 'UPI', 
          planId: '1', planName: 'Gold', invoiceNumber: 'INV1', subtotal: 847, gstAmount: 153, gstRate: 18, durationMonths: 1
        ),
        Payment(
          id: 'p2', memberId: '2', amount: 500, date: now.subtract(const Duration(days: 32)), method: 'Cash', 
          planId: '2', planName: 'Silver', invoiceNumber: 'INV2', subtotal: 423, gstAmount: 77, gstRate: 18, durationMonths: 1
        ),
      ];

      final List<Attendance> attendances = [
        Attendance(memberId: '1', checkInTime: now),
      ];

      when(() => mockMemberQB.watch(fireImmediately: true)).thenAnswer((_) => Stream.value(members));
      when(() => mockPaymentQB.watch(fireImmediately: true)).thenAnswer((_) => Stream.value(payments));
      when(() => mockAttendanceQB.watch(fireImmediately: true)).thenAnswer((_) => Stream.value(attendances));

      final container = ProviderContainer(
        overrides: [
          isarProvider.overrideWithValue(mockIsar),
        ],
      );

      final stats = await container.read(dashboardStatsProvider.future);

      expect(stats.totalMembers, 3);
      expect(stats.activeMembers, 1);
      expect(stats.expiringMembers, 1);
      expect(stats.expiredMembers, 1);
      expect(stats.monthlyRevenue, 1000.0);
      expect(stats.totalRevenue, 1500.0);
      expect(stats.attendanceTrends[6], 1.0); // Today's attendance
    });

    test('Returns empty stats when Isar is null', () async {
      final container = ProviderContainer(
        overrides: [
          isarProvider.overrideWithValue(null),
        ],
      );

      final stats = await container.read(dashboardStatsProvider.future);
      expect(stats.totalMembers, 0);
      expect(stats.activeMembers, 0);
    });
  });
}
