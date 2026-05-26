import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'widgets/offline_banner.dart';

class IronControlApp extends ConsumerWidget {
  const IronControlApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return OfflineBanner(
      child: MaterialApp.router(
        title: 'IronControl',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        routerConfig: router,
      ),
    );
  }
}
