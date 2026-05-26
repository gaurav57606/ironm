import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/ac_colors.dart';
import '../core/constants/ac_strings.dart';
import '../core/constants/ac_text_styles.dart';
import '../providers/admin_auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final error = await ref.read(adminAuthProvider.notifier).login(
          _emailCtrl.text,
          _passwordCtrl.text,
        );

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (error != null) _errorMessage = error;
      });
    }
    // Navigation is handled automatically by routerProvider redirect.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AcColors.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo block
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: AcColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AcColors.primary.withValues(alpha: 0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'IC',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Title
                Text(
                  AcStrings.appName,
                  style: AcTextStyles.h1.copyWith(color: AcColors.primary),
                ),
                const SizedBox(height: 6),
                Text(AcStrings.appTagline, style: AcTextStyles.bodySecondary),
                const SizedBox(height: 40),

                // Email field
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  style: AcTextStyles.body,
                  decoration: const InputDecoration(labelText: 'Admin Email'),
                ),
                const SizedBox(height: 14),

                // Password field
                TextField(
                  controller: _passwordCtrl,
                  obscureText: _obscurePassword,
                  style: AcTextStyles.body,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AcColors.textSecondary,
                        size: 20,
                      ),
                      onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Error message
                if (_errorMessage != null) ...[
                  Text(
                    _errorMessage!,
                    style: AcTextStyles.bodySmall.copyWith(color: AcColors.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 16),

                // Login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Sign In',
                            style: AcTextStyles.label.copyWith(color: Colors.white),
                          ),
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
