import 'app_error.dart';

class ErrorHandler {
  static AppError handle(Object error) {
    if (error is AppError) return error;
    // Map native exceptions to AppError
    return UnknownError(error.toString());
  }
}
