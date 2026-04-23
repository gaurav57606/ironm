import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/status_bar_wrapper.dart';
import '../viewmodel/members_viewmodel.dart';
import '../../payments/viewmodel/payments_viewmodel.dart';
import '../../attendance/viewmodel/attendance_viewmodel.dart';
import '../../../data/models/member.dart';
import '../../../data/models/payment.dart';
import '../../../data/models/attendance.dart';
import '../../../core/utils/date_formatter.dart';
import 'renew_dialog.dart';


class MemberDetailScreen extends ConsumerStatefulWidget {
  final String memberId;
  const MemberDetailScreen({super.key, required this.memberId});

  @override
  ConsumerState<MemberDetailScreen> createState() => _MemberDetailScreenState();
}

class _MemberDetailScreenState extends ConsumerState<MemberDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);
    final member = members.firstWhereOrNull((m) => m.memberId == widget.memberId);

    if (member == null) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
          child: Text('Member not found', style: AppTextStyles.h2),
        ),
      );
    }

    final payments = ref.watch(memberPaymentsProvider(member.memberId));
    final attendanceAsync = ref.watch(memberAttendanceProvider(member.memberId));

    final now = DateTime.now();
    final daysRemaining = member.getDaysRemaining(now);
    final bool isExpired = daysRemaining < 0;
    final bool isExpiring = daysRemaining >= 0 && daysRemaining <= 7;
    final Color statusColor = isExpired ? AppColors.expired : (isExpiring ? AppColors.expiring : AppColors.active);

    return Container(
      decoration: const BoxDecoration(color: AppColors.bg),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: StatusBarWrapper(
          child: Column(
            children: [
              _buildAppBar(context, member, statusColor, daysRemaining),
              _buildActionRow(context, member),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    _buildSectionHeader('Subscription'),
                    _buildSubscriptionCard(member, statusColor, daysRemaining),
                    _buildSectionHeader('Plan Includes'),
                    _buildPlanIncludesCard(member),
                    _buildSectionHeader('Payment History'),
                    _buildActivityHistory(payments, attendanceAsync),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Member member, Color statusColor, int days) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
      child: Row(
        children: [
          _buildIconButton(Icons.chevron_left, () => context.pop()),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              member.name.substring(0, 1).toUpperCase(),
              style: TextStyle(color: statusColor, fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name, style: AppTextStyles.h3.copyWith(fontSize: 14)),
                Text(member.phone ?? '', style: AppTextStyles.label.copyWith(fontSize: 10, color: AppColors.textSecondary)),
              ],
            ),
          ),
          _buildStatusBadge(statusColor, days),
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

  Widget _buildStatusBadge(Color color, int days) {
    String label = days < 0 ? 'Expired' : (days <= 7 ? '$days days' : '${days}d left');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 4, height: 4, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 3),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildActionRow(BuildContext context, Member member) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        children: [
          Expanded(child: _buildActionButton('Generate Invoice', true, () => context.push('/gym/member-details/${member.memberId}/invoice'))),
          const SizedBox(width: 6),
          Expanded(child: _buildActionButton('Renew', false, () => showDialog(context: context, builder: (ctx) => RenewDialog(member: member)))),
          const SizedBox(width: 6),
          Expanded(child: _buildActionButton('WhatsApp', false, () {})),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, bool isPrimary, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.orange : AppColors.bg3,
          borderRadius: BorderRadius.circular(9),
          border: isPrimary ? null : Border.all(color: AppColors.border),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isPrimary ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 9,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 24, 14, 7),
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

  Widget _buildSubscriptionCard(Member member, Color statusColor, int days) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.bg3,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildInfoRow('Plan', member.planName ?? 'Monthly Plan'),
          const Divider(height: 16, color: AppColors.border),
          _buildInfoRow('Join Date', DateFormatter.format(member.joinDate)),
          const Divider(height: 16, color: AppColors.border),
          _buildInfoRow('Expiry', member.expiryDate != null ? DateFormatter.format(member.expiryDate!) : 'No Expiry', valueColor: statusColor),
          const Divider(height: 16, color: AppColors.border),
          _buildInfoRow('Status', days < 0 ? 'Expired' : 'Active', valueColor: statusColor),
        ],
      ),
    );
  }

  Widget _buildPlanIncludesCard(Member member) {
    final subtotal = (member.planPrice ?? 1298) / 1.18;
    final gst = (member.planPrice ?? 1298) - subtotal;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.bg3,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildInfoRow('Gym Access', '₹${subtotal.toInt()}'),
          const Divider(height: 16, color: AppColors.border),
          _buildInfoRow('GST 18%', '₹${gst.toInt()}'),
          const Divider(height: 16, color: AppColors.border),
          _buildInfoRow('Total', '₹${(member.planPrice ?? 1298).toInt()}', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String key, String value, {Color? valueColor, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(key, style: AppTextStyles.label.copyWith(fontSize: 10, color: AppColors.textSecondary)),
        Text(
          value,
          style: AppTextStyles.label.copyWith(
            fontSize: isTotal ? 13 : 10,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            color: isTotal ? AppColors.orange : (valueColor ?? AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityHistory(List<Payment> payments, AsyncValue<List<Attendance>> attendanceAsync) {
    return attendanceAsync.when(
      loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
      error: (e, s) => const Center(child: Text('Error loading activity')),
      data: (attendance) {
        final sortedPayments = [...payments]..sort((a, b) => b.date.compareTo(a.date));
        
        if (sortedPayments.isEmpty) {
          return Center(child: Padding(padding: const EdgeInsets.all(20), child: Text('No payment history', style: AppTextStyles.label)));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: sortedPayments.map((p) => _buildTimelineItem(p)).toList(),
          ),
        );
      },
    );
  }

  Widget _buildTimelineItem(Payment payment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: AppColors.orange, shape: BoxShape.circle),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.border,
              ),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Monthly Renewal', style: AppTextStyles.label.copyWith(fontSize: 11, fontWeight: FontWeight.w600)),
                Text(
                  '${DateFormatter.format(payment.date)} · ${payment.method.toUpperCase()} · #${payment.invoiceNumber.substring(0, 4)}',
                  style: AppTextStyles.label.copyWith(fontSize: 9, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 1),
                Text('₹${payment.amount.toInt()}', style: AppTextStyles.label.copyWith(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.orange)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

