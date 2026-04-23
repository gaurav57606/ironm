import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/status_bar_wrapper.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      _buildMainStats(),
                      const SizedBox(height: 32),
                      _buildGraphSection('Revenue Trends', [0.4, 0.6, 0.5, 0.8, 0.7, 0.9, 0.85]),
                      const SizedBox(height: 24),
                      _buildGraphSection('Member Attendance', [0.3, 0.5, 0.4, 0.6, 0.5, 0.7, 0.65]),
                      const SizedBox(height: 32),
                      Text('Top Performing Plans', style: AppTextStyles.h3),
                      const SizedBox(height: 20),
                      _buildPlanRank('Elite Coaching', 0.85, AppColors.primary),
                      _buildPlanRank('Standard Gym', 0.65, AppColors.blue),
                      _buildPlanRank('Yoga Specialized', 0.45, AppColors.active),
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
                Text('March 2026', style: AppTextStyles.bodySmall.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                const SizedBox(width: 8),
                const Icon(Icons.calendar_today_rounded, color: AppColors.orange, size: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainStats() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Total Members', '1,248', '+12%', Icons.people_rounded)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('Total Revenue', '₹1.4L', '+8%', Icons.account_balance_wallet_rounded)),
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
                  color: AppColors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.orange, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.active.withOpacity(0.1),
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
                      colors: [AppColors.orange.withOpacity(0.8), AppColors.orange.withOpacity(0.2)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.orange.withOpacity(0.2),
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
                color: color.withOpacity(0.1),
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
                      backgroundColor: Colors.white.withOpacity(0.05),
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
