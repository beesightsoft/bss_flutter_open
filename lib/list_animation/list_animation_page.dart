

import 'package:bss_flutter_open/list_animation/list_animation_view.dart';
import 'package:flutter/material.dart';

class ListAnimationPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ListAnimationPageState();
  }
}

class _ListAnimationPageState extends State<ListAnimationPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: ListAnimationView(),
    );
  }
}