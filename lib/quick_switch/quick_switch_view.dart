import 'dart:math';

import 'package:bss_flutter_open/quick_switch/quick_switch_model.dart';
import 'package:flutter/material.dart';

class QuickSwitchView extends StatefulWidget {
  final QuickSwitchModel primary;
  final QuickSwitchModel secondary;

  const QuickSwitchView(
      {Key key, @required this.primary, @required this.secondary})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _QuickSwitchViewState();
  }
}

class _QuickSwitchViewState extends State<QuickSwitchView>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  AnimationController _moveController;
  Animation _moveAnimation;

  bool isPrimary = true;
  bool isReady = false;
  QuickSwitchModel _primary;
  QuickSwitchModel _secondary;
  double _spacingFirst = 0.0;
  double _spacingSecond = 0.0;

  GlobalKey _keyFirstTitle = GlobalKey();
  GlobalKey _keySecondTitle = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._primary = widget.primary;
    this._secondary = widget.secondary;
    this._controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    this._animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuart);
    this._moveController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    this._moveAnimation =
        CurvedAnimation(parent: _moveController, curve: Curves.ease);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _spacingFirst = _keySecondTitle.currentContext.size.width;
        _spacingSecond = _keyFirstTitle.currentContext.size.width;
      });
    });
  }

  double get spacingFirst => this.isPrimary ? _spacingSecond : _spacingFirst;

  double get spacingSecond => this.isPrimary ? _spacingFirst : _spacingSecond;

  QuickSwitchModel get primary => this.isPrimary ? _primary : _secondary;

  QuickSwitchModel get secondary => this.isPrimary ? _secondary : _primary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
      child: Center(
        child: AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      _buildTitle(_keyFirstTitle, _animation.value, primary,
                          spacingSecond),
                      _buildTitle(_keySecondTitle, 1.0 - _animation.value,
                          secondary, spacingFirst),
                    ],
                  ),
                  SizedBox(height: 24.0),
                  Flexible(
                    child: AnimatedBuilder(
                      animation: _moveAnimation,
                      builder: (BuildContext context, Widget child) {
                        return Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            _buildChild(1.0 - _animation.value,
                                1.0 - _moveAnimation.value, secondary),
                            _buildChild(_animation.value, _moveAnimation.value,
                                primary),
                          ],
                        );
                      },
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }

  _buildTitle(_key, double _value, QuickSwitchModel _model, double _spacing) {
    return Padding(
      padding: EdgeInsets.only(left: (_spacing + 24.0) * _value),
      child: Opacity(
        opacity: 1.0 - 0.6 * _value,
        child: GestureDetector(
          child: Container(
            key: _key,
            color: Colors.transparent,
            child: Text(
              _model.title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Colors.white),
            ),
          ),
          onTap: _change,
        ),
      ),
    );
  }

  _buildChild(double _value, double _moveValue, QuickSwitchModel _model) {
    Size _size = MediaQuery.of(context).size;
    Matrix4 _transform = Matrix4.identity()..scale(1.0 - 0.1 * _value,1.0 - 0.1 * _value);
    return Positioned(
      height: _size.height / 1.5 - 48.0,
      width: _size.width - 48.0,
      top: (0.1 * (_size.height / 1.5 - 48.0)) * _moveValue,
      child: Transform(alignment: Alignment.center,
        transform: _transform,
        child: Opacity(
          opacity: 1.0 - 0.6 * _value,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 12.0)
                ]),
            child: _model.child,
          ),
        ),
      ),
    );
  }

  void _change() async {
    if (!_controller.isAnimating||!_moveController.isAnimating) {
      await _moveController.forward(from: 0);
      await _controller.forward(from: 0);
      isPrimary = !isPrimary;
      _moveController.reset();
      _controller.reset();
    }
  }
}
