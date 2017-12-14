import 'package:flutter/material.dart';

import '../forms.dart';

/* TODO put in that cool integer field with the plus and minus signs next to it
 ________________
/   |        |   \
| - |     12 | + |
\___|________|___/

 */
class IntegerField extends StatelessWidget {
  final String jsonKey;
  final String name;
  final FRCFormSaveCallback onSavedCallback;
  IntegerField(this.jsonKey, this.name, this.onSavedCallback);

  @override
  Widget build(BuildContext context) {
    print('IntegerField.build');
    return new ListTile(
      title: new Text(name),
      trailing: new FormField<int>(
        builder: (FormFieldState<int> field) => new TextField(
          controller: new TextEditingController(text: field.value.toString()),
          onChanged: (String out) {
            field.onChanged(int.parse(out));
          },
        ),
        onSaved: (int value) => onSavedCallback(jsonKey, value),
      ),
    );
  }
}