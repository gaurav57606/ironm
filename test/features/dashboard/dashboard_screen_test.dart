import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironm/features/dashboard/presentation/dashboard_screen.dart';
import 'package:ironm/features/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:ironm/features/members/viewmodel/members_viewmodel.dart';
import 'package:ironm/data/models/member.dart';

void main() {
  testWidgets('DashboardScreen shows stats correctly', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          membersStreamProvider.overrideWith((ref) => Stream.value([
            for (int i = 0; i < 100; i++) 
              Member(memberId: 'm$i', name: 'M', joinDate: DateTime.now(), lastUpdated: DateTime.now())
          ])),
          dashboardStatsProvider.overrideWith((ref) => Stream.value(
            const DashboardStats(
              totalMembers: 100,
              activeMembers: 80,
              expiringMembers: 5,
              monthlyRevenue: 5000.0,
            ),
          )),
        ],
        child: const MaterialApp(home: DashboardScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('100'), findsAtLeast(1));
    expect(find.text('80'), findsAtLeast(1));
    expect(find.text('5'), findsAtLeast(1));
  });
}
