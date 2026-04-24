import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ironm/features/attendance/presentation/attendance_screen.dart';
import 'package:ironm/features/attendance/viewmodel/attendance_viewmodel.dart';
import 'package:ironm/features/members/viewmodel/members_viewmodel.dart';
import 'package:ironm/data/models/attendance.dart';
import 'package:ironm/data/models/member.dart';

void main() {
  group('AttendanceScreen Widget Tests', () {
    final now = DateTime.now();
    final member = Member(memberId: 'm1', name: 'John Doe', joinDate: now, lastUpdated: now);
    final attendance = Attendance(memberId: 'm1', checkInTime: now);

    testWidgets('Attendance records for today are visible', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            attendanceProvider.overrideWith((ref) => [attendance]),
            membersProvider.overrideWithValue([member]),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const AttendanceScreen(),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.textContaining('Checked in at'), findsOneWidget);
    });

    testWidgets('FAB tap opens check-in bottom sheet', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            attendanceProvider.overrideWith((ref) => []),
            membersProvider.overrideWithValue([member]),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const AttendanceScreen(),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Search member to check in...'), findsOneWidget);
    });
  });
}
