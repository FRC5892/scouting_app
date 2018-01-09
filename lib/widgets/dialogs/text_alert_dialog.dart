import 'package:flutter/material.dart';

class TextAlertDialog extends StatelessWidget {
  final String text;
  TextAlertDialog(this.text);

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      content: new Text(text),
      actions: <Widget> [
        new FlatButton(
          onPressed: Navigator.of(context).pop,
          child: new Text("CLOSE"),
        ),
      ],
    );
  }
}