import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseWidget<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final T viewModel;
  final Widget child;
  final Function(T) onModelReady;

  BaseWidget(
      {Key key,
      @required this.builder,
      @required this.viewModel,
      this.child,
      this.onModelReady})
      : super(key: key);

  @override
  _BaseWidget<T> createState() => _BaseWidget<T>();
}

class _BaseWidget<T extends ChangeNotifier> extends State<BaseWidget<T>> {
  T _model;

  @override
  void initState() {
    super.initState();
    _model = widget.viewModel;

    if (widget.onModelReady != null) {
      widget.onModelReady(_model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: _model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}
