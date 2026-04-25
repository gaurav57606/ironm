/// Sealed hierarchy of all business + infrastructure errors.
/// Every catch block must map to one of these.
/// Never expose raw exceptions to the UI layer.
sealed class AppError {
  final String message;
  final Object? cause;
  AppError(this.message, {this.cause});

  @override
  String toString() => 'AppError($runtimeType): $message';
}

// ── Infrastructure ─────────────────────────────────────

/// Isar local database read/write failure
class DatabaseError extends AppError {
  DatabaseError(super.message, {super.cause});
}

/// Firebase / Firestore / network failure
class NetworkError extends AppError {
  NetworkError([String? message, Object? cause])
      : super(message ?? 'Network unavailable. Working offline.',
            cause: cause);
}

/// Firebase Auth failure (wrong password, user not found, etc.)
class AuthError extends AppError {
  final String? code;
  AuthError(super.message, {this.code, super.cause});
}

// ── Business Logic ──────────────────────────────────────

/// Member data failed HMAC integrity check
class IntegrityError extends AppError {
  final String entityId;
  IntegrityError(this.entityId)
      : super('Data integrity check failed for: $entityId');
}

/// Attempted operation on expired / locked subscription
class EntitlementError extends AppError {
  EntitlementError() : super('Your subscription has expired.');
}

/// Invalid user input (form validation)
class ValidationError extends AppError {
  final String field;
  ValidationError(String message, {required this.field})
      : super(message);
}

/// Duplicate member ID or record
class DuplicateError extends AppError {
  DuplicateError(String entity) : super('$entity already exists.');
}

/// Requested record not found in local DB
class NotFoundError extends AppError {
  NotFoundError(String entity) : super('$entity not found.');
}

/// PDF / CSV export/generation failure
class ExportError extends AppError {
  ExportError(String operation, {Object? cause})
      : super('$operation failed. Please try again.', cause: cause);
}

/// FCM / push notification failure (non-fatal, silent)
class NotificationError extends AppError {
  NotificationError(super.message, {super.cause});
}

// ── Catch-all ───────────────────────────────────────────

class UnknownError extends AppError {
  UnknownError([String? message, Object? cause])
      : super(message ?? 'An unexpected error occurred.',
            cause: cause);
}
