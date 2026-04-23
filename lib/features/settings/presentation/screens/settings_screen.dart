import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/app_bottom_nav.dart';
import '../../../../shared/widgets/status_bar_wrapper.dart';
import '../../../../data/notifiers/auth_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.bg),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: StatusBarWrapper(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  children: [
                    _buildSectionHeader('General'),
                    _buildSettingsItem(Icons.person_outline_rounded, 'Account Settings', 'Manage your gym profile', () {}),
                    _buildSettingsItem(Icons.notifications_none_rounded, 'Notifications', 'Expiry alerts & reminders', () {}),
                    _buildSettingsItem(Icons.sync_rounded, 'Data Synchronization', 'Sync with cloud (Last sync: 2h ago)', () {}),
                    _buildSettingsToggle(Icons.dark_mode_outlined, 'Dark Mode', 'System default enabled', true),
                    
                    _buildSectionHeader('System'),
                    _buildSettingsItem(Icons.cloud_upload_outlined, 'Backup & Restore', 'Keep your data safe', () {}),
                    _buildSettingsItem(Icons.security_rounded, 'Security & PIN', 'Biometric & PIN lock', () {}),
                    _buildSettingsItem(Icons.language_rounded, 'Language', 'English (IN)', () {}),
                    
                    _buildSectionHeader('About'),
                    _buildSettingsItem(Icons.info_outline_rounded, 'App Version', 'v1.4.2 (Production)', null),
                    _buildSettingsItem(Icons.help_outline_rounded, 'Help & Support', 'Contact IronBook team', () {}),
                    
                    const SizedBox(height: 20),
                    _buildLogoutButton(ref),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: 7, // Setup
          onTap: (index) {
            // Navigation handled by router
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      child: Row(
        children: [
          _buildIconButton(Icons.chevron_left, () => context.pop()),
          const SizedBox(width: 12),
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
            child: const Text('R', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.bg3,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: AppColors.border),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 16, color: AppColors.textPrimary),
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

  Widget _buildSettingsToggle(IconData icon, String title, String subtitle, bool value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.bg3,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
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
        trailing: Switch(
          value: value,
          onChanged: (v) {},
          activeColor: AppColors.orange,
          activeTrackColor: AppColors.orange.withOpacity(0.2),
          inactiveThumbColor: AppColors.textMuted,
          inactiveTrackColor: AppColors.bg4,
        ),
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
            backgroundColor: AppColors.expired.withOpacity(0.1),
            foregroundColor: AppColors.expired,
            padding: const EdgeInsets.symmetric(vertical: 11),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppColors.expired.withOpacity(0.2)),
            ),
            elevation: 0,
            textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
