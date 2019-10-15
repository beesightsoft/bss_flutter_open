import 'package:bss_flutter_open/front_back_card/front_back_card_view.dart';
import 'package:flutter/material.dart';

class FrontBackCardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FrontBackCardPageState();
}

class _FrontBackCardPageState extends State<FrontBackCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: FrontBackCardView(),
      ),
    );
  }
}
