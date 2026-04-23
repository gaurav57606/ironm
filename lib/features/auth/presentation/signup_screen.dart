import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.chevron_left, size: 28),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Set up your gym', style: AppTextStyles.h1),
            const SizedBox(height: 4),
            Text(
              'Create your account to get started',
              style: AppTextStyles.label,
            ),
            const SizedBox(height: 32),
            _buildField('Gym Name', 'e.g. Raj\'s Fitness'),
            _buildField('Your Name', 'e.g. Rajesh Kumar'),
            _buildField('Email Address', 'e.g. raj@rajsfitness.com'),
            _buildField('Phone', 'e.g. +91 98765 43210'),
            _buildField('Password', '••••••••', obscure: true),
            _buildField('Confirm Password', '••••••••', obscure: true),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/pin-setup'),
              child: const Text('Create Account'),
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () => context.go('/login'),
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.label,
                    children: [
                      const TextSpan(text: 'Already have an account? '),
                      TextSpan(
                        text: 'Log in',
                        style: const TextStyle(color: AppColors.orange),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, String hint, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          TextField(
            obscureText: obscure,
            style: AppTextStyles.body,
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
