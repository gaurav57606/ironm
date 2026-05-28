import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/ac_colors.dart';
import '../core/constants/ac_text_styles.dart';
import '../providers/entitlements_provider.dart';

class KillSwitchToggle extends ConsumerStatefulWidget {
  final String userId;
  final bool currentValue;
  const KillSwitchToggle({
    super.key,
    required this.userId,
    required this.currentValue,
  });

  @override
  ConsumerState<KillSwitchToggle> createState() => _KillSwitchToggleState();
}

class _KillSwitchToggleState extends ConsumerState<KillSwitchToggle> {
  bool _loading = false;

  Future<void> _handleToggle(BuildContext context, WidgetRef ref, bool newValue) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AcColors.bg2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              newValue ? Icons.block_rounded : Icons.lock_open_rounded,
              color: newValue ? AcColors.expired : AcColors.active,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              newValue ? 'Activate Kill Switch?' : 'Restore Access?',
              style: AcTextStyles.title,
            ),
          ],
        ),
        content: Text(
          newValue
              ? 'This will immediately lock this subscriber out of the app. '
                'They will not be able to use any features until access is restored.'
              : 'This will restore full app access for this subscriber immediately.',
          style: AcTextStyles.bodySmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: AcTextStyles.bodySmall.copyWith(color: AcColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: newValue ? AcColors.expired : AcColors.active,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              newValue ? 'Yes, Lock Out' : 'Yes, Restore',
              style: AcTextStyles.label.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _loading = true);
    try {
      await ref
          .read(entitlementWriteServiceProvider)
          .setKillSwitch(widget.userId, newValue);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed: $e'),
            backgroundColor: AcColors.expired,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.currentValue
            ? AcColors.expired.withValues(alpha: 0.08)
            : AcColors.elevation2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.currentValue ? AcColors.expired : AcColors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            widget.currentValue
                ? Icons.lock_rounded
                : Icons.lock_open_rounded,
            color: widget.currentValue ? AcColors.expired : AcColors.active,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kill Switch', style: AcTextStyles.label),
                Text(
                  widget.currentValue
                      ? 'User is LOCKED OUT. Toggle off to restore access.'
                      : 'Toggle ON to immediately block user access.',
                  style: AcTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (_loading)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Switch(
              value: widget.currentValue,
              activeColor: AcColors.expired,
              inactiveThumbColor: AcColors.active,
              onChanged: (val) => _handleToggle(context, ref, val),
            ),
        ],
      ),
    );
  }
}
