import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_architecture/exception/base_error.dart';
import 'package:flutter_base_architecture/generated/i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';

extension BaseWidgetExtension on Widget {
  void toastMessage(String message,
      {Toast toastLength,
      ToastGravity gravity,
      Color backgroundColor,
      int timeInSecForIos,
      Color textColor,
      double fontSize}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: toastLength,
        gravity: gravity,
        timeInSecForIos: timeInSecForIos,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize);
  }

  String handleError(BuildContext context, BaseError error) {
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
