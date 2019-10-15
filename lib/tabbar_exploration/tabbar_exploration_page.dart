import 'package:bss_flutter_open/tabbar_exploration/tabbar_exploration_view.dart';
import 'package:flutter/material.dart';

class TabbarExplorationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TabbarExplorationPageState();
  }
}

class _TabbarExplorationPageState extends State<TabbarExplorationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        child: TabbarExplorationView(),
        alignment: Alignment.bottomCenter,
      ),
    );
  }
}
