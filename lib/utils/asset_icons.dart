import 'package:flutter/material.dart';

class AssetIcons {


  static const String _vector = "asset/vector/";
  static const String _drawableFolder = "asset/drawable/";
  static const String _imagesFolder = "asset/images/";

  //vectors
  static const AssetImage logo = AssetImage(_vector + "logo.svg");

  // Icons
  static const AssetImage menu = AssetImage("asset/drawable/menu.png");


  static String get vector => _vector;
  static String get drawableFolder => _drawableFolder;
  static String get imagesFolder => _imagesFolder;
}
