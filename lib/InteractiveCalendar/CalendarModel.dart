import 'package:flutter/material.dart';

enum ECalendarCellType {
  Disable,
  Title,
  Enable,
  Today,
  Selection,
  SelectedToday,
}

enum ECalendarZoomType { Small, Medium, Large }

enum EEvent { Leave, Event, Birthday }

class CalendarCellStyle {
  final FontWeight fontWeight;
  Color borderColor;
  Color backgroundColor;
  Color textColor;
  double fontSize;
  final Size size;
  final Offset offset;
  final double strokeWidth;

  CalendarCellStyle(
      {this.strokeWidth,
      this.fontSize = 14.0,
      this.backgroundColor,
      this.textColor,
      this.borderColor,
      this.fontWeight,
      this.size,
      this.offset});

  factory CalendarCellStyle.disable(Size size, Offset offset) {
    return CalendarCellStyle(
        fontWeight: FontWeight.normal,
        size: size,
        offset: offset,
        strokeWidth: 0.0,
        borderColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        textColor: Colors.white30);
  }

  factory CalendarCellStyle.enable(Size size, Offset offset) {
    return CalendarCellStyle(
        fontWeight: FontWeight.normal,
        size: size,
        offset: offset,
        strokeWidth: 1.0,
        borderColor: Colors.white,
        backgroundColor: Colors.transparent,
        textColor: Colors.white);
  }

  factory CalendarCellStyle.selection(Size size, Offset offset) {
    return CalendarCellStyle(
        fontWeight: FontWeight.normal,
        strokeWidth: 3.0,
        size: size,
        offset: offset,
        backgroundColor: Colors.transparent,
        borderColor: Colors.blueAccent,
        textColor: Colors.white);
  }

  factory CalendarCellStyle.selectedtoday(Size size, Offset offset) {
    return CalendarCellStyle(
        fontWeight: FontWeight.bold,
        size: size,
        strokeWidth: 3.0,
        offset: offset,
        borderColor: Colors.blueAccent,
        backgroundColor: Colors.blue.withOpacity(0.5),
        textColor: Colors.white);
  }

  factory CalendarCellStyle.hover(Size size, Offset offset) {
    return CalendarCellStyle(
        fontWeight: FontWeight.bold,
        size: size,
        strokeWidth: 2.0,
        offset: offset,
        borderColor: Colors.redAccent,
        backgroundColor: Colors.redAccent.withOpacity(0.5),
        textColor: Colors.white);
  }

  factory CalendarCellStyle.today(Size size, Offset offset) {
    return CalendarCellStyle(
        fontWeight: FontWeight.bold,
        size: size,
        strokeWidth: 2.0,
        offset: offset,
        borderColor: Colors.white,
        backgroundColor: Colors.blue.withOpacity(0.5),
        textColor: Colors.white);
  }

  factory CalendarCellStyle.title(Size size, Offset offset) {
    return CalendarCellStyle(
        fontWeight: FontWeight.bold,
        size: size,
        strokeWidth: 0.0,
        offset: offset,
        backgroundColor: Colors.transparent,
        borderColor: Colors.transparent,
        textColor: Colors.white);
  }
}

class CalendarCellText {
  String text;
  ECalendarCellType type;

  CalendarCellText({this.text, this.type});
}

class CellEvent {
  String text;
  Color textColor;
  double textSize;
  Color background;

  CellEvent({this.text, this.textColor, this.background, this.textSize});
}

class CalendarCellEvent extends CalendarCellText {
  List<CellEvent> events;
  DateTime datetime;

  CalendarCellEvent(
      {this.datetime, this.events, String text, ECalendarCellType type})
      : super(text: text, type: type);
}

class CalendarBase {
  ECalendarCellType type;

  CalendarBase({this.type});
}

class CalendarCellTitle extends CalendarBase {
  String text;

  CalendarCellTitle({this.text}) : super(type: ECalendarCellType.Title);
}

class CalendarEvent extends CalendarBase {
  DateTime date;
  List<Event> events;

  CalendarEvent({this.events, this.date, ECalendarCellType type})
      : super(type: type);

  factory CalendarEvent.Disable(DateTime date, List<Event> events) {
    return CalendarEvent(
        date: date, events: events, type: ECalendarCellType.Disable);
  }

  factory CalendarEvent.Enable(DateTime date, List<Event> events) {
    return CalendarEvent(
        date: date, events: events, type: ECalendarCellType.Enable);
  }

  factory CalendarEvent.Today(DateTime date, List<Event> events) {
    return CalendarEvent(
        date: date, events: events, type: ECalendarCellType.Today);
  }

  factory CalendarEvent.Selection(DateTime date, List<Event> events) {
    return CalendarEvent(
        date: date, events: events, type: ECalendarCellType.Selection);
  }

  factory CalendarEvent.SelectedToday(DateTime date, List<Event> events) {
    return CalendarEvent(
        date: date, events: events, type: ECalendarCellType.SelectedToday);
  }
}

class Event {
  String text;
  EEvent type;

  Event({this.text, this.type});
}
