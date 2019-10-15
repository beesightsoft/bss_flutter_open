import 'dart:async';

import 'package:bss_flutter_open/list_animation/food.dart';
import 'package:flutter/material.dart';

class ListAnimationItem extends StatefulWidget {
  final Food food;
  final Function onTap;

  const ListAnimationItem({Key key, this.food, this.onTap}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListAnimationItemState();
  }
}

class _ListAnimationItemState extends State<ListAnimationItem>
    with TickerProviderStateMixin {
  static const double HEIGHT = 180;
  static const double CARD = 0.7;
  static const double ICON = 56;

  AnimationController _ctrImage;
  Animation _aniImage;

  AnimationController _ctrCard;
  Animation _aniCard;

  AnimationController _ctrText;
  Animation _aniText;

  AnimationController _ctrCheck;
  Animation _aniCheck;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ctrImage = AnimationController(
        vsync: this, duration: Duration(milliseconds: 800));
    _aniImage = CurvedAnimation(parent: _ctrImage, curve: Curves.easeOutBack);

    _ctrCard =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _aniCard = CurvedAnimation(parent: _ctrCard, curve: Curves.fastOutSlowIn);

    _ctrText =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _aniText = CurvedAnimation(parent: _ctrText, curve: Curves.fastOutSlowIn);

    _ctrCheck =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _aniCheck = CurvedAnimation(parent: _ctrCheck, curve: Curves.fastOutSlowIn);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _ctrImage.forward();
      Timer(Duration(milliseconds: 400), () {
        if (mounted) _ctrCard.forward();
      });
      Timer(Duration(milliseconds: 600), () {
        if (mounted) _ctrText.forward();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          height: HEIGHT,
          alignment: Alignment.center,
          child: AnimatedBuilder(
              animation: _aniCheck,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    _buildBackground(),
                    _buildImage(),
                    _buildTitle(),
                    _buildDescription(),
                    _buildHeart(),
                  ],
                );
              })),
      onTap: _tap,
    );
  }

  void dispose() {
    this._ctrCard.dispose();
    this._ctrImage.dispose();
    this._ctrText.dispose();
    super.dispose();
  }

  double get _heightCard => HEIGHT * CARD;

  double get _topText => _padding + 12.0;

  double get _leftText => (HEIGHT - _heightCard) * 0.5 + _heightCard + 12.0;

  double get _heightTitle => _heightCard - 12.0;

  double get _paddingText => 12.0;

  double get _padding => (HEIGHT - _heightCard) * 0.5;

  double get _topDescription => _padding + _paddingText + 28.0;

  _buildTitle() {
    return AnimatedBuilder(
      animation: _aniText,
      builder: (context, child) {
        double _value = _aniText.value;

        double _widthText = MediaQuery.of(context).size.width -
            _leftText -
            _padding -
            _paddingText -
            ICON;
        double _heightText = _heightTitle - _paddingText;

        return Positioned(
          top: _topText,
          left: _leftText,
          child: Opacity(
            opacity: _value,
            child: Container(
              height: _heightText,
              width: _widthText,
              child: Text(
                widget.food.name,
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.justify,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      },
    );
  }

  _buildDescription() {
    return AnimatedBuilder(
      animation: _aniText,
      builder: (context, child) {
        double _value = _aniText.value;
        double _widthText = MediaQuery.of(context).size.width -
            _leftText -
            _padding -
            _paddingText;
        double _heightText = _heightCard - _paddingText;

        return Positioned(
          top: _topDescription,
          left: _leftText,
          child: Opacity(
            opacity: _value,
            child: Container(
              height: _heightText,
              width: _widthText,
              child: Text(
                widget.food.description,
                style: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.justify,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      },
    );
  }

  _buildHeart() {
    double _value = 1.0 - _aniCheck.value;
    Color _color = _ctrCheck.isAnimating
        ? (widget.food.isCheck ? Colors.black38 : Colors.pink)
        : (widget.food.isCheck ? Colors.pink : Colors.black38);
    double _expandSize = (widget.food.isCheck ? 0.0 : 12.0) *
        (_ctrCheck.isAnimating ? _value : 0.0);

    return AnimatedBuilder(
      animation: _aniText,
      builder: (context, child) {
        double _value = _aniText.value;
        double _left = MediaQuery.of(context).size.width -
            _padding / 2 -
            _paddingText -
            ICON -
            _expandSize / 2;
        double _top = _topText - _expandSize / 2;
        return Positioned(
          top: _top,
          left: _left,
          child: Opacity(
              opacity: _value,
              child: Icon(
                Icons.check,
                color: _color,
                size: ICON / 2 + _expandSize,
              )),
        );
      },
    );
  }

  _buildBackground() {
    return AnimatedBuilder(
      animation: _aniCard,
      builder: (context, child) {
        double _value = _aniCard.value;
        double _heightCard = this._heightCard * _value;
        double _top = (HEIGHT - _heightCard) * 0.5;
        double _left = _padding + this._heightCard * 0.5;
        double _widthCard =
            MediaQuery.of(context).size.width - _left - _padding;
        return Positioned(
          top: _top,
          left: _left,
          child: Container(
            height: _heightCard,
            width: _widthCard,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(24.0)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 20.0 * _value)
                ]),
          ),
        );
      },
    );
  }

  _buildImage() {
    return AnimatedBuilder(
      animation: _aniImage,
      builder: (context, child) {
        double _value = _aniImage.value;
        double _heightImage = HEIGHT * CARD * _value;
        double _top = (HEIGHT - _heightImage) * 0.5;
        double _left =
            _padding * _value + (this._heightCard * (1 - _value) * 0.5);
        return Positioned(
            top: _top,
            left: _left,
            child: Container(
              height: _heightImage,
              width: _heightImage,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 16.0)
                  ],
                  image: DecorationImage(
                      image: NetworkImage(widget.food.image),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(
                      Radius.circular((_heightImage) * 0.5))),
            ));
      },
    );
  }

  _tap() async {
    if (!_ctrCheck.isAnimating &&
        !_ctrCard.isAnimating &&
        !_ctrImage.isAnimating &&
        !_ctrText.isAnimating) {
      await _ctrCheck.reverse(from: 1);
      await _ctrCheck.forward(from: 0);
      widget.onTap();
    }
  }
}
