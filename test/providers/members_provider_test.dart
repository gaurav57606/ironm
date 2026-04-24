import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironm/data/models/member.dart';
import 'package:ironm/data/repositories/member_repository.dart';
import 'package:ironm/features/members/viewmodel/members_viewmodel.dart';
import 'package:ironm/core/providers/database_provider.dart';

class FakeMemberRepository implements IMemberRepository {
  final List<Member> _members = [];

  @override
  Future<List<Member>> getAll() async => _members;

  @override
  Stream<List<Member>> watchAll() => Stream.value(_members);

  @override
  Future<Member?> getById(String memberId) async {
    try {
      return _members.firstWhere((m) => m.memberId == memberId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(Member member) async {
    final index = _members.indexWhere((m) => m.memberId == member.memberId);
    if (index >= 0) {
      _members[index] = member;
    } else {
      _members.add(member);
    }
  }

  @override
  Future<void> delete(String memberId) async {
    _members.removeWhere((m) => m.memberId == memberId);
  }

  @override
  Future<void> reconcile(String memberId) async {}
}

void main() {
  late ProviderContainer container;
  late FakeMemberRepository fakeRepo;

  setUp(() {
    fakeRepo = FakeMemberRepository();
    container = ProviderContainer(
      overrides: [
        memberRepositoryProvider.overrideWithValue(fakeRepo),
        // Mock membersStreamProvider to return our fake list
        membersStreamProvider.overrideWith((ref) => Stream.value(fakeRepo._members)),
      ],
    );
  });

  group('Members Provider Tests', () {
    test('membersProvider returns [] when DB empty', () async {
      // Wait for StreamProvider to emit initial value
      await Future.delayed(Duration.zero);
      final members = container.read(membersProvider);
      expect(members, isEmpty);
    });

    test('After addMember() → membersProvider length increases', () async {
      final member = Member(
        memberId: '1',
        name: 'John Doe',
        joinDate: DateTime.now(),
        lastUpdated: DateTime.now(),
      );
      
      await container.read(membersNotifierProvider.notifier).addMember(member);
      expect(fakeRepo._members.length, 1);
      expect(fakeRepo._members.first.name, 'John Doe');
    });

    test('filteredMembersProvider filters by status', () async {
      final m1 = Member(memberId: 'm1', name: 'Active', joinDate: DateTime.now(), lastUpdated: DateTime.now());
      final m2 = Member(memberId: 'm2', name: 'Expired', joinDate: DateTime.now().subtract(const Duration(days: 60)), lastUpdated: DateTime.now());
      final m3 = Member(memberId: 'm3', name: 'Expiring', joinDate: DateTime.now(), expiryDate: DateTime.now().add(const Duration(days: 1)), lastUpdated: DateTime.now());
      
      fakeRepo._members.addAll([m1, m2, m3]);
      
      container.read(memberTabProvider.notifier).state = 2; // Expiring
      await container.read(membersStreamProvider.future);
      final filtered = container.read(filteredMembersProvider);
      
      expect(filtered.length, 1);
      expect(filtered.first.name, 'Expiring');
    });

    test('filteredMembersProvider filters by search query', () async {
      final m1 = Member(memberId: 'm1', name: 'John Doe', joinDate: DateTime.now(), lastUpdated: DateTime.now());
      final m2 = Member(memberId: 'm2', name: 'Jane Smith', joinDate: DateTime.now(), lastUpdated: DateTime.now());
      
      fakeRepo._members.addAll([m1, m2]);
      
      container.read(memberSearchQueryProvider.notifier).state = 'john';
      await container.read(membersStreamProvider.future);
      final filtered = container.read(filteredMembersProvider);
      
      expect(filtered.length, 1);
      expect(filtered.first.name, 'John Doe');
    });

    test('filteredMembersProvider sorts by expiryDate ASC, nulls last', () async {
      final now = DateTime.now();
      final m1 = Member(memberId: 'm1', name: 'B', joinDate: now, lastUpdated: now, expiryDate: now.add(const Duration(days: 5)));
      final m2 = Member(memberId: 'm2', name: 'A', joinDate: now, lastUpdated: now, expiryDate: now.add(const Duration(days: 20)));
      final m3 = Member(memberId: 'm3', name: 'C', joinDate: now, lastUpdated: now, expiryDate: null);
      
      fakeRepo._members.addAll([m1, m2, m3]);
      
      await container.read(membersStreamProvider.future);
      final filtered = container.read(filteredMembersProvider);
      
      expect(filtered.length, 3);
      expect(filtered[0].memberId, 'm1'); // 5 days (soonest)
      expect(filtered[1].memberId, 'm2'); // 20 days
      expect(filtered[2].memberId, 'm3'); // null (last)
    });
  });
}
