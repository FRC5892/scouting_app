import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

class WorkingDialog extends StatelessWidget {
  final Future work;
  final String text;
  WorkingDialog(this.work, this.text);

  @override
  Widget build(BuildContext context) {
    work.then((_) => Navigator.pop(context, true)).catchError((_) => Navigator.pop(context, false));
    return new SimpleDialog(
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Container(
              padding: new EdgeInsets.all(20.0), // see commit 714db1329b283578a7a3d03b2a1159bf7ae3b4e1 for previous settings
              child: new CircularProgressIndicator(), // to be replaced... eventually
            ),
            new Container(
              padding: new EdgeInsets.symmetric(horizontal: 5.0),
              child: new Text(text),
            ),
          ],
        )
      ],
    );
  }
}

class FirebasePushDialog extends WorkingDialog {
  FirebasePushDialog() : super(FirebaseManager.instance.pushForms(), "Pushing form entries...");
}

class FirebasePullDialog extends WorkingDialog {
  FirebasePullDialog() : super(FirebaseManager.instance.getData(), "Getting form data...");
}