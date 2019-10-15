import 'package:bss_flutter_open/front_back_card/front_back_card_view.dart';
import 'package:bss_flutter_open/turn_page/turn_page_view.dart';
import 'package:flutter/material.dart';

class TurnPagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TurnPagePageState();
}

class _TurnPagePageState extends State<TurnPagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: TurnPageView(),
      ),
    );
  }
}
