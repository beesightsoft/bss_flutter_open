import 'dart:math';

import 'package:bss_flutter_open/seat_map/seat_map_page.dart';
import 'package:bss_flutter_open/seat_map/utils.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Object {
  Offset offset;
  bool isDrag = false;
  final String id;
  final String asset;
  final double size;
  final String name;

  Object({Offset offset, this.asset, this.size, this.name})
      : id = Uuid().v1(),
        offset = offset;

  Image get image => Image.asset(
        asset,
        width: size,
      );

  Offset get center => Offset(offset.dx + size / 2, offset.dy + size / 2);

  EObject type() => null;

  Widget buildWidget(SeatMapPageState state) => Positioned(
        left: offset.dx - (size + 8) / 2.0,
        top: offset.dy - (size + 8) / 2.0,
        width: (size + 8),
        height: (size + 8),
        child: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: isDrag ? Colors.redAccent : Colors.black12,
                      blurRadius: 20.0)
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                border: Border.all(color: Colors.black12)),
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: image,
                  ),
                  Text(name)
                ],
              ),
            ),
          ),
          onHorizontalDragUpdate: (e) {
            isDrag = true;
            state.setState(() => offset = e.globalPosition);
            state.itemDragUpdate(this);
          },
          onVerticalDragUpdate: (e) {
            isDrag = true;
            state.setState(() => offset = e.globalPosition);
            state.itemDragUpdate(this);
          },
          onHorizontalDragEnd: (e) {
            isDrag = false;
            state.itemDragEnd(this);
          },
          onVerticalDragEnd: (e) {
            isDrag = false;
            state.itemDragEnd(this);
          },
          onDoubleTap: () {
            state.removeObject(id);
          },
          onLongPressUp: () => state.itemLongPressUp(),
          onLongPressStart: (e) => state.modeToGroup(),
          onLongPressMoveUpdate: (e) {
            Offset _delta = e.globalPosition - offset;
            state.itemLongPressUpdate(id, _delta);
          },
        ),
      );
}

class Table extends Object {
  Table({@required Offset offset, String name})
      : super(
            offset: offset,
            size: Utils.sizeTable,
            asset: "lib/seat_map/asset/table.png",
            name: name ?? '');

  @override
  EObject type() => EObject.Table;
}

class Chair extends Object {
  Chair({@required Offset offset, String name})
      : super(
            offset: offset,
            size: Utils.sizeChair,
            asset: "lib/seat_map/asset/chair.png",
            name: name ?? '');

  @override
  EObject type() => EObject.Chair;
}

class Group {
  final String id;
  final String name;
  String hideId;
  List<Table> _tables = [];
  List<Chair> _chairs = [];

  Group(String name)
      : id = Uuid().v1(),
        name = name;

  List<Chair> get chairs => _chairs;

  List<Table> get tables => _tables;

  Widget buildWidget(SeatMapPageState state) {
    List<Widget> _list = [];
    if (tables.isNotEmpty)
      _list.addAll(tables.map((t) => t.buildWidget(state)));
    if (chairs.isNotEmpty)
      _list.addAll(chairs.map((t) => t.buildWidget(state)));
    return Positioned(child: Stack(children: _list));
  }

  Offset formatOffset(Offset offset) {
    return Offset(
        (offset.dx / (Utils.padding / 2.0)).round() * (Utils.padding / 2),
        (offset.dy / (Utils.padding / 2.0)).round() * (Utils.padding / 2));
  }

  void addChild(Offset offset, [bool chair = false]) {
    if (chair) {
      _chairs.add(Chair(
        offset: formatOffset(offset),
        name: "C" + (_chairs.length + 1).toString(),
      ));
      updateChild(_chairs.last, offset);
    } else {
      _tables.add(Table(
        offset: formatOffset(offset),
        name: "T" + (_tables.length + 1).toString(),
      ));
      updateChild(_tables.last, offset);
    }
  }

  void updateChild(Object object, Offset offset) {
    Offset _temp = new Offset(offset.dx, offset.dy);
    int _preLeft = 0;
    int _preTop = 0;
    bool loop = true;
    int count = 0;
    bool loopMode = false;
    while (loop) {
      count++;
      loop = false;
      object.offset = formatOffset(_temp);
      List<Object> _child = allChild();
      for (Object o in _child) {
        if (o.id != object.id) {
          if (Utils.distance(o.center, object.center) < Utils.padding) {
            loop = true;
            int left = 0;
            int top = 0;
            if (object.center.dx < o.center.dx)
              left = -1;
            else if (object.center.dx > o.center.dx) left = 1;
            if (object.center.dy < o.center.dy)
              top = -1;
            else if (object.center.dy > o.center.dy) top = 1;
            if (left == 0 && top == 0) {
              if (_preLeft == 0 && _preTop == 0) {
                left = Random().nextInt(2) == 0 ? 1 : -1;
                top = Random().nextInt(2) == 0 ? 1 : -1;
              } else {
                left = _preLeft;
                top = _preTop;
              }
            }
            if (!loopMode) {
              _preLeft = left;
              _preTop = top;
            }
            _temp = o.offset +
                Offset(_preLeft * Utils.padding, _preTop * Utils.padding);
          }
        }
      }
      if (count == 100) loopMode = true;
    }
  }

  void removeChair(String id) {
    _chairs.removeWhere((t) => t.id == id);
  }

  void removeTable(String id) {
    _tables.removeWhere((t) => t.id == id);
  }

  double shortestDistance(Offset offset) {
    double _shortest;
    for (Table table in tables) {
      double d = Utils.distance(table.offset, offset);
      if (_shortest == null || _shortest > d) _shortest = d;
    }
    return _shortest;
  }

  List<Line> lines() {
    //line table-table
    List<Line> list = [];
    for (int i = 0; i < tables.length - 1; i++) {
      if (tables[i].id != hideId)
        for (int j = i + 1; j < tables.length; j++) {
          if (tables[j].id != hideId)
            list.add(Line(ELine.Bold, tables[i].offset, tables[j].offset));
        }
    }

    //line table-chair
    for (int i = 0; i < chairs.length; i++) {
      int index = 0;
      for (int j = 1; j < tables.length; j++) {
        if (Utils.distance(tables[index].offset, chairs[i].offset) >
            Utils.distance(tables[j].offset, chairs[i].offset)) index = j;
      }
      list.add(Line(ELine.Normal, chairs[i].offset, tables[index].offset));
    }

    return list;
  }

  List<Offset> allCenterPoint() {
    List<Offset> _list = [];
    if (tables.isNotEmpty) _list.addAll(tables.map((t) => t.center));
    if (chairs.isNotEmpty) _list.addAll(chairs.map((t) => t.center));
    return _list;
  }

  List<Offset> allPoint() {
    List<Offset> _list = [];
    if (tables.isNotEmpty) _list.addAll(tables.map((t) => t.offset));
    if (chairs.isNotEmpty) _list.addAll(chairs.map((t) => t.offset));
    return _list;
  }

  List<Object> allChild() {
    List<Object> _list = [];
    if (tables.isNotEmpty) _list.addAll(tables.map((t) => t));
    if (chairs.isNotEmpty) _list.addAll(chairs.map((t) => t));
    return _list;
  }

  Map get circleData {
    List<Offset> _allPoint = allCenterPoint();
    double minX = _allPoint.first.dx;
    double minY = _allPoint.first.dy;
    double maxX = _allPoint.first.dx;
    double maxY = _allPoint.first.dy;

    _allPoint.forEach((o) {
      minX = min(minX, o.dx);
      minY = min(minY, o.dy);
      maxX = max(maxX, o.dx);
      maxY = max(maxY, o.dy);
    });
    double _padding = 24.0;
    Offset _center = Offset(minX + (maxX - minX) / 2 - _padding,
        minY + (maxY - minY) / 2 - _padding);
    double _r = max(maxX - minX, maxY - minY) / 2 + _padding * 2;

    return {'center': _center, 'r': _r};
  }

  void hideLine(String id, bool hide) {
    hideId = hide ? id : null;
  }
}

enum ELine { Normal, Bold }

class Line {
  final ELine type;
  final Offset start;
  final Offset end;

  Line(this.type, this.start, this.end);
}
