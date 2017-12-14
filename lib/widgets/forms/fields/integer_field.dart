import 'package:flutter/material.dart';

import '../forms.dart';

class IntegerField extends StatefulWidget {
  final String jsonKey;
  final String name;
  final FRCFormSaveCallback onSavedCallback;

  IntegerField(this.jsonKey, this.name, this.onSavedCallback);

  @override
  _IntegerFieldState createState() => new _IntegerFieldState();
}

class _IntegerFieldState extends State<IntegerField> {
  final TextEditingController _controller = new TextEditingController(text: "0");

  int cursorPosition;

  static const double buttonFontSize = 18.0;
  static const double buttonWidth = 40.0;

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(widget.name),
      trailing: new FormField<int>(
        initialValue: 0,
        builder: (FormFieldState<int> field) => new Row(
          children: <Widget>[
            new ConstrainedBox(
              constraints: new BoxConstraints(maxWidth: buttonWidth),
              child: new FlatButton(
                child: const Text("-", style: const TextStyle(fontSize: buttonFontSize)),
                onPressed: () {
                  _controller.text = (field.value - 1).toString();
                  field.onChanged(field.value - 1);
                },
              ),
            ),
            new ConstrainedBox(
              constraints: new BoxConstraints(maxWidth: 50.0),
              child: new TextField(
                controller: _controller,
                textAlign: TextAlign.right,
                keyboardType: TextInputType.number,
                onChanged: (String out) => field.onChanged(int.parse(out)),
              ),
            ),
            new ConstrainedBox(
              constraints: new BoxConstraints(maxWidth: buttonWidth),
              child: new FlatButton(
                child: const Text("+", style: const TextStyle(fontSize: buttonFontSize)),
                onPressed: () {
                  _controller.text = (field.value + 1).toString();
                  field.onChanged(field.value + 1);
                },
              ),
            ),
          ],
        ),
        onSaved: (int value) => widget.onSavedCallback(widget.jsonKey, value),
      ),
    );
  }
}