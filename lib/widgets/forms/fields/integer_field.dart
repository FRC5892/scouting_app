import 'package:flutter/material.dart';

import '../forms.dart';

/* TODO make that cool integer field with the plus and minus signs next to it
 ________________
/   |        |   \
| - |     12 | + |
\___|________|___/

 */
class IntegerField extends StatefulWidget {
  final String jsonKey;
  final String name;
  final FRCFormSaveCallback onSavedCallback;

  IntegerField(this.jsonKey, this.name, this.onSavedCallback);

  @override
  _IntegerFieldState createState() => new _IntegerFieldState();
}

class _IntegerFieldState extends State<IntegerField> {
  final TextEditingController _controller = new TextEditingController();

  int cursorPosition;

  @override
  Widget build(BuildContext context) {
    print('IntegerField.build');
    return new ListTile(
      title: new Text(widget.name),
      trailing: new FormField<int>(
        builder: (FormFieldState<int> field) => new ConstrainedBox(
          constraints: new BoxConstraints(maxWidth: 50.0),
          child: new TextField(
            controller: _controller,
            onChanged: (String out) => field.onChanged(int.parse(out)),
          ),
        ),
        onSaved: (int value) => widget.onSavedCallback(widget.jsonKey, value),
      ),
    );
  }
}