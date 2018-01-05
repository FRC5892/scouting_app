import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

class TeamTrackingManagementScreen extends StatefulWidget {
  @override
  _TTMScreenState createState() => new _TTMScreenState();
}

class _TTMScreenState extends State<TeamTrackingManagementScreen> {
  Set<int> initial;
  Set<int> tracking;

  @override
  void initState() {
    super.initState();
    StorageManager.getTrackedTeams().then(initialState);
  }

  void initialState(List<int> initList) => setState(() {
    initial = initList.toSet();
    tracking = new Set.from(initial);
  });

  Future<Null> submitExitHandler(BuildContext context) async {
    if (!await showDialog(context: context, child: const YesNoAlertDialog(
      title: "Confirm changes?",
      content: "All data and reports for any removed teams will be deleted from your device.",
      yesOption: "CONFIRM",
      noOption: "CANCEL",
    ))) return;
    Set<int> removedTeams = initial.difference(tracking);
    removedTeams.forEach(StorageManager.deleteDataForTeam);
    StorageManager.setTrackedTeams(tracking.toList());
    Navigator.pop(context, await showDialog(context: context, child: const YesNoAlertDialog(
      title: "Pull existing data?",
      content: "If you choose \"No,\" only data entered after the present moment will be pulled.",
    ))); // TODO allow picking a time
  }

  @override
  Widget build(BuildContext context) {
    List<int> trackList = tracking?.toList(); trackList?.sort();
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("Tracked Teams"),
        actions: <Widget> [
          new IconButton(icon: new Icon(Icons.add), onPressed: () =>
            showDialog(context: context, child: new TeamNumberEntryDialog()).then((input) {
              if (input != null) setState(() => tracking.add(input));
            }),
          ),
          new IconButton(icon: new Icon(Icons.more_vert), onPressed: null),
          new IconButton(icon: new Icon(Icons.check), onPressed: () => submitExitHandler(context)),
        ],
      ),
      body: new ListView.builder(
        itemCount: tracking?.length ?? 0,
        itemBuilder: (BuildContext context, int index) => new ListTile(
          title: new Text(trackList[index].toString()),
          trailing: new IconButton(
            icon: new Icon(Icons.remove),
            onPressed: () => setState(() => tracking.remove(trackList[index])),
          ),
        ),
      ),
    );
  }
}