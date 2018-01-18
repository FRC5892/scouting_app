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
    "matchHang": "Hang on Scale",
    "matchPenalties": "Penalties",
  };

  Future<Map<int, Map<String, dynamic>>> reportsFuture = StorageManager.getTrackedTeams().then((teamNumbers) async {
    Map<int, Map<String, dynamic>> ret = {};
    await Future.wait(teamNumbers.map((n) async => ret[n] = await StorageManager.getReportsForTeam(n)));
    return ret;
  });
  FilterCriteria criteria;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("Search Reports"),
      ),
      body: new Column(
        children: <Widget>[
          new Container(

          ),
          new FutureBuilder<Map<int, Map<String, dynamic>>>(
            future: reportsFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (criteria == null) return new Container();
            },
          ),
        ],
      ),
    );
  }
}

class FilterCriteria {
  final String testKey;
  final num threshold;
  final bool lessThan;
  final bool equalTo;
  final bool greaterThan;
  const FilterCriteria(this.testKey, this.threshold, {this.lessThan = false, this.equalTo = false, this.greaterThan = false});

  bool match(num input) {
    if (lessThan && input < threshold) return true;
    if (equalTo && input == threshold) return true;
    if (greaterThan && input > threshold) return true;
    return false;
  }
}