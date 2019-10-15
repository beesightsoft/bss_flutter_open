import 'package:bss_flutter_open/seat_map/seat_map_model.dart' as model;
import 'package:bss_flutter_open/seat_map/seat_map_page.dart';
import 'package:bss_flutter_open/seat_map/utils.dart';
import 'package:flutter/material.dart';

class SeatMapPainter extends CustomPainter {
  final List<model.Group> groups;
  final Offset drag;
  final EMode mode;

  SeatMapPainter(
      {@required this.groups, @required this.drag, @required this.mode});

  @override
  void paint(Canvas canvas, Size size) {
    groups.forEach((g) => g.lines().forEach((l) => canvas.drawLine(
        l.start,
        l.end,
        Paint()
          ..color = Colors.black
          ..strokeWidth = l.type == model.ELine.Bold ? 3 : 1)));
    model.Line _line = _buildLineAddNew();
    if (_line != null)
      canvas.drawLine(
          _line.start,
          _line.end,
          Paint()
            ..color = Colors.redAccent.withOpacity(0.6)
            ..strokeCap = StrokeCap.round
            ..strokeWidth = 2.0);

    //draw Circle Area Group
    if (mode == EMode.Group) _drawCircleArea(canvas);
  }

  _drawCircleArea(Canvas canvas) {
    groups.forEach((g) {
      Map _map = g.circleData;
      Offset _center = _map['center'];
      double _r = _map['r'];
      canvas.drawCircle(
          _center, _r, Paint()..color = Colors.blueAccent.withOpacity(0.4));
      canvas.drawCircle(_center, _r * 0.6,
          Paint()..color = Colors.blueAccent.withOpacity(0.4));
    });
  }

  _buildLineAddNew() {
    if (drag != null) {
      model.Table _table;
      for (model.Group group in groups) {
        for (model.Table table in group.tables) {
          if (_table == null ||
              Utils.distance(_table.offset, drag) >
                  Utils.distance(table.offset, drag)) _table = table;
        }
      }
      if (_table != null)
        return model.Line(model.ELine.Bold, drag, _table.offset);
    }
    return null;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
