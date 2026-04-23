// ═══════════════════════════════════════════════════════════════════
// 🔒 LOCKED — RecordPaymentScreen | Verified: 2026-04-24 | DO NOT EDIT
// ═══════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/repositories/plan_repository.dart';
import '../../../data/models/plan.dart';
import '../../../data/models/payment.dart';
import '../viewmodel/payments_viewmodel.dart';

class RecordPaymentScreen extends ConsumerStatefulWidget {
  final String memberId;
  const RecordPaymentScreen({super.key, required this.memberId});

  @override
  ConsumerState<RecordPaymentScreen> createState() => _RecordPaymentScreenState();
}

class _RecordPaymentScreenState extends ConsumerState<RecordPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  Plan? _selectedPlan;
  String _method = 'Cash';
  final _referenceCtrl = TextEditingController();
  bool _isSaving = false;

  static const _methods = ['Cash', 'UPI', 'Card', 'Cheque', 'Other'];

  @override
  void dispose() {
    _referenceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(planRepositoryProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg2,
        title: const Text('Record Payment',
            style: TextStyle(color: AppColors.textPrimary)),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder<List<Plan>>(
        future: (plansAsync as dynamic).getAll(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.orange));
          }
          final plans = (snap.data ?? []).where((p) => p.active).toList();
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // ── Plan selector ────────────────────────────────
                const _SectionLabel('Select Plan'),
                const SizedBox(height: 10),
                if (plans.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.bg3,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Text(
                      'No active plans found. Add a plan in Settings → Plans.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  )
                else
                  ...plans.map((p) => _PlanTile(
                        plan: p,
                        selected: _selectedPlan?.id == p.id,
                        onTap: () => setState(() => _selectedPlan = p),
                      )),
                const SizedBox(height: 24),

                // ── Amount preview ───────────────────────────────
                if (_selectedPlan != null) ...[
                  const _SectionLabel('Payment Summary'),
                  const SizedBox(height: 10),
                  _SummaryCard(plan: _selectedPlan!),
                  const SizedBox(height: 24),
                ],

                // ── Payment method ───────────────────────────────
                const _SectionLabel('Payment Method'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: _methods.map((m) {
                    final sel = m == _method;
                    return ChoiceChip(
                      label: Text(m),
                      selected: sel,
                      selectedColor: AppColors.orange,
                      backgroundColor: AppColors.bg3,
                      labelStyle: TextStyle(
                        color: sel ? Colors.white : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) => setState(() => _method = m),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // ── Reference (optional) ──────────────────────────
                TextFormField(
                  controller: _referenceCtrl,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Reference / UTR (optional)',
                    labelStyle: const TextStyle(color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.bg3,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Save button ───────────────────────────────────
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _isSaving || _selectedPlan == null ? null : _submit,
                    child: _isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5),
                          )
                        : const Text('Confirm Payment',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _submit() async {
    if (_selectedPlan == null) return;
    setState(() => _isSaving = true);
    try {
      final plan = _selectedPlan!;
      final total = plan.totalPrice;
      const gstRate = 18.0;
      final gst = (total * gstRate / 100);
      final subtotal = total - gst;

      await ref.read(recordPaymentNotifierProvider.notifier).recordPayment(
            memberId: widget.memberId,
            amount: total,
            method: _method,
            planId: plan.id,
            planName: plan.name,
            durationMonths: plan.durationMonths,
            subtotal: subtotal,
            gstAmount: gst,
            gstRate: gstRate,
            reference: _referenceCtrl.text.trim().isEmpty
                ? null
                : _referenceCtrl.text.trim(),
            components: plan.components
                .map((c) => PlanComponentSnapshot(name: c.name, price: c.price))
                .toList(),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment recorded successfully'),
            backgroundColor: AppColors.active,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.expired,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: const TextStyle(
            color: AppColors.orange,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2),
      );
}

class _PlanTile extends StatelessWidget {
  final Plan plan;
  final bool selected;
  final VoidCallback onTap;
  const _PlanTile({required this.plan, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.orange.withValues(alpha: 0.12) : AppColors.bg3,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? AppColors.orange : AppColors.border, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan.name,
                      style: TextStyle(
                          color: selected
                              ? AppColors.orange
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  const SizedBox(height: 3),
                  Text('${plan.durationMonths} month(s)',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            Text(
              '₹${plan.totalPrice.toStringAsFixed(0)}',
              style: TextStyle(
                  color: selected ? AppColors.orange : AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(width: 8),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppColors.orange : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final Plan plan;
  const _SummaryCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    final total = plan.totalPrice;
    const gstRate = 18.0;
    final gst = total * gstRate / 100;
    final subtotal = total - gst;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bg3,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', '₹${subtotal.toStringAsFixed(2)}'),
          const Divider(color: AppColors.border, height: 20),
          _buildSummaryRow('GST (${gstRate.toStringAsFixed(0)}%)', '₹${gst.toStringAsFixed(2)}'),
          const Divider(color: AppColors.border, height: 20),
          _buildSummaryRow('Total', '₹${total.toStringAsFixed(2)}', bold: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String l, String v, {bool bold = false}) => Row(
        children: [
          Text(l,
              style: TextStyle(
                  color: bold ? AppColors.textPrimary : AppColors.textSecondary,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                  fontSize: bold ? 15 : 13)),
          const Spacer(),
          Text(v,
              style: TextStyle(
                  color: bold ? AppColors.orange : AppColors.textPrimary,
                  fontWeight: bold ? FontWeight.bold : FontWeight.w600,
                  fontSize: bold ? 15 : 13)),
        ],
      );
}

