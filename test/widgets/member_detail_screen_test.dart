import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironm/data/models/member.dart';
import 'package:ironm/data/models/payment.dart';
import 'package:ironm/features/members/presentation/member_detail_screen.dart';
import 'package:ironm/features/members/viewmodel/members_viewmodel.dart';
import 'package:ironm/features/payments/viewmodel/payments_viewmodel.dart';
import 'package:ironm/features/attendance/viewmodel/attendance_viewmodel.dart';
import 'package:ironm/data/models/attendance.dart';

Member createTestMember({required String name, DateTime? expiryDate, bool archived = false}) {
  return Member(
    memberId: 'm1',
    name: name,
    joinDate: DateTime.now().subtract(const Duration(days: 30)),
    expiryDate: expiryDate,
    lastUpdated: DateTime.now(),
    archived: archived,
    phone: '1234567890',
  );
}

void main() {
  group('MemberDetailScreen Widget Tests', () {
    testWidgets('Renders member name and phone in appbar', (tester) async {
      final member = createTestMember(name: 'John Doe');
      
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            membersProvider.overrideWithValue([member]),
            memberPaymentsProvider(member.memberId).overrideWithValue([]),
            memberAttendanceProvider(member.memberId).overrideWith((ref) => Stream.value([])),
          ],
          child: MaterialApp(
            home: MemberDetailScreen(memberId: member.memberId),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('1234567890'), findsOneWidget);
    });

    testWidgets('Status badge shows "Expired" text for expired member', (tester) async {
      final member = createTestMember(
        name: 'John Doe',
        expiryDate: DateTime.now().subtract(const Duration(days: 1)),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            membersProvider.overrideWithValue([member]),
            memberPaymentsProvider(member.memberId).overrideWithValue([]),
            memberAttendanceProvider(member.memberId).overrideWith((ref) => Stream.value([])),
          ],
          child: MaterialApp(
            home: MemberDetailScreen(memberId: member.memberId),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Expired'), findsOneWidget);
    });

    testWidgets('Shows "No payment history" when no payments', (tester) async {
      final member = createTestMember(name: 'John Doe');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            membersProvider.overrideWithValue([member]),
            memberPaymentsProvider(member.memberId).overrideWithValue([]),
            memberAttendanceProvider(member.memberId).overrideWith((ref) => Stream.value([])),
          ],
          child: MaterialApp(
            home: MemberDetailScreen(memberId: member.memberId),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('No payment history'), findsOneWidget);
    });
  });
}
