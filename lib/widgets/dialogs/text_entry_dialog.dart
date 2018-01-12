import 'package:flutter/material.dart';

// TODO move upwards on the screen (potentially respond to keyboard)
class TextEntryDialog extends StatelessWidget {
  final String prompt;
  const TextEntryDialog(this.prompt);

  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
        title: new Text(prompt),
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 4.0),
            child: new TextField(
              autofocus: true,
              onSubmitted: Navigator.of(context).pop,
            ),
          )
        ]
    );
  }
}