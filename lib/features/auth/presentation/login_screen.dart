import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.orange,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'IG',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text('Welcome back', style: AppTextStyles.h2),
                const SizedBox(height: 4),
                Text(
                  'Log in to your gym account',
                  style: AppTextStyles.label,
                ),
                const SizedBox(height: 32),
                _buildField('Email Address', 'raj@rajsfitness.com'),
                _buildField('Password', '••••••••', obscure: true),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.go('/forgot-password'),
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(color: AppColors.orange, fontSize: 10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => context.go('/pin-entry'),
                  child: const Text('Log In'),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => context.go('/signup'),
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.label,
                      children: [
                        const TextSpan(text: 'New here? '),
                        TextSpan(
                          text: 'Create an account',
                          style: const TextStyle(color: AppColors.orange),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String hint, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
