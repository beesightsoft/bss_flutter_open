import 'dart:math';

import 'package:bss_flutter_open/store_card/store_card_item.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class StoreCardList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StoreCardListState();
  }
}

class _StoreCardListState extends State<StoreCardList>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  Animation _scale;
  int index = 0;
  bool isNext = false;

  AnimationController _controllerFirstTap;
  Animation _animationFirstTap;
  AnimationController _controllerMidTap;
  Animation _animationMidTap;
  AnimationController _controllerPadding;
  Animation _animationPadding;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _animation = CurvedAnimation(
        parent: _controller,
        curve: new Interval(0.0, 1.0, curve: Curves.fastOutSlowIn));
    _scale = CurvedAnimation(
        parent: _controller,
        curve: new Interval(0, 0.8, curve: Curves.fastLinearToSlowEaseIn));
    _controllerMidTap =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _animationMidTap =
        CurvedAnimation(parent: _controllerMidTap, curve: Curves.fastOutSlowIn);
    _controllerFirstTap =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _animationFirstTap = CurvedAnimation(
        parent: _controllerFirstTap, curve: Curves.fastOutSlowIn);
    _controllerPadding =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animationPadding =
        CurvedAnimation(parent: _controllerPadding, curve: Curves.easeInOutQuad);
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
    return GestureDetector(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (BuildContext context, Widget child) {
          return AnimatedBuilder(
            animation: _animationPadding,
            builder: (BuildContext context, Widget child) {
              return Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  _buildFirstCard(),
                  _buildMidCard(),
                  _buildLastCard(),
                ],
              );
            },
          );
        },
      ),
      onHorizontalDragUpdate: (e) {
        if (e.delta.dx < -8.0) {
          next();
        } else if (e.delta.dx > 8.0) {
          prev();
        }
      },
    );
  }

  @override
  void dispose() {
    this._controller.dispose();
    this._controllerFirstTap.dispose();
    this._controllerMidTap.dispose();
    super.dispose();
  }

  _buildLastCard() {
    double _width = (MediaQuery.of(context).size.width / 1.5 + 24.0);
    double _padding = 8.0 * _animationPadding.value;
    return Positioned(
      left: _width +
          _width * (1 - _animation.value) -
          (isNext ? _padding : -_padding),
      child: InkWell(
        child: StoreCardItem(text: '${index + 2}'),
        onTap: next,
      ),
    );
  }

  _buildFirstCard() {
    double _width = (MediaQuery.of(context).size.width / 1.5 + 24.0);
    Matrix4 _transform = _pmat(1.0).scaled(1.0, 1.0 - _scale.value * 0.05, 1.0)
      ..rotateX(0.0)
      ..rotateY(60 * pi / 180 * _scale.value)
      ..rotateZ(0.0);

    return Positioned(
        left: -_animation.value * _width,
        child: Opacity(
          child: Transform(
            transform: _transform,
            alignment: FractionalOffset.center,
            child: AnimatedBuilder(
              animation: _animationFirstTap,
              builder: (BuildContext context, Widget child) {
                Matrix4 _transform = Matrix4.identity().scaled(
                    1.0 - 0.02 * _animationFirstTap.value,
                    1.0 - 0.02 * _animationFirstTap.value,
                    1.0);
                return InkWell(
                    child: Transform(
                      transform: _transform,
                      alignment: FractionalOffset.center,
                      child: StoreCardItem(text: '${index}'),
                    ),
                    onTap: () {
                      if (!_controllerFirstTap.isAnimating &&
                          !_controller.isAnimating) {
                        _controllerFirstTap
                            .forward(from: 0)
                            .then((_) => _controllerFirstTap.reverse(from: 1));
                      }
                    });
              },
            ),
          ),
          opacity: max(1.0 - _scale.value, 0.4),
        ));
  }

  _buildMidCard() {
    double _width = (MediaQuery.of(context).size.width / 1.5 + 24.0);
    double _padding = 8.0 * _animationPadding.value;
    return Positioned(
      left: _width * (1 - _animation.value) - (isNext ? _padding : -_padding),
      child: AnimatedBuilder(
        animation: _animationMidTap,
        builder: (BuildContext context, Widget child) {
          Matrix4 _transform = Matrix4.identity().scaled(
              1.0 - 0.02 * _animationMidTap.value,
              1.0 - 0.02 * _animationMidTap.value,
              1.0);
          return InkWell(
            child: Transform(
              transform: _transform,
              alignment: FractionalOffset.center,
              child: StoreCardItem(text: '${index + 1}'),
            ),
            onTap: () {
              if (isNext) {
                if (!_controllerMidTap.isAnimating &&
                    !_controller.isAnimating) {
                  _controllerMidTap
                      .forward(from: 0)
                      .then((_) => _controllerMidTap.reverse(from: 1));
                }
              } else
                next();
            },
          );
        },
      ),
    );
  }

  next() {
    if (!_controller.isAnimating) {
      if (isNext) this.index++;
      isNext = true;
      _controllerPadding.forward(from: 0);
      _controller
          .forward(from: 0)
          .then((_) => _controllerPadding.reverse(from: 1));
    }
  }

  prev() {
    if (!_controller.isAnimating && index > 0 || (index == 0 && isNext)) {
      if (!isNext) this.index--;
      isNext = false;
      _controllerPadding.forward(from: 0);
      _controller
          .reverse(from: 1)
          .then((_) => _controllerPadding.reverse(from: 1));
    }
  }
}
