import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

class MemberStatusBadge extends StatelessWidget {
  final bool isActive;

  const MemberStatusBadge({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: (isActive ? AppColors.active : AppColors.expired).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        border: Border.all(
          color: isActive ? AppColors.active : AppColors.expired,
        ),
      ),
      child: Text(
        isActive ? 'ACTIVE' : 'EXPIRED',
        style: TextStyle(
          color: isActive ? AppColors.active : AppColors.expired,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
