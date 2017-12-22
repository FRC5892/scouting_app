import 'package:flutter/material.dart';

import '../forms.dart';

class IntegerField extends FRCFormFieldType<int> {
  const IntegerField() : super( _formFill, _dataView);

  static Widget _formFill(FRCFormFieldData<int> data, FRCFormSaveCallback saveCallback) => new _IntegerFieldFill(data, saveCallback);
  static Widget _dataView(FRCFormFieldData<int> data, int value) => new _IntegerFieldView(data, value);
}

class _IntegerFieldFill extends StatefulWidget {
  final FRCFormFieldData<int> data;
  final FRCFormSaveCallback saveCallback;
  _IntegerFieldFill(this.data, this.saveCallback);

  @override
  _IntegerFieldFillState createState() => new _IntegerFieldFillState();
}

class _IntegerFieldFillState extends State<_IntegerFieldFill> {
  final TextEditingController _controller = new TextEditingController(text: "0");

  int cursorPosition;

  static const double buttonFontSize = 18.0;
  static const double buttonWidth = 40.0;

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(widget.data.title),
      trailing: new FormField<int>( // TODO data validation
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
        onSaved: (int value) => widget.saveCallback(widget.data.jsonKey, value),
      ),
    );
  }
}

class _IntegerFieldView extends StatelessWidget {
  final FRCFormFieldData<int> data;
  final int value;
  _IntegerFieldView(this.data, this.value);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(data.title),
      trailing: new Text((value ?? "").toString()),
    );
  }
}