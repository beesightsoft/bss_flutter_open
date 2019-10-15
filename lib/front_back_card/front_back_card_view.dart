import 'dart:math';

import 'package:flutter/material.dart';

class FrontBackCardView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FrontBackCardViewState();
  }
}

class _FrontBackCardViewState extends State<FrontBackCardView>
    with TickerProviderStateMixin {
  static const FRONT = "lib/front_back_card/images/front_card.png";
  static const BACK = "lib/front_back_card/images/back_card.png";

  String image = FRONT;
  bool isNext = false;

  AnimationController _controller;
  Animation _animation;

  AnimationController _controllerRotate;
  Animation _animationRotate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controllerRotate =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _animationRotate =
        CurvedAnimation(parent: _controllerRotate, curve: Curves.fastOutSlowIn);
  }

  String get another => image == FRONT ? BACK : FRONT;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext context, Widget child) {
            double _width = MediaQuery.of(context).size.width;
            double _leftFront = 0;
            double _leftBack = 0;
            if (isNext) {
              _leftFront = -(_animation.value) * _width;
              _leftBack = (1.0 - _animation.value) * _width;
            } else {
              _leftFront = (_animation.value) * _width;
              _leftBack = -(1.0 - _animation.value) * _width;
            }

            return AnimatedBuilder(
              animation: _animationRotate,
              builder: (BuildContext context, Widget child) {
                double _value =
                    isNext ? _animationRotate.value : -(_animationRotate.value);
                Matrix4 _transform =
                    _pmat(1.0).scaled(1.0, 1.0 - _value * 0.01, 1.0)
                      ..rotateX(0.0)
                      ..rotateY(12 * pi / 180 * _value)
                      ..rotateZ(0);
                return Stack(
                  children: <Widget>[
                    _buildCard(_leftBack, another, _transform),
                    _buildCard(_leftFront, image, _transform),
                  ],
                );
              },
            );
          },
        ),
        onHorizontalDragUpdate: (e) {
          if (e.delta.dx < -8.0)
            next();
          else if (e.delta.dx > 8.0) prev();
        },
      ),
    );
  }

  @override
  void dispose() {
    this._controllerRotate.dispose();
    this._controller.dispose();
    super.dispose();
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

  void changeImage() {
    setState(() => this.image = this.image == FRONT ? BACK : FRONT);
  }

  void next() {
    if (!_controller.isAnimating) {
      isNext = true;
      _controllerRotate
          .forward(from: 0)
          .then((_) => _controllerRotate.reverse());
      _controller.forward(from: 0).then((_) {
        _controller.reset();
        changeImage();
      });
    }
  }

  void prev() {
    if (!_controller.isAnimating) {
      isNext = false;
      _controllerRotate
          .forward(from: 0)
          .then((_) => _controllerRotate.reverse());
      _controller.forward(from: 0).then((_) {
        _controller.reset();
        changeImage();
      });
    }
  }

  _buildCard(double left, image, transform) {
    return Positioned(
        left: left,
        top: 0.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 48.0),
          child: Container(
            decoration: BoxDecoration(),
            child: Transform(
              transform: transform,
              child: Image.asset(image, height: 180.0),
            ),
          ),
        ));
  }
}
