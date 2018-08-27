import 'package:flutter_open/Calendar/Home.Screen.dart';
import 'package:flutter_open/GanttChart/Home.Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open/InteractiveCalendar/CalendarScreen.dart';
import 'package:flutter_open/InteractiveCalendar/CalendarWidget.dart';

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
        home: Builder(builder: (context){
          return Scaffold(
            appBar: AppBar(),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  SizedBox(height: 40.0),
                  ListTile(
                      title: Text('Statistic'),
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Statistic2()))),
                  ListTile(
                      title: Text('Interactive Calendar'),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CalendarScreen())))
                ],
              ),
            ),
            body: Center(
              child: Text('Tap Menu to continue'),
            ),
          );
        }));
  }
}
