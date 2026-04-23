sealed class AppError {
  final String message;
  AppError(this.message);
}

class DatabaseError extends AppError {
  DatabaseError(super.message);
}

class ValidationError extends AppError {
  ValidationError(super.message);
}

class UnknownError extends AppError {
  UnknownError([String? message]) : super(message ?? 'An unexpected error occurred');
}
