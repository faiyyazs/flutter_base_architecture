import 'package:flutter/widgets.dart';

import 'base_error.dart';
import 'base_error_parser.dart';

class ErrorHandler<T extends BaseErrorParser>{

  final T parser;
  ErrorHandler(this.parser);

  String parseErrorType(BuildContext context,BaseError error){
    return parser.parseError(context,error);
  }

}

/**
class MyProjectParser extends BaseErrorParser{

    MyProjectParser() : super();

  @override
  String parseError(BuildContext context,BaseError error) {


    var errorMessage = super.parseError(context,error);
    if(errorMessage != null){
      return errorMessage;
    }
    switch (error.type) {
      // My Other error types

      case MoreErrors.EXTRA:

        return S.of(context).error;


      default:
        return S.of(context).unExpectedError;
        break;
    }
  }

}

class MoreErrors extends BaseErrorType<int>{
  const MoreErrors(int value) : super(value);

  static const BaseErrorType EXTRA   = const BaseErrorType(6);

}

**/

