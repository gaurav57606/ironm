import 'package:isar/isar.dart';
import '../../main.dart';
import '../models/payment.dart';

class PaymentRepository {
  Future<List<Payment>> getAllPayments() async {
    return isar.payments.where().findAll();
  }

  Future<List<Payment>> getPaymentsByMember(int memberId) async {
    return isar.payments.filter().memberIdEqualTo(memberId).findAll();
  }

  Future<int> addPayment(Payment payment) async {
    return isar.writeTxn(() => isar.payments.put(payment));
  }

  Stream<List<Payment>> watchAllPayments() {
    return isar.payments.where().watch(fireImmediately: true);
  }
}
