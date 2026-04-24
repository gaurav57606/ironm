import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/providers/database_provider.dart';
import 'core/services/log_service.dart';
import 'package:isar/isar.dart';

import 'core/services/notification_service.dart';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers/web_data_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  
  final prefs = await SharedPreferences.getInstance();
  final webDataStore = WebDataStore(prefs);


  // Catch Flutter framework errors and log them
  FlutterError.onError = (FlutterErrorDetails details) {
    LogService.error('FlutterError', details.exception, details.stack);
    FlutterError.presentError(details);
  };

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  Isar? isar;
  String? isarError;

  try {
    isar = await initIsar();
  } catch (e, stack) {
    isarError = e.toString();
    LogService.error('IsarInitFailed', e, stack);
  }

  if (isar == null && !kIsWeb) {
    // Database failed on native — show blocking error screen.
    runApp(_DatabaseErrorApp(error: isarError ?? 'Unknown database error'));
    return;
  }

  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
        webDataStoreProvider.overrideWithValue(webDataStore),
      ],
      child: const IronBookApp(),
    ),
  );
}

/// Shown when Isar cannot open. Prevents the app from running without data persistence.
class _DatabaseErrorApp extends StatelessWidget {
  final String error;
  const _DatabaseErrorApp({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF1a1a2e),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Color(0xFFe94560), size: 64),
                const SizedBox(height: 24),
                const Text(
                  'Database Error',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'IronBook GM could not open its database.\nYour data is safe but the app cannot start.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFa8a8b3), fontSize: 16),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16213e),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    error,
                    style: const TextStyle(color: Color(0xFFe94560), fontSize: 12, fontFamily: 'monospace'),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Try these steps:\n1. Restart the app\n2. Restart your phone\n3. If it persists, contact support with the error above',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFa8a8b3), fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
