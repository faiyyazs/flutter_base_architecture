import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseWidget<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final T viewModel;
  final Widget child;
  final Function(T) onModelReady;
  Duration duration;
  final bool animate;

  BaseWidget(
      {Key key,
      @required this.builder,
      @required this.viewModel,
      this.child,
      this.onModelReady,
      this.duration: const Duration(
        milliseconds: 800,
      ),
      this.animate: true})
      : super(key: key);

  @override
  _BaseWidget<T> createState() => _BaseWidget<T>();
}

class _BaseWidget<T extends ChangeNotifier> extends State<BaseWidget<T>>
    with SingleTickerProviderStateMixin {
  T _model;
  Duration duration;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.animate) {
      _controller.forward(from: 0.0);
    }
    super.initState();
    _model = widget.viewModel;
    duration = widget.duration;

    if (widget.onModelReady != null) {
      widget.onModelReady(_model);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    if (widget != oldWidget && widget.animate) {
      _controller.forward(from: 0.0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: _model,
      child: Consumer<T>(
        builder: widget.builder,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _controller.value,
              child: child,
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}
