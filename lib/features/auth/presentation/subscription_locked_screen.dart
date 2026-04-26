import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/security_providers.dart';
import '../../../core/security/entitlement_provider.dart';
import '../../../core/security/entitlement_guard.dart';
import '../viewmodel/auth_viewmodel.dart';

class SubscriptionLockedScreen extends ConsumerStatefulWidget {
  const SubscriptionLockedScreen({super.key});

  @override
  ConsumerState<SubscriptionLockedScreen> createState() => _SubscriptionLockedScreenState();
}

class _SubscriptionLockedScreenState extends ConsumerState<SubscriptionLockedScreen> {
  bool _isChecking = false;
  String? _cachedExpiryDisplay;

  @override
  void initState() {
    super.initState();
    _loadCachedExpiry();
  }

  Future<void> _loadCachedExpiry() async {
    final storage = ref.read(appSecureStorageProvider);
    final expiryRaw = await storage.read(key: 'ent_expiry');
    if (expiryRaw != null) {
      final expiry = DateTime.tryParse(expiryRaw);
      if (expiry != null) {
        if (mounted) {
          setState(() {
            _cachedExpiryDisplay = 'Expired on: ${DateFormat('dd MMM yyyy').format(expiry)}';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.expired.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.expired,
                    size: 56,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Subscription Expired',
                  style: AppTextStyles.h1.copyWith(fontSize: 26),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Your IronM subscription has expired.\nPlease renew to continue managing your gym.',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.elevation2,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: authState.owner != null
                      ? Column(
                          children: [
                            Text(
                              'Gym: ${authState.owner!.gymName}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Contact support to renew your subscription.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : Text(
                          'Contact: support@ironm.app',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                ),
                if (_cachedExpiryDisplay != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _cachedExpiryDisplay!,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.expired),
                  ),
                ],
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isChecking
                        ? null
                        : () async {
                            try {
                              setState(() => _isChecking = true);
                              ref.invalidate(entitlementProvider);
                              // Wait for a cycle to allow the FutureProvider to re-fetch
                              await Future.delayed(const Duration(milliseconds: 500));
                              
                              final status = ref.read(entitlementProvider).value;
                              if (status != EntitlementStatus.valid) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Subscription still inactive. Contact support.'),
                                    ),
                                  );
                                  setState(() => _isChecking = false);
                                }
                              }
                            } catch (e) {
                              if (mounted) {
                                setState(() => _isChecking = false);
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isChecking
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Check Again'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () async {
                      await ref.read(authProvider.notifier).signOut();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Sign Out'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
