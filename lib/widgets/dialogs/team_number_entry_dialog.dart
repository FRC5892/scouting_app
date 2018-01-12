import 'package:flutter/material.dart';

// TODO move upwards on the screen (potentially respond to keyboard)
class TeamNumberEntryDialog extends StatelessWidget {
  final TextEditingController _controller = new TextEditingController();

  int intParseOrNull(String input) {
    try {
      return int.parse(input);
    } on Object {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: const Text("Enter team number"),
      children: <Widget>[
        new Container(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 4.0),
          child: new TextField(
            controller: _controller,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.number,
            autofocus: true,
            onSubmitted: (input) => Navigator.of(context).pop(intParseOrNull(input)),
          ),
        )
      ]
    );
  }
}