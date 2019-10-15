import 'dart:math';

import 'package:flutter/material.dart';

class FlipAnimationView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FlipAnimationViewState();
}

class _FlipAnimationViewState extends State<FlipAnimationView>
    with TickerProviderStateMixin {
  static const double HEIGHT = 180;
  static const double WIDTH = 140;

  AnimationController _controller;
  Animation _animation;
  bool _isNext = false;
  int _number = 1;
  int _newNumber = 1;

  @override
  void initState() {
    super.initState();
    this._controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    this._animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuart);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[_buildHeader(), _buildCalendar()],
      ),
    );
  }

  _buildHeader() {
    return Stack(
      children: <Widget>[
        Container(
          height: 16.0,
          width: WIDTH,
          color: Colors.lightGreen,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildDot(),
            _buildDot(),
            _buildDot(),
          ],
        )
      ],
    );
  }

  _buildDot() {
    return Padding(
      child: Material(
        shape: CircleBorder(),
        color: Colors.white,
        child: SizedBox(height: 8.0, width: 8.0),
      ),
      padding: EdgeInsets.all(2.0),
    );
  }

  _buildCalendar() {
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            height: HEIGHT,
            width: WIDTH,
            child: Stack(
              children: <Widget>[
                _buildBackground(),
                _controller.isAnimating ? _buildTop() : SizedBox()
              ],
            ),
          );
        });
  }

  _buildBackground() {
    return Stack(
      children: <Widget>[
        _buildText(_newNumber),
        Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                  height: HEIGHT / 2, width: WIDTH, color: Colors.transparent),
              onTap: () => _forward(false),
            ),
            GestureDetector(
              child: Container(
                  height: HEIGHT / 2, width: WIDTH, color: Colors.transparent),
              onTap: () => _forward(true),
            ),
          ],
        )
      ],
    );
  }

  _buildTop() {
    double _value = _animation.value;
    double _angle = (_isNext ? -1 : 1) * pi * _value;
    Matrix4 _matrix = Matrix4(1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0,
        1.0, 0.002, 0.0, 0.0, 0.0, 1.0)
      ..rotateX(_angle);

    int _t = ((_isNext ? -1 : 1) * _angle ~/ (pi / 2)) % 4;
    int number = _t == 0 || _t == 3 || _t == 4 ? _number : _newNumber;
    bool isRotate = number == _newNumber;

    return Stack(
      children: <Widget>[
        _isNext
            ? _buildHalf(true, _number, false)
            : _buildHalf(false, _number, false),
        Transform(
            alignment: Alignment.center,
            transform: _matrix,
            child: _isNext
                ? _buildHalf(false, number, isRotate)
                : _buildHalf(true, number, isRotate)),
      ],
    );
  }

  _buildHalf(bool isTop, int num, bool isRotate) {
    Matrix4 _rotate = Matrix4.identity()
      ..rotateY(isRotate ? pi : 0)
      ..rotateZ(isTop ? (isRotate ? pi : 0) : (isRotate ? 0 : pi));
    return Transform.rotate(
      angle: isTop ? 0 : pi,
      child: _buildClipper(_rotate, num),
    );
  }

  _buildClipper(transform, value) {
    return ClipPath(
      clipper: HalfClipper(),
      child: Transform(
        alignment: Alignment.center,
        transform: transform,
        child: _buildText(value),
      ),
    );
  }

  _buildText(int value) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.redAccent, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        alignment: Alignment.center,
        child: Text('$value',
            style: TextStyle(color: Colors.white, fontSize: 100)));
  }

  _forward(isNext) async {
    if (!_controller.isAnimating) {
      _isNext = isNext;
      _newNumber = _newNumber + (_isNext ? 1 : -1);
      await _controller.forward(from: 0.0);
      _number = _newNumber;
      _controller.reset();
    }
  }
}

class HalfClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) =>
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height / 2));

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
