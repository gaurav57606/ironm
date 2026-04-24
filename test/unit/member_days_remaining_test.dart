import 'package:flutter_test/flutter_test.dart';
import 'package:ironm/data/models/member.dart';

void main() {
  group('Member Days Remaining Tests', () {
    final now = DateTime(2026, 4, 24);

    test('expiryDate exactly 7 days from now → returns 7', () {
      final member = Member(
        memberId: '1',
        name: 'John',
        joinDate: now,
        expiryDate: now.add(const Duration(days: 7)),
        lastUpdated: now,
      );
      expect(member.getDaysRemaining(now), 7);
    });

    test('expiryDate yesterday → returns -1', () {
      final member = Member(
        memberId: '1',
        name: 'John',
        joinDate: now.subtract(const Duration(days: 2)),
        expiryDate: now.subtract(const Duration(days: 1)),
        lastUpdated: now,
      );
      expect(member.getDaysRemaining(now), -1);
    });

    test('expiryDate null → returns -1', () {
      final member = Member(
        memberId: '1',
        name: 'John',
        joinDate: now,
        expiryDate: null,
        lastUpdated: now,
      );
      expect(member.getDaysRemaining(now), -1);
    });
  });
}
