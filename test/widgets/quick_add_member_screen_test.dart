import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ironm/features/members/presentation/quick_add_member_screen.dart';
import 'package:ironm/features/plans/viewmodel/plans_viewmodel.dart';
import 'package:ironm/data/models/plan.dart';

void main() {
  group('QuickAddMemberScreen Widget Tests', () {
    testWidgets('Register button exists', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            plansStreamProvider.overrideWith((ref) => Stream.value([])),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const QuickAddMemberScreen(),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('FULL NAME'), findsOneWidget);
      expect(find.text('PHONE NUMBER'), findsOneWidget);
      expect(find.text('Register Member & Generate Invoice'), findsOneWidget);
    });

    testWidgets('Shows no plans message when plans list is empty', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            plansStreamProvider.overrideWith((ref) => Stream.value([])),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const QuickAddMemberScreen(),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('No active plans found'), findsOneWidget);
    });

    testWidgets('Plan selection updates summary', (tester) async {
      final plan = Plan(id: 'p1', name: 'Gold Plan', durationMonths: 1, components: [PlanComponent(id: 'c1', name: 'Base', price: 1180)]);
      
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            plansStreamProvider.overrideWith((ref) => Stream.value([plan])),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const QuickAddMemberScreen(),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Gold Plan'));
      await tester.pumpAndSettle();

      expect(find.text('PLAN SUMMARY'), findsOneWidget);
      expect(find.text('₹1180'), findsWidgets);
    });
  });
}
