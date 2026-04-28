sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

final class Error<T> extends Result<T> {
  const Error(this.message);

  final String message;
}
