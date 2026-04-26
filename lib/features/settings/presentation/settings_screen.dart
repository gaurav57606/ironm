import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../features/auth/viewmodel/auth_viewmodel.dart';
import '../../members/viewmodel/members_viewmodel.dart';
import '../../payments/viewmodel/payments_viewmodel.dart';
import '../../../core/services/csv_export_service.dart';



class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {

  bool _exportingMembers = false;
  bool _exportingPayments = false;
  final _csvService = const CsvExportService();

  @override
  void initState() {
    super.initState();
    // Dark mode: not yet implemented — hidden from UI
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.bg),
      child: Scaffold(
        backgroundColor: Colors.transparent,        body: Column(
          children: [
            _buildHeader(context, ref),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                children: [
                  _buildSectionHeader('General'),
                  _buildSettingsItem(Icons.person_outline_rounded, 'Account Settings', 'Manage your gym profile', () => context.push('/settings/account')),
                  _buildSettingsItem(Icons.card_membership_rounded, 'Membership Plans', 'Manage plans & pricing', () => context.push('/settings/plans')),
                  _buildSettingsItem(Icons.notifications_none_rounded, 'Notifications', 'Expiry alerts — coming soon', null),
                  _buildSettingsItem(Icons.sync_rounded, 'Data Synchronization', 'Auto-syncs when online', null),
                  
                  _buildSectionHeader('System'),
                  _buildSettingsItem(Icons.cloud_upload_outlined, 'Backup & Restore', 'Keep your data safe', () => context.push('/settings/backup')),
                  
                  _buildSectionHeader('Export Data'),
                  _buildExportTile(
                    Icons.file_download_outlined,
                    'Export Members',
                    'Download member list as CSV',
                    _exportingMembers,
                    _exportMembers,
                  ),
                  _buildExportTile(
                    Icons.receipt_long_outlined,
                    'Export Payments',
                    'Download payment records as CSV',
                    _exportingPayments,
                    _exportPayments,
                  ),
                  _buildSettingsItem(Icons.security_rounded, 'Security & PIN', 'PIN & biometric — coming soon', null),
                  _buildSettingsItem(Icons.language_rounded, 'Language', 'English (IN)', null),
                  
                  _buildSectionHeader('About'),
                  _buildSettingsItem(Icons.info_outline_rounded, 'App Version', 'v1.4.2 (Production)', null),
                  _buildSettingsItem(Icons.help_outline_rounded, 'Help & Support', 'Contact IronBook team', () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: AppColors.bg3,
                        title: Text('Help & Support', style: AppTextStyles.h3),
                        content: Text(
                          'For support, contact:\nsupport@ironm.app\n\nVersion: v1.4.2',
                          style: AppTextStyles.body.copyWith(fontSize: 11),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => ctx.pop(),
                            child: const Text('Close', style: TextStyle(color: AppColors.orange)),
                          ),
                        ],
                      ),
                    );
                  }),
                  
                  const SizedBox(height: 20),
                  _buildLogoutButton(ref),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final owner = ref.watch(authProvider).owner;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      child: Row(
        children: [
          Text('Settings', style: AppTextStyles.h2.copyWith(fontSize: 20)),
          const Spacer(),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.orange,
              borderRadius: BorderRadius.circular(11),
            ),
            alignment: Alignment.center,
            child: Text(owner?.ownerName.isNotEmpty == true ? owner!.ownerName[0].toUpperCase() : 'I', 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
          ),
        ],
      ),
    );
  }



  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 20, 6, 8),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.label.copyWith(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, String subtitle, VoidCallback? onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.bg3,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        dense: true,
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.bg4,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 16, color: AppColors.orange),
        ),
        title: Text(title, style: AppTextStyles.body.copyWith(fontSize: 12, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: AppTextStyles.label.copyWith(fontSize: 9, color: AppColors.textMuted)),
        trailing: onTap != null ? const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.textMuted) : null,
      ),
    );
  }



  Widget _buildLogoutButton(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => ref.read(authProvider.notifier).logout(),
          icon: const Icon(Icons.logout_rounded, size: 14),
          label: const Text('Log Out'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.expired.withValues(alpha: 0.1),
            foregroundColor: AppColors.expired,
            padding: const EdgeInsets.symmetric(vertical: 11),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppColors.expired.withValues(alpha: 0.2)),
            ),
            elevation: 0,
            textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
  Future<void> _exportMembers() async {
    setState(() => _exportingMembers = true);
    try {
      final members = ref.read(membersProvider);
      await _csvService.exportAndShareMembers(members);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _exportingMembers = false);
    }
  }

  Future<void> _exportPayments() async {
    setState(() => _exportingPayments = true);
    try {
      final payments = ref.read(allPaymentsProvider);
      await _csvService.exportAndSharePayments(payments);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _exportingPayments = false);
    }
  }

  Widget _buildExportTile(IconData icon, String title, String subtitle, bool isLoading, VoidCallback onTap) {
    return _buildSettingsItem(
      isLoading ? Icons.hourglass_empty_rounded : icon,
      title,
      subtitle,
      isLoading ? null : onTap,
    );
  }
}

