import 'package:flutter/material.dart';
import 'package:quiver/core.dart';
import 'package:date_utils/date_utils.dart';

class CustomCalendar extends StatelessWidget {
  final Function onSelectDay;
  final List<Offset> selectedPositions;

  GestureDetector touch;
  CustomPaint canvas;
  Painter painter;

  int startDayIndex;
  int nameOfEndDay;

  CustomCalendar({this.onSelectDay, this.selectedPositions}) {
    nameOfEndDay = Utils.lastDayOfMonth(DateTime.now()).day;

    if (DateTime.now().weekday > 0) {
      startDayIndex = DateTime.now().weekday - 1;
    } else {
      startDayIndex = 6;
    }

    painter = new Painter(
        selectedPositions: selectedPositions,
        nameOfEndDay: nameOfEndDay,
        startDayIndex: startDayIndex,
        onSelectDay: this.onSelectDay);
  }

  void selectDate(TapUpDetails position) {
    painter.select(Offset(
        position.globalPosition.dx - 16.0, position.globalPosition.dy - 247.0));
  }

  @override
  Widget build(BuildContext context) {
    touch = new GestureDetector(
      onTapUp: selectDate,
    );

    return CustomPaint(
      child: touch,
      painter: painter,
    );
  }
}

class Painter extends ChangeNotifier implements CustomPainter {
  Paint _paint;
  Paint _paintFill;
  Paint _paintFillWeekend;
  Paint _paintFillSelection;

  int startDayIndex; //3
  int nameOfEndDay;

  int today = DateTime.now().day;

  double w, h;
  Offset position = new Offset(0.0, 0.0);

  SelectedDateInfo selectedDayInfo = new SelectedDateInfo();
  Function onSelectDay;
  List<Offset> selectedPositions;


  Painter({this.nameOfEndDay, this.startDayIndex, this.onSelectDay, this.selectedPositions}) {
    _paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    _paintFill = Paint()
      ..color = Colors.green.withOpacity(0.45)
      ..style = PaintingStyle.fill;

    _paintFillWeekend = Paint()
      ..color = Colors.red.withOpacity(0.45)
      ..style = PaintingStyle.fill;

    _paintFillSelection = Paint()
      ..color = Colors.purpleAccent
      ..style = PaintingStyle.fill;
  }

  void select(Offset position) {
    double t = h / (4 + 1) / 2;
    var dx = (position.dx ~/ (w / 7)) * (w / 7);
    var dy = (position.dy ~/ t) * t;

    if(dx < 5 * w / 7 && dy >= h / (5 + 1)) {
      Offset temp = new Offset(dx, dy);
      if (selectedPositions.indexOf(temp) == -1) {
        selectedPositions.add(temp);
      } else {
        selectedPositions.remove(temp);
      }
    }
    notifyListeners();
  }

  @override
  bool hitTest(Offset position) {
    getSelectedDayInfo(position);
    onSelectDay(selectedDayInfo);
    selectedDayInfo = new SelectedDateInfo();
    return null;
  }

  getSelectedDayInfo(Offset l) {
    int x, y;
    double t = h / (4 + 1);
    x = l.dx ~/ (w / 7);
    y = l.dy ~/ t;

    switch (y) {
      case 1:
        if (x - startDayIndex + 1 > 0) {
          selectedDayInfo.day = x - startDayIndex + today;
        }
        break;
      case 2:
        selectedDayInfo.day = x - startDayIndex + today + 7;
        break;
      case 3:
        selectedDayInfo.day = x - startDayIndex + today + 14;
        break;
      case 4:
        selectedDayInfo.day = x - startDayIndex + today + 21;
        break;
    }

    if (y != 0 && x < 5) {
      if (l.dy - y * t < t / 2) {
        selectedDayInfo.session = sessionOfDay.Morning;
      } else {
        selectedDayInfo.session = sessionOfDay.Afternoon;
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final w = size.width;

    this.w = w;
    this.h = h;

    int numberOfRowLine = 4;

    //Border
    canvas.drawLine(Offset(0.0, 0.0), Offset(w, 0.0), _paint);
    canvas.drawLine(Offset(0.0, 0.0), Offset(0.0, h), _paint);
    canvas.drawLine(Offset(0.0, h), Offset(w, h), _paint);
    canvas.drawLine(Offset(w, 0.0), Offset(w, h), _paint);

    //Row
    for (int i = 0; i < numberOfRowLine + 1; i++) {
      canvas.drawLine(Offset(0.0, (i + 1) * h / (numberOfRowLine + 1)),
          Offset(w, (i + 1) * h / (numberOfRowLine + 1)), _paint);
    }

    //Column
    canvas.drawLine(Offset(w / 7, 0.0), Offset(w / 7, h), _paint);
    canvas.drawLine(Offset(2 * w / 7, 0.0), Offset(2 * w / 7, h), _paint);
    canvas.drawLine(Offset(3 * w / 7, 0.0), Offset(3 * w / 7, h), _paint);
    canvas.drawLine(Offset(4 * w / 7, 0.0), Offset(4 * w / 7, h), _paint);
    canvas.drawLine(Offset(5 * w / 7, 0.0), Offset(5 * w / 7, h), _paint);
    canvas.drawLine(Offset(6 * w / 7, 0.0), Offset(6 * w / 7, h), _paint);

    canvas.drawRect(
        Rect.fromPoints(
            Offset(0.0, 0.0), Offset(5 * w / 7, h / (numberOfRowLine + 1))),
        _paintFill);
    canvas.drawRect(Rect.fromPoints(Offset(5 * w / 7, 0.0), Offset(w, h)),
        _paintFillWeekend);

    selectedPositions.forEach((position) {
      if((position.dy == 50.0 && position.dx < startDayIndex * w / 7) || (position.dy == 75.0 && position.dx < startDayIndex * w / 7)) {

      } else {
        canvas.drawRect(
            Rect.fromPoints(
                position,
                Offset(position.dx + w / 7,
                    position.dy + h / (2 * numberOfRowLine + 2))),
            _paintFillSelection);
      }
    });

    drawText(canvas, size, new Offset(0.0, 0.0), 'Mon');
    drawText(canvas, size, new Offset(w / 7, 0.0), 'Tue');
    drawText(canvas, size, new Offset(2 * w / 7, 0.0), 'Wed');
    drawText(canvas, size, new Offset(3 * w / 7, 0.0), 'Thu');
    drawText(canvas, size, new Offset(4 * w / 7, 0.0), 'Fri');
    drawText(canvas, size, new Offset(5 * w / 7, 0.0), 'Sat');
    drawText(canvas, size, new Offset(6 * w / 7, 0.0), 'Sun');

    //1st line
    for (int i = 0; i < 7 - startDayIndex; i++) {
      if (i + today > nameOfEndDay) {
        drawTextDate(
            canvas,
            size,
            Offset(
                (i + startDayIndex) * w / 7,
                h / (numberOfRowLine + 1)),
            (i + today - nameOfEndDay).toString(),
            i == 0 ? Colors.red : Colors.black
        );
      } else {
        drawTextDate(
            canvas,
            size,
            Offset(
                (i + startDayIndex) * w / 7,
                h / (numberOfRowLine + 1)),
            (i + today).toString(),
            i == 0 ? Colors.red : Colors.black
        );
      }
    }
    //2nd line
    for (int i = 7 - startDayIndex; i < 14 - startDayIndex; i++) {
      if (i + today > nameOfEndDay) {
        drawTextDate(
            canvas,
            size,
            Offset(
                (i - 7 + startDayIndex) * w / 7,
                2 * h / (numberOfRowLine + 1)),
            (i + today - nameOfEndDay).toString());
      } else {
        drawTextDate(
            canvas,
            size,
            Offset(
                (i - 7 + startDayIndex) * w / 7,
                2 * h / (numberOfRowLine + 1)),
            (i + today).toString());
      }
    }
    //3rd line
    for (int i = 14 - startDayIndex; i < 21 - startDayIndex; i++) {
      if (i + today > nameOfEndDay) {
        drawTextDate(
            canvas,
            size,
            Offset(
                (i - 14 + startDayIndex) * w / 7,
                3 * h / (numberOfRowLine + 1)),
            (i + today - nameOfEndDay).toString());
      } else {
        drawTextDate(
            canvas,
            size,
            Offset(
                (i - 14 + startDayIndex) * w / 7,
                3 * h / (numberOfRowLine + 1)),
            (i + today).toString());
      }
    }
    //4th line
    for (int i = 21 - startDayIndex; i < 28 - startDayIndex; i++) {
      if (i + today > nameOfEndDay) {
        drawTextDate(
            canvas,
            size,
            Offset(
                (i - 21 + startDayIndex) * w / 7,
                4 * h / (numberOfRowLine + 1)),
            (i + today - nameOfEndDay).toString());
      } else {
        drawTextDate(
            canvas,
            size,
            Offset(
                (i - 21 + startDayIndex) * w / 7,
                4 * h / (numberOfRowLine + 1)),
            (i + today).toString());
      }
    }

    canvas.drawRect(Rect.fromPoints(Offset(5 * w / 7, 0.0), Offset(w, h)),
        _paintFillWeekend);
  }

  void drawText(Canvas canvas, Size size, Offset offset, String text,
      [Color color = Colors.black]) {
    int numberOfRowLine = 4;

    TextPainter tp = new TextPainter(
        text: new TextSpan(style: new TextStyle(color: color), text: text),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();

    double dx = offset.dx + size.width / 14 - tp.width / 2;
    double dy =
        offset.dy + size.height / (2 * numberOfRowLine + 2) - tp.height / 2;

    tp.paint(canvas, Offset(dx, dy));
  }

  void drawTextDate(Canvas canvas, Size size, Offset offset, String text,
      [Color color = Colors.black]) {

    TextPainter tp = new TextPainter(
        text: new TextSpan(style: new TextStyle(color: color, fontSize: 12.0), text: text),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();

    TextPainter tpMorning = new TextPainter(
        text: new TextSpan(style: new TextStyle(color: color, fontSize: 12.0), text: '☀'),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tpMorning.layout();

    TextPainter tpAfternoon = new TextPainter(
        text: new TextSpan(style: new TextStyle(color: color, fontSize: 12.0), text: '🌙'),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tpAfternoon.layout();

    double dx = offset.dx + 6.0;
    double dy = offset.dy + 4.0;

    if(offset.dx < 5 * size.width / 7) {
      tpMorning.paint(canvas, Offset(dx + 25.0, dy - 4.0));
      tpAfternoon.paint(canvas, Offset(dx + 25.0, dy + 25.0));
    }

    tp.paint(canvas, Offset(dx, dy));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  // TODO: implement semanticsBuilder
  @override
  SemanticsBuilderCallback get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    // TODO: implement shouldRebuildSemantics
    return true;
  }
}

class SelectedDateInfo {
  int day;
  sessionOfDay session;

  SelectedDateInfo({this.day, this.session});

  bool operator ==(o) => o is SelectedDateInfo && day == o.day && session == o.session;
  int get hashCode => hash2(day.hashCode, session.hashCode);
}

enum dayOfWeek { Mon, Tue, Wed, Thu, Fri, Sat, Sun }

enum sessionOfDay { Morning, Afternoon }