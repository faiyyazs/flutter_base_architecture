import 'package:flutter/widgets.dart';
import 'package:flutter_base_architecture/generated/i18n.dart';

import 'base_error.dart';

class BaseErrorHandler{

  final BuildContext context;

  BaseErrorHandler(this.context);

  @mustCallSuper
  String parseError(BaseError error){
    switch (error.type) {
      case BaseErrorType.DEFAULT:
        return S.of(context).error;
        break;

      case BaseErrorType.UNEXPECTED:
        return S.of(context).unExpectedError;
        break;

      case BaseErrorType.SERVER_TIMEOUT:
        return S.of(context).noNetwork;
        break;
      case BaseErrorType.INVALID_RESPONSE:
        return S.of(context).problemParsingError;
        break;

      default:
        return S.of(context).unExpectedError;
        break;
    }
  }

}