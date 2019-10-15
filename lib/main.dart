import 'package:bss_flutter_open/calendar_demo/calendar_demo_page.dart';
import 'package:bss_flutter_open/calendar_demo/calendar/custom_calendar_screen.dart';
import 'package:bss_flutter_open/calendar_demo/gantt_chart/gantt_chart_screen.dart';
import 'package:bss_flutter_open/flip_animation/flip_animation_page.dart';
import 'package:bss_flutter_open/four_seasons/four_seasons_page.dart';
import 'package:bss_flutter_open/front_back_card/front_back_card_page.dart';
import 'package:bss_flutter_open/list_animation/list_animation_page.dart';
import 'package:bss_flutter_open/quick_switch/quick_switch_page.dart';
import 'package:bss_flutter_open/seat_map/seat_map_page.dart';
import 'package:bss_flutter_open/slider_selector/slider_selector_page.dart';
import 'package:bss_flutter_open/store_card/store_card_page.dart';
import 'package:bss_flutter_open/tabbar_exploration/tabbar_exploration_page.dart';
import 'package:bss_flutter_open/toss_card/toss_card_page.dart';
import 'package:bss_flutter_open/turn_page/turn_page_page.dart';
import 'package:bss_flutter_open/using_card/using_card_page.dart';
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
      home: UsingCardPage(),
    );
  }
}
