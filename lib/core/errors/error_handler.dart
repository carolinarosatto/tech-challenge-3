import 'package:tech_challenge_3/core/errors/failure.dart';

class ErrorHandler {
  const ErrorHandler._();

  static String toMessage(Failure failure) {
    if (failure is ValidationFailure) {
      return failure.message;
    }

    if (failure is AuthFailure) {
      return failure.message;
    }

    if (failure is DatabaseFailure) {
      return failure.message;
    }

    return 'Ocorreu um erro inesperado. Tente novamente.';
  }
}
