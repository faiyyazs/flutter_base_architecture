import 'package:flutter/widgets.dart';
import 'package:flutter_base_architecture/generated/i18n.dart';

import 'base_error.dart';

abstract class BaseErrorParser{


  BaseErrorParser();

  @mustCallSuper
  String parseError(BuildContext context,BaseError error){
    switch (error.type) {
      case BaseErrorType.DEFAULT:
        return S.of(context).error;

      case BaseErrorType.UNEXPECTED:
        return S.of(context).unExpectedError;

      case BaseErrorType.SERVER_TIMEOUT:
        return S.of(context).noNetwork;

      case BaseErrorType.INVALID_RESPONSE:
        return S.of(context).problemParsingError;

      default:
        return null;

    }
  }
}