import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../core/constants/ac_colors.dart';
import '../core/constants/ac_strings.dart';
import '../core/constants/ac_text_styles.dart';
import '../models/entitlement_record.dart';
import '../providers/entitlements_provider.dart';
import '../widgets/kill_switch_toggle.dart';
import '../widgets/status_badge.dart';

class SubscriberDetailScreen extends ConsumerStatefulWidget {
  final String userId;
  const SubscriberDetailScreen({super.key, required this.userId});

  @override
  ConsumerState<SubscriberDetailScreen> createState() =>
      _SubscriberDetailScreenState();
}

class _SubscriberDetailScreenState extends ConsumerState<SubscriberDetailScreen> {
  bool _editingNotes = false;
  final TextEditingController _notesCtrl = TextEditingController();
  bool _savingNotes = false;
  bool _savingGrace = false;

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _editGracePeriod(BuildContext context, WidgetRef ref, EntitlementRecord record) async {
    int tempDays = record.gracePeriodDays;
    final confirmed = await showDialog<int>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          backgroundColor: AcColors.bg2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Edit Grace Period', style: AcTextStyles.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Set the number of days after expiry before the account is fully locked.',
                  style: AcTextStyles.bodySmall),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: tempDays > 0 ? () => setStateDialog(() => tempDays--) : null,
                    icon: const Icon(Icons.remove_circle_outline, color: AcColors.textSecondary),
                  ),
                  SizedBox(
                    width: 48,
                    child: Text('$tempDays days', textAlign: TextAlign.center, style: AcTextStyles.label),
                  ),
                  IconButton(
                    onPressed: tempDays < 30 ? () => setStateDialog(() => tempDays++) : null,
                    icon: const Icon(Icons.add_circle_outline, color: AcColors.primary),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, null),
              child: Text('Cancel', style: AcTextStyles.bodySmall.copyWith(color: AcColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, tempDays),
              child: Text('Save', style: AcTextStyles.label.copyWith(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
    if (confirmed == null || confirmed == record.gracePeriodDays) return;
    setState(() => _savingGrace = true);
    try {
      await ref.read(entitlementWriteServiceProvider).updateGracePeriod(record.userId, confirmed);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Grace period updated.'),
        backgroundColor: AcColors.active,
      ));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update: $e'),
        backgroundColor: AcColors.expired,
      ));
    } finally {
      if (mounted) setState(() => _savingGrace = false);
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
        body: Center(
            child: Text('Error: $e', style: AcTextStyles.bodySecondary)),
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

        return Scaffold(
          backgroundColor: AcColors.bg,
          appBar: AppBar(
            title: Text(record.businessName, style: AcTextStyles.title),
            leading: const BackButton(),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── SECTION 1: Info Card ─────────────────────────────────
                const _SectionHeader('Subscriber Info'),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AcColors.elevation2,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AcColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoRow('Owner', record.ownerName),
                      _InfoRow('Business', record.businessName),
                      _InfoRow(
                          'Phone', record.phone.isEmpty ? '—' : record.phone),
                      _InfoRow('App ID', record.appId),
                      _InfoRow(
                          'Plan', record.planId.isEmpty ? '—' : record.planId),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 110,
                              child: Text('Grace Period', style: AcTextStyles.bodySmall.copyWith(color: AcColors.textMuted)),
                            ),
                            Text('${record.gracePeriodDays} days',
                                style: AcTextStyles.bodySmall.copyWith(color: AcColors.textPrimary, fontWeight: FontWeight.w500)),
                            const Spacer(),
                            _savingGrace
                                ? const SizedBox(width: 16, height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: AcColors.primary))
                                : GestureDetector(
                                    onTap: () => _editGracePeriod(context, ref, record),
                                    child: const Icon(Icons.edit_outlined, size: 16, color: AcColors.primary),
                                  ),
                          ],
                        ),
                      ),
                      _InfoRow('Started',
                          DateFormat('dd MMM yyyy').format(record.startDate)),
                      _InfoRow('Expires',
                          DateFormat('dd MMM yyyy').format(record.expiresAt)),
                      _InfoRow(
                          'Last Synced',
                          record.lastSyncedAt != null
                              ? DateFormat('dd MMM yyyy – HH:mm')
                                  .format(record.lastSyncedAt!)
                              : 'Never synced'),
                      const SizedBox(height: 12),
                      StatusBadge(
                          status: record.status,
                          killSwitchActive: record.killSwitchActive),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── SECTION 2: Kill Switch ───────────────────────────────
                const _SectionHeader('Kill Switch'),
                const SizedBox(height: 8),
                KillSwitchToggle(
                  userId: record.userId,
                  currentValue: record.killSwitchActive,
                ),
                const SizedBox(height: 20),

                // ── SECTION 3: Quick Actions ─────────────────────────────
                const _SectionHeader('Quick Actions'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _ActionButton(
                      label: '+7 Days',
                      icon: Icons.add_circle_outline_rounded,
                      color: AcColors.active,
                      onPressed: () => _extend(ref, record, 7),
                    ),
                    _ActionButton(
                      label: '+15 Days',
                      icon: Icons.add_circle_outline_rounded,
                      color: AcColors.active,
                      onPressed: () => _extend(ref, record, 15),
                    ),
                    _ActionButton(
                      label: '+30 Days',
                      icon: Icons.add_circle_outline_rounded,
                      color: AcColors.active,
                      onPressed: () => _extend(ref, record, 30),
                    ),
                    _ActionButton(
                      label: '+90 Days',
                      icon: Icons.add_circle_outline_rounded,
                      color: AcColors.active,
                      onPressed: () => _extend(ref, record, 90),
                    ),
                    _ActionButton(
                      label: 'Suspend',
                      icon: Icons.pause_circle_outline_rounded,
                      color: AcColors.expiring,
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: AcColors.bg2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            title: Row(
                              children: [
                                const Icon(Icons.pause_circle_outline_rounded, color: AcColors.expiring, size: 22),
                                const SizedBox(width: 10),
                                Text('Suspend Subscriber?', style: AcTextStyles.title),
                              ],
                            ),
                            content: Text(
                              'This will suspend ${record.businessName}. '
                              'They will be locked out until you manually reactivate them.',
                              style: AcTextStyles.bodySmall,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: Text('Cancel', style: AcTextStyles.bodySmall.copyWith(color: AcColors.textSecondary)),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AcColors.expiring),
                                onPressed: () => Navigator.pop(ctx, true),
                                child: Text('Yes, Suspend', style: AcTextStyles.label.copyWith(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                        if (confirmed != true) return;
                        if (!context.mounted) return;
                        _setStatus(context, ref, record.userId, 'suspended', AcStrings.suspended);
                      },
                    ),
                    _ActionButton(
                      label: 'Reactivate',
                      icon: Icons.play_circle_outline_rounded,
                      color: AcColors.primary,
                      onPressed: () => _setStatus(context, ref, record.userId,
                          'active', AcStrings.reactivated),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── SECTION 4: Admin Notes ───────────────────────────────
                const _SectionHeader('Admin Notes'),
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
                        color: AcColors.elevation2,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AcColors.border),
                      ),
                      child: Text(
                        record.notes.isEmpty
                            ? 'Tap to add notes...'
                            : record.notes,
                        style: AcTextStyles.bodySmall.copyWith(
                          color: record.notes.isEmpty
                              ? AcColors.textMuted
                              : AcColors.textPrimary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  )
                else ...[
                  TextField(
                    controller: _notesCtrl,
                    maxLines: 5,
                    style: AcTextStyles.body,
                    decoration: const InputDecoration(
                        hintText: 'Write admin notes here...'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => setState(() => _editingNotes = false),
                        child: Text(
                          'Cancel',
                          style: AcTextStyles.bodySmall
                              .copyWith(color: AcColors.textSecondary),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _savingNotes
                            ? null
                            : () async {
                                setState(() => _savingNotes = true);
                                try {
                                  await ref
                                      .read(entitlementWriteServiceProvider)
                                      .updateNotes(
                                          record.userId, _notesCtrl.text.trim());
                                  if (!context.mounted) return;
                                  setState(() {
                                    _savingNotes = false;
                                    _editingNotes = false;
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(AcStrings.notesSaved),
                                    backgroundColor: AcColors.active,
                                  ));
                                } catch (e) {
                                  if (!context.mounted) return;
                                  setState(() => _savingNotes = false);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('Failed to save: $e'),
                                    backgroundColor: AcColors.expired,
                                  ));
                                }
                              },
                        child: _savingNotes
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Save Notes'),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                const Divider(color: AcColors.border),
                const SizedBox(height: 16),
                const _SectionHeader('Danger Zone'),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AcColors.expired.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AcColors.expired.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delete Subscriber',
                        style: AcTextStyles.bodySmall.copyWith(
                          color: AcColors.expired,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Permanently removes this subscriber and all their data from the system. This cannot be undone.',
                        style: AcTextStyles.subtext,
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _deleteSubscriber(context, ref, record),
                          icon: const Icon(Icons.delete_forever_rounded, color: AcColors.expired, size: 18),
                          label: Text('Delete Subscriber',
                              style: AcTextStyles.label.copyWith(color: AcColors.expired)),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AcColors.expired.withValues(alpha: 0.5)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _extend(WidgetRef ref,
      EntitlementRecord record, int days) async {
    try {
      await ref
          .read(entitlementWriteServiceProvider)
          .extendExpiry(record.userId, record.expiresAt, days);
      if (!mounted) return;
      final msg = {
        7: AcStrings.extended7,
        15: AcStrings.extended15,
        30: AcStrings.extended30,
        90: AcStrings.extended90,
      }[days] ?? 'Subscription extended by $days days.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: AcColors.active,
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed: $e'),
        backgroundColor: AcColors.expired,
      ));
    }
  }

  Future<void> _deleteSubscriber(BuildContext context, WidgetRef ref, EntitlementRecord record) async {
    // Step 1: Are you sure?
    final step1 = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AcColors.bg2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          const Icon(Icons.warning_rounded, color: AcColors.expired, size: 22),
          const SizedBox(width: 10),
          Text('Delete Subscriber?', style: AcTextStyles.title),
        ]),
        content: Text(
          'You are about to permanently delete "${record.businessName}". This action cannot be undone.',
          style: AcTextStyles.bodySmall,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancel', style: AcTextStyles.bodySmall.copyWith(color: AcColors.textSecondary))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AcColors.expired),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Continue', style: AcTextStyles.label.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
    if (step1 != true) return;
    if (!context.mounted) return;
    // Step 2: Type business name to confirm
    final nameCtrl = TextEditingController();
    final step2 = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          backgroundColor: AcColors.bg2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Confirm Deletion', style: AcTextStyles.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Type the business name to confirm:',
                style: AcTextStyles.bodySmall,
              ),
              const SizedBox(height: 6),
              Text('"${record.businessName}"',
                  style: AcTextStyles.bodySmall.copyWith(
                      color: AcColors.expired, fontWeight: FontWeight.w700)),
              const SizedBox(height: 14),
              TextField(
                controller: nameCtrl,
                style: AcTextStyles.body,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Type business name here'),
                onChanged: (_) => setStateDialog(() {}),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false),
                child: Text('Cancel', style: AcTextStyles.bodySmall.copyWith(color: AcColors.textSecondary))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AcColors.expired),
              onPressed: nameCtrl.text.trim() == record.businessName
                  ? () => Navigator.pop(ctx, true)
                  : null,
              child: Text('Delete Forever', style: AcTextStyles.label.copyWith(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
    nameCtrl.dispose();
    if (step2 != true) return;
    try {
      await ref.read(entitlementWriteServiceProvider).deleteEntitlement(record.userId);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Subscriber deleted successfully.'),
        backgroundColor: AcColors.active,
      ));
      context.go('/subscribers');
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete: $e'),
        backgroundColor: AcColors.expired,
      ));
    }
  }

  Future<void> _setStatus(BuildContext context, WidgetRef ref, String userId,
      String status, String successMsg) async {
    try {
      await ref.read(entitlementWriteServiceProvider).setStatus(userId, status);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(successMsg),
        backgroundColor: AcColors.active,
      ));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed: $e'),
        backgroundColor: AcColors.expired,
      ));
    }
  }
}

// ── Private sub-widgets (file-level private classes) ───────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);
  @override
  Widget build(BuildContext context) => Text(
        title.toUpperCase(),
        style: AcTextStyles.sectionTitle,
      );
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              child: Text(label,
                  style:
                      AcTextStyles.bodySmall.copyWith(color: AcColors.textMuted)),
            ),
            Expanded(
              child: Text(
                value,
                style: AcTextStyles.bodySmall.copyWith(
                  color: AcColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16, color: color),
        label: Text(label, style: AcTextStyles.bodySmall.copyWith(color: color)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withValues(alpha: 0.6)),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
}
