import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironm/features/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:ironm/data/repositories/member_repository.dart';
import 'package:ironm/data/repositories/payment_repository.dart';
import 'package:ironm/data/models/member.dart';
import 'package:ironm/data/models/payment.dart';

class MockMemberRepository extends Mock implements IMemberRepository {}
class MockPaymentRepository extends Mock implements IsarPaymentRepository {}

void main() {
  late MockMemberRepository mockMemberRepo;
  late MockPaymentRepository mockPaymentRepo;
  late ProviderContainer container;

  setUp(() {
    mockMemberRepo = MockMemberRepository();
    mockPaymentRepo = MockPaymentRepository();
    container = ProviderContainer(
      overrides: [
        memberRepositoryProvider.overrideWithValue(mockMemberRepo),
        paymentRepositoryProvider.overrideWithValue(mockPaymentRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('DashboardViewModel Detailed Analysis', skip: 'Redundant with unit tests and requires Isar core binary', () {
    test('Initial state is loading', () {
      final state = container.read(dashboardStatsProvider);
      expect(state is AsyncLoading, true);
    });

    test('Calculates stats correctly with multiple members and payments', () async {
      // Mock Data
      final members = [
        Member(
          memberId: '1',
          name: 'Active John',
          joinDate: DateTime.now(),
          expiryDate: DateTime.now().add(const Duration(days: 10)),
          lastUpdated: DateTime.now(),
        ),
        Member(
          memberId: '2',
          name: 'Expiring Jane',
          joinDate: DateTime.now(),
          expiryDate: DateTime.now().add(const Duration(days: 3)),
          lastUpdated: DateTime.now(),
        ),
        Member(
          memberId: '3',
          name: 'Inactive Bob',
          joinDate: DateTime.now(),
          expiryDate: DateTime.now().subtract(const Duration(days: 1)),
          lastUpdated: DateTime.now(),
        ),
      ];

      final payments = [
        Payment(
          id: 'p1',
          memberId: '1',
          amount: 1000.0,
          date: DateTime.now(),
          method: 'Cash',
          planId: 'plan1',
          planName: 'Monthly',
          invoiceNumber: 'INV-001',
          subtotal: 847.46,
          gstAmount: 152.54,
          gstRate: 18.0,
          durationMonths: 1,
        ),
        Payment(
          id: 'p2',
          memberId: '2',
          amount: 500.0,
          date: DateTime.now(),
          method: 'UPI',
          planId: 'plan1',
          planName: 'Monthly',
          invoiceNumber: 'INV-002',
          subtotal: 423.73,
          gstAmount: 76.27,
          gstRate: 18.0,
          durationMonths: 1,
        ),
        Payment(
          id: 'p3',
          memberId: '1',
          amount: 2000.0,
          date: DateTime.now().subtract(const Duration(days: 45)), // Last month
          method: 'Cash',
          planId: 'plan1',
          planName: 'Monthly',
          invoiceNumber: 'INV-003',
          subtotal: 1694.92,
          gstAmount: 305.08,
          gstRate: 18.0,
          durationMonths: 1,
        ),
      ];

      when(() => mockMemberRepo.getAll()).thenAnswer((_) async => members);
      when(() => mockPaymentRepo.getAll()).thenAnswer((_) async => payments);

      // Trigger build
      final state = await container.read(dashboardStatsProvider.future);

      expect(state.totalMembers, 3);
      expect(state.activeMembers, 1); // Only John is active
      expect(state.expiringMembers, 1); // Only Jane
      expect(state.monthlyRevenue, 1500.0); // Only current month payments
    });

    test('Handles empty data gracefully', () async {
      when(() => mockMemberRepo.getAll()).thenAnswer((_) async => []);
      when(() => mockPaymentRepo.getAll()).thenAnswer((_) async => []);

      final state = await container.read(dashboardStatsProvider.future);

      expect(state.totalMembers, 0);
      expect(state.activeMembers, 0);
      expect(state.expiringMembers, 0);
      expect(state.monthlyRevenue, 0.0);
    });

    test('Handles repository errors', () async {
      when(() => mockMemberRepo.getAll()).thenThrow(Exception('Database error'));
      
      // Wait for the future to complete and catch the error
      try {
        await container.read(dashboardStatsProvider.future);
      } catch (_) {}

      final finalState = container.read(dashboardStatsProvider);
      expect(finalState is AsyncError, true);
    });
  });
}
