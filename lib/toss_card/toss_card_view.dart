import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class TossCardView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TossCardViewState();
  }
}

class _TossCardViewState extends State<TossCardView>
    with TickerProviderStateMixin {
  static const FRONT = "lib/front_back_card/images/front_card.png";
  static const BACK = "lib/front_back_card/images/back_card.png";

  AnimationController _tossController;
  Animation _tossAnimation;

  AnimationController _firstController;
  Animation _firstAnimation;

  @override
  void initState() {
    super.initState();
    _tossController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));
    _tossAnimation =
        CurvedAnimation(parent: _tossController, curve: Curves.easeInOutQuart);
    _firstController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _firstAnimation =
        CurvedAnimation(parent: _firstController, curve: Curves.easeInOutQuart);
  }

  String image(_x) {
    int _t = (-_x ~/ (pi / 2)) % 4;
    return _t == 0 || _t == 3 || _t == 4 ? FRONT : BACK;
  }

  Matrix4 _pmat(num pv) {
    return new Matrix4(
      1.0,
      0.0,
      0.0,
      0.0,
      //
      0.0,
      1.0,
      0.0,
      0.0,
      //
      0.0,
      0.0,
      1.0,
      pv * 0.001,
      //
      0.0,
      0.0,
      0.0,
      1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      AnimatedBuilder(
        animation: _tossAnimation,
        builder: (BuildContext context, Widget child) {
          double __value = _tossAnimation.value;
          double _x = -760 * pi / 180 * __value;
          double _y = 12 * pi /180 * __value;
          double _z = 30 * pi / 180 * __value;
          Matrix4 _transform = Matrix4.identity()
            ..rotateX(_x)
            ..rotateY(_y)
            ..rotateZ(_z);
          return AnimatedBuilder(
            animation: _firstAnimation,
            builder: (BuildContext context, Widget child) {
              double _valueFirst = 1.0 - _firstAnimation.value;
              Matrix4 _transformFirst = _pmat(1.0).scaled(1.0, 1.0, 1.0)
                ..rotateZ(-30 * pi / 180 * (1 - _valueFirst))
                ..rotateX(-60 * pi / 180 * _valueFirst);
              return Positioned(
                  bottom: (MediaQuery.of(context).size.height / 2) * (__value) +
                      120.0 * (1 - _valueFirst),
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: GestureDetector(
                    child: Transform(
                      alignment: Alignment.center,
                      transform: _transform,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: _transformFirst,
                        child: Image.asset(
                          image(_x),
                          width: MediaQuery.of(context).size.width / 1.5,
                        ),
                      ),
                    ),
                    onTap: _toss,
                  )));
            },
          );
        },
      ),
    ]);
  }

  _toss() async {
    if (!_tossController.isAnimating && !_firstController.isAnimating) {
      await _firstController.forward(from: 0);
      await _tossController.forward(from: 0);
      _firstController.reset();
      _tossController.reset();
    }
  }
}
