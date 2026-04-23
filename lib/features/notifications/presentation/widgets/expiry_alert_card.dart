// ═══════════════════════════════════════════════════════════════════
// 🔒 LOCKED — ExpiryAlertCard | Verified: 2026-04-23
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';

import '../../viewmodel/notifications_viewmodel.dart';

class ExpiryAlertCard extends StatelessWidget {
  final ExpiryAlert alert;
  final VoidCallback onTap;

  const ExpiryAlertCard({
    super.key,
    required this.alert,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final badge = _buildBadge();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF16213e),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Avatar initial
              CircleAvatar(
                backgroundColor: badge.color.withValues(alpha: 0.18),
                child: Text(
                  alert.member.name.isNotEmpty
                      ? alert.member.name[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    color: badge.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Name + phone
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.member.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    if (alert.member.phone != null &&
                        alert.member.phone!.isNotEmpty)
                      Text(
                        alert.member.phone!,
                        style: const TextStyle(
                          color: Color(0xFFa8a8b3),
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ),
              // Status badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: badge.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: badge.color.withValues(alpha: 0.5)),
                ),
                child: Text(
                  badge.label,
                  style: TextStyle(
                    color: badge.color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _BadgeInfo _buildBadge() {
    final d = alert.daysUntilExpiry;
    if (d < 0) {
      return _BadgeInfo(
          color: const Color(0xFFe94560),
          label: 'Expired ${d.abs()}d ago');
    } else if (d == 0) {
      return const _BadgeInfo(
          color: Color(0xFFe94560), label: 'Expires Today');
    } else if (d <= 3) {
      return _BadgeInfo(
          color: const Color(0xFFff6b35), label: 'In ${d}d');
    } else if (d <= 7) {
      return _BadgeInfo(
          color: const Color(0xFFf5a623), label: 'In ${d}d');
    } else {
      return _BadgeInfo(
          color: const Color(0xFF4caf50), label: 'In ${d}d');
    }
  }
}

class _BadgeInfo {
  final Color color;
  final String label;
  const _BadgeInfo({required this.color, required this.label});
}
