import 'package:rxdart/rxdart.dart';
import '../../../core/providers/web_data_store.dart';
import '../../models/payment.dart';
import '../../models/invoice_sequence.dart';
import '../payment_repository.dart';

class WebPaymentRepository implements IPaymentRepository {
  final WebDataStore _store;
  static const String _collection = 'payments';
  static const String _sequenceCollection = 'invoice_sequences';
  final _subject = BehaviorSubject<List<Payment>>();

  WebPaymentRepository(this._store) {
    _init();
  }

  Future<void> _init() async {
    final list = await getAll();
    _subject.add(list);
  }

  @override
  Future<List<Payment>> getAll() async {
    final data = await _store.getAll(_collection);
    final payments = data.map((e) => Payment.fromJson(e)).toList();
    payments.sort((a, b) => b.date.compareTo(a.date));
    return payments;
  }

  @override
  Stream<List<Payment>> watchAll() => _subject.stream;

  @override
  Future<void> save(Payment payment) async {
    await _store.save(_collection, payment.id, payment.toJson());
    final list = await getAll();
    _subject.add(list);
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
