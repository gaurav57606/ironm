import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/status_bar_wrapper.dart';

class NotificationsHubScreen extends ConsumerWidget {
  const NotificationsHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: StatusBarWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildCategoryFilter(),
              const SizedBox(height: 16),
              _buildNotificationsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Notifications',
            style: AppTextStyles.h1.copyWith(fontSize: 24),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Mark all as read',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildCategoryChip('All', true),
            _buildCategoryChip('Payments', false),
            _buildCategoryChip('System', false),
            _buildCategoryChip('Reminders', false),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList() {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          _buildNotificationItem(
            'Payment Successful',
            'Premium membership for John Doe renewed.',
            '2m ago',
            Icons.check_circle_rounded,
            AppColors.active,
            true,
          ),
          _buildNotificationItem(
            'New Member Alert',
            'Sarah Jenkins joined with Elite Coaching plan.',
            '1h ago',
            Icons.person_add_rounded,
            AppColors.primary,
            true,
          ),
          _buildNotificationItem(
            'System Update',
            'Analytics engine updated for better insights.',
            '5h ago',
            Icons.system_update_rounded,
            Colors.blue,
            false,
          ),
          _buildNotificationItem(
            'Plan Expiry',
            'Mike Ross plan expires in 3 days.',
            '1d ago',
            Icons.warning_amber_rounded,
            AppColors.expiring,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.elevation2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: active ? AppColors.primary : AppColors.border),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: active ? Colors.white : AppColors.textSecondary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String desc, String time,
      IconData icon, Color color, bool unread) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.elevation2,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: unread ? color.withOpacity(0.3) : AppColors.border,
          width: unread ? 1.5 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      time,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (unread)
            Container(
              margin: const EdgeInsets.only(left: 8, top: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}
