import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/status_bar_wrapper.dart';
import '../../../../data/notifiers/auth_notifier.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _emailSent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref
          .read(authProvider.notifier)
          .sendPasswordReset(_emailController.text);
      if (mounted) {
        setState(() => _emailSent = true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.expired,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _emailSent ? _buildSuccessView(context) : _buildResetView(context),
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    return StatusBarWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.active.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_outline, color: AppColors.active, size: 40),
            ),
            const SizedBox(height: 32),
            Text(
              'Email sent!',
              style: AppTextStyles.h2.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 12),
            Text(
              'Check ${_emailController.text} for your reset link. Check your spam folder too.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 48),
            AppButton(
              text: 'Back to Login',
              onPressed: () => context.go('/login'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _isLoading ? null : _handleReset,
              child: Text(
                _isLoading ? 'Sending...' : 'Resend email',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetView(BuildContext context) {
    return StatusBarWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.elevation1,
                padding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Reset password',
              style: AppTextStyles.h1.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 12),
            Text(
              'Enter your email and we\'ll send a reset link to your inbox.',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            AppTextField(
              label: 'Email Address',
              hint: 'e.g. raj@rajsfitness.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            const SizedBox(height: 32),
            AppButton(
              text: 'Send Reset Link',
              isLoading: _isLoading,
              onPressed: _isLoading ? null : _handleReset,
            ),
          ],
        ),
      ),
    );
  }
}
