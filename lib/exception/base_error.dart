/// The operation was not allowed by the current state of the object.
///
/// This is a generic error used for a variety of different erroneous
/// actions. The message should be descriptive.
class BaseError implements Exception {
  BaseError({
    this.message,
    this.type = BaseErrorType.DEFAULT,
    this.error,
    this.stackTrace,
  });

  /// Error descriptions.
  String message;

  BaseErrorType type;

  /// The original error/exception object; It's usually not null when `type`
  /// is AmerErrorType.DEFAULT
  dynamic error;

  String toString() => message;

  /*String toString() =>
      "AmerErrorType [$type]: " +
          (message ?? "") +
          (stackTrace ?? "").toString();*/

  /// Error stacktrace info
  StackTrace stackTrace;
}

enum BaseErrorType {
  /// Default error type, Some other Error. In this case, you can
  /// read the AmerErrorType.error if it is not null.
  DEFAULT,
  UNEXPECTED,
  SERVER_TIMEOUT,
  INVALID_RESPONSE,
}
