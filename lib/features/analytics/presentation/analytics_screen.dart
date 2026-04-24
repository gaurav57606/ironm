import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/status_bar_wrapper.dart';
import '../../dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:intl/intl.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final stats = statsAsync.value ?? const DashboardStats();
    
    final activeCount = stats.activeMembers;
    final revenue = stats.monthlyRevenue;
    
    // Normalize weekly revenue for the graph
    final maxRev = stats.weeklyRevenue.isNotEmpty 
        ? stats.weeklyRevenue.reduce((a, b) => a > b ? a : b) 
        : 0.0;
    final normalizedRev = stats.weeklyRevenue.map((v) => maxRev > 0 ? (v / maxRev).clamp(0.1, 1.0) : 0.1).toList();

    // Normalize attendance for the graph
    final maxAttendance = stats.attendanceTrends.isNotEmpty 
        ? stats.attendanceTrends.reduce((a, b) => a > b ? a : b) 
        : 0.0;
    final normalizedAttendance = stats.attendanceTrends.map((v) => maxAttendance > 0 ? (v / maxAttendance).clamp(0.1, 1.0) : 0.1).toList();

    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: StatusBarWrapper(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      _buildMainStats(activeCount, revenue, stats.memberGrowth, stats.revenueGrowth),
                      const SizedBox(height: 32),
                      _buildGraphSection('Revenue Trends', normalizedRev),
                      const SizedBox(height: 24),
                      _buildGraphSection('Member Attendance', normalizedAttendance),
                      const SizedBox(height: 32),
                      Text('Top Performing Plans', style: AppTextStyles.h3),
                      const SizedBox(height: 20),
                      if (stats.topPlans.isEmpty)
                        const Center(child: Text('No plan data available', style: TextStyle(color: AppColors.textMuted)))
                      else
                        ...stats.topPlans.asMap().entries.map((entry) {
                          final colors = [AppColors.primary, AppColors.blue, AppColors.active];
                          return _buildPlanRank(entry.value.name, entry.value.percent, colors[entry.key % colors.length]);
                        }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Gym Analytics',
            style: AppTextStyles.h1.copyWith(fontSize: 24),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.elevation2,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Text(DateFormat('MMMM yyyy').format(DateTime.now()), 
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                const SizedBox(width: 8),
                const Icon(Icons.calendar_today_rounded, color: AppColors.orange, size: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainStats(int activeMembers, double monthlyRevenue, double memberGrowth, double revenueGrowth) {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Active Members', activeMembers.toString(), '${memberGrowth >= 0 ? '+' : ''}${memberGrowth.toStringAsFixed(0)}%', Icons.people_rounded)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('Total Revenue', '₹${(monthlyRevenue / 1000).toStringAsFixed(1)}k', '${revenueGrowth >= 0 ? '+' : ''}${revenueGrowth.toStringAsFixed(0)}%', Icons.account_balance_wallet_rounded)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String growth, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.elevation2,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.orange, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.active.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(growth, style: AppTextStyles.bodySmall.copyWith(color: AppColors.active, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(value, style: AppTextStyles.h2.copyWith(fontSize: 22)),
          Text(title, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildGraphSection(String title, List<double> values) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.elevation2,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
              const Icon(Icons.more_horiz, color: AppColors.textMuted),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: values.asMap().entries.map((entry) {
                return Container(
                  width: 24,
                  height: 120 * entry.value,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.orange.withValues(alpha: 0.8), AppColors.orange.withValues(alpha: 0.2)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.orange.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
              return SizedBox(
                width: 24,
                child: Center(
                  child: Text(day, style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanRank(String plan, double percent, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.elevation2,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.analytics_rounded, color: color, size: 18),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(plan, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
                      Text('${(percent * 100).toInt()}%', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percent,
                      minHeight: 4,
                      backgroundColor: Colors.white.withValues(alpha: 0.05),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

