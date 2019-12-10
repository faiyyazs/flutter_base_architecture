import 'package:flutter_base_architecture/presentation/enum.dart';

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
      "BaseErrorType [$type]: " +
          (message ?? "") +
          (stackTrace ?? "").toString();*/

  /// Error stacktrace info
  StackTrace stackTrace;
}

class BaseErrorType<int> extends Enum<int> {
  const BaseErrorType(int value) : super(value);

  /// Default error type, Some other Error. In this case, you can
  /// read the AmerErrorType.error if it is not null.

  static const BaseErrorType DEFAULT = const BaseErrorType(1);
  static const BaseErrorType UNEXPECTED = const BaseErrorType(2);
  static const BaseErrorType SERVER_TIMEOUT = const BaseErrorType(3);
  static const BaseErrorType INVALID_RESPONSE = const BaseErrorType(4);
  static const BaseErrorType SERVER_MESSAGE = const BaseErrorType(5);
}
