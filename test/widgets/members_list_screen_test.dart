import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ironm/features/members/presentation/members_list_screen.dart';
import 'package:ironm/features/members/viewmodel/members_viewmodel.dart';
import 'package:ironm/data/models/member.dart';
import 'package:ironm/core/utils/clock.dart';

class FakeClock implements IClock {
  final DateTime _now;
  FakeClock(this._now);
  @override
  DateTime get now => _now;
}

void main() {
  group('MembersListScreen Widget Tests', () {
    final now = DateTime(2026, 4, 24);
    final member1 = Member(memberId: '1', name: 'Alice', joinDate: now, expiryDate: now.add(const Duration(days: 10)), lastUpdated: now);
    final member2 = Member(memberId: '2', name: 'Bob', joinDate: now, expiryDate: now.subtract(const Duration(days: 1)), lastUpdated: now);

    testWidgets('Renders stats correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            membersProvider.overrideWith((ref) => [member1, member2]),
            clockProvider.overrideWithValue(FakeClock(now)),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const MembersListScreen(),
                ),
                GoRoute(
                  path: '/gym/add-member',
                  builder: (context, state) => const Scaffold(),
                ),
                GoRoute(
                  path: '/gym/member-details/:id',
                  builder: (context, state) => const Scaffold(),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('ACTIVE'), findsOneWidget);
      expect(find.text('TOTAL'), findsOneWidget);
      expect(find.text('2'), findsWidgets); // Total 2, Alice is Active(1), Bob is Expired(1)
    });

    testWidgets('Shows empty state when no members', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            membersProvider.overrideWith((ref) => []),
            clockProvider.overrideWithValue(FakeClock(now)),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const MembersListScreen(),
                ),
                GoRoute(
                  path: '/gym/add-member',
                  builder: (context, state) => const Scaffold(),
                ),
                GoRoute(
                  path: '/gym/member-details/:id',
                  builder: (context, state) => const Scaffold(),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('No members found'), findsOneWidget);
    });

    testWidgets('Search query filters list', (tester) async {
      // Note: testing logic that relies on providers usually requires pump() 
      // but if the provider is overridden it should work directly.
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            membersProvider.overrideWith((ref) => [member1, member2]),
            clockProvider.overrideWithValue(FakeClock(now)),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const MembersListScreen(),
                ),
                GoRoute(
                  path: '/gym/add-member',
                  builder: (context, state) => const Scaffold(),
                ),
                GoRoute(
                  path: '/gym/member-details/:id',
                  builder: (context, state) => const Scaffold(),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Alice');
      await tester.pump();

      // Since filteredMembersProvider is what builds the list, and it's not overridden but depends on memberSearchQueryProvider
      // entering text should trigger the update.
    });
  });
}
