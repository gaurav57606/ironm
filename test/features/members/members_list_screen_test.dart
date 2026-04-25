import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ironm/data/models/member.dart';
import 'package:ironm/features/members/presentation/members_list_screen.dart';
import 'package:ironm/features/members/viewmodel/members_viewmodel.dart';

GoRouter _testRouter() => GoRouter(
      initialLocation: '/gym',
      routes: [
        GoRoute(
            path: '/gym',
            builder: (_, __) => const MembersListScreen(),
            routes: [
              GoRoute(
                  path: 'add-member',
                  builder: (_, __) =>
                      const Scaffold(body: Text('Add Member'))),
              GoRoute(
                  path: 'member-details/:memberId',
                  builder: (_, __) =>
                      const Scaffold(body: Text('Detail'))),
            ]),
      ],
    );

void main() {
  group('MembersListScreen', () {
    testWidgets('renders without crash when stream is empty',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            membersStreamProvider
                .overrideWith((ref) => const Stream.empty()),
          ],
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );
      await tester.pump();
      expect(find.byType(MembersListScreen), findsOneWidget);
    });

    testWidgets('shows empty state when member list is empty',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            membersStreamProvider
                .overrideWith((ref) => Stream.value([])),
          ],
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No members found'), findsOneWidget);
    });

    testWidgets('shows member name when data is present',
        (tester) async {
      final members = [
        Member(
          memberId: 'test-001',
          name: 'Ravi Kumar',
          joinDate: DateTime(2025, 1, 1),
          lastUpdated: DateTime(2025, 1, 1),
          expiryDate: DateTime(2026, 6, 1),
        ),
      ];
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            membersStreamProvider
                .overrideWith((ref) => Stream.value(members)),
          ],
          child: MaterialApp.router(routerConfig: _testRouter()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Ravi Kumar'), findsOneWidget);
    });
  });
}
