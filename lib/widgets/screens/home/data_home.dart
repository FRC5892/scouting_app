import 'package:flutter/material.dart';

import 'package:scouting_app/main.dart';

class DataHome implements HomeView {
  @override
  List<Widget> actions(BuildContext context) {
    return <Widget> [
      new IconButton(icon: new Icon(Icons.cloud_download), onPressed: null),
      new IconButton(icon: new Icon(Icons.search), onPressed: null),
      new IconButton(icon: new Icon(Icons.more_vert), onPressed: StorageManager.deleteEverything),
    ];
  }

  @override
  Widget body(BuildContext context) {
    return null;
  }
}