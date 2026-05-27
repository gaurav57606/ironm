import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/ac_colors.dart';
import '../core/constants/ac_text_styles.dart';
import '../providers/admin_auth_provider.dart';
import '../widgets/app_toast.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  
  late AnimationController _btnController;
  double _btnScale = 1.0;

  @override
  void initState() {
    super.initState();
    _btnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.96,
      upperBound: 1.0,
    )..addListener(() {
        setState(() {
          _btnScale = _btnController.value;
        });
      });
    _btnController.value = 1.0;
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _btnController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (email.isEmpty) {
      ref.read(toastProvider.notifier).show('Email is required.');
      return;
    }
    if (password.isEmpty) {
      ref.read(toastProvider.notifier).show('Password is required.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final error = await ref.read(adminAuthProvider.notifier).login(email, password);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      if (error != null) {
        // Trigger premium HSL green/red toast (using global toast provider)
        ref.read(toastProvider.notifier).show(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AcColors.bg,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1220), AcColors.bg],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ── HERO PORTION ──
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Radial Glow Background Effect
                    Positioned(
                      top: -100,
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AcColors.primary.withValues(alpha: 0.15),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Hero Content
                    SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Stacked Diamond Logo (Visual adaptation of SVG)
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AcColors.primary, Color(0xFFEF4444)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: AcColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 32,
                                  offset: const Offset(0, 8),
                                )
                              ],
                            ),
                            child: const Icon(
                              Icons.layers_rounded,
                              color: Colors.white,
                              size: 38,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'IronBook GM',
                            style: AcTextStyles.h1,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'SaaS Admin Console',
                            style: AcTextStyles.bodySecondary.copyWith(
                              color: AcColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                            decoration: BoxDecoration(
                              color: AcColors.brandL,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AcColors.brandD, width: 1),
                            ),
                            child: Text(
                              'ADMIN ACCESS ONLY',
                              style: AcTextStyles.label.copyWith(
                                color: AcColors.primary,
                                fontSize: 11,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── FORM PORTION ──
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AcColors.s1,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  border: Border(
                    top: BorderSide(color: AcColors.rim2, width: 1),
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 28,
                  right: 28,
                  top: 28,
                  bottom: 36,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Admin Email',
                      style: AcTextStyles.sectionTitle.copyWith(
                        fontSize: 12,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Styled Input
                    TextField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style: AcTextStyles.body.copyWith(fontSize: 15),
                      decoration: InputDecoration(
                        fillColor: AcColors.s2,
                        hintText: 'admin@ironbook.app',
                        hintStyle: TextStyle(color: AcColors.textMuted.withOpacity(0.5)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Password',
                      style: AcTextStyles.sectionTitle.copyWith(
                        fontSize: 12,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordCtrl,
                      obscureText: _obscurePassword,
                      style: AcTextStyles.body.copyWith(fontSize: 15),
                      decoration: InputDecoration(
                        fillColor: AcColors.s2,
                        hintText: '••••••••••',
                        hintStyle: TextStyle(color: AcColors.textMuted.withOpacity(0.5)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: AcColors.textMuted,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Login Button with Press Shrink Scale Effect
                    GestureDetector(
                      onTapDown: (_) => _btnController.reverse(),
                      onTapUp: (_) {
                        _btnController.forward();
                        _handleLogin();
                      },
                      onTapCancel: () => _btnController.forward(),
                      child: Transform.scale(
                        scale: _btnScale,
                        child: Container(
                          width: double.infinity,
                          height: 54,
                          decoration: BoxDecoration(
                            color: AcColors.primary,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: AcColors.primary.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          alignment: Alignment.center,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.login_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Sign In',
                                      style: AcTextStyles.body.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
