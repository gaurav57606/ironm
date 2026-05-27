import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../core/constants/ac_colors.dart';
import '../core/constants/ac_text_styles.dart';
import '../core/constants/ac_strings.dart';
import '../providers/entitlements_provider.dart';
import '../widgets/action_sheet.dart';
import '../widgets/app_toast.dart';
import 'subscription_screen.dart';

class SubscriberDetailScreen extends ConsumerStatefulWidget {
  final String userId;
  const SubscriberDetailScreen({super.key, required this.userId});

  @override
  ConsumerState<SubscriberDetailScreen> createState() => _SubscriberDetailScreenState();
}

class _SubscriberDetailScreenState extends ConsumerState<SubscriberDetailScreen> {
  bool _editingNotes = false;
  final _notesCtrl = TextEditingController();
  bool _savingNotes = false;

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  // Choose avatar gradient based on user name
  LinearGradient _avatarGradient(String name) {
    final code = name.isEmpty ? 0 : name.codeUnitAt(0) % 5;
    switch (code) {
      case 0:
        return const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 1:
        return const LinearGradient(
          colors: [Color(0xFFA78BFA), Color(0xFFEC4899)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 2:
        return const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 3:
        return const LinearGradient(
          colors: [Color(0xFF22C55E), Color(0xFF06B6D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFFF97316), Color(0xFFBE185D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  // Quick Action: Toggle status in database
  Future<void> _setStatus(String userId, String status, String message) async {
    try {
      await ref.read(entitlementWriteServiceProvider).setStatus(userId, status);
      ref.read(toastProvider.notifier).show(message);
    } catch (e) {
      ref.read(toastProvider.notifier).show('Failed: $e');
    }
  }

  // Quick Action: Toggle kill switch lockout in database
  Future<void> _toggleKillSwitch(String userId, bool active) async {
    try {
      await ref.read(entitlementWriteServiceProvider).setKillSwitch(userId, active);
      ref.read(toastProvider.notifier).show(active ? 'Account locked.' : 'Access restored.');
    } catch (e) {
      ref.read(toastProvider.notifier).show('Failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final recordsAsync = ref.watch(allEntitlementsProvider);

    return recordsAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AcColors.bg,
        body: Center(child: CircularProgressIndicator(color: AcColors.primary)),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AcColors.bg,
        body: Center(child: Text('Error: $e', style: AcTextStyles.bodySecondary)),
      ),
      data: (list) {
        final record = list.where((r) => r.userId == widget.userId).firstOrNull;

        if (record == null) {
          return Scaffold(
            backgroundColor: AcColors.bg,
            appBar: AppBar(title: const Text('Subscriber')),
            body: Center(
              child: Text(
                'Subscriber not found.',
                style: AcTextStyles.bodySecondary,
              ),
            ),
          );
        }

        final initials = record.ownerName.length >= 2
            ? record.ownerName.substring(0, 2).toUpperCase()
            : record.ownerName.isNotEmpty
                ? record.ownerName[0].toUpperCase()
                : 'Gym';

        // Calculate days remaining
        final daysRemaining = record.daysUntilExpiry;

        // Resolve status tag
        Color tagColor = AcColors.active;
        String tagText = 'Active';

        if (record.killSwitchActive) {
          tagColor = AcColors.expired;
          tagText = 'Locked';
        } else if (record.status == 'suspended') {
          tagColor = AcColors.expired;
          tagText = 'Suspended';
        } else if (record.isEffectivelyExpired) {
          tagColor = AcColors.expired;
          tagText = 'Expired';
        } else if (record.daysUntilExpiry <= 7 && record.daysUntilExpiry >= 0) {
          tagColor = AcColors.warning;
          tagText = 'Grace';
        } else if (record.planId.contains('trial')) {
          tagColor = AcColors.warning;
          tagText = 'Trial';
        }

        // Open options action sheet drawer overlay
        void openOptionsSheet() {
          showAppActionSheet(
            context: context,
            title: 'User Actions',
            items: [
              ActionSheetItem(
                icon: Icons.calendar_today_rounded,
                label: 'Extend Subscription',
                subtitle: 'Add days to current plan manually',
                color: AcColors.active,
                onTap: () {
                  // Direct navigation to dedicated subscription manager page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubscriptionScreen(userId: record.userId),
                    ),
                  );
                },
              ),
              ActionSheetItem(
                icon: Icons.lock_person_outlined,
                label: record.killSwitchActive ? 'Unlock Account' : 'Lock Account',
                subtitle: record.killSwitchActive ? 'Restore active access' : 'Send immediate FCM lockout signal',
                color: record.killSwitchActive ? AcColors.active : AcColors.expired,
                onTap: () => _toggleKillSwitch(record.userId, !record.killSwitchActive),
              ),
              ActionSheetItem(
                icon: Icons.pause_circle_outline_rounded,
                label: record.status == 'suspended' ? 'Reactivate Plan' : 'Suspend Account',
                subtitle: record.status == 'suspended' ? 'Change status back to active' : 'Set status to suspended',
                color: record.status == 'suspended' ? AcColors.blue : AcColors.warning,
                onTap: () {
                  if (record.status == 'suspended') {
                    _setStatus(record.userId, 'active', 'Account reactivated.');
                  } else {
                    _setStatus(record.userId, 'suspended', 'Account suspended.');
                  }
                },
              ),
            ],
          );
        }

        return Scaffold(
          backgroundColor: AcColors.bg,
          body: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── BACK BAR ──
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (context.canPop()) {
                                    context.pop();
                                  } else {
                                    context.go('/dashboard');
                                  }
                                },
                                icon: const Icon(Icons.arrow_back_rounded, color: AcColors.textPrimary),
                                style: IconButton.styleFrom(
                                  backgroundColor: AcColors.s2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(11),
                                    side: const BorderSide(color: AcColors.rim2, width: 1),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text('User Profile', style: AcTextStyles.h2.copyWith(fontSize: 18)),
                              const Spacer(),
                              IconButton(
                                onPressed: openOptionsSheet,
                                icon: const Icon(Icons.more_vert_rounded, color: AcColors.textPrimary),
                                style: IconButton.styleFrom(
                                  backgroundColor: AcColors.s2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(11),
                                    side: const BorderSide(color: AcColors.rim2, width: 1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ── USER HERO ──
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          child: Row(
                            children: [
                              // Large Avatar
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: _avatarGradient(record.ownerName),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black45,
                                      blurRadius: 16,
                                      offset: Offset(0, 4),
                                    )
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  initials,
                                  style: AcTextStyles.label.copyWith(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      record.ownerName,
                                      style: AcTextStyles.h2.copyWith(fontSize: 20),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      record.businessName,
                                      style: AcTextStyles.bodySmall.copyWith(fontSize: 12.5),
                                    ),
                                    const SizedBox(height: 8),
                                    // Badges
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: tagColor.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: tagColor.withValues(alpha: 0.25), width: 1),
                                          ),
                                          child: Text(
                                            tagText.toUpperCase(),
                                            style: AcTextStyles.bodySmall.copyWith(
                                              color: tagColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AcColors.purple.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: AcColors.purple.withValues(alpha: 0.25), width: 1),
                                          ),
                                          child: Text(
                                            record.planId.toUpperCase(),
                                            style: AcTextStyles.bodySmall.copyWith(
                                              color: AcColors.purple,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // ── SUBSCRIPTION DETAILS CARD ──
                        _buildDetailCard(
                          icon: Icons.credit_card_rounded,
                          color: AcColors.primary,
                          title: 'Subscription Details',
                          rows: [
                            _buildCardRow('Plan', record.planId.toUpperCase(), isPrimary: true),
                            _buildCardRow('Start Date', DateFormat('dd MMM yyyy').format(record.startDate)),
                            _buildCardRow('Expiry Date', DateFormat('dd MMM yyyy').format(record.expiresAt)),
                            _buildCardRow(
                              'Days Remaining',
                              daysRemaining < 0 ? 'Expired' : '$daysRemaining days',
                              valColor: daysRemaining < 0
                                  ? AcColors.expired
                                  : daysRemaining <= 7
                                      ? AcColors.warning
                                      : AcColors.active,
                            ),
                            _buildCardRow('Auto-Renew', record.status == 'active' ? 'Enabled' : 'Disabled',
                                valColor: record.status == 'active' ? AcColors.active : AcColors.textSecondary),
                          ],
                        ),

                        // ── ACCOUNT INFO CARD ──
                        _buildDetailCard(
                          icon: Icons.person_outline_rounded,
                          color: AcColors.blue,
                          title: 'Account Info',
                          rows: [
                            _buildCardRow('User ID', record.userId),
                            _buildCardRow('Phone', record.phone.isEmpty ? '—' : record.phone),
                            _buildCardRow('Joined', DateFormat('dd MMM yyyy').format(record.createdAt)),
                            _buildCardRow('Last Active', record.lastSyncedAt != null ? DateFormat('dd MMM – HH:mm').format(record.lastSyncedAt!) : 'Never synced',
                                valColor: record.lastSyncedAt != null ? AcColors.active : AcColors.textSecondary),
                            _buildCardRow('Play Integrity', record.killSwitchActive ? 'FAIL' : 'PASS',
                                valColor: record.killSwitchActive ? AcColors.expired : AcColors.active),
                          ],
                        ),

                        // ── ADMIN NOTES CARD ──
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Admin Notes'.toUpperCase(), style: AcTextStyles.sectionTitle),
                              const SizedBox(height: 8),
                              if (!_editingNotes)
                                GestureDetector(
                                  onTap: () {
                                    _notesCtrl.text = record.notes;
                                    setState(() => _editingNotes = true);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: AcColors.s1,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: AcColors.rim2, width: 1),
                                    ),
                                    child: Text(
                                      record.notes.isEmpty ? 'Tap to add notes...' : record.notes,
                                      style: AcTextStyles.bodySmall.copyWith(
                                        color: record.notes.isEmpty ? AcColors.textMuted : AcColors.textPrimary,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                )
                              else ...[
                                TextField(
                                  controller: _notesCtrl,
                                  maxLines: 4,
                                  style: AcTextStyles.body,
                                  decoration: InputDecoration(
                                    fillColor: AcColors.s2,
                                    hintText: 'Write admin notes here...',
                                    hintStyle: TextStyle(color: AcColors.textMuted.withOpacity(0.5)),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () => setState(() => _editingNotes = false),
                                      child: Text(
                                        'Cancel',
                                        style: AcTextStyles.bodySmall.copyWith(color: AcColors.textSecondary),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AcColors.primary,
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                      ),
                                      onPressed: _savingNotes
                                          ? null
                                          : () async {
                                              setState(() => _savingNotes = true);
                                              try {
                                                await ref
                                                    .read(entitlementWriteServiceProvider)
                                                    .updateNotes(record.userId, _notesCtrl.text.trim());
                                                setState(() {
                                                  _savingNotes = false;
                                                  _editingNotes = false;
                                                });
                                                ref.read(toastProvider.notifier).show(AcStrings.notesSaved);
                                              } catch (e) {
                                                setState(() => _savingNotes = false);
                                                ref.read(toastProvider.notifier).show('Failed to save: $e');
                                              }
                                            },
                                      child: _savingNotes
                                          ? const SizedBox(
                                              height: 16,
                                              width: 16,
                                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                            )
                                          : const Text('Save Notes'),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ── QUICK ACTIONS GRID ──
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text('Quick Actions'.toUpperCase(), style: AcTextStyles.sectionTitle),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.5,
                            children: [
                              _buildActionButton(
                                icon: Icons.calendar_month_rounded,
                                color: AcColors.active,
                                label: 'Extend Subscription',
                                sub: 'Add days manually',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SubscriptionScreen(userId: record.userId),
                                    ),
                                  );
                                },
                              ),
                              _buildActionButton(
                                icon: Icons.swap_horiz_rounded,
                                color: AcColors.blue,
                                label: 'Change Plan',
                                sub: 'Monthly or annual',
                                onTap: () {
                                  // Open plan changer action sheet
                                  showAppActionSheet(
                                    context: context,
                                    title: 'Change Plan Tier',
                                    items: [
                                      ActionSheetItem(
                                        icon: Icons.wallet_rounded,
                                        label: 'Change to Monthly Plan',
                                        subtitle: 'Tier ₹499/mo',
                                        color: AcColors.blue,
                                        onTap: () => _setStatus(record.userId, 'active', 'Switched to Monthly.'),
                                      ),
                                      ActionSheetItem(
                                        icon: Icons.wallet_rounded,
                                        label: 'Upgrade to Annual Plan',
                                        subtitle: 'Tier ₹4,999/yr',
                                        color: AcColors.purple,
                                        onTap: () => _setStatus(record.userId, 'active', 'Switched to Annual.'),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              _buildActionButton(
                                icon: Icons.notifications_active_rounded,
                                color: AcColors.warning,
                                label: 'Send Reminder',
                                sub: 'Push notification',
                                onTap: () {
                                  ref.read(toastProvider.notifier).show('Reminder push sent.');
                                },
                              ),
                              _buildActionButton(
                                icon: Icons.lock_reset_rounded,
                                color: AcColors.purple,
                                label: 'Reset PIN',
                                sub: 'Clear app PIN',
                                onTap: () {
                                  ref.read(toastProvider.notifier).show('PIN reset instruction sent.');
                                },
                              ),
                              _buildActionButton(
                                icon: Icons.lock_open_rounded,
                                color: AcColors.active,
                                label: 'Restore Access',
                                sub: 'Unlock account',
                                onTap: () => _toggleKillSwitch(record.userId, false),
                              ),
                              _buildActionButton(
                                icon: Icons.block_rounded,
                                color: AcColors.expired,
                                label: 'Lock Account',
                                sub: 'Block app access',
                                onTap: () => _toggleKillSwitch(record.userId, true),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                
                // Toast overlay floating above content
                const AppToastOverlay(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required Color color,
    required String title,
    required List<Widget> rows,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: AcColors.s1,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AcColors.rim2, width: 1),
      ),
      child: Column(
        children: [
          // Card Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AcColors.rim, width: 1)),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    icon,
                    color: color,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: AcTextStyles.label.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
          // Rows
          ...rows,
        ],
      ),
    );
  }

  Widget _buildCardRow(String label, String value, {bool isPrimary = false, Color? valColor}) {
    final valueStyle = isPrimary
        ? AcTextStyles.mono(fontSize: 13, fontWeight: FontWeight.w800, color: AcColors.primary)
        : AcTextStyles.mono(fontSize: 13, fontWeight: FontWeight.w700, color: valColor ?? AcColors.textPrimary);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AcColors.rim, width: 1)),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: AcTextStyles.bodySmall.copyWith(
              color: AcColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: valueStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required String sub,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AcColors.s1,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AcColors.rim2, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(9),
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                color: color,
                size: 15,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AcTextStyles.label.copyWith(fontSize: 12, height: 1.2),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: AcTextStyles.subtext.copyWith(color: AcColors.textMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
