
import 'package:bss_flutter_open/flip_animation/flip_animation_view.dart';
import 'package:flutter/material.dart';

class FlipAnimationPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _FlipAnimationPageState();
  }
}

class _FlipAnimationPageState extends State<FlipAnimationPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: FlipAnimationView());
  }

}