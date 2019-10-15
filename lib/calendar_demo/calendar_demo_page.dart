import 'package:flutter/material.dart';

import 'gantt_chart/gantt_chart_screen.dart';
import 'interactive_calendar/calendar_screen.dart';

class CalendarDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(height: 40.0),
            ListTile(
                title: Text('Statistic'),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GranttChartScreen()))),
            ListTile(
                title: Text('Interactive Calendar'),
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CalendarScreen())))
          ],
        ),
      ),
      body: Center(
        child: Text('Tap Menu to continue'),
      ),
    );
  }
}
