import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironm/features/dashboard/presentation/dashboard_screen.dart';
import 'package:ironm/features/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:ironm/features/members/viewmodel/members_viewmodel.dart';
import 'package:ironm/features/auth/viewmodel/auth_viewmodel.dart';

import 'package:ironm/data/models/app_settings.dart';

class FakeAuthViewModel extends AuthViewModel {
  final AuthState _state;
  FakeAuthViewModel(this._state);

  @override
  AuthState build() => _state;
}

void main() {
  group('DashboardScreen Widget Tests', () {
    final stats = DashboardStats(
      activeMembers: 10,
      expiringMembers: 3,
      expiredMembers: 5,
      monthlyRevenue: 15000,
    );

    testWidgets('Active, Expiring, Expired counts match stats', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardStatsProvider.overrideWith((ref) => Stream.value(stats)),
            membersProvider.overrideWithValue([]),
            authProvider.overrideWith(() => FakeAuthViewModel(AuthState(isLoading: false, settings: AppSettings()))),
          ],
          child: MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('10').first, findsOneWidget); // Active
      expect(find.text('3').first, findsOneWidget);  // Expiring
      expect(find.text('5').first, findsOneWidget);  // Expired
    });

    testWidgets('Monthly revenue shows formatted correctly', (tester) async {
      tester.view.physicalSize = const Size(600, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardStatsProvider.overrideWith((ref) => Stream.value(stats)),
            membersProvider.overrideWithValue([]),
            authProvider.overrideWith(() => FakeAuthViewModel(AuthState(isLoading: false, settings: AppSettings()))),
          ],
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Ensure the revenue card is visible
      await tester.scrollUntilVisible(find.textContaining('15000'), 100);
      await tester.pumpAndSettle();

      // Should show the revenue value
      expect(find.textContaining('15000'), findsOneWidget);
    });
  });
}
