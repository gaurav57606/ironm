import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Track every member',
      description: "See who's active, expiring, and due — at a glance every morning.",
      icon: Icons.people_outline,
    ),
    OnboardingData(
      title: 'Instant invoices',
      description: 'Generate and share professional GST invoices via WhatsApp in seconds.',
      icon: Icons.receipt_long_outlined,
    ),
    OnboardingData(
      title: 'Your gym, your rules',
      description: 'Set your own plans, pricing, and components. Everything in one place.',
      icon: Icons.settings_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 110,
                          decoration: BoxDecoration(
                            color: AppColors.bgCard,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Icon(
                            _pages[index].icon,
                            size: 48,
                            color: AppColors.orange,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _pages[index].title,
                          style: AppTextStyles.h2,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _pages[index].description,
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 16 : 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? AppColors.orange
                              : AppColors.textTertiary,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentIndex < _pages.length - 1) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        context.go('/signup');
                      }
                    },
                    child: Text(
                      _currentIndex == _pages.length - 1 ? 'Get started' : 'Next',
                    ),
                  ),
                  if (_currentIndex < _pages.length - 1)
                    TextButton(
                      onPressed: () => context.go('/signup'),
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: AppColors.textTertiary),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
  });
}
