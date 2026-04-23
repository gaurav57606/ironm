import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../data/notifiers/plans_notifier.dart';
import '../../../../data/notifiers/payments_notifier.dart';
import '../../../../data/models/member.dart';
import '../../../../data/models/plan.dart';

class RenewDialog extends ConsumerStatefulWidget {
  final Member member;
  const RenewDialog({super.key, required this.member});

  @override
  ConsumerState<RenewDialog> createState() => _RenewDialogState();
}

class _RenewDialogState extends ConsumerState<RenewDialog> {
  Plan? _selectedPlan;
  String _paymentMethod = 'Cash';
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final plans = ref.watch(plansProvider);
    
    return AlertDialog(
      backgroundColor: AppColors.elevation1,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Text('Renew Membership', style: AppTextStyles.h2),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Member: ${widget.member.name}', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Text('SELECT PLAN', style: AppTextStyles.sectionTitle.copyWith(fontSize: 10)),
              const SizedBox(height: 12),
              ...plans.map((plan) => RadioListTile<Plan>(
                value: plan,
                groupValue: _selectedPlan,
                onChanged: (v) => setState(() => _selectedPlan = v),
                title: Text(plan.name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                subtitle: Text('₹${plan.totalPrice.toInt()} · ${plan.durationMonths} Months', style: AppTextStyles.bodySmall),
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
              )),
              const SizedBox(height: 24),
              Text('PAYMENT METHOD', style: AppTextStyles.sectionTitle.copyWith(fontSize: 10)),
              const SizedBox(height: 12),
              Row(
                children: ['Cash', 'UPI', 'Card'].map((m) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(m),
                      selected: _paymentMethod == m,
                      onSelected: (v) => setState(() => _paymentMethod = m),
                      backgroundColor: AppColors.elevation2,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: _paymentMethod == m ? Colors.white : AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isProcessing ? null : () => Navigator.pop(context),
          child: const Text('CANCEL', style: TextStyle(color: AppColors.textMuted)),
        ),
        AppButton(
          text: 'COLLECT',
          width: 120,
          isLoading: _isProcessing,
          onPressed: _selectedPlan == null || _isProcessing ? null : _handleRenew,
        ),
      ],
    );
  }

  Future<void> _handleRenew() async {
    setState(() => _isProcessing = true);
    try {
      await ref.read(paymentsProvider.notifier).recordMemberPayment(
        memberId: widget.member.memberId,
        plan: _selectedPlan!,
        method: _paymentMethod,
      );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Membership Renewed Successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.expired),
        );
      }
    }
  }
}
