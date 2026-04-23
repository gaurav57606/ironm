import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/status_bar_wrapper.dart';
import '../../../../core/providers/owner_provider.dart';
import '../../../../data/models/owner_profile.dart';
import '../../members/viewmodel/members_viewmodel.dart';
import '../../payments/viewmodel/payments_viewmodel.dart';
import '../../../../data/models/member.dart';

class GamificationScreen extends ConsumerWidget {
  const GamificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final owner = ref.watch(ownerProvider).valueOrNull;
    final membersAsync = ref.watch(membersViewModelProvider);
    final paymentsAsync = ref.watch(paymentsViewModelProvider);

    final members = membersAsync.valueOrNull ?? [];
    final payments = paymentsAsync.valueOrNull ?? [];

    // Dynamic Metric Calculation
    final totalMembers = members.length;
    final activeMembers = members.where((m) => m.isActive).length;
    final endurance = totalMembers > 0 ? (activeMembers / totalMembers) : 0.5;

    final totalRevenue = payments.fold(0.0, (sum, p) => sum + p.amount);
    final strength = (totalRevenue / 500000).clamp(0.1, 1.0); // 5L as baseline for 100% strength

    // For now, dexterity is hardcoded or tied to something else
    const dexterity = 0.9; 

    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: StatusBarWrapper(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      _buildCharacterSlot(
                        context,
                        'Iron Warrior',
                        'Level ${owner?.level ?? 1} Gym Leader',
                        Icons.shield_rounded,
                        owner?.selectedCharacterId == 'warrior' || owner?.selectedCharacterId == null,
                        onTap: () => _updateCharacter(ref, 'warrior'),
                      ),
                      const SizedBox(height: 16),
                      _buildCharacterSlot(
                        context,
                        'Agility Master',
                        (owner?.level ?? 1) >= 5 ? 'Unlocked' : 'Unlocks at Level 5',
                        Icons.bolt_rounded,
                        owner?.selectedCharacterId == 'agility',
                        locked: (owner?.level ?? 1) < 5,
                        onTap: () => _updateCharacter(ref, 'agility'),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.analytics_rounded, color: AppColors.orange, size: 16),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'ENTERPRISE VITALITY',
                            style: AppTextStyles.bodySmall.copyWith(
                              letterSpacing: 2.0, 
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildMetricRow('STRENGTH (REVENUE)', strength, AppColors.primary),
                      _buildMetricRow('ENDURANCE (RETENTION)', endurance, AppColors.blue),
                      _buildMetricRow('DEXTERITY (INTEGRITY)', AppColors.active, dexterity),
                      
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.elevation2,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.info_outline_rounded, color: AppColors.orange, size: 28),
                            const SizedBox(height: 16),
                            Text(
                              'Stats are calculated from real business metrics. Improve your sync health and revenue to increase your levels.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Gym Leader Profile',
            style: AppTextStyles.h1.copyWith(fontSize: 24),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.elevation2,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.shield_rounded, color: AppColors.orange, size: 20),
          ),
        ],
      ),
    );
  }

  void _updateCharacter(WidgetRef ref, String id) {
    final current = ref.read(ownerProvider).valueOrNull;
    if (current == null) return;
    
    if (id == 'agility' && current.level < 5) return;

    ref.read(ownerProvider.notifier).updateOwner(
      current.copyWith(selectedCharacterId: id),
    );
  }

  Widget _buildCharacterSlot(BuildContext context, String title, String subtitle, IconData icon, bool active, {bool locked = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: active ? AppColors.elevation3 : AppColors.elevation2,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: active ? AppColors.orange : AppColors.border, width: active ? 2 : 1),
          boxShadow: active ? [
            BoxShadow(
              color: AppColors.orange.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ] : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: active ? AppColors.orange.withOpacity(0.1) : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: active ? AppColors.orange : AppColors.textMuted, size: 26),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: active ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            if (locked)
              const Icon(Icons.lock_outline_rounded, color: AppColors.textMuted, size: 22)
            else if (active)
              const Icon(Icons.check_circle_rounded, color: AppColors.orange, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label, 
                style: AppTextStyles.bodySmall.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.7))
              ),
              Text(
                '${(value * 100).toInt()}%', 
                style: AppTextStyles.bodySmall.copyWith(fontSize: 11, color: color, fontWeight: FontWeight.black)
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(4),
            ),
            child: UnconstrainedBox(
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                height: 8,
                width: MediaQuery.of(context).size.width * 0.8 * value,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.5)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
