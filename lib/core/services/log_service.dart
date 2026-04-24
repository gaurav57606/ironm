import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class LogService {
  LogService._();

  static const String _logFileName = 'ironm_error_log.txt';
  static const String _oldLogFileName = 'ironm_error_log_old.txt';
  static const int _maxFileSize = 2 * 1024 * 1024; // 2MB
  
  static bool _isWriting = false;

  static Future<String> getLogFilePath() async {
    if (kIsWeb) return '';
    final dir = await getApplicationDocumentsDirectory();
    final logDir = io.Directory('${dir.path}/logs');
    if (!await logDir.exists()) {
      await logDir.create(recursive: true);
    }
    return '${logDir.path}/$_logFileName';
  }

  static Future<void> info(String tag, String message) => _log('INFO', tag, message);
  static Future<void> warning(String tag, String message) => _log('WARNING', tag, message);
  static Future<void> error(String tag, dynamic exception, [StackTrace? stackTrace]) =>
      _log('ERROR', tag, '$exception', stackTrace);

  static Future<void> _log(String level, String tag, String message, [StackTrace? stackTrace]) async {
    final timestamp = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(DateTime.now());
    final entry = '[$timestamp] [$level] [$tag]: $message\n${stackTrace ?? ""}\n---\n';

    // Thread-safe writing
    while (_isWriting) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
    _isWriting = true;

    try {
      if (kIsWeb) {
        // ignore: avoid_print
        print('[$timestamp] [$level] [$tag]: $message');
        return;
      }
      final path = await getLogFilePath();
      final file = io.File(path);

      if (await file.exists() && await file.length() > _maxFileSize) {
        final oldFile = io.File(path.replaceFirst(_logFileName, _oldLogFileName));
        if (await oldFile.exists()) {
          await oldFile.delete();
        }
        await file.rename(oldFile.path);
      }

      await file.writeAsString(entry, mode: io.FileMode.append, flush: true);
    } catch (e) {
      // Fallback to debugPrint if logging fails
      // ignore: avoid_print
      print('Failed to write log: $e');
    } finally {
      _isWriting = false;
    }
  }

  static Future<String> readLogs() async {
    try {
      final path = await getLogFilePath();
      final file = io.File(path);
      if (await file.exists()) {
        return await file.readAsString();
      }
    } catch (e) {
      return 'Error reading logs: $e';
    }
    return 'No logs found.';
  }

  static Future<void> clearLogs() async {
    try {
      final path = await getLogFilePath();
      final file = io.File(path);
      if (await file.exists()) {
        await file.delete();
      }
      final oldPath = path.replaceFirst(_logFileName, _oldLogFileName);
      final oldFile = io.File(oldPath);
      if (await oldFile.exists()) {
        await oldFile.delete();
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error clearing logs: $e');
    }
  }
}
