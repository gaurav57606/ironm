import '../../data/models/member.dart';

abstract class IMemberRepository {
  Future<List<Member>> getAllMembers();
  Future<List<Member>> getActiveMembers();
  Future<Member?> getMemberById(int id);
  Future<int> addMember(Member member);
  Future<void> updateMember(Member member);
  Future<void> deleteMember(int id);
  Stream<List<Member>> watchAllMembers();
}
