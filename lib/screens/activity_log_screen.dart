import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../core/constants/ac_colors.dart';
import '../core/constants/ac_text_styles.dart';
import '../core/constants/ac_strings.dart';
import '../models/entitlement_record.dart';
import '../providers/entitlements_provider.dart';

class ActivityLogScreen extends ConsumerWidget {
  const ActivityLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(allEntitlementsProvider);

    return Scaffold(
      backgroundColor: AcColors.bg,
      body: SafeArea(
        child: recordsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AcColors.primary),
          ),
          error: (e, _) => Center(
            child: Text(
              'Error loading logs: $e',
              style: AcTextStyles.bodySecondary,
            ),
          ),
          data: (list) => _buildActivityLog(context, ref, list),
        ),
      ),
    );
  }

  Widget _buildActivityLog(BuildContext context, WidgetRef ref, List<EntitlementRecord> list) {
    // ── REVENUE SNAPSHOT CALCULATIONS ──
    int monthlyCount = 0;
    int quarterlyCount = 0;
    int biannualCount = 0;
    int yearlyCount = 0;
    double monthlyRevenue = 0.0;
    double annualRevenueYTD = 0.0;

    for (final r in list) {
      if (r.status == 'active' && !r.killSwitchActive) {
        switch (r.planId.toLowerCase()) {
          case 'monthly':
            monthlyCount++;
            monthlyRevenue += 499.0;
            annualRevenueYTD += 499.0 * 5.5; // Estimated 5.5 months YTD
            break;
          case 'quarterly':
            quarterlyCount++;
            monthlyRevenue += 1299.0 / 3;
            annualRevenueYTD += 1299.0 * 1.8;
            break;
          case 'biannual':
            biannualCount++;
            monthlyRevenue += 2499.0 / 6;
            annualRevenueYTD += 2499.0;
            break;
          case 'yearly':
          case 'annual':
            yearlyCount++;
            monthlyRevenue += 4999.0 / 12;
            annualRevenueYTD += 4999.0;
            break;
          default:
            monthlyCount++;
            monthlyRevenue += 499.0;
            annualRevenueYTD += 499.0 * 5.5;
        }
      }
    }

    final totalActive = list.where((r) => r.status == 'active' && !r.killSwitchActive).length;
    final avgDealSize = totalActive == 0 ? 0.0 : (monthlyCount * 499.0 + quarterlyCount * 1299.0 + biannualCount * 2499.0 + yearlyCount * 4999.0) / totalActive;
    final paidInvoices = totalActive;
    final totalInvoices = list.length;
    final overdue = list.where((r) => r.isEffectivelyExpired && !r.killSwitchActive).length;

    return RefreshIndicator(
      color: AcColors.primary,
      backgroundColor: AcColors.s2,
      onRefresh: () async {
        ref.invalidate(allEntitlementsProvider);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // ── TOP SECTION ──
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last 7 days · ${list.length} events',
                      style: AcTextStyles.subtext.copyWith(
                        fontSize: 12,
                        color: AcColors.textMuted,
                      ),
                    ),
                    Text(
                      'Activity Log',
                      style: AcTextStyles.h2.copyWith(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── REVENUE SNAPSHOT CARD ──
          Row(
            children: [
              Text('Revenue Snapshot', style: AcTextStyles.h3),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: AcColors.s2,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AcColors.rim, width: 1),
                ),
                child: Text(
                  'This Month',
                  style: AcTextStyles.subtext.copyWith(
                    color: AcColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AcColors.s1,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AcColors.rim2, width: 1),
            ),
            child: Column(
              children: [
                _buildSnapshotRow('Monthly Revenue', '₹${NumberFormat('#,##,###').format(monthlyRevenue.toInt())}', isBrand: true),
                _buildSnapshotRow('Annual Revenue (YTD)', '₹${(annualRevenueYTD / 100000.0).toStringAsFixed(1)}L', isBrand: true),
                _buildSnapshotRow('Avg Deal Size', '₹${NumberFormat('#,##,###').format(avgDealSize.toInt())}'),
                _buildSnapshotRow('Paid Invoices', '$paidInvoices / $totalInvoices', valColor: AcColors.active),
                _buildSnapshotRow('Overdue', '$overdue invoices', valColor: overdue > 0 ? AcColors.expired : AcColors.textPrimary, isLast: true),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── EVENT LOG ──
          Text('Event Log', style: AcTextStyles.h3),
          const SizedBox(height: 10),

          if (list.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  AcStrings.noSubscribers,
                  style: AcTextStyles.bodySecondary,
                ),
              ),
            )
          else
            ...list.map((record) => _buildLogItem(context, record)),
        ],
      ),
    );
  }

  Widget _buildSnapshotRow(
    String label,
    String value, {
    bool isBrand = false,
    Color? valColor,
    bool isLast = false,
  }) {
    final textColor = isBrand
        ? AcColors.primary
        : valColor ?? AcColors.textPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AcColors.rim, width: 1)),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: AcTextStyles.body.copyWith(
              color: AcColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AcTextStyles.mono(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogItem(BuildContext context, EntitlementRecord record) {
    IconData icon = Icons.info_outline;
    Color color = AcColors.blue;
    String title = '';
    String subtitle = '';
    String time = '1d';

    final now = DateTime.now();
    final difference = now.difference(record.createdAt).inMinutes;

    if (record.killSwitchActive) {
      icon = Icons.lock_person_outlined;
      color = AcColors.expired;
      title = '${record.ownerName} locked out';
      subtitle = 'Payment failure · System auto-lock';
      time = '1h';
    } else if (record.status == 'suspended') {
      icon = Icons.pause_circle_outline_rounded;
      color = AcColors.expired;
      title = '${record.ownerName} account suspended';
      subtitle = 'Manual Admin Suspension active';
      time = '3h';
    } else if (record.isExpiringSoon) {
      icon = Icons.warning_amber_rounded;
      color = AcColors.warning;
      title = 'Announcement alert: ${record.businessName}';
      subtitle = '${record.daysUntilExpiry} days remaining · Reminders queued';
      time = '2h';
    } else if (record.planId == 'yearly' || record.planId == 'annual') {
      icon = Icons.check_circle_outline_rounded;
      color = AcColors.active;
      title = '₹4,999 payment received';
      subtitle = '${record.ownerName} · Annual renewal completed';
      time = difference < 60 ? '${difference}m' : '${difference ~/ 60}h';
    } else {
      icon = Icons.add_circle_outline_rounded;
      color = AcColors.blue;
      title = 'New signup: ${record.ownerName}';
      subtitle = 'Trial started · ${record.businessName}';
      time = difference < 60 ? '${difference}m' : '${difference ~/ 60}h';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          context.go('/subscriber/${record.userId}');
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AcColors.s1,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AcColors.rim, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: color,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AcTextStyles.label.copyWith(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: AcTextStyles.bodySmall.copyWith(fontSize: 11.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: AcTextStyles.mono(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                  color: AcColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
