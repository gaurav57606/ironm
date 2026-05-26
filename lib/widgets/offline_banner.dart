import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../core/constants/ac_colors.dart';
import '../core/constants/ac_text_styles.dart';

class OfflineBanner extends StatefulWidget {
  final Widget child;
  const OfflineBanner({super.key, required this.child});

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner> {
  bool _isOffline = false;
  late final StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    _sub = Connectivity().onConnectivityChanged.listen((results) {
      // connectivity_plus 6.x returns a List<ConnectivityResult>
      final offline = results.every((r) => r == ConnectivityResult.none);
      if (mounted) setState(() => _isOffline = offline);
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _isOffline ? 36 : 0,
          color: AcColors.warning,
          child: _isOffline
              ? Center(
                  child: Text(
                  '⚠  No internet connection — data may be stale',
                  style: AcTextStyles.bodySmall.copyWith(
                      color: Colors.black87, fontWeight: FontWeight.w600),
                ))
              : null,
        ),
        Expanded(child: widget.child),
      ],
    );
  }
}
