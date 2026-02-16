abstract class Failure {
  const Failure({required this.message, this.exception, this.stackTrace});

  final String message;
  final Object? exception;
  final StackTrace? stackTrace;
}

class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.exception,
    super.stackTrace,
  });
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required super.message,
    super.exception,
    super.stackTrace,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.exception,
    super.stackTrace,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.exception,
    super.stackTrace,
  });
}
