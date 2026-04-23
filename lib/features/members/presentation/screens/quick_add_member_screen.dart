import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/notifiers/members_notifier.dart';
import '../../../../shared/widgets/status_bar_wrapper.dart';

class QuickAddMemberScreen extends ConsumerStatefulWidget {
  const QuickAddMemberScreen({super.key});

  @override
  ConsumerState<QuickAddMemberScreen> createState() => _QuickAddMemberScreenState();
}

class _QuickAddMemberScreenState extends ConsumerState<QuickAddMemberScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedPlan = 'Monthly';
  double _planPrice = 1298;
  String _paymentMethod = 'UPI';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.bg),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: StatusBarWrapper(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    _buildFormField('Full Name', _nameController, 'Ravi Kumar', isFocused: true),
                    _buildFormField('Phone Number', _phoneController, '+91 99887 76655'),
                    _buildDateReadOnlyField('Join Date', DateFormat('dd MMM yyyy').format(DateTime.now())),
                    _buildPlanSelection(),
                    _buildPlanSummary(),
                    _buildPaymentMethodSelection(),
                    const SizedBox(height: 16),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
      child: Row(
        children: [
          _buildIconButton(Icons.chevron_left, () => context.pop()),
          const SizedBox(width: 8),
          Text('Add Member', style: AppTextStyles.h2.copyWith(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.bg3,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 16, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildFormField(String label, TextEditingController controller, String hint, {bool isFocused = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: AppTextStyles.label.copyWith(fontSize: 9, color: AppColors.textSecondary, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            style: AppTextStyles.body.copyWith(fontSize: 11),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.label.copyWith(fontSize: 11, color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.bg3,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: isFocused ? AppColors.orange : AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.orange),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: AppTextStyles.label.copyWith(fontSize: 9, color: AppColors.textSecondary, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.bg3,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(value, style: AppTextStyles.body.copyWith(fontSize: 11, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanSelection() {
    final plans = [
      {'label': 'Monthly ₹1,298', 'price': 1298.0},
      {'label': 'Quarterly ₹3,540', 'price': 3540.0},
      {'label': 'Half-Year ₹6,490', 'price': 6490.0},
      {'label': 'Annual ₹11,800', 'price': 11800.0},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SELECT PLAN', style: AppTextStyles.label.copyWith(fontSize: 9, color: AppColors.textSecondary, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: plans.map((p) {
              final isSelected = _selectedPlan == p['label'].toString().split(' ')[0];
              return GestureDetector(
                onTap: () => setState(() {
                  _selectedPlan = p['label'].toString().split(' ')[0];
                  _planPrice = p['price'] as double;
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.orange.withOpacity(0.1) : AppColors.bg3,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isSelected ? AppColors.orange : AppColors.border),
                  ),
                  child: Text(
                    p['label'] as String,
                    style: TextStyle(
                      color: isSelected ? AppColors.orange : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 9,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanSummary() {
    final subtotal = _planPrice / 1.18;
    final gst = _planPrice - subtotal;
    final expiryDate = DateTime.now().add(const Duration(days: 30));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.orange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.orange.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PLAN SUMMARY', style: AppTextStyles.label.copyWith(fontSize: 9, color: AppColors.orange, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
          const SizedBox(height: 5),
          _buildSummaryRow('Gym Access + Locker + Steam', '₹${subtotal.toInt()}'),
          _buildSummaryRow('GST 18%', '₹${gst.toInt()}'),
          const Divider(height: 10, color: Color(0x33FF6B2B)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: AppTextStyles.body.copyWith(fontSize: 11, fontWeight: FontWeight.w700)),
              Text('₹${_planPrice.toInt()}', style: AppTextStyles.body.copyWith(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.orange)),
            ],
          ),
          const SizedBox(height: 3),
          Text('Expires: ${DateFormat('dd MMM yyyy').format(expiryDate)}', style: AppTextStyles.label.copyWith(fontSize: 9, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.label.copyWith(fontSize: 9, color: AppColors.textSecondary)),
          Text(value, style: AppTextStyles.label.copyWith(fontSize: 9, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelection() {
    final methods = ['Cash', 'UPI', 'Card', 'Bank'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PAYMENT METHOD', style: AppTextStyles.label.copyWith(fontSize: 9, color: AppColors.textSecondary, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Row(
            children: methods.map((m) {
              final isSelected = _paymentMethod == m;
              return GestureDetector(
                onTap: () => setState(() => _paymentMethod = m),
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.orange.withOpacity(0.1) : AppColors.bg3,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isSelected ? AppColors.orange : AppColors.border),
                  ),
                  child: Text(
                    m,
                    style: TextStyle(
                      color: isSelected ? AppColors.orange : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 9,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              ref.read(membersProvider.notifier).addMember(
                name: _nameController.text,
                phone: _phoneController.text,
                planName: _selectedPlan,
                planPrice: _planPrice,
                paymentMethod: _paymentMethod,
              );
              context.pop();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 11),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          ),
          child: const Text('Register Member & Generate Invoice', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}
