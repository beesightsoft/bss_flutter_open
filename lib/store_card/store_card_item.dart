
import 'dart:math';

import 'package:flutter/material.dart';

class StoreCardItem extends StatelessWidget{
 final String text;

  const StoreCardItem({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Row(children: <Widget>[
      Padding(
        padding: EdgeInsets.only(left: 24.0),
        child: Container(
          child: Text(text,style: TextStyle(fontSize: 64.0),),
          height: MediaQuery.of(context).size.height/1.5,
          width:  MediaQuery.of(context).size.width/1.5,
          decoration: BoxDecoration(
              border: Border.all(),
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(24.0))),
        ),
      )
    ],);
  }
}