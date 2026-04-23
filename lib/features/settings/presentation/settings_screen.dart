import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

// 🔒 LOCKED SCREEN — SettingsScreen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 32),
            _buildSection('Gym Configuration', [
              _buildSettingTile('Subscription Plans', Icons.fitness_center_outlined, 'Manage your plans'),
              _buildSettingTile('GST Settings', Icons.receipt_long_outlined, 'Configure taxes'),
            ]),
            const SizedBox(height: 24),
            _buildSection('Security', [
              _buildSettingTile('Change PIN', Icons.lock_outline, 'Update your entry PIN'),
              _buildSettingTile('Biometrics', Icons.fingerprint, 'Face ID / Fingerprint'),
            ]),
            const SizedBox(height: 24),
            _buildSection('System', [
              _buildSettingTile('Backup Data', Icons.cloud_upload_outlined, 'Sync to cloud'),
              _buildSettingTile('Restore Data', Icons.cloud_download_outlined, 'Download history'),
            ]),
            const SizedBox(height: 48),
            Center(
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Log Out', style: TextStyle(color: AppColors.red)),
              ),
            ),
            Center(
              child: Text('IronBook GM v1.0.0', style: AppTextStyles.subtext),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: AppColors.orange,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Raj\'s Fitness', style: AppTextStyles.title),
                Text('Owner: Rajesh Kumar', style: AppTextStyles.subtext),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textTertiary),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.caption.copyWith(color: AppColors.orange)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingTile(String title, IconData icon, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary, size: 20),
      title: Text(title, style: AppTextStyles.body),
      subtitle: Text(subtitle, style: AppTextStyles.subtext),
      trailing: const Icon(Icons.chevron_right, size: 16, color: AppColors.textTertiary),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: BottomNavigationBar(
        currentIndex: 4,
        onTap: (index) {
          switch (index) {
            case 0: context.go('/dashboard'); break;
            case 1: context.go('/members'); break;
            case 2: context.go('/payments'); break;
            case 3: context.go('/attendance'); break;
            case 4: context.go('/settings'); break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Members'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Payments'),
          BottomNavigationBarItem(icon: Icon(Icons.fact_check_outlined), label: 'Attendance'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}
