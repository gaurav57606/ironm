import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'app_error.dart';

/// Central error mapper for IronM.
/// USAGE: catch (e, st) { final err = ErrorHandler.handle(e, st); }
/// Every screen's catch block calls this — never import
/// firebase_crashlytics directly in screens.
class ErrorHandler {

  /// Map any throwable → typed [AppError] and log it.
  static AppError handle(Object error, [StackTrace? stack]) {
    final appError = _map(error);
    _record(appError, error, stack);
    return appError;
  }

  /// Short user-facing message safe for SnackBar display.
  static String userMessage(AppError error) {
    return switch (error) {
      NetworkError()      => 'No internet. Changes saved locally.',
      AuthError()         => error.message,
      ValidationError()   => error.message,
      EntitlementError()  => 'Subscription expired. Please renew.',
      IntegrityError()    => 'Data check failed. Contact support.',
      ExportError()       => error.message,
      NotFoundError()     => error.message,
      DuplicateError()    => error.message,
      DatabaseError()     => 'Database error. Restart the app.',
      NotificationError() => 'Notification failed.',
      _                   => 'Something went wrong. Try again.',
    };
  }

  // ── Private: mapping ──────────────────────────────────

  static AppError _map(Object error) {
    if (error is AppError) return error;

    if (error is FirebaseAuthException) {
      return AuthError(_authMessage(error.code),
          code: error.code, cause: error);
    }

    if (error is FirebaseException) {
      if (error.code == 'unavailable' ||
          error.code == 'network-request-failed') {
        return NetworkError(null, error);
      }
      return NetworkError(error.message, error);
    }

    if (error is IsarError) {
      return DatabaseError(error.message, cause: error);
    }

    final msg = error.toString().toLowerCase();
    if (msg.contains('socketexception') ||
        msg.contains('handshakeexception') ||
        msg.contains('connection refused') ||
        msg.contains('no address associated')) {
      return NetworkError(null, error);
    }

    if (error is FormatException) {
      return ValidationError(
          'Invalid data format: ${error.message}',
          field: 'unknown');
    }

    return UnknownError(error.toString(), error);
  }

  // ── Private: recording ────────────────────────────────

  static void _record(
      AppError appError, Object original, StackTrace? stack) {
    debugPrint('[ErrorHandler] ${appError.runtimeType}: '
        '${appError.message}');
    if (appError.cause != null) {
      debugPrint('[ErrorHandler] Cause: ${appError.cause}');
    }

    // Skip Crashlytics in debug to keep reports clean
    if (kDebugMode) return;

    _recordToCrashlytics(appError, original, stack);
  }

  static void _recordToCrashlytics(
      AppError appError, Object original, StackTrace? stack) {
    try {
      FirebaseCrashlytics.instance.recordError(
        original,
        stack ?? StackTrace.current,
        reason: appError.message,
        fatal: false,
        printDetails: false,
      );
      FirebaseCrashlytics.instance.setCustomKey(
          'error_type', appError.runtimeType.toString());
      FirebaseCrashlytics.instance.setCustomKey(
          'error_message', appError.message);
    } catch (_) {
      // Crashlytics must never crash the app
    }
  }

  // ── Auth message lookup ───────────────────────────────

  static String _authMessage(String code) {
    return switch (code) {
      'user-not-found'         => 'No account found with this email.',
      'wrong-password'         => 'Incorrect password.',
      'email-already-in-use'   => 'Email already registered.',
      'invalid-email'          => 'Enter a valid email address.',
      'weak-password'          => 'Password must be 6+ characters.',
      'user-disabled'          => 'This account has been disabled.',
      'too-many-requests'      => 'Too many attempts. Wait and retry.',
      'network-request-failed' => 'No internet connection.',
      'invalid-credential'     => 'Incorrect email or password.',
      _                        => 'Authentication failed.',
    };
  }
}
