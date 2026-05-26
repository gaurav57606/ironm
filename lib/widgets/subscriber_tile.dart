import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/constants/ac_colors.dart';
import '../core/constants/ac_text_styles.dart';
import '../models/entitlement_record.dart';
import 'status_badge.dart';

class SubscriberTile extends StatelessWidget {
  final EntitlementRecord record;
  final VoidCallback onTap;
  const SubscriberTile({
    super.key,
    required this.record,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final expiryLabel = DateFormat('dd MMM yy').format(record.expiresAt);
    final daysLeft = record.daysUntilExpiry;
    final daysColor = daysLeft < 0
        ? AcColors.expired
        : daysLeft <= 7
            ? AcColors.warning
            : AcColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AcColors.elevation2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AcColors.border),
        ),
        child: Row(
          children: [
            // Avatar circle
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AcColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                record.businessName.isNotEmpty
                    ? record.businessName[0].toUpperCase()
                    : '?',
                style: AcTextStyles.label.copyWith(
                    color: AcColors.primary, fontSize: 16),
              ),
            ),
            const SizedBox(width: 12),
            // Name + owner
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(record.businessName,
                      style: AcTextStyles.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(record.ownerName,
                      style: AcTextStyles.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Badge + expiry
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StatusBadge(
                    status: record.status,
                    killSwitchActive: record.killSwitchActive),
                const SizedBox(height: 4),
                Text(
                  'Exp: $expiryLabel',
                  style: AcTextStyles.subtext.copyWith(color: daysColor),
                ),
              ],
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded,
                color: AcColors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}
