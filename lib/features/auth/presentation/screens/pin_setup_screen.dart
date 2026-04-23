import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/status_bar_wrapper.dart';
import '../../../../data/notifiers/auth_notifier.dart';

class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key});

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  String _pin = '';
  bool _confirming = false;
  String _confirmedPin = '';
  bool _showBiometric = false;
  bool _error = false;
  bool _isLoading = false;

  void _onKeyPress(String key) {
    if (_isLoading) return;
    setState(() {
      _error = false;
      if (key == '⌫') {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      } else if (_pin.length < 4) {
        _pin += key;
        if (_pin.length == 4) {
          _handlePinComplete();
        }
      }
    });
  }

  Future<void> _handlePinComplete() async {
    if (!_confirming) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        setState(() {
          _confirming = true;
          _confirmedPin = _pin;
          _pin = '';
        });
      }
    } else {
      if (_pin == _confirmedPin) {
        setState(() => _isLoading = true);
        await ref.read(authProvider.notifier).setPin(_confirmedPin);

        if (mounted) {
          if (kIsWeb) {
             context.go('/dashboard');
          } else {
            setState(() {
              _isLoading = false;
              _showBiometric = true;
            });
          }
        }
      } else {
        setState(() {
          _error = true;
          _pin = '';
        });
      }
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
        body: _showBiometric ? _buildBiometricView() : _buildPinView(),
      ),
    );
  }

  Widget _buildBiometricView() {
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
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.fingerprint,
                  color: AppColors.primary, size: 40),
            ),
            const SizedBox(height: 32),
            Text(
              'Enable biometric unlock?',
              textAlign: TextAlign.center,
              style: AppTextStyles.h2.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 12),
            Text(
              'Skip the PIN and open the app with your fingerprint or face.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 48),
            AppButton(
              text: 'Enable Biometrics',
              onPressed: () async {
                await ref.read(authProvider.notifier).setBiometricOptIn(true);
                if (!mounted) return;
                context.go('/dashboard');
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go('/dashboard'),
              child: Text(
                'Skip for now',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinView() {
    return StatusBarWrapper(
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 40),
          _buildPinIndicators(),
          if (_error) ...[
            const SizedBox(height: 24),
            Text(
              'PINs don\'t match, try again',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.expired, fontWeight: FontWeight.bold),
            ),
          ],
          if (_isLoading) ...[
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: AppColors.primary),
          ],
          const Spacer(),
          _buildKeyboard(),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
      child: Column(
        children: [
          Text(
            _confirming ? 'Confirm your PIN' : 'Create your PIN',
            style: AppTextStyles.h1.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 12),
          Text(
            _confirming
                ? 'Enter the same PIN again to confirm'
                : 'You\'ll use this PIN every time you open the app',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isFilled = index < _pin.length;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 20,
          height: 20,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? AppColors.primary : Colors.transparent,
            border: Border.all(
              color: _error
                  ? AppColors.expired
                  : (isFilled ? AppColors.primary : AppColors.bg4),
              width: 2,
            ),
            boxShadow: isFilled ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ] : [],
          ),
        );
      }),
    );
  }

  Widget _buildKeyboard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ...['1', '2', '3', '4', '5', '6', '7', '8', '9']
              .map((k) => _buildKey(k)),
          const SizedBox(),
          _buildKey('0'),
          _buildKey('⌫'),
        ],
      ),
    );
  }

  Widget _buildKey(String key) {
    final isAction = key == '⌫';
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onKeyPress(key),
        borderRadius: BorderRadius.circular(40),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.elevation2,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
          alignment: Alignment.center,
          child: isAction 
            ? const Icon(Icons.backspace_rounded, size: 20, color: AppColors.textPrimary)
            : Text(
                key,
                style: AppTextStyles.h2.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
        ),
      ),
    );
  }
}
