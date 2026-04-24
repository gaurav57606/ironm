import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../../members/viewmodel/members_viewmodel.dart';
import '../viewmodel/dashboard_viewmodel.dart';
import '../../../shared/widgets/status_bar_wrapper.dart';
import 'widgets/member_health_donut.dart';
import 'widgets/revenue_mini_bars.dart';
import 'widgets/alert_banner.dart';
import '../../../data/models/member.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(membersProvider);
    final statsAsync = ref.watch(dashboardStatsProvider);
    final stats = statsAsync.value ?? const DashboardStats();

    final activeCount = stats.activeMembers;
    final expiringCount = stats.expiringMembers;
    final expiredCount = stats.expiredMembers;
    final totalCount = members.length;

    return Container(
      decoration: const BoxDecoration(color: AppColors.bg),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: StatusBarWrapper(
          child: Column(
            children: [
          _buildHeader(context, ref),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    _buildSubHeader(),
                    _buildStatsGrid(
                        totalCount, activeCount, expiringCount, expiredCount),
                    MemberHealthDonut(
                      active: activeCount,
                      expiring: expiringCount,
                      expired: expiredCount,
                    ),
                    if (expiredCount > 0)
                      AlertBanner(
                        title: '$expiredCount memberships expired',
                        subtitle: 'Tap to view and take action',
                        color: AppColors.expired,
                        onTap: () {
                          ref.read(memberTabProvider.notifier).state = 3;
                          context.go('/gym');
                        },
                      ),
                    if (expiringCount > 0)
                      AlertBanner(
                        title: '$expiringCount expiring in 7 days',
                        subtitle: 'Tap to notify members',
                        color: AppColors.expiring,
                        onTap: () {
                          ref.read(memberTabProvider.notifier).state = 2;
                          context.go('/gym');
                        },
                      ),
                    const SizedBox(height: 12),
                    _buildSectionHeader(
                        context, 'Due Today', null),
                    _buildDueTodayList(members),
                    _buildSectionHeader(context, 'This Month', null),
                    RevenueMiniBars(revenue: stats.monthlyRevenue, trend: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final owner = ref.watch(authProvider).owner;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_getGreeting(),
                  style: AppTextStyles.label
                      .copyWith(color: AppColors.textSecondary, fontSize: 11)),
              Text(owner?.gymName ?? "IronM Fitness",
                  style: AppTextStyles.h2.copyWith(fontSize: 18)),
              Text(
                DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()),
                style: AppTextStyles.label
                    .copyWith(color: AppColors.textMuted, fontSize: 10),
              ),
            ],
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.orange,
              borderRadius: BorderRadius.circular(11),
            ),
            alignment: Alignment.center,
            child: Text(owner?.ownerName.isNotEmpty == true ? owner!.ownerName[0].toUpperCase() : 'I',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16)),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Widget _buildSubHeader() {
    return const SizedBox(height: 8);
  }

  Widget _buildStatsGrid(int total, int active, int expiring, int expired) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: _buildStatCard('Total Members', total.toString(),
                      isHighlight: true)),
              const SizedBox(width: 8),
              Expanded(
                  child: _buildStatCard('Active', active.toString(),
                      color: AppColors.active)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                  child: _buildStatCard('Expiring Soon', expiring.toString(),
                      color: AppColors.expiring)),
              const SizedBox(width: 8),
              Expanded(
                  child: _buildStatCard('Expired', expired.toString(),
                      color: AppColors.expired)),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value,
      {Color? color, bool isHighlight = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isHighlight ? null : AppColors.bg3,
        gradient: isHighlight ? AppColors.primaryGradient : null,
        borderRadius: BorderRadius.circular(14),
        border: isHighlight ? null : Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: AppTextStyles.h1.copyWith(
              fontSize: 22,
              color:
                  isHighlight ? Colors.white : (color ?? AppColors.textPrimary),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label.toUpperCase(),
            style: AppTextStyles.label.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.4,
              color: isHighlight
                  ? Colors.white.withValues(alpha: 0.7)
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, String? route) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: AppTextStyles.label.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          if (route != null)
            GestureDetector(
              onTap: () => context.push(route),
              child: Text(
                'See all',
                style: AppTextStyles.label.copyWith(
                    fontSize: 10,
                    color: AppColors.orange,
                    fontWeight: FontWeight.w500),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDueTodayList(List<Member> members) {
    final now = DateTime.now();
    final dueToday =
        members.where((m) => m.expiryDate != null && m.getDaysRemaining(now) == 0).toList();

    if (dueToday.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 14),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.bg3,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Center(
          child: Text('No memberships due today',
              style: AppTextStyles.label.copyWith(color: AppColors.textMuted)),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bg3,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          for (int i = 0; i < dueToday.length; i++) ...[
            _buildDueMemberRow(dueToday[i]),
            if (i < dueToday.length - 1)
              const Divider(height: 1, color: AppColors.border),
          ],
        ],
      ),
    );
  }

  Widget _buildDueMemberRow(Member member) {
    final now = DateTime.now();
    final days = member.getDaysRemaining(now);
    final color = days <= 0 ? AppColors.expired : AppColors.expiring;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(9),
            ),
            alignment: Alignment.center,
            child: Text(
              member.name.substring(0, 1).toUpperCase(),
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w700, fontSize: 11),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name,
                    style: AppTextStyles.body
                        .copyWith(fontSize: 12, fontWeight: FontWeight.w600)),
                Text(
                    '${member.planName ?? "Monthly"} Membership',
                    style: AppTextStyles.label
                        .copyWith(fontSize: 9, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(days.toString(),
                  style: AppTextStyles.h3.copyWith(fontSize: 13, color: color)),
              Text('days left',
                  style: AppTextStyles.label
                      .copyWith(fontSize: 8, color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}

