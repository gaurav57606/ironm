import 'package:rxdart/rxdart.dart';
import '../../../core/providers/web_data_store.dart';
import '../../models/sale.dart';
import '../../models/invoice_sequence.dart';
import '../sale_repository.dart';

class WebSaleRepository implements ISaleRepository {
  final WebDataStore _store;
  static const String _collection = 'sales';
  static const String _sequenceCollection = 'invoice_sequences';
  final _subject = BehaviorSubject<List<Sale>>();

  WebSaleRepository(this._store) {
    _init();
  }

  Future<void> _init() async {
    final list = await getAll();
    _subject.add(list);
  }

  @override
  Future<List<Sale>> getAll() async {
    final data = await _store.getAll(_collection);
    final list = data.map((e) => Sale.fromJson(e)).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Stream<List<Sale>> watchAll() => _subject.stream;

  @override
  Future<void> save(Sale sale) async {
    await _store.save(_collection, sale.id, sale.toJson());
    final list = await getAll();
    _subject.add(list);
  }

  @override
  Future<List<Sale>> getByDateRange(DateTime start, DateTime end) async {
    final all = await getAll();
    return all.where((s) => s.date.isAfter(start) && s.date.isBefore(end)).toList();
  }

  @override
  Future<InvoiceSequence> getNextInvoiceSequence(String prefix) async {
    final data = await _store.get(_sequenceCollection, prefix);
    if (data == null) {
      final seq = InvoiceSequence(prefix: prefix);
      await updateInvoiceSequence(seq);
      return seq;
    }
    return InvoiceSequence.fromJson(data);
  }

  @override
  Future<void> updateInvoiceSequence(InvoiceSequence sequence) async {
    await _store.save(_sequenceCollection, sequence.prefix, sequence.toJson());
  }
}
