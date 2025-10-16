// lib/core/errors/exceptions.dart

// We define a custom exception class. Its name is enough to identify the error.
class SessionExpiredException implements Exception {
  final String message = 'Session has expired, please log in again.';
}