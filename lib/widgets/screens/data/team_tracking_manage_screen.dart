import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

class TeamTrackingManagementScreen extends StatefulWidget {
  @override
  _TTMScreenState createState() => new _TTMScreenState();
}

class _TTMScreenState extends State<TeamTrackingManagementScreen> {
  List<int> tracking;

  @override
  void initState() {
    super.initState();
    StorageManager.getTrackedTeams().then(stateUpdate);
  }

  void stateUpdate(List<int> newList) => setState(() {
    newList.sort();
    tracking = newList;
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("Tracked Teams"),
        actions: <Widget> [
          new IconButton(icon: new Icon(Icons.add), onPressed: null),
          new IconButton(icon: new Icon(Icons.more_vert), onPressed: null),
        ],
      ),
      body: new ListView.builder(
        itemCount: tracking?.length ?? 0,
        itemBuilder: (BuildContext context, int index) => new ListTile(

        ),
      ),
    );
  }
}