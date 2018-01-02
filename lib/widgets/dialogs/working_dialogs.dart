import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

typedef Future ReturnsFuture(); // why does everything need a goddamn typedef.

class WorkingDialog extends StatelessWidget {
  final ReturnsFuture work;
  final String text;
  WorkingDialog(this.work, this.text);

  @override
  Widget build(BuildContext context) {
    work().then(Navigator.of(context).pop).catchError(Navigator.of(context).pop);
    return new SimpleDialog(
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Container(
              padding: new EdgeInsets.symmetric(horizontal: 10.0),
              child: new Placeholder(fallbackHeight: 96.2, fallbackWidth: 78.3),
            ),
            new Container(
              padding: new EdgeInsets.symmetric(horizontal: 20.0),
              child: new Text(text),
            ),
          ],
        )
      ],
    );
  }
}

class FirebasePushDialog extends WorkingDialog {
  FirebasePushDialog() : super(FirebaseManager.instance.pushForms, "Pushing form entries...");
}

class FirebasePullDialog extends WorkingDialog {
  FirebasePullDialog() : super(FirebaseManager.instance.getData, "Getting form data...");
}