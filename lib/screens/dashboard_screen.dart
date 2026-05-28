import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../core/constants/ac_colors.dart';
import '../core/constants/ac_strings.dart';
import '../core/constants/ac_text_styles.dart';
import '../models/entitlement_record.dart';
import '../providers/admin_auth_provider.dart';
import '../providers/entitlements_provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/subscriber_tile.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(allEntitlementsProvider);

    return Scaffold(
      backgroundColor: AcColors.bg,
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'IC',
              style: TextStyle(
                color: AcColors.primary,
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(width: 8),
            Text(AcStrings.appName, style: AcTextStyles.title),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people_outline_rounded),
            tooltip: 'All Subscribers',
            onPressed: () => context.go('/subscribers'),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign Out',
            onPressed: () => ref.read(adminAuthProvider.notifier).logout(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: recordsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AcColors.primary),
        ),
        error: (e, _) => Center(
          child: Text(
            'Error loading data: $e',
            style: AcTextStyles.bodySecondary,
          ),
        ),
        data: (list) => _buildBody(context, ref, list),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, List<EntitlementRecord> list) {
    final now = DateTime.now();
    final active = list
        .where((r) =>
            r.status == 'active' &&
            !r.killSwitchActive &&
            r.expiresAt.isAfter(now))
        .length;
    final expiring = list.where((r) => r.isExpiringSoon).length;
    final expired = list.where((r) => r.isEffectivelyExpired).length;
    final killed = list.where((r) => r.killSwitchActive).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header
          Text(
            DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()),
            style: AcTextStyles.bodySmall,
          ),
          const SizedBox(height: 4),
          Text('Overview', style: AcTextStyles.h2),
          const SizedBox(height: 16),

          // Stats grid — 2x2
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              StatCard(
                label: 'Active',
                value: '$active',
                color: AcColors.active,
                icon: Icons.check_circle_outline_rounded,
              ),
              StatCard(
                label: 'Expiring (7d)',
                value: '$expiring',
                color: AcColors.warning,
                icon: Icons.timer_outlined,
              ),
              StatCard(
                label: 'Expired / Suspended',
                value: '$expired',
                color: AcColors.expiring,
                icon: Icons.cancel_outlined,
              ),
              StatCard(
                label: 'Kill-Switched',
                value: '$killed',
                color: AcColors.expired,
                icon: Icons.block_rounded,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Expiring soon alert — only show if expiring > 0
          if (expiring > 0)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AcColors.warning.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AcColors.warning.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: AcColors.warning, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '$expiring subscriber${expiring > 1 ? 's' : ''} expiring within 7 days.',
                      style:
                          AcTextStyles.bodySmall.copyWith(color: AcColors.warning),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/subscribers'),
                    child: Text(
                      'View',
                      style: AcTextStyles.bodySmall.copyWith(
                        color: AcColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Recent subscribers header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent (by expiry)', style: AcTextStyles.title),
              TextButton(
                onPressed: () => context.push('/subscribers'),
                child: Text(
                  'View All',
                  style: AcTextStyles.bodySmall.copyWith(
                    color: AcColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Top 5 soonest-expiring subscribers
          if (list.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  AcStrings.noSubscribers,
                  style: AcTextStyles.bodySecondary,
                ),
              ),
            )
          else
            ...([...list]..sort((a, b) => a.expiresAt.compareTo(b.expiresAt)))
                .take(5)
                .map((r) => SubscriberTile(
                      record: r,
                      onTap: () => context.go('/subscriber/${r.userId}'),
                    )),
        ],
      ),
    );
  }
}
