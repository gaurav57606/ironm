import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/providers/database_provider.dart';
import 'package:isar/isar.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    
    print('Initializing Isar...');
    Isar? isar;
    try {
      isar = await initIsar();
      print('Isar initialized.');
    } catch (e) {
      print('Isar initialization failed: $e');
      print('Running in demo mode (no persistence).');
    }

    runApp(
      ProviderScope(
        overrides: [
          if (isar != null) isarProvider.overrideWithValue(isar),
        ],
        child: const IronBookApp(),
      ),
    );
  } catch (e, stack) {
    print('CRASH IN MAIN: $e');
    print(stack);
    runApp(MaterialApp(home: Scaffold(body: Center(child: Text('CRASH: $e')))));
  }
}
