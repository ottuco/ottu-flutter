sealed class Result<T> {
  const Result();

  /// Creates an instance of Result containing a value
  factory Result.ok(T value) => Success(value);

  /// Create an instance of Result containing an error
  factory Result.error(Exception error) => Error(error);

  void onResult({required Function(T) success, required Function(Exception) error}) {
    switch (this) {
      case Success data:
        success(data.value);
      case Error err:
        error(err.error);
    }
  }
}

/// Subclass of Result for values
final class Success<T> extends Result<T> {
  const Success(this.value);

  /// Returned value in result
  final T value;
}

/// Subclass of Result for errors
final class Error<T> extends Result<T> {
  const Error(this.error);

  /// Returned error in result
  final Exception error;
}
