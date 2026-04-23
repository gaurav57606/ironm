import '../../../data/models/member.dart';
import '../../interfaces/i_member_repository.dart';

class AddMemberUseCase {
  final IMemberRepository repository;

  AddMemberUseCase(this.repository);

  Future<int> execute(Member member) async {
    // Business logic/validation before adding
    return repository.addMember(member);
  }
}
