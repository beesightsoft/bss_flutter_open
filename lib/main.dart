import 'package:bss_flutter_open/calendar_demo/calendar/custom_calendar_screen.dart';
import 'package:bss_flutter_open/calendar_demo/calendar_demo.dart';
import 'package:bss_flutter_open/calendar_demo/gantt_chart/gantt_chart_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalendarDemo(),
    );
  }
}
