import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironm/features/plans/presentation/screens/plans_screen.dart';
import 'package:ironm/features/plans/viewmodel/plans_viewmodel.dart';
import 'package:ironm/data/models/plan.dart';

void main() {
  group('PlansScreen Widget Tests', () {
    final plan = Plan(
      id: 'p1',
      name: 'Monthly Gold',
      durationMonths: 1,
      components: [PlanComponent(id: 'c1', name: 'Gym', price: 1500)],
      active: true,
    );

    testWidgets('Renders plans list', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            plansStreamProvider.overrideWith((ref) => Stream.value([plan])),
          ],
          child: const MaterialApp(
            home: PlansScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Monthly Gold'), findsOneWidget);
      expect(find.text('₹1500'), findsOneWidget);
      expect(find.text('ACTIVE'), findsOneWidget);
    });

    testWidgets('Shows empty state when no plans', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            plansStreamProvider.overrideWith((ref) => Stream.value([])),
          ],
          child: const MaterialApp(
            home: PlansScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No plans yet'), findsOneWidget);
    });

    testWidgets('FAB opens new plan dialog', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            plansStreamProvider.overrideWith((ref) => Stream.value([])),
          ],
          child: const MaterialApp(
            home: PlansScreen(),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('New Plan'), findsOneWidget);
    });
  });
}
