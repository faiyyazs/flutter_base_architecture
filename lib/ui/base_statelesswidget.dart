import 'package:flutter/material.dart';

/// every StatelessWidget should be inherited from this
abstract class BaseStatelessWidget extends StatelessWidget {
  Widget getLayout(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return getLayout(context);
  }
}

abstract class BaseStatelessScreen extends BaseStatelessWidget {
  @override
  Widget build(BuildContext context) {
    return getLayout(context);
  }

  Widget getLayout(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppbar(context),
        body: buildBody(context),
      ),
    );
  }

  /// should be overridden in extended widget
  Widget buildAppbar(BuildContext context);

  /// should be overridden in extended widget
  Widget buildBody(BuildContext context);
}
