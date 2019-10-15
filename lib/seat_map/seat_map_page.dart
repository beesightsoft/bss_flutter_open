import 'package:bss_flutter_open/seat_map/seat_map_painter.dart';
import 'package:bss_flutter_open/seat_map/utils.dart';
import 'package:flutter/material.dart';

import 'seat_map_model.dart' as model;

class SeatMapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SeatMapPageState();
  }
}

enum EObject { None, Table, Chair, NewGroup }
enum EMode { Single, Group }

class SeatMapPageState extends State<SeatMapPage> {
  List<model.Group> _groups = [];
  Offset _drag = Offset.zero;
  EObject _objectType = EObject.None;
  EMode _mode = EMode.Single;
  Offset _dragAvailable;
  Map _dataCircleDrag;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Size _size = Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height - 80);
      Offset _center = _size.center(Offset.zero);
//      _groups.add(model.Group(_groups.length.toString()));
//
//      //
//      _groups.last.addChild(_center - Offset(Utils.padding, _center.dy / 2));
//      _groups.last.addChild(_center - Offset(-Utils.padding, _center.dy / 2));
//
//      double _bottom = _center.dy / 2 - Utils.padding * 1.5;
//      double _top = _center.dy / 2 + Utils.padding * 1.5;
//      double _hori = Utils.padding * 2.5;
//      _groups.last.addChild(_center - Offset(Utils.padding, _bottom), true);
//      _groups.last.addChild(_center - Offset(Utils.padding, _top), true);
//      _groups.last.addChild(_center - Offset(_hori, _center.dy / 2), true);
//
//      _groups.last.addChild(_center - Offset(-Utils.padding, _bottom), true);
//      _groups.last.addChild(_center - Offset(-Utils.padding, _top), true);
//      _groups.last.addChild(_center - Offset(-_hori, _center.dy / 2), true);
//
//      //
//      _groups.add(model.Group(_groups.length.toString()));
//      _groups.last.addChild(_center + Offset(-Utils.padding, _center.dy / 2));
//      _groups.last.addChild(_center + Offset(Utils.padding, _center.dy / 2));
//
//      _top = _center.dy / 2 - Utils.padding * 1.5;
//      _bottom = _center.dy / 2 + Utils.padding * 1.5;
//
//      _groups.last.addChild(_center + Offset(-Utils.padding, _top), true);
//      _groups.last.addChild(_center + Offset(-Utils.padding, _bottom), true);
//      _groups.last.addChild(_center + Offset(-_hori, _center.dy / 2), true);
//
//      _groups.last.addChild(_center + Offset(Utils.padding, _top), true);
//      _groups.last.addChild(_center + Offset(Utils.padding, _bottom), true);
//      _groups.last.addChild(_center + Offset(_hori, _center.dy / 2), true);

      double _padding = 120;
      double _distance = 70;
      double _xLeft = _center.dx - _padding / 2;
      double _xRight = _center.dx + _padding / 2;
      double _left = _xLeft - _distance;
      double _right = _xRight + _distance;
      double _yTop = _padding + _distance;
      double _paddingBottom = _size.height - _padding;
      double _yBottom = _paddingBottom - _distance;

      //group
      _groups.add(model.Group(_groups.length.toString()));

      //table
      _groups.last.addChild(Offset(_xLeft, _padding));
      _groups.last.addChild(Offset(_xRight, _padding));

      //chairs
      _groups.last.addChild(Offset(_left, _padding), true);
      _groups.last.addChild(Offset(_left, _yTop), true);
      _groups.last.addChild(Offset(_left + _distance, _yTop), true);
      _groups.last.addChild(Offset(_right, _padding), true);
      _groups.last.addChild(Offset(_right, _yTop), true);
      _groups.last.addChild(Offset(_right - _distance, _yTop), true);

      //group
      _groups.add(model.Group(_groups.length.toString()));
      //table
      _groups.last.addChild(Offset(_xLeft, _paddingBottom));
      _groups.last.addChild(Offset(_xRight, _paddingBottom));
      //chairs
      _groups.last.addChild(Offset(_left, _paddingBottom), true);
      _groups.last.addChild(Offset(_left, _yBottom), true);
      _groups.last.addChild(Offset(_left + _distance, _yBottom), true);
      _groups.last.addChild(Offset(_right, _paddingBottom), true);
      _groups.last.addChild(Offset(_right, _yBottom), true);
      _groups.last.addChild(Offset(_right - _distance, _yBottom), true);

      _updateName();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildListGroup(),
          _buildBottom(),
          _buildDragObject()
        ],
      ),
    );
  }

  _buildListGroup() {
    List<Widget> _list = [
      Container(
        color: Colors.transparent,
        child: CustomPaint(
          size: MediaQuery.of(context).size,
          painter: SeatMapPainter(
            mode: _mode,
            groups: _groups,
            drag: _objectType == EObject.None || _objectType == EObject.NewGroup
                ? _dragAvailable
                : _drag,
          ),
        ),
      )
    ];
    if (_groups.isNotEmpty)
      _list.addAll(_groups.map((g) => g.buildWidget(this)));
    return Stack(children: _list);
  }

  _buildDragObject() {
    return _objectType == EObject.Table || _objectType == EObject.NewGroup
        ? model.Table(offset: _drag).buildWidget(this)
        : (_objectType == EObject.Chair
            ? model.Chair(offset: _drag).buildWidget(this)
            : SizedBox());
  }

  _buildBottom() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          height: 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.grey,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20.0)]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildItemBottom(EObject.NewGroup),
              _buildItemBottom(EObject.Table, _groups.isEmpty),
              _buildItemBottom(EObject.Chair, _groups.isEmpty)
            ],
          ),
        )
      ],
    );
  }

  _buildItemBottom(EObject type, [bool hidden = false]) {
    return Flexible(
        child: hidden
            ? SizedBox()
            : GestureDetector(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Image.asset(
                          type == EObject.Chair
                              ? "lib/seat_map/asset/chair.png"
                              : "lib/seat_map/asset/table.png",
                          width: 26.0,
                        ),
                      ),
                      Center(
                        child: Text(type == EObject.Chair
                            ? "Chair"
                            : (type == EObject.Table ? "Table" : "New Group")),
                      )
                    ],
                  ),
                ),
                onHorizontalDragEnd: _onDragEnd,
                onVerticalDragEnd: _onDragEnd,
                onHorizontalDragUpdate: (e) => _onDragUpdate(type, e),
                onVerticalDragUpdate: (e) => _onDragUpdate(type, e),
              ));
  }

  removeObject(String id) {
    String idGroupDel;
    for (model.Group gr in _groups) {
      gr.removeChair(id);
      gr.removeTable(id);
      if (gr.tables.length == 0) idGroupDel = gr.id;
    }
    if (idGroupDel != null) _groups.removeWhere((g) => g.id == idGroupDel);
    _updateName();
  }

  _updateName() {
    //named
    List<model.Group> _newGrs = [];
    List<model.Chair> _chairs = [];
    for (model.Group gr in _groups) {
      model.Group _newGr = model.Group(gr.name);
      gr.tables.forEach((t) => _newGr.addChild(t.offset));
      _newGrs.add(_newGr);
      if (gr.chairs.isNotEmpty) _chairs.addAll(gr.chairs);
    }

    for (model.Chair chair in _chairs) {
      double _distance;
      int index = -1;
      for (model.Group gr in _newGrs) {
        if (index == -1 || _distance > gr.shortestDistance(chair.offset)) {
          _distance = gr.shortestDistance(chair.offset);
          index = _newGrs.indexOf(gr);
        }
      }
      if (index != -1) _newGrs[index].addChild(chair.offset, true);
    }

    setState(() => this._groups = _newGrs);
  }

  itemDragUpdate(model.Object object) {
    model.Group _g = _groups.firstWhere(
        (g) => g.allChild().indexWhere((o) => o.id == object.id) != -1,
        orElse: () => null);
    if (_g != null) {
      if (_dragAvailable == null) {
        _dataCircleDrag = _g.circleData;
      }
      if (_g.tables.length > 1)
        _g.hideLine(
            object.id,
            object.type() == EObject.Table &&
                Utils.distance(_dataCircleDrag['center'], object.offset) >
                    _dataCircleDrag['r'] * 1.5);
    }

    setState(() => this._dragAvailable = object.offset);
  }

  itemDragEnd(model.Object object) {
    setState(() => this._dragAvailable = null);
    model.Group _g = _groups.firstWhere(
        (g) => g.allChild().indexWhere((o) => o.id == object.id) != -1,
        orElse: () => null);
    if (_g != null) {
      if (_g.hideId != null) {
        model.Table _table =
            _g.tables.firstWhere((f) => f.id == _g.hideId, orElse: () => null);
        if (_table != null) {
          removeObject(_g.hideId);
          _g.hideId = null;
          _groups.add(
              model.Group(_groups.length.toString())..addChild(_table.offset));
        }
      }
      _g.updateChild(object, object.offset);
    }
    modeToSingle();
    _updateName();
  }

  itemLongPressUpdate(String id, Offset delta) {
    if (_mode == EMode.Group) {
      for (model.Group g in _groups) {
        List<model.Object> objects = g.allChild();
        int index = objects.indexWhere((t) => t.id == id);
        if (index != -1) {
          setState(() {
            objects.forEach((o) {
              o.offset += delta;
            });
          });
        }
      }
    }
  }

  itemLongPressUp() {
    bool existDup = true;
    List<model.Group> _newGr = _groups;
    while (existDup) {
      existDup = false;
      int index = -1;

      List<model.Group> _tempGr = [];
      for (int i = 0; i < _newGr.length; i++) {
        if (i != index) {
          model.Group _g = model.Group(_newGr[i].name);
          _newGr[i].tables.forEach((t) => _g.addChild(t.offset));
          _newGr[i].chairs.forEach((t) => _g.addChild(t.offset, true));

          if (!existDup) {
            for (int j = i + 1; j < _newGr.length; j++) {
              Map _mi = _newGr[i].circleData;
              Map _mj = _newGr[j].circleData;
              Rect _recti = Rect.fromCircle(
                  center: _mi['center'], radius: _mi['r'] * 0.6);
              Rect _rectj = Rect.fromCircle(
                  center: _mj['center'], radius: _mj['r'] * 0.6);
              if (isDuplication(_recti, _rectj) ||
                  isDuplication(_rectj, _recti)) {
                index = j;
                existDup = true;
                break;
              }
            }

            if (index != -1) {
              _newGr[index].tables.forEach((t) => _g.addChild(t.offset));
              _newGr[index].chairs.forEach((t) => _g.addChild(t.offset, true));
            }
          }
          _tempGr.add(_g);
        }
      }
      _newGr = _tempGr;
    }
    setState(() => _groups = _newGr);
    modeToSingle();
  }

  bool isDuplication(Rect r1, Rect r2) {
    bool r = r1.right >= r2.left && r1.right <= r2.right;
    bool t = r1.top >= r2.bottom && r1.top <= r2.top;
    bool l = r1.left >= r2.left && r1.left <= r2.right;
    bool b = r1.bottom >= r2.top && r1.bottom <= r2.bottom;
    bool lr = r1.left <= r2.left && r1.right >= r2.left;
    bool tb = r1.top <= r2.top && r1.bottom >= r2.bottom;
    return r && t ||
        r && b ||
        l && t ||
        l && b ||
        lr && tb ||
        lr && t ||
        lr && b ||
        tb && l ||
        tb && r;
  }

  _onDragUpdate(EObject type, DragUpdateDetails e) {
    setState(() {
      _objectType = type;
      _drag = e.globalPosition;
    });
  }

  _onDragEnd(DragEndDetails e) {
    if (_objectType != EObject.None) {
      if (_drag.dy < MediaQuery.of(context).size.height - 80) {
        if (_objectType == EObject.NewGroup)
          _addGroup();
        else if (_objectType == EObject.Table)
          _addTable();
        else
          _addChair();
        _updateName();
      }
      setState(() {
        _objectType = EObject.None;
        _drag = Offset.zero;
      });
    }
  }

  _addTable() {
    model.Group nearestGroup;
    double nearest;

    for (model.Group gr in _groups)
      if (nearestGroup == null || nearest > gr.shortestDistance(_drag)) {
        nearestGroup = gr;
        nearest = gr.shortestDistance(_drag);
      }

    if (nearestGroup != null) {
      setState(() => nearestGroup.addChild(_drag));
    }
  }

  _addGroup() {
    setState(() =>
        _groups.add(model.Group(_groups.length.toString())..addChild(_drag)));
  }

  _addChair() {
    model.Group nearestGroup;
    double nearest;

    for (model.Group gr in _groups)
      if (nearestGroup == null || nearest > gr.shortestDistance(_drag)) {
        nearestGroup = gr;
        nearest = gr.shortestDistance(_drag);
      }

    if (nearestGroup != null) {
      setState(() => nearestGroup.addChild(_drag, true));
    }
  }

  modeToGroup() => setState(() => _mode = EMode.Group);

  modeToSingle() => setState(() => _mode = EMode.Single);
}
