import 'package:flutter/material.dart';

class SizeHelper {

  static Size _phoneScreenSize(context){
    return MediaQuery.of(context).size;
  }

  static Size getDimensions(context) {
   var size = _phoneScreenSize(context);
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return Size(size.width, size.height);
    } else {
      return Size(size.height, size.width);
    }
  }

  static double width(width,context){
    var size = getDimensions(context);
    return width * (size.width * size.aspectRatio);
  }

  static double height(height,context){
    var size = getDimensions(context);
    return height * (size.height * size.aspectRatio);
  }

  static double sp(fontSize,context){
    var size = getDimensions(context);
    return fontSize * (size.width * size.aspectRatio);
  }

}
