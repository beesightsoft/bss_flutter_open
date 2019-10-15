
import 'package:bss_flutter_open/toss_card/toss_card_view.dart';
import 'package:flutter/material.dart';

class TossCardPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _TossCardPageState();
  }
}

class _TossCardPageState extends State<TossCardPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: TossCardView(),);
  }
}