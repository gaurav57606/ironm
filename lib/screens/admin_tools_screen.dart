import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/ac_colors.dart';
import '../core/constants/ac_text_styles.dart';
import '../models/entitlement_record.dart';
import '../providers/entitlements_provider.dart';
import '../widgets/app_toast.dart';

class AdminToolsScreen extends ConsumerStatefulWidget {
  const AdminToolsScreen({super.key});

  @override
  ConsumerState<AdminToolsScreen> createState() => _AdminToolsScreenState();
}

class _AdminToolsScreenState extends ConsumerState<AdminToolsScreen> {
  bool _processing = false;

  // ── DYNAMIC FCM OPERATIONS ──
  
  // Sends a lock signal to all expired users in Firestore
  Future<void> _lockExpiredUsers(List<EntitlementRecord> expiredUsers) async {
    if (expiredUsers.isEmpty) {
      ref.read(toastProvider.notifier).show('No expired accounts to lock.');
      return;
    }

    setState(() => _processing = true);
    int lockedCount = 0;
    try {
      final writeService = ref.read(entitlementWriteServiceProvider);
      for (final r in expiredUsers) {
        if (!r.killSwitchActive) {
          await writeService.setKillSwitch(r.userId, true);
          lockedCount++;
        }
      }
      ref.read(toastProvider.notifier).show('Lock signal sent to $lockedCount expired accounts.');
    } catch (e) {
      ref.read(toastProvider.notifier).show('Failed to lock: $e');
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  // Sends an emergency kill signal to ALL users
  Future<void> _emergencyKillAll(List<EntitlementRecord> allUsers) async {
    if (allUsers.isEmpty) return;

    setState(() => _processing = true);
    int lockedCount = 0;
    try {
      final writeService = ref.read(entitlementWriteServiceProvider);
      for (final r in allUsers) {
        await writeService.setKillSwitch(r.userId, true);
        lockedCount++;
      }
      ref.read(toastProvider.notifier).show('EMERGENCY: Locked all $lockedCount users.');
    } catch (e) {
      ref.read(toastProvider.notifier).show('Emergency lock failed: $e');
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recordsAsync = ref.watch(allEntitlementsProvider);

    return Scaffold(
      backgroundColor: AcColors.bg,
      body: SafeArea(
        child: recordsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AcColors.primary),
          ),
          error: (e, _) => Center(
            child: Text(
              'Error loading controls: $e',
              style: AcTextStyles.bodySecondary,
            ),
          ),
          data: (list) => _buildToolsList(context, ref, list),
        ),
      ),
    );
  }

  Widget _buildToolsList(BuildContext context, WidgetRef ref, List<EntitlementRecord> list) {
    final now = DateTime.now();

    // Compute dynamic parameters from Firestore
    final expiredCount = list.where((r) => r.isEffectivelyExpired && !r.killSwitchActive).length;
    final expiringCount = list.where((r) => r.isExpiringSoon).length;
    final graceCount = list.where((r) => r.status == 'active' && r.expiresAt.isBefore(now.add(const Duration(days: 3)))).length;

    // Filter list of expired users for fcm locking
    final expiredList = list.where((r) => r.isEffectivelyExpired && !r.killSwitchActive).toList();

    return _processing
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AcColors.primary),
                SizedBox(height: 16),
                Text('Queuing signals... Please wait.', style: TextStyle(color: AcColors.textSecondary)),
              ],
            ),
          )
        : ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              // ── TOP SECTION ──
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Controls & Actions',
                          style: AcTextStyles.subtext.copyWith(
                            fontSize: 12,
                            color: AcColors.textMuted,
                          ),
                        ),
                        Text(
                          'Admin Tools',
                          style: AcTextStyles.h2.copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── BROADCAST CONTROLS ──
              Text('Broadcast Controls', style: AcTextStyles.h3),
              const SizedBox(height: 10),

              _buildToolCard(
                icon: Icons.volume_up_outlined,
                color: AcColors.primary,
                title: 'Push Announcement',
                desc: 'Send a custom notification to all users or a targeted segment. Supports feature announcements, payment reminders, and maintenance alerts.',
                meta: 'Last sent: 3 hours ago',
                onTap: () {
                  ref.read(toastProvider.notifier).show('Announcement sent to ${list.length} users.');
                },
              ),

              _buildToolCard(
                icon: Icons.alarm_on_rounded,
                color: AcColors.warning,
                title: 'Expiry Reminders',
                desc: 'Auto-send renewal reminder notifications to users whose subscriptions expire within 3, 7, or 14 days.',
                meta: '$expiringCount users expiring soon',
                onTap: () {
                  ref.read(toastProvider.notifier).show('Expiry reminders sent.');
                },
              ),
              const SizedBox(height: 16),

              // ── FCM CONTROLS ──
              Text('FCM Controls', style: AcTextStyles.h3),
              const SizedBox(height: 10),

              _buildToolCard(
                icon: Icons.lock_person_outlined,
                color: AcColors.blue,
                title: 'Lock Expired Users',
                desc: 'Automatically send FCM kill signals to all users whose subscriptions have expired. App will show lockout screen on next open.',
                meta: '$expiredCount expired accounts pending',
                onTap: () => _lockExpiredUsers(expiredList),
              ),

              _buildToolCard(
                icon: Icons.warning_amber_rounded,
                color: AcColors.purple,
                title: 'Grace Period Warning',
                desc: 'Send warning banners inside the app to users in the grace period. Urges them to renew before full lockout activates.',
                meta: '$graceCount in grace period',
                onTap: () {
                  ref.read(toastProvider.notifier).show('Grace period warnings sent.');
                },
              ),
              const SizedBox(height: 20),

              // ── DANGER ZONE ──
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF43F5E).withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0x33F43F5E), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Color(0xFFF43F5E),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Danger Zone',
                          style: AcTextStyles.label.copyWith(
                            color: const Color(0xFFF43F5E),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sends a kill signal to ALL users regardless of subscription status. This will lock everyone out immediately. Use only for maintenance or security incidents.',
                      style: AcTextStyles.bodySmall.copyWith(
                        color: AcColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF43F5E),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Confirm emergency shut down!
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: AcColors.s2,
                            title: const Text('Confirm Absolute Lockout?'),
                            content: Text(
                              'This will lock out ALL ${list.length} subscribers immediately. Are you absolutely sure?',
                              style: const TextStyle(color: AcColors.textSecondary),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF43F5E),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _emergencyKillAll(list);
                                },
                                child: const Text('Yes, Lock All'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.block_rounded, color: Colors.white, size: 17),
                      label: Center(
                        child: Text(
                          'Send Kill Signal · All Users',
                          style: AcTextStyles.body.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
  }

  Widget _buildToolCard({
    required IconData icon,
    required Color color,
    required String title,
    required String desc,
    required String meta,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: AcColors.s1,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AcColors.rim2, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            icon,
                            color: color,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          title,
                          style: AcTextStyles.label.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      desc,
                      style: AcTextStyles.bodySecondary.copyWith(
                        color: AcColors.textSecondary,
                        fontSize: 12.5,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Footer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  color: AcColors.s2,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  border: Border(
                    top: BorderSide(color: AcColors.rim, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      meta,
                      style: AcTextStyles.subtext.copyWith(
                        color: AcColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AcColors.textMuted,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
