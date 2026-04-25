import 'package:rxdart/rxdart.dart';
import '../../../core/providers/web_data_store.dart';
import '../../models/attendance.dart';
import '../attendance_repository.dart';

class WebAttendanceRepository implements IAttendanceRepository {
  final WebDataStore _store;
  static const String _collection = 'attendance';
  final _subject = BehaviorSubject<List<Attendance>>();

  WebAttendanceRepository(this._store) {
    _init();
  }

  Future<void> _init() async {
    final list = await getAll();
    _subject.add(list);
  }

  @override
  Future<List<Attendance>> getAll() async {
    final data = await _store.getAll(_collection);
    final list = data.map((e) => Attendance.fromJson(e)).toList();
    list.sort((a, b) => b.checkInTime.compareTo(a.checkInTime));
    return list;
  }

  @override
  Future<List<Attendance>> getByMember(String memberId) async {
    final all = await getAll();
    return all.where((e) => e.memberId == memberId).toList();
  }

  @override
  Stream<List<Attendance>> watchAll() => _subject.stream;

  @override
  Stream<List<Attendance>> watchMember(String memberId) {
    return _subject.stream.map((list) => list.where((e) => e.memberId == memberId).toList());
  }

  @override
  Future<void> save(Attendance attendance) async {
    await _store.save(_collection, attendance.attendanceId, attendance.toJson());
    final list = await getAll();
    _subject.add(list);
  }
}
