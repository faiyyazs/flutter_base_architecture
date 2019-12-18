import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_architecture/data/local/sharedpreferences/user_stores.dart';
import 'package:flutter_base_architecture/dto/base_dto.dart';
import 'package:flutter_base_architecture/exception/base_error.dart';
import 'package:flutter_base_architecture/exception/base_error_handler.dart';
import 'package:flutter_base_architecture/exception/base_error_parser.dart';
import 'package:flutter_base_architecture/extensions/widget_extensions.dart';
import 'package:flutter_base_architecture/viewmodels/base_view_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'base_error_widget.dart';
import 'base_widget.dart';

/// Every StatefulWidget should be inherited from this
abstract class BaseStatefulWidget<VM extends BaseViewModel> extends StatefulWidget {
  BaseStatefulWidget({Key key}) : super(key: key);
}

abstract class _BaseState<
    VM extends BaseViewModel,
    T extends BaseStatefulWidget<VM>,
    ErrorParser extends BaseErrorParser,
    User extends BaseDto> extends State<T> {
  bool _requiresLogin = true;
  UserStore<User> _userStore;
  ErrorHandler<ErrorParser> _errorHandler;

  @override
  void initState() {
    super.initState();
    _performLoginCheck();
  }

  _performLoginCheck() {
    if (isRequiresLogin()) {
      Future.delayed(Duration(seconds: 0), () {
        userIsLoggedIn().then((loggedIn) {
          if (!loggedIn) {
            Navigator.pushReplacementNamed(context, onBoardingRoutePath());
            return;
          }
        });
      });
    }
  }

  String onBoardingRoutePath();

  isRequiresLogin() {
    return _requiresLogin;
  }

  setRequiresLogin(bool requiresLogin) {
    this._requiresLogin = requiresLogin;
  }

  Future<bool> setUser(User user) async {
    return await _userStore.setUser(user);
  }

  @protected
  Future<bool> userIsLoggedIn() async {
    return await _userStore.userIsLoggedIn();
  }

  Future<User> getLoggedInUser() async {
    return await _userStore.getLoggedInUserJson();
  }

  void showToastMessage(String message,
      {Toast toastLength,
      ToastGravity gravity,
      Color backgroundColor,
      int timeInSecForIos,
      Color textColor,
      double fontSize}) {
    widget?.toastMessage(message,
        toastLength: toastLength,
        gravity: gravity,
        timeInSecForIos: timeInSecForIos,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize);
  }

  String getErrorMessage(BaseError errorType) {
    return _errorHandler.parseErrorType(context, errorType);
  }
}

abstract class BaseStatefulScreen<
    VM extends BaseViewModel,
    B extends BaseStatefulWidget<VM>,
    ErrorParser extends BaseErrorParser,
    User extends BaseDto> extends _BaseState<VM,B, ErrorParser, User> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  VM viewModel;

  BaseStatefulScreen();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //viewModel = Provider.of(context);
    if (viewModel == null || getViewModel() != viewModel) {
      viewModel = initViewModel();
    }
  }

  @override
  Widget build(BuildContext context) {
    addDefaultErrorWidget(context);
    _userStore = Provider.of(context);
    _errorHandler = Provider.of(context, listen: false);
    return getLayout();
  }

  void addDefaultErrorWidget(context) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return errorWidget();
    };
  }

  VM getViewModel() {
    return viewModel;
  }

  Widget getLayout() {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: statusBarColor(),
      ),
      child: BaseWidget<VM>(
          viewModel: getViewModel(),
          builder: (BuildContext context, VM model, Widget child) {
            return Scaffold(
                backgroundColor: scaffoldColor(),
                key: scaffoldKey,
                appBar: buildAppbar(),
                body: buildBody(),
                resizeToAvoidBottomPadding: resizeToAvoidBottomPadding(),
                bottomNavigationBar: buildBottomNavigationBar(),
                floatingActionButton: floatingActionButton(),
                floatingActionButtonLocation: floatingActionButtonLocation(),
                floatingActionButtonAnimator: floatingActionButtonAnimator(),
                persistentFooterButtons: persistentFooterButtons(),
                drawer: drawer(),
                endDrawer: endDrawer(),
                bottomSheet: bottomSheet(),
                resizeToAvoidBottomInset: resizeToAvoidBottomInset(),
                drawerDragStartBehavior: drawerDragStartBehavior(),
                drawerScrimColor: drawerScrimColor(),
                drawerEdgeDragWidth: drawerEdgeDragWidth());
          }),
    );
  }

  // Can be overridden in extended widget to support AppBar
  Widget errorWidget() {
    return BaseErrorScreen(errorLogo(), widgetErrorMessage());
  }

  Widget buildAppbar() {
    return null;
  }

  /// Should be overridden in extended widget
  Widget buildBody();

  Widget buildBottomNavigationBar() {
    return null;
  }

  Widget floatingActionButton() {
    return null;
  }

  FloatingActionButtonLocation floatingActionButtonLocation() {
    return FloatingActionButtonLocation.endFloat;
  }

  FloatingActionButtonAnimator floatingActionButtonAnimator() {
    return null;
  }

  List<Widget> persistentFooterButtons() {
    return null;
  }

  Widget drawer() {
    return null;
  }

  Widget endDrawer() {
    return null;
  }

  Widget bottomSheet() {
    return null;
  }

  bool resizeToAvoidBottomPadding() {
    return true;
  }

  bool resizeToAvoidBottomInset() {
    return true;
  }

  DragStartBehavior drawerDragStartBehavior() {
    return DragStartBehavior.start;
  }

  Color drawerScrimColor() {
    return Colors.black54;
  }

  double drawerEdgeDragWidth() {
    return 20.0;
  }

  VM initViewModel();

  Color scaffoldColor();

  Color statusBarColor();

  String errorLogo();

  String widgetErrorMessage();

  @override
  void dispose() {
    getViewModel().dispose();
    super.dispose();
  }
}
