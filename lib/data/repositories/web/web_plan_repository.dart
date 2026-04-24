import 'package:rxdart/rxdart.dart';
import '../../../core/providers/web_data_store.dart';
import '../../models/plan.dart';
import '../plan_repository.dart';

class WebPlanRepository implements IPlanRepository {
  final WebDataStore _store;
  static const String _collection = 'plans';
  final _subject = BehaviorSubject<List<Plan>>();

  WebPlanRepository(this._store) {
    _init();
  }

  Future<void> _init() async {
    final list = await getAll();
    _subject.add(list);
  }

  @override
  Future<List<Plan>> getAll() async {
    final data = await _store.getAll(_collection);
    return data.map((e) => Plan.fromJson(e)).toList();
  }

  @override
  Stream<List<Plan>> watchAll() => _subject.stream;

  @override
  Future<Plan?> getById(String id) async {
    final data = await _store.get(_collection, id);
    if (data == null) return null;
    return Plan.fromJson(data);
  }

  @override
  Future<void> save(Plan plan) async {
    await _store.save(_collection, plan.id, plan.toJson());
    final list = await getAll();
    _subject.add(list);
  }

  @override
  Future<void> delete(String id) async {
    await _store.delete(_collection, id);
    final list = await getAll();
    _subject.add(list);
  }
}
