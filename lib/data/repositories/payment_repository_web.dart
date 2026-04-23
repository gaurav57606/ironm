import '../models/payment.dart';

class PaymentRepository {
  final List<Payment> _payments = [];

  Future<List<Payment>> getAllPayments() async => _payments;
  
  Future<List<Payment>> getPaymentsByMember(int memberId) async {
    return _payments.where((p) => p.memberId == memberId).toList();
  }

  Future<int> addPayment(Payment payment) async {
    payment.id = _payments.length + 1;
    _payments.add(payment);
    return payment.id;
  }

  Stream<List<Payment>> watchAllPayments() => Stream.value(_payments);
}
