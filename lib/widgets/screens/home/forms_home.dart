import 'package:flutter/material.dart';

import 'package:scouting_app/main.dart';

class FormsHome implements HomeView {
  @override
  List<Widget> actions(BuildContext context) {
    return <Widget> [
      new IconButton(icon: new Icon(Icons.cloud_upload), onPressed: null),
      new IconButton(icon: new Icon(Icons.add), onPressed: () {
        Navigator.push(context, new MaterialPageRoute(builder: (_) => new TestForm()));
      }),
      new IconButton(icon: new Icon(Icons.more_vert), onPressed: null),
    ];
  }

  @override
  Widget body(BuildContext context) {
    return null;
  }
}