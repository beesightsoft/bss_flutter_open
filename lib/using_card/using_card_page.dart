import 'package:bss_flutter_open/front_back_card/front_back_card_view.dart';
import 'package:bss_flutter_open/using_card/using_card_view.dart';
import 'package:flutter/material.dart';

class UsingCardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UsingCardPageState();
  }
}

class _UsingCardPageState extends State<UsingCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UsingCardView(
        card: ConstrainedBox(
          constraints: BoxConstraints.expand(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5),
          child: FrontBackCardView(),
        ),
        view: Center(
          child: ListView.builder(
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
          ),
        ),
      ),
    );
  }
}
