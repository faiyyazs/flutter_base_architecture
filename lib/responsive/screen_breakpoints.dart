import 'package:flutter/widgets.dart';

/// Manually define screen resolution breakpoints
///
/// Overrides the defaults
class ScreenBreakpoints {
  final double watch;
  final double tablet;
  final double desktop;

  ScreenBreakpoints(
      {@required this.desktop, @required this.tablet, @required this.watch});

  @override
  String toString() {
    return "Desktop: $desktop, Tablet: $tablet, Watch: $watch";
  }
}
