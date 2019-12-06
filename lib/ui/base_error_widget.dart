
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_architecture/generated/i18n.dart';
import 'package:flutter_svg/svg.dart';

import 'base_statelesswidget.dart';

class BaseErrorScreen extends BaseStatelessScreen {
  final String assetName;

  BaseErrorScreen(this.assetName);

  @override
  Widget buildAppbar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.all(8.0),
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            SystemNavigator.pop();
          },
        ),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                assetName,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  S.of(context).error,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          )),
    );
  }
}
