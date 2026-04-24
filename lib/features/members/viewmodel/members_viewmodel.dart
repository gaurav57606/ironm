// ═══════════════════════════════════════════════════════════════════
// 🔒 LOCKED — MembersViewModel | Verified: 2026-04-24 | DO NOT EDIT
// ═══════════════════════════════════════════════════════════════════
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/member.dart';
import '../../../data/models/payment.dart';
import '../../../data/repositories/member_repository.dart';
import '../../../core/providers/database_provider.dart';
import '../../payments/viewmodel/payments_viewmodel.dart';

part 'members_viewmodel.g.dart';


// ── Stream Provider: all members live ──────────────────────────────
final membersStreamProvider = StreamProvider.autoDispose<List<Member>>((ref) {
  final repo = ref.watch(memberRepositoryProvider);
  return repo.watchAll();
});

// Alias for compatibility with older UI
final membersProvider = Provider.autoDispose<List<Member>>((ref) {
  return ref.watch(membersStreamProvider).value ?? [];
});

// ── Search & Filter State ───────────────────────────────────────────
final memberSearchQueryProvider = StateProvider<String>((ref) => '');
final memberTabProvider = StateProvider<int>((ref) => 0); // 0: All, 1: Active, 2: Expiring, 3: Expired

final filteredMembersProvider = Provider.autoDispose<List<Member>>((ref) {
  final members = ref.watch(membersProvider);
  final query = ref.watch(memberSearchQueryProvider).toLowerCase();
  final tabIndex = ref.watch(memberTabProvider);
  
  var filtered = members;
  
  if (query.isNotEmpty) {
    filtered = filtered.where((m) => 
      m.name.toLowerCase().contains(query) || 
      (m.phone?.contains(query) ?? false)
    ).toList();
  }
  
  // Filter by tab
  final now = DateTime.now(); // Ideally use clockProvider
  if (tabIndex == 1) { // Active
    filtered = filtered.where((m) => m.getStatus(now) == MemberStatus.active).toList();
  } else if (tabIndex == 2) { // Expiring
    filtered = filtered.where((m) => m.getStatus(now) == MemberStatus.expiring).toList();
  } else if (tabIndex == 3) { // Expired
    filtered = filtered.where((m) => m.getStatus(now) == MemberStatus.expired).toList();
  }
  
  // Sort by expiry (soonest first)
  filtered.sort((a, b) {
    if (a.expiryDate == null) return 1;
    if (b.expiryDate == null) return -1;
    return a.expiryDate!.compareTo(b.expiryDate!);
  });
  
  return filtered;
});


// ── Single member by memberId ───────────────────────────────────────
final memberByIdProvider =
    FutureProvider.autoDispose.family<Member?, String>((ref, memberId) async {
  final repo = ref.watch(memberRepositoryProvider);
  return repo.getById(memberId);
});

// ── Write Notifier ──────────────────────────────────────────────────
@riverpod
class MembersViewModel extends _$MembersViewModel {

  @override
  FutureOr<void> build() async {}

  Future<void> addMember(Member member) async {
    final repo = ref.read(memberRepositoryProvider);
    await repo.save(member);
  }


  Future<void> updateMember(Member member) async {
    final repo = ref.read(memberRepositoryProvider);
    await repo.save(member);
  }

  Future<void> deleteMember(String memberId) async {
    final repo = ref.read(memberRepositoryProvider);
    await repo.delete(memberId);
  }

  Future<void> archiveMember(String memberId) async {
    final repo = ref.read(memberRepositoryProvider);
    final member = await repo.getById(memberId);
    if (member == null) return;
    member.archived = true;
    member.lastUpdated = DateTime.now();
    await repo.save(member);
  }
}

// Alias for compatibility with older UI
final membersNotifierProvider = membersViewModelProvider;

