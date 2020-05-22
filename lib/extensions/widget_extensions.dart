import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        timeInSecForIosWeb: timeInSecForIos,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize);
  }
}
