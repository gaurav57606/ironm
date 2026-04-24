import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/providers/backup_provider.dart';
import '../../../../core/services/backup_service.dart';
import '../../../../core/services/restore_service.dart';

class BackupRestoreScreen extends ConsumerStatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  ConsumerState<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends ConsumerState<BackupRestoreScreen> {
  // UI state for progress/messages
  String? _statusMessage;
  bool _isSuccess = true;

  Future<void> _handleCreateBackup() async {
    final result = await ref.read(backupViewModelProvider.notifier).createBackup();
    if (!context.mounted) return;
    if (result is BackupSuccess) {
        setState(() {
          _statusMessage = 'Backup created successfully at\n${result.filePath}';
          _isSuccess = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup Saved!'), backgroundColor: Colors.green),
        );
      } else if (result is BackupFailure) {
        setState(() {
          _statusMessage = 'Backup failed: ${result.error}';
          _isSuccess = false;
        });
      }
    }

  Future<void> _handleRestore() async {
    final pickerResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (pickerResult != null && pickerResult.files.single.path != null) {
      final path = pickerResult.files.single.path!;
      if (!context.mounted) return;
      // Confirm restore
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.bg3,
          title: Text('Confirm Restore', style: AppTextStyles.h3),
          content: Text(
            'This will OVERWRITE all current data with the backup. This cannot be undone. Continue?',
            style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Restore Now', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );

      if (confirm == true) {
        final result = await ref.read(backupViewModelProvider.notifier).restoreFromFile(path);
        if (!context.mounted) return;
        if (result is RestoreSuccess) {
            setState(() {
              _statusMessage = 'Restore complete! ${result.membersRestored} members recovered.';
              _isSuccess = true;
            });
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                backgroundColor: AppColors.bg3,
                title: Text('Restore Successful', style: AppTextStyles.h3),
                content: Text(
                  'The application data has been restored. Please restart the app to ensure all changes are reflected.',
                  style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
                ),
                actions: [
                  TextButton(onPressed: () => context.go('/dashboard'), child: const Text('OK')),
                ],
              ),
            );
          } else if (result is RestoreFailure) {
            setState(() {
              _statusMessage = 'Restore failed: ${result.error}';
              _isSuccess = false;
            });
          }
        }
      }
    }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(backupViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text('Backup & Restore', style: AppTextStyles.h3.copyWith(fontSize: 18)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(),
                const SizedBox(height: 32),
                _buildActionSection(
                  title: 'Data Preservation',
                  subtitle: 'Create a secure backup of your gym database.',
                  icon: Icons.cloud_upload_rounded,
                  buttonLabel: 'Create New Backup',
                  onPressed: _handleCreateBackup,
                  isLoading: asyncState.isLoading,
                ),
                const SizedBox(height: 24),
                _buildActionSection(
                  title: 'Disaster Recovery',
                  subtitle: 'Restore your database from a previously saved file.',
                  icon: Icons.settings_backup_restore_rounded,
                  buttonLabel: 'Select Backup File',
                  onPressed: _handleRestore,
                  isLoading: asyncState.isLoading,
                  isWarning: true,
                ),
                if (_statusMessage != null) ...[
                  const SizedBox(height: 40),
                  _buildStatusArea(),
                ],
              ],
            ),
          ),
          if (asyncState.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.orange),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.orange.withValues(alpha: 0.1), Colors.transparent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.orange.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.orange, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Your data is stored locally. Regular backups protect you against device damage or loss.',
              style: AppTextStyles.label.copyWith(color: AppColors.textSecondary, height: 1.5, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required String buttonLabel,
    required VoidCallback onPressed,
    required bool isLoading,
    bool isWarning = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: isWarning ? Colors.amber : AppColors.orange, size: 18),
            const SizedBox(width: 8),
            Text(title, style: AppTextStyles.h3.copyWith(fontSize: 15)),
          ],
        ),
        const SizedBox(height: 6),
        Text(subtitle, style: AppTextStyles.label.copyWith(color: AppColors.textMuted, fontSize: 11)),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isWarning ? AppColors.bg3 : AppColors.orange,
              foregroundColor: isWarning ? AppColors.textPrimary : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: isWarning ? const BorderSide(color: AppColors.border) : BorderSide.none,
              ),
              elevation: 0,
            ),
            child: Text(buttonLabel, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusArea() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isSuccess ? Colors.green.withValues(alpha: 0.05) : Colors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _isSuccess ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(
            _isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
            color: _isSuccess ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(height: 10),
          Text(
            _statusMessage!,
            textAlign: TextAlign.center,
            style: AppTextStyles.label.copyWith(
              color: _isSuccess ? Colors.green.shade200 : Colors.red.shade200,
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
