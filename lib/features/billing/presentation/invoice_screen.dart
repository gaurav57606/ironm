import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:printing/printing.dart';
import '../../../core/services/invoice_pdf_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../../members/viewmodel/members_viewmodel.dart';
import '../../payments/viewmodel/payments_viewmodel.dart';
import '../../../data/models/member.dart';
import '../../../data/models/payment.dart';
import '../../../data/models/owner_profile.dart';
import '../../../shared/widgets/status_bar_wrapper.dart';

class InvoiceScreen extends ConsumerStatefulWidget {
  final String memberId;
  const InvoiceScreen({super.key, required this.memberId});

  @override
  ConsumerState<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends ConsumerState<InvoiceScreen> {
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    final owner = ref.watch(authProvider).owner;
    final member = ref.watch(membersProvider)
        .firstWhereOrNull((m) => m.memberId == widget.memberId);
    final payments = ref.watch(memberPaymentsProvider(widget.memberId));
    final latestPayment = payments.isNotEmpty ? payments.first : null;

    if (member == null) {
      return const Scaffold(body: Center(child: Text('Member not found')));
    }

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
                    _buildInvoiceCard(member, latestPayment, owner),
                    _buildSectionHeader('Payment Method'),
                    _buildPaymentMethodChips(latestPayment?.method ?? 'Cash'),
                    const SizedBox(height: 20),
                    _buildShareButton(member, latestPayment, owner),
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
          Text('Invoice', style: AppTextStyles.h2.copyWith(fontSize: 16)),
          const Spacer(),
          if (_isGenerating)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                  width: 14, height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else ...[
            _buildIconButton(Icons.download_rounded, () async {
              final owner   = ref.read(authProvider).owner;
              final members = ref.read(membersProvider);
              final member  = members.firstWhereOrNull(
                  (m) => m.memberId == widget.memberId);
              final payments = ref.read(
                  memberPaymentsProvider(widget.memberId));
              final payment  = payments.isNotEmpty ? payments.first : null;
              if (member == null || payment == null) return;
              final bytes = await _generatePdf(member, payment, owner);
              if (bytes == null || !mounted) return;
              await Printing.sharePdf(
                bytes: bytes,
                filename: 'Invoice_${payment.invoiceNumber}.pdf',
              );
            }),
            const SizedBox(width: 6),
            _buildIconButton(Icons.print_rounded, () async {
              final owner   = ref.read(authProvider).owner;
              final members = ref.read(membersProvider);
              final member  = members.firstWhereOrNull(
                  (m) => m.memberId == widget.memberId);
              final payments = ref.read(
                  memberPaymentsProvider(widget.memberId));
              final payment  = payments.isNotEmpty ? payments.first : null;
              if (member == null || payment == null) return;
              final bytes = await _generatePdf(member, payment, owner);
              if (bytes == null || !mounted) return;
              await Printing.layoutPdf(
                onLayout: (_) async => bytes,
                name: 'Invoice_${payment.invoiceNumber}',
              );
            }),
          ],
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
        child: Icon(icon, size: 13, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildInvoiceCard(Member member, Payment? payment, OwnerProfile? owner) {
    if (payment == null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 14),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.bg3,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(child: Text('No payment record found', style: TextStyle(color: AppColors.textSecondary))),
      );
    }

    final components = payment.components;
    final expiryDate = DateTime(payment.date.year, payment.date.month + payment.durationMonths, payment.date.day);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1206), Color(0xFF2A1D0A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(owner?.gymName ?? "IronM Fitness", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.orange)),
                  const SizedBox(height: 2),
                  Text('${owner?.address ?? "Premium Gym Management"} · GSTIN ${owner?.gstin ?? "N/A"}', 
                    style: AppTextStyles.label.copyWith(fontSize: 9, color: AppColors.textSecondary)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('INVOICE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.orange)),
                  Text('#${payment.invoiceNumber}', style: AppTextStyles.label.copyWith(fontSize: 9, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 7), child: Divider(color: AppColors.border)),
          _buildInvRow('Member', member.name),
          _buildInvRow('Date', DateFormat('dd MMM yyyy').format(payment.date)),
          _buildInvRow('Period', '${DateFormat('dd MMM').format(payment.date)} – ${member.expiryDate != null ? DateFormat('dd MMM yyyy').format(member.expiryDate!) : 'N/A'}'),
          const Padding(padding: EdgeInsets.symmetric(vertical: 7), child: Divider(color: AppColors.border)),
          if (components.isNotEmpty)
            ...components.map((c) => _buildInvRow(c.name, '₹${c.price.toStringAsFixed(2)}'))
          else
            _buildInvRow(payment.planName, '₹${payment.subtotal.toStringAsFixed(2)}'),
          const Padding(padding: EdgeInsets.symmetric(vertical: 7), child: Divider(color: AppColors.border)),
          _buildInvRow('Subtotal', '₹${payment.subtotal.toStringAsFixed(2)}'),
          _buildInvRow('GST @ 18% (Inc)', '₹${payment.gstAmount.toStringAsFixed(2)}'),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Paid', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Text('₹${payment.amount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.orange)),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 7), child: Divider(color: AppColors.border)),
          Text('Bank: ${owner?.bankName ?? "N/A"} · A/C ${owner?.accountNumber ?? "N/A"} · IFSC ${owner?.ifsc ?? "N/A"}', 
            style: AppTextStyles.label.copyWith(fontSize: 8, color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Text('Transaction ID: ${payment.id.substring(0, 8).toUpperCase()}', style: AppTextStyles.label.copyWith(fontSize: 8, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _buildInvRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.label.copyWith(fontSize: 9, color: AppColors.textSecondary)),
          Text(value, style: AppTextStyles.label.copyWith(fontSize: 9, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 7),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.label.copyWith(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodChips(String current) {
    final methods = ['Cash', 'UPI', 'Card', 'Bank'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: methods.map((m) => _buildChip(m, m.toLowerCase() == current.toLowerCase())).toList(),
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.orange.withValues(alpha: 0.1) : AppColors.bg3,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isSelected ? AppColors.orange : AppColors.border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.orange : AppColors.textSecondary,
          fontWeight: FontWeight.w600,
          fontSize: 9,
        ),
      ),
    );
  }

  Widget _buildShareButton(Member member, Payment? payment, OwnerProfile? owner) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          if (payment == null) return;
          final text = 'Hello ${member.name}, your payment of ₹${payment.amount.toInt()} for ${payment.planName} was successful. Invoice: #${payment.invoiceNumber}. Thank you for choosing ${owner?.gymName ?? "IronM Fitness"}!';
          Share.share(text);
        },
        icon: const Icon(Icons.share_outlined, size: 13),
        label: const Text('Share via WhatsApp'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Future<Uint8List?> _generatePdf(
      Member member, Payment payment, OwnerProfile? owner) async {
    if (_isGenerating) return null;
    setState(() => _isGenerating = true);
    try {
      final args = {
        'member':  member.toJson(),
        'payment': payment.toJson(),
        'owner':   owner?.toJson(),
      };
      return await compute(InvoicePdfService.generateFromMaps, args);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not generate PDF: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
      return null;
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }
}

