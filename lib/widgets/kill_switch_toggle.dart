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
              onChanged: (val) async {
                setState(() => _loading = true);
                try {
                  await ref
                      .read(entitlementWriteServiceProvider)
                      .setKillSwitch(widget.userId, val);
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
              },
            ),
        ],
      ),
    );
  }
}
