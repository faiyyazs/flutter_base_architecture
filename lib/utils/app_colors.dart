import 'package:flutter/material.dart';

// https://github.com/jwilm/alacritty/wiki/Color-schemes
// https://www.schemecolor.com/sample?getcolor=%23E5E5E3

class BaseAppColors {


  static final BaseAppColors _instance = BaseAppColors._internal();

  factory BaseAppColors() => _instance;

  BaseAppColors._internal();

  static const Color backgroundColor = whiteBackground;
  static const Color primaryColor = amberDark;
  static const Color whiteForeGroundTransparent = Color.fromRGBO(229, 229, 227, 0.95);
  static const Color transparent = Colors.transparent;

  static const Color black = Colors.black;
  static const Color black45 = Colors.black45;
  static const Color black54 = Colors.black54;
  static const Color white = Color.fromRGBO(252, 252, 250, 1);
  static const Color whiteForeGround = Color.fromRGBO(229, 229, 227, 1);
  static const Color whiteBackground = Color.fromRGBO(213, 213, 212, 1);
  static const Color amber = Colors.amber;
  static const Color red = Colors.red;
  static const Color blue = Colors.blue;
  static const Color orange = Colors.orange;
  static const Color green = Colors.green;
  static const Color indigo = Colors.indigo;
  static const Color deepOrange = Colors.deepOrange;
  static const Color lightGreen = Colors.lightGreen;
  static const Color redAccent = Colors.redAccent;
  static const Color yellow = Colors.yellow;
  static const Color blueAccent = Colors.blueAccent;
  static const Color orangeAccent = Colors.orangeAccent;
  static const Color indigoAccent = Colors.indigoAccent;
  static const Color lightBlue = Colors.lightBlue;
  static const Color deepPurpleAccent = Colors.deepPurpleAccent;

//Shades
  static const Color lime = Color.fromRGBO(212, 252, 0, 1.0);
  static const Color grey = Color.fromRGBO(61, 60, 58, 1.0);
  static const Color whiteBg = Color.fromRGBO(246, 246, 246, 1);
  static const Color amberDark = Color.fromRGBO(255, 138, 52, 1.0);
  static const Color amberMid = Color.fromRGBO(255, 185, 84, 1.0);
  static const Color amberLight = Color.fromRGBO(255, 200, 95, 1.0);

  //textColors
  static const Color textBlack = black;
  static const Color textDark = Colors.black87;
  static const Color textDarkGrey = black54;
  static const Color textLightGrey = Colors.black12;

  static const Color platinum = Color.fromRGBO(227, 227, 227, 1);
  static const Color philippineSilver = Color.fromRGBO(184, 184, 184, 1);
  static const Color silverChalice = Color.fromRGBO(173, 173, 173, 1);
  static const Color philippineGray = Color.fromRGBO(146, 146, 146, 1);
  static const Color whitebg = Color.fromRGBO(246, 246, 246, 1);

  static const Color buttonLinearStart = Color.fromRGBO(255, 200, 95, 1.0);
  static const Color buttonLinearEnd = Color.fromRGBO(255, 138, 52, 1.0);
}
