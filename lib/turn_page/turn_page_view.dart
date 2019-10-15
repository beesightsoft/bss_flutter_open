import 'dart:math';

import 'package:flutter/material.dart';

class TurnPageView extends StatefulWidget {

  List<Color> data = [Colors.yellow, Colors.red, Colors.green];

  TurnPageView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TurnPageViewState();
  }
}

class _TurnPageViewState extends State<TurnPageView>
    with SingleTickerProviderStateMixin {
  int page = 0;
  int _nextPage = 0;
  AnimationController _controller;
  Animation _animation;
  bool isAnimation = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext context, Widget child) {
            Map _map = getPath();
            return Stack(
              children: <Widget>[
                _buildPage(_nextPage),
                CustomPaint(
                  painter: BoxShadowPainter(_map['path']),
                  child: ClipPath(
                    clipper: ClipScreen(_map['path']),
                    child: _buildPage(
                      page,
                    ),
                  ),
                ),
                CustomPaint(
                  painter: BoxConnerPainter(
                      _map['central'], _map['start'], _map['end']),
                  size: MediaQuery.of(context).size,
                )
              ],
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              child: Text("PREV"),
              onPressed: prev,
            ),
            FlatButton(
              child: Text("NEXT"),
              onPressed: next,
            ),
          ],
        )
      ],
    );
  }

  void prev() {
    if (!isAnimation) {
      if (page - 1 > 0) {
        setState(() => this._nextPage = page - 1);
        isAnimation = true;
        _controller.reverse(from: 1).then((_) {
          setState(() => page = _nextPage);
          isAnimation = false;
        });
      }
    }
  }

  void next() {
    if (!isAnimation) {
      if (page + 1 < widget.data.length) {
        setState(() => this._nextPage = page + 1);
        isAnimation = true;
        _controller.forward(from: 0).then((_) {
          setState(() => page = _nextPage);
          isAnimation = false;
        });
      }
    }
  }

  _buildPage(page) {
    int _page = max(min(page, widget.data.length - 1), 0);
    return Container(
      color: widget.data[_page],
      child: Text(
        '$page',
        style: TextStyle(fontSize: 120.0),
      ),
      alignment: Alignment.center,
    );
  }

  getPath() {
    Size size = MediaQuery.of(context).size;
    bool isNext = _nextPage > page;
    double animation = _animation.value;
    Path path = Path();
    Offset central = Offset.zero;
    Offset start = Offset.zero;
    Offset end = Offset.zero;
    if (isNext) {
      double y = size.height * (1 - 2 * animation);
      double x = size.width * (1 - 2 * animation);
      path.moveTo(-size.width, -size.height);
      path.lineTo(size.width, -size.height);
      path.lineTo(size.width, y);
      path.lineTo(x, size.height);
      path.lineTo(-size.width, size.height);
      start = Offset(x, size.height);
      end = Offset(size.width, y);
      central = Offset(x + (size.width - x) / 2, y + (size.height - y) / 2);
    } else {
      double y = size.height * (1 - 2 * (1 - animation));
      double x = size.width * 2 * (1 - animation);
      path.moveTo(0, -size.height);
      path.lineTo(2 * size.width, -size.height);
      path.lineTo(2 * size.width, size.height);
      path.lineTo(x, size.height);
      path.lineTo(0, y);
      start = Offset(x, size.height);
      end = Offset(0, y);
      central = Offset(x / 2, y + (size.height - y) / 2);
    }
    path.close();
    return {'path': path, 'start': start, 'end': end, 'central': central};
  }
}

class ClipScreen extends CustomClipper<Path> {
  final Path path;

  ClipScreen(this.path);

  @override
  Path getClip(Size size) => path;

  @override
  bool shouldReclip(ClipScreen oldClipper) {
    return oldClipper.path != path;
  }
}

class BoxShadowPainter extends CustomPainter {
  final Path path;

  BoxShadowPainter(this.path);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawShadow(path, Colors.black45, 12.0, false);
  }

  @override
  bool shouldRepaint(BoxShadowPainter oldDelegate) {
    return path != oldDelegate.path;
  }
}

class BoxConnerPainter extends CustomPainter {
  final Offset central;
  final Offset start;
  final Offset end;

  BoxConnerPainter(this.central, this.start, this.end);

  @override
  void paint(Canvas canvas, Size size) {
//    canvas.drawCircle(central, 12.0, Paint()..color = Colors.black);
//    canvas.drawCircle(start, 12.0, Paint()..color = Colors.green);
//    canvas.drawCircle(end, 12.0, Paint()..color = Colors.white);
    Path _path = Path();
    if (start.dx < end.dx) {
      _path.moveTo(start.dx, start.dy);
      _path.quadraticBezierTo(
          start.dx,
          start.dy - 2 * (start.dy - central.dy) * 0.65,
          start.dx + 100,
          start.dy - 2 * (start.dy - central.dy) * 0.65);
      _path.quadraticBezierTo(
          size.width,
          start.dy - 2 * (start.dy - central.dy),
          size.width,
          start.dy - 2 * (start.dy - central.dy));
    } else {
      _path.moveTo(end.dx, end.dy);
      _path.quadraticBezierTo(end.dx + 2 * (start.dx - central.dx), end.dy,
          end.dx + 2 * (start.dx - central.dx), end.dy);
      _path.quadraticBezierTo(end.dx + 2 * (start.dx - central.dx), size.height,
          end.dx + 2 * (start.dx - central.dx), size.height);
    }
    canvas.drawShadow(_path, Colors.black45, 6.0, false);
    canvas.drawPath(_path, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(BoxConnerPainter oldDelegate) {
    return central != oldDelegate.central;
  }
}
