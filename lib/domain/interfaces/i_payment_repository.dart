import '../../data/models/payment.dart';

abstract class IPaymentRepository {
  Future<List<Payment>> getAllPayments();
  Future<int> recordPayment(Payment payment);
  Future<List<Payment>> getPaymentsByMember(int memberId);
}
