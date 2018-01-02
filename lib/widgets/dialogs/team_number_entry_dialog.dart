import 'package:scouting_app/main.dart';
import 'package:flutter/material.dart';

// TODO move upwards on the screen (potentially respond to keyboard)
class TeamNumberEntryDialog extends StatelessWidget {
  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: new Text("Enter team number"),
      children: <Widget>[
        new Container(
          padding: new EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 4.0),
          child: new TextField(
            controller: _controller,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.number,
            onSubmitted: Navigator.of(context).pop,
          ),
        )
      ]
    );
  }
}