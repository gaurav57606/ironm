import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class MemberHealthDonut extends StatelessWidget {
  final int active;
  final int expiring;
  final int expired;

  const MemberHealthDonut({
    super.key,
    required this.active,
    required this.expiring,
    required this.expired,
  });

  @override
  Widget build(BuildContext context) {
    final total = active + expiring + expired;
    final activePct = total > 0 ? active / total : 0.0;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg3,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              children: [
                const Center(
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 10,
                      color: AppColors.border,
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: CircularProgressIndicator(
                      value: activePct,
                      strokeWidth: 10,
                      color: AppColors.active,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${(activePct * 100).toInt()}%', style: AppTextStyles.h3.copyWith(fontSize: 12)),
                      Text('ACTIVE', style: AppTextStyles.label.copyWith(fontSize: 7, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Member Health', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 11)),
                const SizedBox(height: 8),
                _buildLegendItem('Active', active, AppColors.active),
                _buildLegendItem('Expiring', expiring, AppColors.expiring),
                _buildLegendItem('Expired', expired, AppColors.expired),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.label.copyWith(fontSize: 9, color: AppColors.textSecondary)),
          const Spacer(),
          Text('$value', style: AppTextStyles.body.copyWith(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}
