import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/member.dart';
import '../../../data/repositories/member_repository.dart';

part 'members_viewmodel.g.dart';

@riverpod
class MembersViewModel extends _$MembersViewModel {
  @override
  Stream<List<Member>> build() {
    final repo = ref.watch(memberRepositoryProvider);
    return repo.watchAllMembers();
  }

  Future<void> addMember(Member member) async {
    final repo = ref.read(memberRepositoryProvider);
    await repo.addMember(member);
  }

  Future<void> updateMember(Member member) async {
    final repo = ref.read(memberRepositoryProvider);
    await repo.updateMember(member);
  }

  Future<void> deleteMember(int id) async {
    final repo = ref.read(memberRepositoryProvider);
    await repo.deleteMember(id);
  }
}
