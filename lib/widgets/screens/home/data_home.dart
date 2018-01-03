import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

enum _AppBarPopupOption {MANAGE, CLEAR}

class DataHome extends StatefulWidget implements HomeView {
  @override
  List<Widget> actions(BuildContext context) {
    return <Widget> [
      new IconButton(icon: new Icon(Icons.cloud_download), onPressed: () =>
        showDialog(context: context, barrierDismissible: false, child: new FirebasePullDialog()) // TODO handle errors
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

  Future<Null> handleAppBarMenu(BuildContext context, _AppBarPopupOption selected) async {
    switch (selected) {
      case _AppBarPopupOption.MANAGE:
        bool pullNow = await Navigator.pushNamed(context, "/data/manageTeams");
        if (pullNow == null) break; // exited with back button
        else if (pullNow) {
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