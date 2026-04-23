import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/status_bar_wrapper.dart';
import '../viewmodel/auth_viewmodel.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Track every member',
      subtitle: 'See who\'s active, expiring, and due — at a glance every morning.',
      image: 'assets/images/onb_1.png',
    ),
    OnboardingData(
      title: 'Instant invoices',
      subtitle: 'Generate and share professional GST invoices via WhatsApp in seconds.',
      image: 'assets/images/onb_2.png',
    ),
    OnboardingData(
      title: 'Your gym, your rules',
      subtitle: 'Set your own plans, pricing, and components. Everything in one place.',
      image: 'assets/images/onb_3.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatusBarWrapper(
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final data = _pages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              color: AppColors.elevation2,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  blurRadius: 40,
                                  offset: const Offset(0, 20),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Image.asset(
                                data.image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),
                          Text(
                            data.title,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.h1.copyWith(fontSize: 28),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            data.subtitle,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 8),
                          height: 6,
                          width: _currentPage == index ? 24 : 6,
                          decoration: BoxDecoration(
                            color: _currentPage == index ? AppColors.primary : AppColors.bg4,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    AppButton(
                      text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                      onPressed: () async {
                        if (_currentPage < _pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOutCubic,
                          );
                        } else {
                          await ref.read(authProvider.notifier).completeOnboarding();
                          if (!context.mounted) return;
                          context.go('/signup');
                        }
                      },
                    ),
                    if (_currentPage < _pages.length - 1) ...[
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () async {
                          await ref.read(authProvider.notifier).completeOnboarding();
                          if (!context.mounted) return;
                          context.go('/signup');
                        },
                        child: Text(
                          'Skip',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
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

class OnboardingData {
  final String title;
  final String subtitle;
  final String image;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}

