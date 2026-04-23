import 'package:isar/isar.dart';
import '../../main.dart';
import '../models/member.dart';

class MemberRepository {
  Future<List<Member>> getAllMembers() async {
    return isar.members.where().findAll();
  }

  Future<List<Member>> getActiveMembers() async {
    return isar.members.filter().isActiveEqualTo(true).findAll();
  }

  Future<Member?> getMemberById(int id) async {
    return isar.members.get(id);
  }

  Future<int> addMember(Member member) async {
    return isar.writeTxn(() => isar.members.put(member));
  }

  Future<void> updateMember(Member member) async {
    await isar.writeTxn(() => isar.members.put(member));
  }

  Future<void> deleteMember(int id) async {
    await isar.writeTxn(() => isar.members.delete(id));
  }

  Stream<List<Member>> watchAllMembers() {
    return isar.members.where().watch(fireImmediately: true);
  }
}
