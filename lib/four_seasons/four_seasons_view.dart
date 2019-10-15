import 'dart:math';

import 'package:flutter/material.dart';

class FourSeasonsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FourSeasonsViewState();
  }
}

class _FourSeasonsViewState extends State<FourSeasonsView>
    with TickerProviderStateMixin {
  bool _isRight = false;
  AnimationController _controller;
  Animation _animation;
  double _angle = 0;
  double _diffAngle = 0;
  static const double MAX_ANGLE = 60;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _animation = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeInBack);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: MediaQuery.of(context).size.height / 2,
          child: GestureDetector(
            child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) => _buildMainView()),
            onHorizontalDragUpdate: (e) async {
              if (e.globalPosition.dy - MediaQuery.of(context).size.height / 2- MediaQuery.of(context).size.height / 2 >
                  0)
                this._angle -= e.delta.dx;
              else
                this._angle += e.delta.dx;
              _isRight = e.delta.dx > 0;
              await _controller.forward(from: 1);
              _controller.reset();
            },
            onHorizontalDragEnd: _stop,
            onVerticalDragUpdate: (e) async {
              if (e.globalPosition.dx - MediaQuery.of(context).size.width / 2 <
                  0)
                this._angle -= e.delta.dy;
              else
                this._angle += e.delta.dy;
              _isRight = e.delta.dy > 0;
              await _controller.forward(from: 1);
              _controller.reset();
            },
            onVerticalDragEnd: _stop,
          ),
        )
      ],
    );
  }

  _stop(DragEndDetails e) async {
    if (!_controller.isAnimating) {
      int _int = _angle ~/ 90;
      double _mod = _angle % 90;
      double _newAngle = _int * 90.0;
      _diffAngle = _newAngle - _angle;
      await _controller.forward(from: 0);
      _diffAngle = 0;
      _angle = _newAngle;
      _controller.reset();
    }
  }

  _buildMainView() {
    double _value = _animation.value;
    double angle = (_angle + _diffAngle * _value) * pi / 180;
    return Transform.rotate(
      angle: angle,
      child: Stack(
        children: <Widget>[
          CustomPaint(
            painter: FourSeasonsPainter(),
            size: MediaQuery.of(context).size,
          ),
          _buildSpring(),
          _buildSummer(),
          _buildAutumn(),
          _buildWinter(),
        ],
      ),
    );
  }

  _buildIcon(asset, {width}) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: width,
          child: Image.asset(asset,
              height: 50.0, width: 50.0, color: Colors.white),
        ),
        Container(
          child: Image.asset(asset, height: 48.0, width: 48.0),
        )
      ],
    );
  }

  _buildSpring() {
    return Positioned(
      left: MediaQuery.of(context).size.width / 2 - 25.0,
      top: MediaQuery.of(context).size.height / 2 -
          MediaQuery.of(context).size.width / 2 * 0.8 +
          16.0,
      child: _buildIcon("lib/four_seasons/images/spring.png"),
    );
  }

  _buildSummer() {
    return Positioned(
      top: MediaQuery.of(context).size.height / 2 - 25.0,
      left: MediaQuery.of(context).size.width / 2 * 0.8 - 25.0 - 16.0,
      child: Transform.rotate(
        angle: pi / 2,
        child: _buildIcon("lib/four_seasons/images/summer.png",
            width: MediaQuery.of(context).size.width),
      ),
    );
  }

  _buildAutumn() {
    return Positioned(
      left: MediaQuery.of(context).size.width / 2 - 25.0,
      top: MediaQuery.of(context).size.height / 2 +
          MediaQuery.of(context).size.width / 2 * 0.8 -
          16.0 -
          50.0,
      child: Transform.rotate(
        angle: pi,
        child: _buildIcon("lib/four_seasons/images/autumn.png"),
      ),
    );
  }

  _buildWinter() {
    return Positioned(
      left: -MediaQuery.of(context).size.width / 2 * 0.8 + 25.0 + 16.0,
      top: MediaQuery.of(context).size.height / 2 - 25.0,
      child: Transform.rotate(
        angle: 3 * pi / 2,
        child: _buildIcon("lib/four_seasons/images/winter.png",
            width: MediaQuery.of(context).size.width),
      ),
    );
  }
}

class FourSeasonsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Offset _center = size.center(Offset.zero);
    double _radius = size.width / 2 * 0.8;
    double _radiusSmall = size.width / 2 * 0.3;
    canvas.drawCircle(_center, _radius, Paint()..color = Colors.white);
    canvas.drawArc(
        Rect.fromCircle(center: _center, radius: _radius),
        -135 * pi / 180,
        90 * pi / 180,
        true,
        Paint()..color = Colors.pinkAccent.withOpacity(0.8));
    canvas.drawArc(
        Rect.fromCircle(center: _center, radius: _radius),
        -45 * pi / 180,
        90 * pi / 180,
        true,
        Paint()..color = Colors.yellowAccent.withOpacity(0.8));
    canvas.drawArc(
        Rect.fromCircle(center: _center, radius: _radius),
        45 * pi / 180,
        90 * pi / 180,
        true,
        Paint()..color = Colors.orangeAccent.withOpacity(0.8));
    canvas.drawArc(
        Rect.fromCircle(center: _center, radius: _radius),
        135 * pi / 180,
        90 * pi / 180,
        true,
        Paint()..color = Colors.blueAccent.withOpacity(0.8));
    canvas.drawCircle(_center, _radiusSmall, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
