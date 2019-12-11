import 'package:flutter/material.dart';
import 'package:flutter_base_architecture/exception/base_error.dart';
import 'package:flutter_base_architecture/exception/base_error_handler.dart';
import 'package:flutter_base_architecture/exception/base_error_parser.dart';
import 'package:flutter_base_architecture/extensions/widget_extensions.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

abstract class BaseModelWidget<T> extends Widget {

  ErrorHandler<BaseErrorParser> _errorHandler;

  @protected
  Widget build(BuildContext context, T model);

  @override
  DataProviderElement<T> createElement() => DataProviderElement<T>(this);

  void showToastMessage(String message,
      {Toast toastLength,
      ToastGravity gravity,
      Color backgroundColor,
      int timeInSecForIos,
      Color textColor,
      double fontSize}) {
    toastMessage(message,
        toastLength: toastLength,
        gravity: gravity,
        timeInSecForIos: timeInSecForIos,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize);
  }

  String getErrorMessage(BuildContext context, BaseError error) {
    return _errorHandler.parseErrorType(context, error);
  }
}

class DataProviderElement<T> extends ComponentElement {
  DataProviderElement(BaseModelWidget widget) : super(widget);

  @override
  BaseModelWidget get widget => super.widget;

  @override
  Widget build() {
    widget._errorHandler =
        Provider.of<ErrorHandler<BaseErrorParser>>(this, listen: false);
    return widget.build(this, Provider.of<T>(this));
  }

  @override
  void update(BaseModelWidget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    rebuild();
  }
}
