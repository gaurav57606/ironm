import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../members/viewmodel/members_viewmodel.dart';
import '../viewmodel/payments_viewmodel.dart';
import '../../../data/models/payment.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

// ✅ LOCKED SCREEN — RecordPaymentScreen
class RecordPaymentScreen extends ConsumerStatefulWidget {
  final int memberId;
  const RecordPaymentScreen({super.key, required this.memberId});

  @override
  ConsumerState<RecordPaymentScreen> createState() => _RecordPaymentScreenState();
}

class _RecordPaymentScreenState extends ConsumerState<RecordPaymentScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Record Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AppTextField(
              controller: _amountController,
              label: 'Amount',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _noteController,
              label: 'Note (Optional)',
            ),
            const Spacer(),
            AppButton(
              text: 'Save Payment',
              onPressed: () async {
                final amount = double.tryParse(_amountController.text) ?? 0;
                if (amount <= 0) return;

                final payment = Payment()
                  ..memberId = widget.memberId
                  ..amount = amount
                  ..paymentDate = DateTime.now()
                  ..note = _noteController.text;

                await ref.read(paymentsViewModelProvider.notifier).recordPayment(payment);
                if (mounted) context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
