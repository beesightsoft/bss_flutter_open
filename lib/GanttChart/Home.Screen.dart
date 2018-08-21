import 'package:flutter/material.dart';
import 'package:date_utils/date_utils.dart';
import 'dart:math';

import 'package:flutter_open/GanttChart/models.dart';

class Statistic2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new Statistic2State();
  }
}

class Statistic2State extends State<Statistic2> with TickerProviderStateMixin {
  AnimationController animationController;

  DateTime fromDate = DateTime(2018, 1, 1);
  DateTime toDate = DateTime(2019, 1, 1);

  List<User> usersInChart;
  List<Project> projectsInChart;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        duration: Duration(microseconds: 2000), vsync: this);
    animationController.forward();

    projectsInChart = projects;
    usersInChart = users;
  }

  Widget buildAppBar() {
    return AppBar(
      title: Text('GANTT CHART'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: GanttChart(
                animationController: animationController,
                fromDate: fromDate,
                toDate: toDate,
                data: projectsInChart,
                usersInChart: usersInChart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GanttChart extends StatelessWidget {
  final AnimationController animationController;
  final DateTime fromDate;
  final DateTime toDate;
  final List<Project> data;
  final List<User> usersInChart;

  int viewRange;
  int viewRangeToFitScreen = 6;
  Animation<double> width;

  GanttChart({
    this.animationController,
    this.fromDate,
    this.toDate,
    this.data,
    this.usersInChart,
  }) {
    viewRange = calculateNumberOfMonthsBetween(fromDate, toDate);
  }

  Color randomColorGenerator() {
    var r = new Random();
    return Color.fromRGBO(r.nextInt(256), r.nextInt(256), r.nextInt(256), 0.75);
  }

  int calculateNumberOfMonthsBetween(DateTime from, DateTime to) {
    return to.month - from.month + 12 * (to.year - from.year) + 1;
  }

  int calculateDistanceToLeftBorder(DateTime projectStartedAt) {
    if (projectStartedAt.compareTo(fromDate) <= 0) {
      return 0;
    } else
      return calculateNumberOfMonthsBetween(fromDate, projectStartedAt) - 1;
  }

  int calculateRemainingWidth(
      DateTime projectStartedAt, DateTime projectEndedAt) {
    int projectLength =
    calculateNumberOfMonthsBetween(projectStartedAt, projectEndedAt);
    if (projectStartedAt.compareTo(fromDate) >= 0 &&
        projectStartedAt.compareTo(toDate) <= 0) {
      if (projectLength <= viewRange)
        return projectLength;
      else
        return viewRange -
            calculateNumberOfMonthsBetween(fromDate, projectStartedAt);
    } else if (projectStartedAt.isBefore(fromDate) &&
        projectEndedAt.isBefore(fromDate)) {
      return 0;
    } else if (projectStartedAt.isBefore(fromDate) &&
        projectEndedAt.isBefore(toDate)) {
      return projectLength -
          calculateNumberOfMonthsBetween(projectStartedAt, fromDate);
    } else if (projectStartedAt.isBefore(fromDate) &&
        projectEndedAt.isAfter(toDate)) {
      return viewRange;
    }
    return 0;
  }

  List<Widget> buildChartBars(
      List<Project> data, double chartViewWidth, Color color) {
    List<Widget> chartBars = new List();

    for(int i = 0; i < data.length; i++) {
      var remainingWidth =
      calculateRemainingWidth(data[i].startTime, data[i].endTime);
      if (remainingWidth > 0) {
        chartBars.add(Container(
          decoration: BoxDecoration(
              color: color.withAlpha(100),
              borderRadius: BorderRadius.circular(10.0)),
          height: 25.0,
          width: remainingWidth * chartViewWidth / viewRangeToFitScreen,
          margin: EdgeInsets.only(
              left: calculateDistanceToLeftBorder(data[i].startTime) *
                  chartViewWidth /
                  viewRangeToFitScreen,
              top: i == 0 ? 4.0 : 2.0,
              bottom: i == data.length - 1 ? 4.0 : 2.0
          ),
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              data[i].name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 10.0),
            ),
          ),
        ));
      }
    }

    return chartBars;
  }

  Widget buildHeader(double chartViewWidth, Color color) {
    List<Widget> headerItems = new List();

    DateTime tempDate = fromDate;

    headerItems.add(Container(
      width: chartViewWidth / viewRangeToFitScreen,
      child: new Text(
        'NAME',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10.0,
        ),
      ),
    ));

    for (int i = 0; i < viewRange; i++) {
      headerItems.add(Container(
        width: chartViewWidth / viewRangeToFitScreen,
        child: new Text(
          tempDate.month.toString() + '/' + tempDate.year.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10.0,
          ),
        ),
      ));
      tempDate = Utils.nextMonth(tempDate);
    }

    return Container(
      height: 25.0,
      color: color.withAlpha(100),
      child: Row(
        children: headerItems,
      ),
    );
  }

  Widget buildGrid(double chartViewWidth) {
    List<Widget> gridColumns = new List();

    for (int i = 0; i <= viewRange; i++) {
      gridColumns.add(Container(
        decoration: BoxDecoration(
            border: Border(
                right:
                BorderSide(color: Colors.grey.withAlpha(100), width: 1.0))),
        width: chartViewWidth / viewRangeToFitScreen,
        //height: 300.0,
      ));
    }

    return Row(
      children: gridColumns,
    );
  }

  Widget buildChartForEachUser(
      List<Project> userData, double chartViewWidth, User user) {
    Color color = randomColorGenerator();
    var chartBars = buildChartBars(userData, chartViewWidth, color);
    return Container(
      height: chartBars.length * 29.0 + 25.0 + 4.0,
      child: ListView(
        physics: new ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Stack(fit: StackFit.loose, children: <Widget>[
            buildGrid(chartViewWidth),
            buildHeader(chartViewWidth, color),
            Container(
                margin: EdgeInsets.only(top: 25.0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                                width: chartViewWidth / viewRangeToFitScreen,
                                height: chartBars.length * 29.0 + 4.0,
                                color: color.withAlpha(100),
                                child: Center(
                                  child: new RotatedBox(
                                    quarterTurns: chartBars.length * 29.0 + 4.0 > 50 ? 0 : 0,
                                    child: new Text(
                                      user.name,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: chartBars,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ]),
        ],
      ),
    );
  }

  List<Widget> buildChartContent(double chartViewWidth) {
    List<Widget> chartContent = new List();

    usersInChart.forEach((user) {

      List<Project> projectsOfUser = new List();

      projectsOfUser = projects.where((project) => project.participants.indexOf(user.id) != -1).toList();

      if (projectsOfUser.length > 0) {
        chartContent.add(buildChartForEachUser(projectsOfUser, chartViewWidth, user));
      }
    });

    return chartContent;
  }

  @override
  Widget build(BuildContext context) {
    var chartViewWidth = MediaQuery.of(context).size.width;
    var screenOrientation = MediaQuery.of(context).orientation;

    screenOrientation == Orientation.landscape
        ? viewRangeToFitScreen = 12
        : viewRangeToFitScreen = 6;

    return Container(
      child: MediaQuery.removePadding(child: ListView(children: buildChartContent(chartViewWidth)), removeTop: true, context: context,),
    );
  }
}

var users = [
  User(id: 1, name: 'Steve'),
  User(id: 2, name: 'Leila'),
  User(id: 3, name: 'Alex'),
  User(id: 4, name: 'Ryan'),
];

var projects = [
  Project(id: 1, name: 'Basetax', startTime: DateTime(2017, 3, 1), endTime: DateTime(2018, 6, 1),
      participants: [1, 2, 3]
  ),
  Project(id: 2, name: 'CENTTO', startTime: DateTime(2018, 4, 1), endTime: DateTime(2018, 6, 1),
      participants: [2, 3]
  ),
  Project(id: 3, name: 'Uber', startTime: DateTime(2017, 5, 1), endTime: DateTime(2018, 9, 1),
      participants: [1, 2, 4]
  ),
  Project(id: 4, name: 'Grab', startTime: DateTime(2018, 6, 1), endTime: DateTime(2018, 10, 1),
      participants: [1, 4, 3]
  ),
  Project(id: 5, name: 'GO-JEK', startTime: DateTime(2017, 3, 1), endTime: DateTime(2018, 11, 1),
      participants: [4, 2, 3]
  ),
  Project(id: 6, name: 'Lyft', startTime: DateTime(2018, 4, 1), endTime: DateTime(2018, 7, 1),
      participants: [4, 2, 3]
  ),
  Project(id: 7, name: 'San Jose', startTime: DateTime(2018, 5, 1), endTime: DateTime(2018, 12, 1),
      participants: [1, 2, 4]
  ),
];
