import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

class FirebasePushDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseManager.instance.pushForms()
      .then(Navigator.of(context).pop)
      .catchError(Navigator.of(context).pop);
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
              child: new Text("Pushing to Firebase..."),
            ),
          ],
        )
      ],
    );
  }
}