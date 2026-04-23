import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/payment.dart';
import '../../../data/repositories/payment_repository.dart';

part 'payments_viewmodel.g.dart';

@riverpod
class PaymentsViewModel extends _$PaymentsViewModel {
  @override
  Stream<List<Payment>> build() {
    final repo = ref.watch(paymentRepositoryProvider);
    return repo.watchAllPayments();
  }

  Future<void> recordPayment(Payment payment) async {
    final repo = ref.read(paymentRepositoryProvider);
    await repo.addPayment(payment);
  }
}
