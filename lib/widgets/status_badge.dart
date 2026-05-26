import 'package:flutter/material.dart';
import '../core/constants/ac_colors.dart';
import '../core/constants/ac_text_styles.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool killSwitchActive;
  const StatusBadge({
    super.key,
    required this.status,
    required this.killSwitchActive,
  });

  @override
  Widget build(BuildContext context) {
    final (label, color) = _resolve();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: AcTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  (String, Color) _resolve() {
    if (killSwitchActive) return ('⛔ Kill-Switched', AcColors.expired);
    switch (status) {
      case 'active':    return ('🟢 Active',    AcColors.active);
      case 'suspended': return ('🔴 Suspended',  AcColors.expired);
      default:          return ('⚠ Expired',    AcColors.expiring);
    }
  }
}
