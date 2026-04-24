import '../../../core/providers/web_data_store.dart';
import '../../models/member.dart';
import '../member_repository.dart';
import 'package:rxdart/rxdart.dart';

class WebMemberRepository implements IMemberRepository {
  final WebDataStore _store;
  static const String _collection = 'members';
  final _subject = BehaviorSubject<List<Member>>();

  WebMemberRepository(this._store) {
    _init();
  }

  Future<void> _init() async {
    final list = await getAll();
    _subject.add(list);
  }

  @override
  Future<List<Member>> getAll() async {
    final data = await _store.getAll(_collection);
    return data.map((e) => Member.fromJson(e)).toList();
  }

  @override
  Stream<List<Member>> watchAll() => _subject.stream;

  @override
  Future<Member?> getById(String memberId) async {
    final data = await _store.get(_collection, memberId);
    if (data == null) return null;
    return Member.fromJson(data);
  }

  @override
  Future<void> save(Member member) async {
    await _store.save(_collection, member.memberId, member.toJson());
    final list = await getAll();
    _subject.add(list);
  }

  @override
  Future<void> delete(String memberId) async {
    await _store.delete(_collection, memberId);
    final list = await getAll();
    _subject.add(list);
  }

  @override
  Future<void> reconcile(String memberId) async {
    // Event-based reconciliation not implemented for web fallback yet
  }
}
