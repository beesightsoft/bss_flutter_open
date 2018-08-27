import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open/InteractiveCalendar/CalendarModel.dart';
import 'package:flutter_open/InteractiveCalendar/CalendarWidget.dart';
import 'package:flutter_open/InteractiveCalendar/Utils.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as UI;

class CalendarPainter extends CustomPainter {
  //double LONG_PRESS_OPACITY = 0.4;
  //todo 7x7
  List<CalendarBase> values = [];
  List<Map<String, dynamic>> data = [];
  double widthCell = 0.0;
  double margin = 0.0;
  final String title;
  final double zoom;
  final Offset offset;
  final double widthParent;
  final ECalendarZoomType type;
  final bool isLongPress;
  final DateTime dateHover;

  CalendarPainter(
      {this.widthParent,
      this.isLongPress,
      this.title,
      this.offset,
      this.dateHover,
      @required this.zoom,
      this.values,
      this.widthCell,
      this.margin})
      : this.type = zoom < 2
            ? ECalendarZoomType.Small
            : (zoom < 4 ? ECalendarZoomType.Medium : ECalendarZoomType.Large);

  @override
  void paint(Canvas canvas, Size size) {
    paintTitleMonth(canvas, size);
    paintCells(canvas, size);
    paintLineLongPress(canvas, size);
  }

  @override
  bool shouldRepaint(CalendarPainter oldDelegate) {
    return values != oldDelegate.values ||
        widthCell != oldDelegate.widthCell ||
        offset != oldDelegate.offset ||
        margin != oldDelegate.margin ||
        isLongPress != oldDelegate.isLongPress ||
        zoom != oldDelegate.zoom;
  }

  void paintCells(Canvas canvas, Size size) {
    data = [];

    //todo init style
    double marginTop = (margin + HEIGHT_TITLE_MONTH) * zoom;
    values.forEach((t) {
      double _width = widthCell * zoom;
      double _height =
          (data.length < 7 ? HEIGHT_TITLE_WEEKDAY : widthCell * zoom);
      double _x = (margin + data.length % 7 * widthCell) * zoom;
      double _y = data.length < 7
          ? marginTop
          : (((data.length / 7).floor() - 1) * widthCell * zoom +
              marginTop +
              HEIGHT_TITLE_WEEKDAY);

      CalendarCellStyle style = getStyleByType(
          t.type, Size(_width, _height), Offset(_x, _y) + offset);
      data.add({'value': t, 'style': style});
    });

    //todo config by zoom: Small - Medium - Large
    //Value ==> Text
    configData(data);

    //todo sort
    data.sort((c1, c2) => (c1['value'] as CalendarCellText)
        .type
        .index
        .compareTo((c2['value'] as CalendarCellText).type.index));

    for (int i = 0; i < data.length; i++) {
      CalendarCellText text = data[i]['value'];
      CalendarCellStyle style = data[i]['style'];
      Rect rect = Rect.fromPoints(
          style.offset,
          Offset(style.offset.dx + style.size.width,
              style.offset.dy + style.size.height));
      if (text is CalendarCellEvent)
        paintEvents(canvas, text.events, style.offset);
      paintValue(canvas, text, style, rect);
    }
  }

  void paintEvents(Canvas canvas, List<CellEvent> events, Offset offset) {
    double padding = 12.0;
    for (CellEvent value in events) {
      Offset leftTop = Offset(
          offset.dx,
          offset.dy +
              30.0 +
              (value.textSize + padding) * events.indexOf(value));
      Offset rightBottom = Offset(
          offset.dx + widthCell * zoom,
          offset.dy +
              30.0 +
              (value.textSize + padding) * (events.indexOf(value) + 1));

      if (rightBottom.dy - offset.dy > widthCell * zoom) break;

      Rect rect = Rect.fromPoints(leftTop, rightBottom);

      //background
      Paint fill = new Paint()
        ..color = value.background
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.fill;
      canvas.drawRect(rect, fill);

      //text
      TextSpan span = new TextSpan(
          style:
              new TextStyle(color: value.textColor, fontSize: value.textSize),
          text: value.text.toString());
      TextPainter tp = new TextPainter(
          maxLines: 1,
          text: span,
          textAlign: TextAlign.justify,
          textDirection: UI.TextDirection.ltr);
      tp.layout(
          minWidth: widthCell * zoom - padding,
          maxWidth: widthCell * zoom - padding);
      tp.paint(
          canvas, Offset(leftTop.dx + padding / 2, leftTop.dy + padding / 2));
    }
  }

  void paintValue(Canvas canvas, CalendarCellText value,
      CalendarCellStyle style, Rect rect) {
    Color background =
        (value.type == ECalendarCellType.Selection && isLongPress)
            ? Colors.white
            : style.backgroundColor;
    Color backgroundsecond =
        (value.type == ECalendarCellType.Selection && isLongPress)
            ? Colors.white24
            : style.backgroundColor;

    Paint border = new Paint()
      ..color = style.borderColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = style.strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawRect(rect, border);

    Paint fill = new Paint()
      ..color = background
      ..shader =
          RadialGradient(radius: 0.8, colors: [backgroundsecond, background])
              .createShader(rect)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, fill);

    TextSpan span = new TextSpan(
        style: new TextStyle(
            color: style.textColor,
            fontWeight: style.fontWeight,
            fontSize: style.fontSize),
        text: value.text.toString());
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: UI.TextDirection.ltr);
    tp.layout(minWidth: widthCell * zoom);
    tp.paint(canvas, Offset(rect.topLeft.dx, rect.topLeft.dy + 3.0));
  }

  CalendarCellStyle getStyleByType(
      ECalendarCellType type, Size size, Offset offset) {
    switch (type) {
      case ECalendarCellType.Disable:
        return CalendarCellStyle.disable(size, offset);
      case ECalendarCellType.Enable:
        return CalendarCellStyle.enable(size, offset);
      case ECalendarCellType.Title:
        return CalendarCellStyle.title(size, offset);
      case ECalendarCellType.Today:
        return CalendarCellStyle.today(size, offset);
      case ECalendarCellType.Selection:
        return CalendarCellStyle.selection(size, offset);
      case ECalendarCellType.SelectedToday:
        return CalendarCellStyle.selectedtoday(size, offset);
      default:
        return CalendarCellStyle.disable(size, offset);
    }
  }

  //todo 8/2018
  void paintTitleMonth(Canvas canvas, Size size) {
    double _zoom = zoom < 1.0 ? 1.0 : (zoom > 4.0 ? 4.0 : zoom);
    TextSpan span = new TextSpan(
        style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0 * _zoom,
            letterSpacing: 2.0),
        text: title);
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: UI.TextDirection.ltr);
    tp.layout(minWidth: widthParent * zoom);
    tp.paint(canvas, size.topLeft(Offset(0.0, margin * zoom) + offset));
  }

  void configData(List<Map<String, dynamic>> data) {
    //config data by type
    for (int i = 0; i < 49; i++) {
      if (i < 7) {
        if (type == ECalendarZoomType.Small)
          data[i]['value'] = CalendarCellText(
              text: data[i]['value'].text.toString(),
              type: data[i]['value'].type);
        else {
          int index =
              DateTime.now().weekday == 7 ? 0 : DateTime.now().weekday + i;
          String text = DateFormat('EEEE')
              .format(DateTime.now().subtract(Duration(days: index)));
          data[i]['value'] =
              CalendarCellText(text: text, type: data[i]['value'].type);
          data[i]['style'].fontSize = 16.0;
          if (type.index > ECalendarZoomType.Medium.index)
            data[i]['style'].fontSize = 20.0;
        }
      } else {
        DateTime _date = data[i]['value'].date;
        CalendarBase _base = data[i]['value'];

        List<CellEvent> _list =
            (data[i]['value'].events as List<Event>).map((Event e) {
          Color background = e.type == EEvent.Birthday
              ? Colors.deepOrangeAccent
              : (e.type == EEvent.Leave
                  ? Colors.deepPurpleAccent
                  : Colors.green);

          return CellEvent(
              background: background.withOpacity(
                  _base.type == ECalendarCellType.Disable ? 0.2 : 1.0),
              textColor: Colors.white.withOpacity(
                  _base.type == ECalendarCellType.Disable ? 0.2 : 1.0),
              textSize: type == ECalendarZoomType.Medium ? 12.0 : 14.0,
              text: e.text);
        }).toList();

        if (type == ECalendarZoomType.Small)
          data[i]['value'] = CalendarCellEvent(
              datetime: _date,
              text: _date.day.toString(),
              type: data[i]['value'].type,
              events: _list..map((f) => f.textSize = 8.0).toList());
        else if (type == ECalendarZoomType.Medium) {
          data[i]['value'] = CalendarCellEvent(
              datetime: _date,
              text: DateFormat('dd/MM').format(_date),
              type: data[i]['value'].type,
              events: _list..map((f) => f.textSize = 12.0).toList());
          data[i]['style'].fontSize = 16.0;
        } else {
          data[i]['value'] = CalendarCellEvent(
              datetime: _date,
              text: DateFormat('dd/MM/yyyy').format(_date),
              type: data[i]['value'].type,
              events: _list..map((f) => f.textSize = 14.0).toList());
          data[i]['style'].fontSize = 20.0;
        }
      }
    }
  }

  void paintLineLongPress(Canvas canvas, Size size) {
    if (isLongPress && dateHover != null) {
      Paint line = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round;
      Offset _start, _end;
      CalendarCellEvent hover;
      double _width = widthCell * zoom;

      for (Map _map in data) {
        CalendarCellStyle style = _map['style'];
        if (_map['value'].type == ECalendarCellType.Selection ||
            _map['value'].type == ECalendarCellType.SelectedToday)
          _start = Offset(
              style.offset.dx + _width / 2, style.offset.dy + _width / 2);
        if (_map['value'] is CalendarCellEvent &&
            Utils.isEqual(dateHover, _map['value'].datetime)) {
          hover = _map['value'];
          _end = Offset(
              style.offset.dx + _width / 2, style.offset.dy + _width / 2);
        }
        if (_start != null && _end != null) break;
      }

      canvas.drawCircle(_start, 3.0, line);

      if (_end == null) return;
      canvas.drawCircle(_end, 3.0, line);

      canvas.drawLine(_start, _end, line);

      paintValue(
          canvas,
          hover..text = '',
          CalendarCellStyle.hover(Size(_width, _width),
              Offset(_end.dx - _width / 2, _end.dy - _width / 2)),
          Rect.fromPoints(Offset(_end.dx - _width / 2, _end.dy - _width / 2),
              Offset(_end.dx + _width / 2, _end.dy + _width / 2)));
    }
  }
}