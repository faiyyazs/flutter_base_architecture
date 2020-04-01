import 'package:flutter/material.dart';
import 'package:flutter_base_architecture/enums/device_screen_type.dart';

class SizingInformation {
  final DeviceScreenType deviceScreenType;
  final Size screenSize;
  final Size localWidgetSize;

  bool get isMobile => deviceScreenType == DeviceScreenType.Mobile;

  bool get isTablet => deviceScreenType == DeviceScreenType.Tablet;

  bool get isDesktop => deviceScreenType == DeviceScreenType.Desktop;

  bool get isWatch => deviceScreenType == DeviceScreenType.Watch;

  SizingInformation({
    this.deviceScreenType,
    this.screenSize,
    this.localWidgetSize,
  });

  @override
  String toString() {
    return 'DeviceType:$deviceScreenType ScreenSize:$screenSize LocalWidgetSize:$localWidgetSize';
  }
}
