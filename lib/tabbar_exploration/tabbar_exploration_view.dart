import 'dart:math';

import 'package:flutter/material.dart';

class TabbarExplorationView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TabbarExplorationViewState();
  }
}

class _TabbarExplorationViewState extends State<TabbarExplorationView>
    with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController _iconController;
  AnimationController _containController;
  Animation _animation;
  Animation _iconAnimation;
  Animation _containAnimation;
  bool isExpand = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticIn);
    _iconController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _iconAnimation =
        CurvedAnimation(parent: _iconController, curve: Curves.easeOutBack);
    _containController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _containAnimation = CurvedAnimation(
        parent: _containController, curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        double _value = 1 - _animation.value;
        return Container(
          alignment: Alignment.bottomLeft,
          color: Colors.grey.withOpacity(0.28),
          child: Stack(
            children: <Widget>[
              Container(color: Colors.transparent),
              Opacity(
                opacity: max(min(1.0, _value), 0.0),
                child: _buildLeftTab(),
              ),
              Opacity(
                opacity: max(min(1.0, _value), 0.0),
                child: _buildRightTab(),
              ),
              _buildButton(),
              _buildLeftIcon(),
              _buildLeftMidIcon(),
              _buildRightMidIcon(),
              _buildRightIcon(),
            ],
          ),
        );
      },
    );
  }

  _buildBackgroundTab() {
    Size _size = MediaQuery.of(context).size;
    return AnimatedBuilder(
        animation: _containAnimation,
        builder: (context, child) {
          double _containValue = 1 - _containAnimation.value;
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: 64.0 * max(min(_animation.value, 1.0), 0.0),
                width: 64.0 * max(min(_animation.value, 1.0), 0.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 20.0)
                    ]),
              ),
              Padding(
                padding: EdgeInsets.all(16.0 * _containValue),
                child: Container(
                  height: 32 + (80 - 32 - 32) * _containValue,
                  width: 32 + (_size.width / 5 - 32 - 32) * _containValue,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(
                          max(_size.width / 5, 80.0) * _containValue))),
                ),
              )
            ],
          );
        });
  }

  _buildLeftIcon() {
    Size _size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _iconAnimation,
      builder: (context, child) {
        double _value = _iconAnimation.value;
        double _top = _size.height - 80.0;
        double _left = 0;

        return Positioned(
          top: _top - 36.0 * _value,
          left: _left + 32.0 * _value,
          child: Container(
            height: 80.0,
            width: _size.width / 5,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                _buildBackgroundTab(),
                Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: min(max(1 - _value, 0), 1.0),
                      child: Icon(Icons.home),
                    ),
                    Opacity(
                      opacity: min(max(_value, 0), 1.0),
                      child: Icon(Icons.photo_album),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _buildLeftMidIcon() {
    Size _size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _iconAnimation,
      builder: (context, child) {
        double _value = _iconAnimation.value;
        double _top = _size.height - 80.0;
        double _left = _size.width / 5;

        return Positioned(
          top: _top - 100.0 * _value,
          left: _left + 28.0 * _value,
          child: Container(
              height: 80.0,
              width: _size.width / 5,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  _buildBackgroundTab(),
                  Stack(
                    children: <Widget>[
                      Opacity(
                        opacity: min(max(1 - _value, 0), 1.0),
                        child: Icon(Icons.people),
                      ),
                      Opacity(
                        opacity: min(max(_value, 0), 1.0),
                        child: Icon(Icons.camera_alt),
                      ),
                    ],
                  ),
                ],
              )),
        );
      },
    );
  }

  _buildRightMidIcon() {
    Size _size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _iconAnimation,
      builder: (context, child) {
        double _value = _iconAnimation.value;
        double _top = _size.height - 80.0;
        double _left = 3 * _size.width / 5;
        return Positioned(
          top: _top - 100.0 * _value,
          left: _left - 28.0 * _value,
          child: Container(
              height: 80.0,
              width: _size.width / 5,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  _buildBackgroundTab(),
                  Stack(
                    children: <Widget>[
                      Opacity(
                        opacity: min(max(1 - _value, 0), 1.0),
                        child: Icon(Icons.message),
                      ),
                      Opacity(
                        opacity: min(max(_value, 0), 1.0),
                        child: Icon(Icons.videocam),
                      ),
                    ],
                  ),
                ],
              )),
        );
      },
    );
  }

  _buildRightIcon() {
    Size _size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _iconAnimation,
      builder: (context, child) {
        double _value = _iconAnimation.value;
        double _top = _size.height - 80.0;
        double _left = 4 * _size.width / 5;
        return Positioned(
          top: _top - 36.0 * _value,
          left: _left - 32.0 * _value,
          child: Container(
              height: 80.0,
              width: _size.width / 5,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  _buildBackgroundTab(),
                  Stack(
                    children: <Widget>[
                      Opacity(
                        opacity: min(max(1 - _value, 0), 1.0),
                        child: Icon(Icons.search),
                      ),
                      Opacity(
                        opacity: min(max(_value, 0), 1.0),
                        child: Icon(Icons.share),
                      ),
                    ],
                  ),
                ],
              )),
        );
      },
    );
  }

  _buildButton() {
    Size _size = MediaQuery.of(context).size;
    return Positioned(
      bottom: 38.0 + (80.0 - 38.0) * (1 - _animation.value) - 34.0,
      left: _size.width / 2 - 34.0,
      child: GestureDetector(
        child: Transform.rotate(
          angle: 7 * 45 * pi / 180 * _animation.value,
          child: Container(
            alignment: Alignment.center,
            width: 68.0,
            height: 68.0,
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20.0)],
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.all(Radius.circular(34.0))),
            child: Text(
              "+",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        onTap: _tap,
      ),
    );
  }

  _tap() async {
    if (!_controller.isAnimating && !_iconController.isAnimating && !_containController.isAnimating) {
      if (isExpand) {
        isExpand = false;
        await _iconController.reverse(from: 1);
        _controller.reverse(from: 1);
        await _containController.reverse(from: 1);
      } else {
        isExpand = true;
        await _controller.forward(from: 0);
        _iconController.forward(from: 0);
        await _containController.forward(from: 0);
      }
    }
  }

  _buildLeftTab() {
    Size _size = MediaQuery.of(context).size;
    return ClipPath(
      clipper: TabbarExplorationClipper(animation: 1 - _animation.value),
      child: Container(
        color: Colors.white,
        width: _size.width,
        height: _size.height,
      ),
    );
  }

  _buildRightTab() {
    Size _size = MediaQuery.of(context).size;
    Matrix4 _transform = Matrix4.identity()..rotateY(pi);
    return Transform(
      alignment: Alignment.center,
      transform: _transform,
      child: ClipPath(
        clipper: TabbarExplorationClipper(animation: 1 - _animation.value),
        child: Container(
          color: Colors.white,
          width: _size.width,
          height: _size.height,
        ),
      ),
    );
  }
}

class TabbarExplorationClipper extends CustomClipper<Path> {
  final double animation;

  TabbarExplorationClipper({this.animation});

  @override
  Path getClip(Size size) {
    Path _path = Path();

    double _width = 80 * animation;
    double _height = 46 * animation;
    double _y = size.height - 80.0;
    double _x = size.width / 2 - _width;
    _path.moveTo(0, _y);
    _path.lineTo(_x, _y);

    double _x1 = _width / 2 + _x;
    double _y1 = _y;
    double _x2 = _width / 2 + _x;
    double _y2 = _height + _y;
    double _x3 = _width + _x;
    double _y3 = _height + _y;
    _path.cubicTo(_x1, _y1, _x2, _y2, _x3, _y3);
    //1,1,0,0

    _path.lineTo(_x3, size.height);
    _path.lineTo(0, size.height);
    return _path;
  }

  @override
  bool shouldReclip(TabbarExplorationClipper oldClipper) {
    return animation != oldClipper.animation;
  }
}
