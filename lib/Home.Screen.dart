import 'package:flutter_open/CustomCalendar.dart';
import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/*class InputDropdown extends StatelessWidget {
  const InputDropdown(
      {Key key,
        this.child,
        this.labelText,
        this.valueText,
        this.valueStyle,
        this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration:
        new InputDecoration(labelText: labelText, border: InputBorder.none),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
            new Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}

class DatePickerWithDuration extends StatelessWidget {
  const DatePickerWithDuration({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectDate,
    this.remove,
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;
  final remove;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(2015, 8),
        lastDate: new DateTime(2101));
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.subhead;
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Expanded(
          flex: 3,
          child: new InputDropdown(
            labelText: labelText,
            valueText: new DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
        new Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('AM'),
                Checkbox(
                  value: true,
                  onChanged: null,
                ),
                Text('PM'),
                Checkbox(
                  value: true,
                  onChanged: null,
                ),
                IconButton(icon: Icon(Icons.remove_circle_outline), onPressed: remove),
              ],
            ),
          ),
        ),
      ],
    );
  }
}*/

class PersonalDialog extends StatefulWidget {
  PersonalDialog();

  @override
  PersonalDialogState createState() => new PersonalDialogState();
}

class PersonalDialogState extends State<PersonalDialog> {
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
