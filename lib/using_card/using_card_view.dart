import 'package:flutter/material.dart';

class UsingCardView extends StatefulWidget {
  final Widget card;
  final Widget view;

  const UsingCardView({Key key, @required this.card, @required this.view})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UsingCardViewState();
  }
}

class _UsingCardViewState extends State<UsingCardView>
    with TickerProviderStateMixin {
  static const CONTENT_SIZE = 0.8;

  AnimationController _animationController;
  Animation _animation;
  AnimationController _animationCardController;
  Animation _animationCard;
  AnimationController _animationTapController;
  Animation _animationTapCard;
  bool expandedCard = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn);
    _animationCardController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _animationCard = CurvedAnimation(
        parent: _animationCardController, curve: Curves.fastOutSlowIn);
    _animationTapController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 160));
    _animationTapCard =
        CurvedAnimation(parent: _animationTapController, curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [Colors.redAccent, Colors.blueGrey])),
      child: Stack(
        children: <Widget>[_buildCard(), _buildContent()],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationCardController.dispose();
    super.dispose();
  }

  _buildCard() {
    return AnimatedBuilder(
        animation: _animationCard,
        builder: (BuildContext context, Widget child) {
          double _value = 1 - _animationCard.value;
          double _distance = 72.0;
          return Positioned(
              top: _distance * _value,
              child: GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.transparent,
                  child: AnimatedBuilder(
                    animation: _animationTapCard,
                    builder: (BuildContext context, Widget child) {
                      double _value = 1 - _animationTapCard.value;
                      Matrix4 _transform = Matrix4.identity()
                        ..scale(1.0 + _value * 0.05, 1.0 + _value * 0.05);
                      return Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Transform(
                            transform: _transform,
                            child: widget.card,
                            alignment: Alignment.center,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                onTap: _tap,
              ));
        });
  }

  _buildContent() {
    Size _size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget child) {
        double _value = 1 - _animation.value;
        double _padding = _size.height * (CONTENT_SIZE) * _value;
        double _top = _size.height * (1 - CONTENT_SIZE) * (1 - _value);
        return Positioned(
          top: _top + _padding,
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(
              height: _size.height * CONTENT_SIZE,
              width: _size.width,
            ),
            child: GestureDetector(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black38, blurRadius: 20.0)
                      ],
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12.0))),
                  child: widget.view),
              onTap: _tapList,
            ),
          ),
        );
      },
    );
  }

  void _tapList() {
    if (isReady && !expandedCard) {
      _animationController.forward(from: 0);
      _animationCardController.forward(from: 0);
      expandedCard = !expandedCard;
    }
  }

  void _tap() async {
    if (isReady) {
      await _animationTapController.forward();
      _animationTapController.reverse();
      if (expandedCard) {
        _animationCardController.reverse(from: 1);
        _animationController.reverse(from: 1);
      } else {
        _animationController.forward(from: 0);
        _animationCardController.forward(from: 0);
      }
      expandedCard = !expandedCard;
    }
  }

  bool get isReady => !(_animationController.isAnimating ||
      _animationTapController.isAnimating ||
      _animationCardController.isAnimating);
}
