
import 'package:bss_flutter_open/slider_selector/slider_selector_view.dart';
import 'package:flutter/material.dart';

class SliderSelectorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SliderSelectorPageState();
}

class _SliderSelectorPageState extends  State<SliderSelectorPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: SliderSelectorView(),),);
  }
}