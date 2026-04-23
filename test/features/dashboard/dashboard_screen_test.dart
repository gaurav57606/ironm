import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironm/features/dashboard/presentation/dashboard_screen.dart';
import 'package:ironm/features/dashboard/viewmodel/dashboard_viewmodel.dart';

void main() {
  testWidgets('DashboardScreen shows stats correctly', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardViewModelProvider.overrideWith(() => MockDashboardViewModel(
            const DashboardState(
              totalMembers: 100,
              activeMembers: 80,
              expiringSoon: 5,
              monthlyRevenue: 5000.0,
            ),
          )),
        ],
        child: const MaterialApp(home: DashboardScreen()),
      ),
    );

    await tester.pump();

    expect(find.text('100'), findsOneWidget);
    expect(find.text('80'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
  });
}

class MockDashboardViewModel extends DashboardViewModel {
  final DashboardState _initialState;
  MockDashboardViewModel(this._initialState);

  @override
  Future<DashboardState> build() async => _initialState;
}
