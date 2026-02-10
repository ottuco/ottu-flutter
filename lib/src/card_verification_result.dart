/**
 *  Result class encapsulates successful outcome with a value of type [T]
 *  or a failure with message.
 */
sealed class CardVerificationResult<T, E> {
  const CardVerificationResult();

  factory CardVerificationResult.success({T? value}) => Success(value);

  factory CardVerificationResult.failure(E message) => Failure(message);
}

final class Success<T, E> extends CardVerificationResult<T, E> {
  const Success(this.value);

  final T? value;
}

final class Failure<T, E> extends CardVerificationResult<T, E> {
  const Failure(this.message);

  final E message;
}
