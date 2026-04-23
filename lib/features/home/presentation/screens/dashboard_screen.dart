import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/greeting_formatter.dart';
import '../../../../shared/widgets/status_bar_wrapper.dart';
import '../../../auth/presentation/screens/login_screen.dart'; // For logo asset reference if needed
// MemberStatus enum is now in member.dart
import '../../../../data/models/member.dart';
import '../../../../data/notifiers/members_notifier.dart';
import '../../../../data/notifiers/payments_notifier.dart';
import '../../../../data/notifiers/auth_notifier.dart';

import '../widgets/stats_card.dart';
import '../widgets/member_health_donut.dart';
import '../widgets/alert_banner.dart';
import '../widgets/member_row.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(membersProvider);
    final payments = ref.watch(paymentsProvider);
    final auth = ref.watch(authProvider);
    final clock = ref.watch(clockProvider);
    final now = clock.now;

    int activeCount = 0;
    int expiringCount = 0;
    int expiredCount = 0;
    final expiredMembersList = <Member>[];
    final expiringMembersList = <Member>[];

    for (final m in members) {
      final status = m.getStatus(now);
      switch (status) {
        case MemberStatus.active:
          activeCount++;
          break;
        case MemberStatus.expiring:
          expiringCount++;
          expiringMembersList.add(m);
          break;
        case MemberStatus.expired:
          expiredCount++;
          expiredMembersList.add(m);
          break;
        case MemberStatus.pending:
          break;
      }
    }

    final expiredSummary = expiredMembersList.take(3).map((m) => m.name).join(', ');
    final expiringSummary = expiringMembersList.take(3).map((m) => m.name).join(', ');

    // Calculate revenue this month
    final startOfMonth = DateTime(now.year, now.month, 1);
    final monthlyRevenue = payments
        .where((p) => p.date.isAfter(startOfMonth))
        .fold(0.0, (sum, p) => sum + p.amount);


    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: StatusBarWrapper(
          child: RefreshIndicator(
            onRefresh: () async {
              await ref.read(membersProvider.notifier).refresh();
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(auth)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatsGrid(members.length, activeCount, expiringCount, expiredCount),
                        const SizedBox(height: 20),
                        MemberHealthDonut(
                          active: activeCount,
                          expiring: expiringCount,
                          expired: expiredCount,
                        ),
                        const SizedBox(height: 24),
                        if (expiredCount > 0)
                          AlertBanner(
                            title: '$expiredCount memberships expired',
                            subtitle: '$expiredSummary${expiredCount > 3 ? " +${expiredCount - 3}" : ""}',
                            isError: true,
                          ),
                        if (expiringCount > 0)
                          Padding(
                            padding: EdgeInsets.only(top: expiredCount > 0 ? 8 : 0),
                            child: AlertBanner(
                              title: '$expiringCount expiring in 7 days',
                              subtitle: '$expiringSummary${expiringCount > 3 ? " +${expiringCount - 3}" : ""}',
                              isError: false,
                            ),
                          ),

                        _buildSectionHeader(context, 'DUE TODAY', 'Show all'),
                        _buildDueList(members, now),
                        const SizedBox(height: 32),
                        _buildSectionHeader(context, 'REVENUE THIS MONTH', null),
                        _buildRevenueCard(monthlyRevenue),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AuthState auth) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 20, 14, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${GreetingFormatter.greeting()}, ${auth.owner?.ownerName ?? "Owner"}'.toUpperCase(),
                style: AppTextStyles.sectionTitle.copyWith(fontSize: 8, letterSpacing: 1.5, color: AppColors.textMuted),
              ),
              const SizedBox(height: 4),
              Text(
                auth.owner?.gymName ?? 'IRONBOOK GM',
                style: AppTextStyles.h2.copyWith(fontSize: 22, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormatter.format(DateTime.now()).toUpperCase(),
                style: AppTextStyles.bodySmall.copyWith(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 1.0),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => context.go('/attendance'),
                icon: const Icon(Icons.fact_check_rounded, color: AppColors.textPrimary, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.elevation2,
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.elevation4,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.fitness_center_rounded, size: 24, color: AppColors.primary),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget _buildStatsGrid(int total, int active, int expiring, int expired) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.8,
      children: [
        StatsCard(value: total.toString(), label: 'Total Members', isPrimary: true),
        StatsCard(value: active.toString(), label: 'Active', valueColor: AppColors.active),
        StatsCard(value: expiring.toString(), label: 'Expiring Soon', valueColor: AppColors.expiring),
        StatsCard(value: expired.toString(), label: 'Expired', valueColor: AppColors.expired),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String? action) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 32, 0, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.sectionTitle.copyWith(fontSize: 9, letterSpacing: 2.0),
          ),
          if (action != null)
            GestureDetector(
              onTap: () => context.go('/gym'),
              child: Row(
                children: [
                  Text(
                    action.toUpperCase(),
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.primary),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 8, color: AppColors.primary),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDueList(List<Member> members, DateTime now) {
    final due = members.where((m) {
      final days = m.getDaysRemaining(now);
      return days >= 0 && days <= 3;
    }).toList();

    if (due.isEmpty) {
      return Container(
        height: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.elevation1,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Text('NO TASKS DUE TODAY', style: AppTextStyles.bodySmall.copyWith(fontSize: 9, letterSpacing: 1.0, color: AppColors.textMuted)),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.elevation1,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: List.generate(due.length, (index) {
          final m = due[index];
          final days = m.getDaysRemaining(now);
          final status = m.getStatus(now);
          final color = status == MemberStatus.expired ? AppColors.expired : (status == MemberStatus.expiring ? AppColors.expiring : AppColors.active);

          return MemberRow(
            name: m.name,
            initials: m.name.isNotEmpty ? m.name.substring(0, 1).toUpperCase() : '?',
            subtitle: '${m.planName ?? "N/A"}',
            daysLeft: days.toString(),
            statusColor: color,
          );
        }),
      ),
    );
  }

  Widget _buildRevenueCard(double monthlyRevenue) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.elevation2,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ESTIMATED REVENUE'.toUpperCase(),
                style: AppTextStyles.sectionTitle.copyWith(fontSize: 8, letterSpacing: 1.5, color: AppColors.textMuted),
              ),
              const SizedBox(height: 6),
              Text(
                '₹${monthlyRevenue.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}', 
                style: AppTextStyles.h2.copyWith(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primary),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.trending_up_rounded, size: 12, color: AppColors.active),
                  const SizedBox(width: 4),
                  Text(
                    'Tracking active this month',
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 9, color: AppColors.active, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
          _buildMiniBars(),
        ],
      ),
    );
  }

  Widget _buildMiniBars() {
    final heights = [0.55, 0.65, 0.45, 0.8, 0.6, 0.85, 1.0];
    return SizedBox(
      height: 36,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(heights.length, (index) {
          final isLast = index == heights.length - 1;
          return Container(
            width: 6,
            height: 36 * heights[index],
            margin: const EdgeInsets.only(left: 3),
            decoration: BoxDecoration(
              color: isLast ? AppColors.primary : AppColors.bg4,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }
}
