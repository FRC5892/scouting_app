import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

class ReportFilterScreen extends StatefulWidget {
  @override
  _ReportFilterScreenState createState() => new _ReportFilterScreenState();
}

class _ReportFilterScreenState extends State<ReportFilterScreen> {
  static const Map<String, String> fieldNames = const {
    "matchAutoMobility": "Auto Line",
    "matchAutoCubes": "Power Cubes in Auto",
    "matchCubesSw1tch": "TeleOp Cubes to Sw1tch",
    "matchCubesScale": "TeleOp Cubes to Scale",
    "matchCubesSw2tch": "TeleOp Cubes to Sw2tch",
    "matchCubesExchange": "TeleOp Cubes to Exchange",
    "matchClimb": "Climb Alone",
    "matchClimbAssist": "Climb Assist",
    "matchPenalties": "Penalties",
  };

  static final List<DropdownMenuItem<String>> fieldDropdownItems = fieldNames.keys.map((key) => new DropdownMenuItem(
    value: key,
    child: new Text(fieldNames[key]),
  )).toList();
  static const List<DropdownMenuItem<FilterCriteria>> criteriaDropdownItems = const [
    const DropdownMenuItem(child: const Text("less than"), value: const FilterCriteria(lessThan: true)),
    const DropdownMenuItem(child: const Text("less than or equal to"), value: const FilterCriteria(lessThan: true, equalTo: true)),
    const DropdownMenuItem(child: const Text("equal to"), value: const FilterCriteria(equalTo: true)),
    const DropdownMenuItem(child: const Text("greater than or equal to"), value: const FilterCriteria(greaterThan: true, equalTo: true)),
    const DropdownMenuItem(child: const Text("greater than"), value: const FilterCriteria(greaterThan: true)),
  ];

  Future<Map<int, Map<String, dynamic>>> reportsFuture = StorageManager.getTrackedTeams().then((teamNumbers) async {
    Map<int, Map<String, dynamic>> ret = {};
    await Future.wait(teamNumbers.map((n) async => ret[n] = await StorageManager.getReportsForTeam(n)));
    return ret;
  });
  FilterCriteria criteria;
  String testKey;
  num threshold;

  final TextEditingController _controller = new TextEditingController();

  static const double _SIDE_PADDING = 15.0;
  Widget sidePadding(Widget input) => new Container(
    padding: const EdgeInsets.symmetric(horizontal: _SIDE_PADDING),
    child: input,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("Search Reports"),
      ),
      body: new Column(
        children: <Widget>[
          new Container(
            child: new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    sidePadding(const Text("Filter where")),
                    sidePadding(new DropdownButton<String>(
                      value: testKey,
                      items: fieldDropdownItems,
                      onChanged: (val) => setState(() => testKey = val),
                    )),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    sidePadding(const Text("is")),
                    sidePadding(new DropdownButton<FilterCriteria>(
                      value: criteria,
                      items: criteriaDropdownItems,
                      onChanged: (val) => setState(() => criteria = val),
                    )),
                    new Container(
                      constraints: const BoxConstraints(maxWidth: 75.0),
                      padding: const EdgeInsets.symmetric(horizontal: _SIDE_PADDING),
                      child: new TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.end,
                        onChanged: (val) => setState(() => threshold = num.parse(val)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          new Divider(),
          new FutureBuilder<Map<int, Map<String, dynamic>>>(
            future: reportsFuture,
            builder: (BuildContext context, AsyncSnapshot<Map<int, Map<String, dynamic>>> snapshot) {
              if (criteria == null || threshold == null || testKey == null || snapshot.connectionState != ConnectionState.done) return new Container();
              if (snapshot.hasError) return new Text(snapshot.error);
              return new ListView(
                shrinkWrap: true,
                children: snapshot.data.keys.where((v) => criteria.matchStr(snapshot.data[v][testKey], threshold))
                  .map((teamNumber) => new ListTile(
                    title: new Text(teamNumber.toString()),
                    onTap: () => Navigator.push(context, new MaterialPageRoute(builder: (_) => new TeamDataViewScreen(teamNumber))),
                )).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class FilterCriteria {
  final bool lessThan;
  final bool equalTo;
  final bool greaterThan;
  const FilterCriteria({this.lessThan = false, this.equalTo = false, this.greaterThan = false});

  bool matchStr(String input, num threshold) {
    int lastChar = input.length - 1;
    if (input[lastChar] == '%') return match(num.parse(input.substring(0, lastChar)), threshold);
    return match(num.parse(input), threshold);
  }

  bool match(num input, num threshold) {
    if (lessThan && input < threshold) return true;
    if (equalTo && input == threshold) return true;
    if (greaterThan && input > threshold) return true;
    return false;
  }
}