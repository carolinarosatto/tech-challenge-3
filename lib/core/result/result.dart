import 'package:tech_challenge_3/core/errors/failure.dart';

sealed class Result<T> {
  const Result();

  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    final self = this;
    if (self is Success<T>) {
      return onSuccess(self.value);
    }
    return onFailure((self as FailureResult<T>).failure);
  }

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

final class FailureResult<T> extends Result<T> {
  const FailureResult(this.failure);

  final Failure failure;
}
