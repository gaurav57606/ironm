// ═══════════════════════════════════════════════════════════════════
// 🔒 LOCKED — NotificationsScreen | Verified: 2026-04-23
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../viewmodel/notifications_viewmodel.dart';
import '../widgets/expiry_alert_card.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsAsync = ref.watch(expiringMembersProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213e),
        title: const Text(
          'Alerts',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Refresh',
            onPressed: () => ref.invalidate(expiringMembersProvider),
          ),
        ],
      ),
      body: alertsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFe94560)),
        ),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline,
                    color: Color(0xFFe94560), size: 48),
                const SizedBox(height: 12),
                Text(
                  'Could not load alerts:\n$e',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFFa8a8b3)),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFe94560)),
                  onPressed: () => ref.invalidate(expiringMembersProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (alerts) {
          if (alerts.isEmpty) return const _EmptyState();

          // Separate expired from expiring
          final expired = alerts.where((a) => a.isExpired).toList();
          final expiring = alerts.where((a) => !a.isExpired).toList();

          return RefreshIndicator(
            color: const Color(0xFFe94560),
            onRefresh: () async => ref.invalidate(expiringMembersProvider),
            child: ListView(
              padding: const EdgeInsets.only(top: 12, bottom: 24),
              children: [
                if (expired.isNotEmpty) ...[
                  _SectionHeader(
                    label: 'Expired (${expired.length})',
                    color: const Color(0xFFe94560),
                  ),
                  ...expired.map((a) => ExpiryAlertCard(
                        alert: a,
                        onTap: () => context
                            .push('/members/${a.member.memberId}'),
                      )),
                ],
                if (expiring.isNotEmpty) ...[
                  _SectionHeader(
                    label: 'Expiring Soon (${expiring.length})',
                    color: const Color(0xFFf5a623),
                  ),
                  ...expiring.map((a) => ExpiryAlertCard(
                        alert: a,
                        onTap: () => context
                            .push('/members/${a.member.memberId}'),
                      )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Empty State ─────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline,
                color: Color(0xFF4caf50), size: 72),
            SizedBox(height: 20),
            Text(
              'All memberships are active',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Members expiring in the next 30 days will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFa8a8b3), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section Header ───────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final Color color;

  const _SectionHeader({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
