import 'package:flutter/material.dart';
import '../core/constants/ac_colors.dart';
import '../core/constants/ac_text_styles.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AcColors.elevation2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AcColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: AcTextStyles.h2.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(label, style: AcTextStyles.bodySmall),
        ],
      ),
    );
  }
}
