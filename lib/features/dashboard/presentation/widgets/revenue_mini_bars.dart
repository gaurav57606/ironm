import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class RevenueMiniBars extends StatelessWidget {
  final double revenue;
  final double trend;

  const RevenueMiniBars({
    super.key,
    required this.revenue,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg3,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('REVENUE', style: AppTextStyles.label.copyWith(fontSize: 9, letterSpacing: 0.5)),
              const SizedBox(height: 4),
              Text('₹${revenue.toInt()}', style: AppTextStyles.h1.copyWith(fontSize: 20)),
              const SizedBox(height: 2),
              Text(
                '${trend > 0 ? '↑' : '↓'} ${trend.abs().toInt()}% vs last month',
                style: AppTextStyles.label.copyWith(fontSize: 9, color: trend > 0 ? AppColors.active : AppColors.expired),
              ),
            ],
          ),
          SizedBox(
            height: 36,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar(0.55),
                _buildBar(0.65),
                _buildBar(0.45),
                _buildBar(0.80),
                _buildBar(0.60),
                _buildBar(0.85),
                _buildBar(1.0, isHighlighted: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(double heightFactor, {bool isHighlighted = false}) {
    return Container(
      width: 6,
      height: 36 * heightFactor,
      margin: const EdgeInsets.only(left: 3),
      decoration: BoxDecoration(
        color: isHighlighted ? AppColors.orange : AppColors.bg4,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
