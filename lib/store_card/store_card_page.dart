import 'package:bss_flutter_open/store_card/store_card_list.dart';
import 'package:flutter/material.dart';

class StoreCardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StoreCardPageState();
  }
}

class _StoreCardPageState extends State<StoreCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.green, Colors.lightGreen])),
        alignment: Alignment.center,
        child: StoreCardList(),
      ),
    );
  }
}
