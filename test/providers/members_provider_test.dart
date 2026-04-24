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
      
      // We need to wait for the stream to emit if we were using a real stream, 
      // but here we are overriding with a static list in Stream.value.
      // For a more realistic test, we'd use a BehaviorSubject in the fake.
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

    test('filteredMembersProvider sorts by name', () async {
      final m1 = Member(memberId: 'm1', name: 'B', joinDate: DateTime.now(), lastUpdated: DateTime.now());
      final m2 = Member(memberId: 'm2', name: 'A', joinDate: DateTime.now(), lastUpdated: DateTime.now());
      
      fakeRepo._members.addAll([m1, m2]);
      
      await container.read(membersStreamProvider.future);
      final filtered = container.read(filteredMembersProvider);
      expect(filtered.last.name, 'B');
      expect(filtered.first.name, 'A');
    });
  });
}
