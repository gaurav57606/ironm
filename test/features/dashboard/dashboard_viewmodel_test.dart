import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironbook_gm/features/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:ironbook_gm/data/repositories/member_repository.dart';
import 'package:ironbook_gm/data/repositories/payment_repository.dart';
import 'package:ironbook_gm/data/models/member.dart';
import 'package:ironbook_gm/data/models/payment.dart';

class MockMemberRepository extends Mock implements MemberRepository {}
class MockPaymentRepository extends Mock implements PaymentRepository {}

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

  group('DashboardViewModel Detailed Analysis', () {
    test('Initial state is loading', () {
      final state = container.read(dashboardViewModelProvider);
      expect(state is AsyncLoading, true);
    });

    test('Calculates stats correctly with multiple members and payments', () async {
      // Mock Data
      final members = [
        Member()
          ..name = 'Active John'
          ..isActive = true
          ..expiryDate = DateTime.now().add(const Duration(days: 10)),
        Member()
          ..name = 'Expiring Jane'
          ..isActive = true
          ..expiryDate = DateTime.now().add(const Duration(days: 3)),
        Member()
          ..name = 'Inactive Bob'
          ..isActive = false
          ..expiryDate = DateTime.now().subtract(const Duration(days: 1)),
      ];

      final payments = [
        Payment()
          ..amount = 1000.0
          ..paymentDate = DateTime.now(),
        Payment()
          ..amount = 500.0
          ..paymentDate = DateTime.now(),
        Payment()
          ..amount = 2000.0
          ..paymentDate = DateTime.now().subtract(const Duration(days: 45)), // Last month
      ];

      when(() => mockMemberRepo.getAllMembers()).thenAnswer((_) async => members);
      when(() => mockPaymentRepo.getAllPayments()).thenAnswer((_) async => payments);

      // Trigger build
      final state = await container.read(dashboardViewModelProvider.future);

      expect(state.totalMembers, 3);
      expect(state.activeMembers, 2);
      expect(state.expiringSoon, 1); // Only Jane
      expect(state.monthlyRevenue, 1500.0); // Only current month payments
    });

    test('Handles empty data gracefully', () async {
      when(() => mockMemberRepo.getAllMembers()).thenAnswer((_) async => []);
      when(() => mockPaymentRepo.getAllPayments()).thenAnswer((_) async => []);

      final state = await container.read(dashboardViewModelProvider.future);

      expect(state.totalMembers, 0);
      expect(state.activeMembers, 0);
      expect(state.expiringSoon, 0);
      expect(state.monthlyRevenue, 0.0);
    });

    test('Handles repository errors', () async {
      when(() => mockMemberRepo.getAllMembers()).thenThrow(Exception('Database error'));
      
      // Wait for the future to complete and catch the error
      try {
        await container.read(dashboardViewModelProvider.future);
      } catch (_) {}

      final finalState = container.read(dashboardViewModelProvider);
      expect(finalState is AsyncError, true);
    });
  });
}
