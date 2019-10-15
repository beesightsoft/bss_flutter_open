import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'custom_calendar.dart';

class CustomCalendarScreen extends StatefulWidget {
  CustomCalendarScreen();

  @override
  CustomCalendarScreenState createState() => new CustomCalendarScreenState();
}

class CustomCalendarScreenState extends State<CustomCalendarScreen> {
  DateTime _date = new DateTime.now();
  String _note = '';
  var selectedPositions = new List<Offset>();

  final noteTextFieldController = TextEditingController();
  final dateTimeFormatter = new DateFormat('dd-MM-yyyy h:mm a');
  final timeFormatter = new DateFormat('h:mm a');

  var selectedDatesInfo = new List<SelectedDateInfo>();


  Widget contentDetail(String text, int index) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('placeholder'),
        IconButton(icon: Icon(Icons.remove_circle_outline), onPressed: null)
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    noteTextFieldController.dispose();
    super.dispose();
  }

  Widget _buildAppBar() {
    return new AppBar(
      title: Text('Calendar Demo'),
      actions: [
        new IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            splashColor: Theme.of(context).primaryColor,
            onPressed: () {}
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Scaffold(
          appBar: _buildAppBar(),
          body: new DropdownButtonHideUnderline(
            child: new SafeArea(
              top: false,
              bottom: false,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: new ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: <Widget>[
                    /*Calendar(
                  isExpandable: true,
                ),*/
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                      child: new TextField(
                        controller: noteTextFieldController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        onChanged: (text) {
                          _note = text;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Reason',
                          hintText: 'Why?',
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    Container(
                        width: 350.0,
                        height: (4 + 1) * 50.0,
                        child: CustomCalendar(
                            selectedPositions: selectedPositions,
                            onSelectDay: (SelectedDateInfo info) {
                              FocusScope.of(context).requestFocus(new FocusNode());
                              if (info.session != null && info.day != null) {
                                print(info.session.toString() +
                                    ' - ' +
                                    info.day.toString());

                                if (selectedDatesInfo.indexOf(info) == -1) {
                                  selectedDatesInfo.add(info);
                                } else {
                                  selectedDatesInfo.remove(info);
                                }
                                print(selectedDatesInfo.length);
                              }
                            })
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
