import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
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
                      _InfoRow('Grace Period', '${record.gracePeriodDays} days'),
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
                      onPressed: () => _setStatus(ref, record.userId,
                          'suspended', AcStrings.suspended),
                    ),
                    _ActionButton(
                      label: 'Reactivate',
                      icon: Icons.play_circle_outline_rounded,
                      color: AcColors.primary,
                      onPressed: () => _setStatus(ref, record.userId,
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(days == 30 ? AcStrings.extended30 : AcStrings.extended90),
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

  Future<void> _setStatus(WidgetRef ref, String userId,
      String status, String successMsg) async {
    try {
      await ref.read(entitlementWriteServiceProvider).setStatus(userId, status);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(successMsg),
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
