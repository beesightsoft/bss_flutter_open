import 'package:bss_flutter_open/quick_switch/quick_switch_model.dart';
import 'package:bss_flutter_open/quick_switch/quick_switch_view.dart';
import 'package:flutter/material.dart';

class QuickSwitchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QuickSwitchPageState();
  }
}

class _QuickSwitchPageState extends State<QuickSwitchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: QuickSwitchView(
          primary: QuickSwitchModel("Home", _buildHome()),
          secondary: QuickSwitchModel("List", _buildList()),
        ),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.redAccent, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
      ),
    );
  }

  Widget _buildList() {
    return Center(child: ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 12,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 8.0)
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '#Item $index',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  height: 1.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.blueGrey, Colors.transparent])),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0, top: 8.0),
                  child: Text(
                    'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source.',
                    style:
                    TextStyle(color: Colors.black87, fontSize: 11.0),
                    maxLines: 3,
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),);
  }

  Widget _buildHome() {
    return Center(child: Icon(Icons.home,size: 120.0, color: Theme.of(context).primaryColor,),);
  }
}
