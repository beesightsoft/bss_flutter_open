import 'package:bss_flutter_open/four_seasons/four_seasons_view.dart';
import 'package:flutter/material.dart';

class FourSeasonsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FourSeasonsPageState();
}

class _FourSeasonsPageState extends State<FourSeasonsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: FourSeasonsView(),
      ),
    );
  }
}
