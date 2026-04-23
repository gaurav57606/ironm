import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../data/models/member.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import 'member_status_badge.dart';

class MemberCard extends StatelessWidget {
  final Member member;

  const MemberCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.sm,
      ),
      child: ListTile(
        onTap: () => context.go('/members/${member.id}'),
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        leading: CircleAvatar(
          backgroundColor: AppColors.secondary,
          child: member.photoPath != null
              ? null // TODO: Image.file
              : Text(
                  member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
        ),
        title: Text(
          member.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(member.phone, style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text(
              'Expires: ${AppDateUtils.formatDate(member.expiryDate)}',
              style: TextStyle(
                fontSize: 12,
                color: member.isExpired ? AppColors.error : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        trailing: MemberStatusBadge(isActive: member.isActive && !member.isExpired),
      ),
    );
  }
}
