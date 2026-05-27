import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/ac_colors.dart';
import '../core/constants/ac_text_styles.dart';
import '../core/firebase/firebase_providers.dart';
import '../models/entitlement_record.dart';
import '../providers/entitlements_provider.dart';
import '../widgets/app_toast.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  final String userId;
  const SubscriptionScreen({super.key, required this.userId});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  int _selectedDays = 30; // default selected duration
  bool _applying = false;

  // Manual extension execution
  Future<void> _applyExtension(EntitlementRecord record) async {
    setState(() => _applying = true);
    try {
      await ref
          .read(entitlementWriteServiceProvider)
          .extendExpiry(record.userId, record.expiresAt, _selectedDays);
      ref.read(toastProvider.notifier).show('Extension applied! +$_selectedDays Days');
    } catch (e) {
      ref.read(toastProvider.notifier).show('Extension failed: $e');
    } finally {
      setState(() => _applying = false);
    }
  }

  // Set selected plan or status manually in database
  Future<void> _updatePlan(String planId, String toastMsg) async {
    try {
      await ref.read(entitlementWriteServiceProvider).setStatus(widget.userId, 'active');
      // Update planId in Firestore
      final firestore = ref.read(firestoreProvider);
      if (firestore != null) {
        await firestore.collection('entitlements').doc(widget.userId).update({
          'planId': planId,
        });
      }
      ref.read(toastProvider.notifier).show(toastMsg);
    } catch (e) {
      ref.read(toastProvider.notifier).show('Failed: $e');
    }
  }

  // Cancel/Suspend subscription in database
  Future<void> _cancelSubscription() async {
    try {
      await ref.read(entitlementWriteServiceProvider).setStatus(widget.userId, 'suspended');
      ref.read(toastProvider.notifier).show('Subscription cancelled.');
    } catch (e) {
      ref.read(toastProvider.notifier).show('Failed: $e');
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
              'Error loading plan details: $e',
              style: AcTextStyles.bodySecondary,
            ),
          ),
          data: (list) {
            final record = list.where((r) => r.userId == widget.userId).firstOrNull;

            if (record == null) {
              return Center(
                child: Text('Subscriber not found.', style: AcTextStyles.bodySecondary),
              );
            }

            // Calculate active subscriber counts for both plans dynamically
            final monthlyActive = list.where((r) => r.planId.toLowerCase() == 'monthly' && r.status == 'active' && !r.killSwitchActive).length;
            final annualActive = list.where((r) => (r.planId.toLowerCase() == 'yearly' || r.planId.toLowerCase() == 'annual') && r.status == 'active' && !r.killSwitchActive).length;

            return Stack(
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
                                  Navigator.pop(context);
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
                              Text('Manage Subscription', style: AcTextStyles.h2.copyWith(fontSize: 18)),
                            ],
                          ),
                        ),

                        // ── CURRENT PLANS UTILIZATION CARDS ──
                        
                        // Monthly Plan Card
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1A2A4A), Color(0xFF162036)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AcColors.blue.withValues(alpha: 0.2), width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Monthly Plan',
                                style: AcTextStyles.sectionTitle.copyWith(
                                  fontSize: 11,
                                  color: AcColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₹499',
                                style: AcTextStyles.h1.copyWith(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '$monthlyActive active subscribers',
                                style: AcTextStyles.bodySmall.copyWith(
                                  color: AcColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 14),
                              // Utilization Bar
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Utilization', style: AcTextStyles.subtext.copyWith(fontSize: 11)),
                                  Text('$monthlyActive/120', style: AcTextStyles.subtext.copyWith(fontSize: 11)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: LinearProgressIndicator(
                                  value: monthlyActive / 120.0,
                                  backgroundColor: Colors.white10,
                                  color: AcColors.blue,
                                  minHeight: 4,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Annual Plan Card
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2A1A3E), Color(0xFF1E1630)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AcColors.purple.withValues(alpha: 0.2), width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Annual Plan',
                                style: AcTextStyles.sectionTitle.copyWith(
                                  fontSize: 11,
                                  color: AcColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₹4,999',
                                style: AcTextStyles.h1.copyWith(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '$annualActive active subscribers',
                                style: AcTextStyles.bodySmall.copyWith(
                                  color: AcColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 14),
                              // Utilization Bar
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Utilization', style: AcTextStyles.subtext.copyWith(fontSize: 11)),
                                  Text('$annualActive/80', style: AcTextStyles.subtext.copyWith(fontSize: 11)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: LinearProgressIndicator(
                                  value: annualActive / 80.0,
                                  backgroundColor: Colors.white10,
                                  color: AcColors.purple,
                                  minHeight: 4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ── EXTEND DURATION SLIDER ──
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AcColors.s1,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AcColors.rim2, width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Extend Duration for: ${record.ownerName}',
                                style: AcTextStyles.label.copyWith(fontSize: 13),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  _buildDurationOpt(7, 'Days'),
                                  const SizedBox(width: 8),
                                  _buildDurationOpt(15, 'Days'),
                                  const SizedBox(width: 8),
                                  _buildDurationOpt(30, 'Days'),
                                  const SizedBox(width: 8),
                                  _buildDurationOpt(90, 'Days'),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // ── APPLY EXTENSION BUTTON ──
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AcColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: _applying ? null : () => _applyExtension(record),
                              child: _applying
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                      'Apply Extension · +$_selectedDays Days',
                                      style: AcTextStyles.body.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // ── ALL SUBSCRIPTION ACTIONS ──
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text('All Subscription Actions'.toUpperCase(), style: AcTextStyles.sectionTitle),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AcColors.s1,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AcColors.rim2, width: 1),
                          ),
                          child: Column(
                            children: [
                              _buildActionRow(
                                label: 'Force Renew (Manual)',
                                actionColor: AcColors.primary,
                                onTap: () => _applyExtension(record),
                              ),
                              _buildActionRow(
                                label: 'Extend Trial Period',
                                actionColor: AcColors.primary,
                                onTap: () => _updatePlan('trial', 'Trial period extended.'),
                              ),
                              _buildActionRow(
                                label: 'Upgrade to Annual',
                                actionColor: AcColors.primary,
                                onTap: () => _updatePlan('yearly', 'Upgraded to Annual plan.'),
                              ),
                              _buildActionRow(
                                label: 'Downgrade to Monthly',
                                actionColor: AcColors.warning,
                                onTap: () => _updatePlan('monthly', 'Downgraded to Monthly plan.'),
                              ),
                              _buildActionRow(
                                label: 'Cancel Subscription',
                                actionColor: AcColors.expired,
                                isLast: true,
                                onTap: _cancelSubscription,
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildDurationOpt(int val, String lbl) {
    final isSelected = _selectedDays == val;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedDays = val),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AcColors.brandL : AcColors.s2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AcColors.brandD : AcColors.rim2,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                '$val',
                style: AcTextStyles.label.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? AcColors.primary : AcColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                lbl,
                style: AcTextStyles.subtext.copyWith(
                  fontSize: 10,
                  color: isSelected ? AcColors.primary : AcColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionRow({
    required String label,
    required Color actionColor,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(bottom: BorderSide(color: AcColors.rim, width: 1)),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: AcTextStyles.body.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AcColors.textPrimary,
              ),
            ),
            const Spacer(),
            Text(
              '→',
              style: AcTextStyles.mono(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: actionColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
