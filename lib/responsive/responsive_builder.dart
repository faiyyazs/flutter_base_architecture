import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_architecture/enums/device_screen_type.dart';

import 'screen_breakpoints.dart';
import 'sizing_information.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    SizingInformation sizingInformation,
  ) builder;

  final ScreenBreakpoints breakpoints;

  const ResponsiveBuilder({Key key, this.builder, this.breakpoints})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxConstraints) {
      var mediaQuery = MediaQuery.of(context);
      var sizingInformation = SizingInformation(
        deviceScreenType: _getDeviceType(mediaQuery, breakpoints),
        screenSize: mediaQuery.size,
        localWidgetSize:
            Size(boxConstraints.maxWidth, boxConstraints.maxHeight),
      );
      return builder(context, sizingInformation);
    });
  }
}

DeviceScreenType _getDeviceType(MediaQueryData mediaQuery, ScreenBreakpoints breakpoint) {
  double deviceWidth = mediaQuery.size.shortestSide;

  if (kIsWeb) {
    deviceWidth = mediaQuery.size.width;
  }

  // Replaces the defaults with the user defined definitions
  if(breakpoint != null) {
    if(deviceWidth > breakpoint.desktop) {
      return DeviceScreenType.Desktop;
    }

    if(deviceWidth > breakpoint.tablet) {
      return DeviceScreenType.Tablet;
    }

    if(deviceWidth < breakpoint.watch) {
      return DeviceScreenType.Watch;
    }
  }

  // If no user defined definitions are passed through use the defaults
  if (deviceWidth > 950) {
    return DeviceScreenType.Desktop;
  }

  if (deviceWidth > 600) {
    return DeviceScreenType.Tablet;
  }

  if (deviceWidth < 300) {
    return DeviceScreenType.Watch;
  }

  return DeviceScreenType.Mobile;
}
