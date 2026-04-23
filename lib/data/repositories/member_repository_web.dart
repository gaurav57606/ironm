import '../models/member.dart';

class MemberRepository {
  final List<Member> _members = [];

  Future<List<Member>> getAllMembers() async => _members;
  Future<List<Member>> getActiveMembers() async => _members.where((m) => m.isActive).toList();
  Future<Member?> getMemberById(int id) async => _members.firstWhere((m) => m.id == id, orElse: () => throw Exception('Not found'));
  
  Future<int> addMember(Member member) async {
    member.id = _members.length + 1;
    _members.add(member);
    return member.id;
  }

  Future<void> updateMember(Member member) async {
    final index = _members.indexWhere((m) => m.id == member.id);
    if (index != -1) _members[index] = member;
  }

  Future<void> deleteMember(int id) async {
    _members.removeWhere((m) => m.id == id);
  }

  Stream<List<Member>> watchAllMembers() => Stream.value(_members);
}
