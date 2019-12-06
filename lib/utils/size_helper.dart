import 'package:flutter/material.dart';

class SizeHelper {
  static Size getDimensions(context) {
    var phoneScreenSize = MediaQuery.of(context).size;
    if (MediaQuery
        .of(context)
        .orientation == Orientation.portrait) {
      return Size(phoneScreenSize.width, phoneScreenSize.height);
    } else {
      return Size(phoneScreenSize.height, phoneScreenSize.width);
    }
  }
}
