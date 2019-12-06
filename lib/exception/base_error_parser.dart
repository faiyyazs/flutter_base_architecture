import 'package:flutter/widgets.dart';

import 'base_error.dart';

abstract class BaseErrorParser {
  BaseErrorParser();

  @mustCallSuper
  String parseError(BuildContext context, BaseError error) {
    switch (error.type) {
      case BaseErrorType.DEFAULT:
        return "Something went wrong. Please try again.";
    }
  }
}
