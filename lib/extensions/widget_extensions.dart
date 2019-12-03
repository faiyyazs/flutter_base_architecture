import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_architecture/exception/base_error.dart';
import 'package:flutter_base_architecture/generated/i18n.dart';
import 'package:flutter_base_architecture/utils/app_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

extension BaseWidgetExtension on Widget {
  void toastMessage(String message,{
    Toast toastLength:Toast.LENGTH_SHORT,
    ToastGravity gravity:ToastGravity.BOTTOM,
    Color backgroundColor:BaseAppColors.whiteForeGroundTransparent,
    Color textColor:Colors.black,
    double fontSize: 14.0}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: toastLength,
        gravity: gravity,
        timeInSecForIos: 2,
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
