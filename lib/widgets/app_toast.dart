import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/ac_colors.dart';
import '../core/constants/ac_text_styles.dart';

class ToastState {
  final String message;
  final bool show;
  const ToastState({required this.message, required this.show});
}

class ToastNotifier extends StateNotifier<ToastState> {
  ToastNotifier() : super(const ToastState(message: '', show: false));
  Timer? _timer;

  void show(String message) {
    _timer?.cancel();
    state = ToastState(message: message, show: true);
    _timer = Timer(const Duration(milliseconds: 2400), () {
      state = ToastState(message: message, show: false);
    });
  }
}

final toastProvider = StateNotifierProvider<ToastNotifier, ToastState>((ref) => ToastNotifier());

class AppToastOverlay extends ConsumerWidget {
  const AppToastOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toast = ref.watch(toastProvider);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      bottom: toast.show ? 90 : 40,
      left: 24,
      right: 24,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: toast.show ? 1.0 : 0.0,
        child: IgnorePointer(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2A1E), // Premium #1e2a1e dark green
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AcColors.active.withValues(alpha: 0.3), width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  )
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: AcColors.active,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      toast.message,
                      style: AcTextStyles.bodySmall.copyWith(
                        color: AcColors.active,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
