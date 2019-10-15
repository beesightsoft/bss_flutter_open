import 'dart:math';

import 'package:flutter/material.dart';

import 'calendar_model.dart';
import 'calendar_widget.dart';

class CalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CalendarScreenState();
  }
}

class CalendarScreenState extends State<CalendarScreen> {
  List<List<Event>> events = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i = 0 ; i < 42 ; i ++)
      events.add(randomEvent());
  }

  List<Event> randomEvent() {
    List<Event> _arr = [
      Event(text: 'Event gì đó', type: EEvent.Event),
      Event(text: 'Birthday ai đó', type: EEvent.Birthday),
      Event(
          text: 'Đăng ký nghri phép ....', type: EEvent.Leave),
      Event(text: 'Đăng ký nghri phép ....', type: EEvent.Leave)
    ];
    List<Event> _list = [];
    int length = Random().nextInt(1000) % 5;
    for (int i = 0; i < length; i++)
      _list.add(_arr[Random().nextInt(1000) % _arr.length]);
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Calendar'), backgroundColor: Theme.of(context).primaryColor),
      body: buildContent(),
    );
  }

  Widget buildContent() {
    return InteractiveCalendar(fakeEvents: events);
  }
}
