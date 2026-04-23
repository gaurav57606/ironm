import 'package:flutter/material.dart';
import '../../../data/models/payment.dart';
import '../../../core/utils/date_utils.dart';

class PaymentTile extends StatelessWidget {
  final Payment payment;

  const PaymentTile({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.payment, color: Colors.green),
      title: Text('₹${payment.amount.toStringAsFixed(2)}'),
      subtitle: Text(AppDateUtils.formatDateTime(payment.paymentDate)),
      trailing: payment.note != null ? const Icon(Icons.note_alt_outlined) : null,
    );
  }
}
