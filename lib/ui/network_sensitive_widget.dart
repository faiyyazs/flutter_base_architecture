import 'package:flutter/material.dart';
import 'package:flutter_base_architecture/constants/connectivity_status.dart';
import 'package:provider/provider.dart';

class NetworkSensitiveWidget extends StatelessWidget {
  final Widget child;
  final double opacity;

  NetworkSensitiveWidget({
    this.child,
    this.opacity = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    // Get our connection status from the provider
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    if ((connectionStatus == ConnectivityStatus.Cellular) ||
        (connectionStatus == ConnectivityStatus.WiFi)) {
      return child;
    }

    return IgnorePointer(
      ignoring: true,
      child: Opacity(
        opacity: opacity,
        child: child,
      ),
    );
  }
}
