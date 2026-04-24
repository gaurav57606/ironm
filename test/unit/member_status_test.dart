import 'package:flutter_test/flutter_test.dart';
import 'package:ironm/data/models/member.dart';

void main() {
  group('Member Status Tests', () {
    final now = DateTime(2026, 4, 24);

    test('expiryDate = 30 days future → MemberStatus.active', () {
      final member = Member(
        memberId: '1',
        name: 'John',
        joinDate: now,
        expiryDate: now.add(const Duration(days: 30)),
        lastUpdated: now,
      );
      expect(member.getStatus(now), MemberStatus.active);
    });

    test('expiryDate = 6 days future → MemberStatus.expiring', () {
      final member = Member(
        memberId: '1',
        name: 'John',
        joinDate: now,
        expiryDate: now.add(const Duration(days: 6)),
        lastUpdated: now,
      );
      expect(member.getStatus(now), MemberStatus.expiring);
    });

    test('expiryDate = 0 days (today) → MemberStatus.expiring', () {
      final member = Member(
        memberId: '1',
        name: 'John',
        joinDate: now,
        expiryDate: now,
        lastUpdated: now,
      );
      expect(member.getStatus(now), MemberStatus.expiring);
    });

    test('expiryDate = yesterday → MemberStatus.expired', () {
      final member = Member(
        memberId: '1',
        name: 'John',
        joinDate: now.subtract(const Duration(days: 2)),
        expiryDate: now.subtract(const Duration(days: 1)),
        lastUpdated: now,
      );
      expect(member.getStatus(now), MemberStatus.expired);
    });

    test('expiryDate = null → MemberStatus.expired', () {
      final member = Member(
        memberId: '1',
        name: 'John',
        joinDate: now,
        expiryDate: null,
        lastUpdated: now,
      );
      expect(member.getStatus(now), MemberStatus.expired);
    });

    test('archived = true → should not affect getStatus()', () {
      final member = Member(
        memberId: '1',
        name: 'John',
        joinDate: now,
        expiryDate: now.add(const Duration(days: 30)),
        lastUpdated: now,
        archived: true,
      );
      expect(member.getStatus(now), MemberStatus.active);
    });
  });
}
