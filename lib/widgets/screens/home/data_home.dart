import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

enum _AppBarPopupOption {MANAGE, CLEAR}

class DataHome extends StatefulWidget implements HomeView {
  @override
  List<Widget> actions(BuildContext context) {
    return <Widget> [
      new Builder(builder: (BuildContext context) =>
        new IconButton(icon: new Icon(Icons.cloud_download), onPressed: () => pullAndCrunchNumbers(context))
      ),
      new IconButton(icon: new Icon(Icons.search), onPressed: null),
      new PopupMenuButton<_AppBarPopupOption>(
        onSelected: (selected) => handleAppBarMenu(context, selected),
        itemBuilder: (BuildContext context) => const <PopupMenuItem<_AppBarPopupOption>> [
          const PopupMenuItem<_AppBarPopupOption>(
            value: _AppBarPopupOption.MANAGE,
            child: const Text("Manage tracked teams"),
          ),
          const PopupMenuItem<_AppBarPopupOption>(
            value: _AppBarPopupOption.CLEAR,
            child: const Text("Clear all data"),
          ),
        ]
      ),
    ];
  }

  static Future<Null> handleAppBarMenu(BuildContext context, _AppBarPopupOption selected) async {
    switch (selected) {
      case _AppBarPopupOption.MANAGE:
        bool pullNow = await Navigator.pushNamed(context, "/data/manageTeams");
        if (pullNow == null) break; // exited with back button
        if (pullNow) {
          await StorageManager.setLastPullTimestamp(new DateTime.fromMillisecondsSinceEpoch(0));
          showDialog(context: context, barrierDismissible: false, child: new FirebasePullDialog());
        } else {
          StorageManager.setLastPullTimestamp(new DateTime.now());
        }
        break;
      case _AppBarPopupOption.CLEAR:
        StorageManager.deleteAllData();
    }
  }

  static Future<Null> pullAndCrunchNumbers(BuildContext context) async {
    await showDialog(context: context, barrierDismissible: false, child: new FirebasePullDialog()); // TODO handle errors
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("Pull successful. Generating reports..."),
    ));
    StorageManager.setCrunchingNumbers(true);
    Map<int, List<FormWithMetadata>> data = new Map();
    await Future.wait((await StorageManager.getTrackedTeams()).map((teamNumber) async =>
      data[teamNumber] = await StorageManager.getDataForTeam(teamNumber).toList()));
    ReceivePort reports = spawnNumberCrunchingIsolate(data);
    reports.listen((report) {
      if (report == DONE_MESSAGE) {
        StorageManager.setCrunchingNumbers(false);
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("Reports generated!"),
          backgroundColor: new Color(0xFF006432),
        ));
      }
      else if (report is NumberCrunchTeamReport) {
        StorageManager.addData(report.report, report.teamNumber, GENERATED_REPORT);
      }
    });
  }

  @override
  Widget body(BuildContext context) => this;

  @override
  _DataHomeState createState() => new _DataHomeState();
}

class _DataHomeState extends State<DataHome> {
  List<int> teamNumbers;
  StreamSubscription<Null> _dataChangeSubscription;

  @override
  void initState() {
    super.initState();
    _dataChangeSubscription = StorageManager.dataChangeNotifier.listen(
      (_) => StorageManager.getTrackedTeams().then((nums) => setState(() => teamNumbers = nums))
    );
  }

  @override
  Widget build(BuildContext context) {
    if (teamNumbers == null) StorageManager.getTrackedTeams().then((nums) => setState(() => teamNumbers = nums));
    return new ListView.builder(
      itemCount: teamNumbers?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          title: new Text(teamNumbers[index].toString()),
        );
      },
    );
  }

  @override
  void dispose() {
    _dataChangeSubscription.cancel();
    super.dispose();
  }
}