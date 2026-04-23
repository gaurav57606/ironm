import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _ActionButton(
            icon: Icons.person_add,
            label: 'Add Member',
            onTap: () => context.go('/members/add'),
          ),
          const SizedBox(width: 12),
          _ActionButton(
            icon: Icons.currency_rupee,
            label: 'Payments',
            onTap: () => context.go('/payments'),
          ),
          const SizedBox(width: 12),
          _ActionButton(
            icon: Icons.how_to_reg,
            label: 'Attendance',
            onTap: () => context.go('/attendance'),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
