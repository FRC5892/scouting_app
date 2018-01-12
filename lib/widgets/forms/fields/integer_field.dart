import 'package:flutter/material.dart';

import '../forms.dart';

class IntegerField extends FRCFormFieldType<int> {
  const IntegerField() : super(formFill: _formFill,
    dataView: _dataView, dataReport: _dataReport);

  static Widget _formFill(FRCFormFieldData<int> data, FRCFormSaveCallback saveCallback) => new _IntegerFieldFill(data, saveCallback);
  static Widget _dataView(FRCFormFieldData<int> data, int value) => new _IntegerFieldView(data, value);
  static Widget _dataReport(FRCFormFieldData<int> data, String reportValue) => new _IntegerFieldReport(data, reportValue);
}

class _IntegerFieldFill extends StatefulWidget {
  final FRCFormFieldData<int> data;
  final FRCFormSaveCallback saveCallback;
  _IntegerFieldFill(this.data, this.saveCallback);

  @override
  _IntegerFieldFillState createState() => new _IntegerFieldFillState();
}

class _IntegerFieldFillState extends State<_IntegerFieldFill> {
  String get jsonKey => widget.data.jsonKey;
  final TextEditingController _controller = new TextEditingController();

  static const double buttonFontSize = 18.0;
  static const double buttonWidth = 40.0;

  int initValue;

  @override
  void initState() {
    super.initState();
    initValue = FRCFormFillView.of(context)?.getValue(jsonKey) ?? 0;
    _controller.text = initValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(widget.data.title),
      trailing: new FormField<int>(
        initialValue: initValue,
        builder: (FormFieldState<int> field) => new Row(
          children: <Widget>[
            new ConstrainedBox(
              constraints: new BoxConstraints(maxWidth: buttonWidth),
              child: new FlatButton(
                child: const Text("-", style: const TextStyle(fontSize: buttonFontSize)),
                onPressed: () {
                  int newValue = field.value - 1;
                  _controller.text = newValue.toString();
                  field.onChanged(newValue);
                  widget.saveCallback(jsonKey, newValue);
                },
              ),
            ),
            new ConstrainedBox(
              constraints: new BoxConstraints(maxWidth: 50.0),
              child: new TextField(
                controller: _controller,
                textAlign: TextAlign.right,
                keyboardType: TextInputType.number,
                onChanged: (String out) {
                  int value = int.parse(out);
                  field.onChanged(value);
                  widget.saveCallback(jsonKey, value);
                },
              ),
            ),
            new ConstrainedBox(
              constraints: new BoxConstraints(maxWidth: buttonWidth),
              child: new FlatButton(
                child: const Text("+", style: const TextStyle(fontSize: buttonFontSize)),
                onPressed: () {
                  int newValue = field.value + 1;
                  _controller.text = newValue.toString();
                  field.onChanged(newValue);
                  widget.saveCallback(jsonKey, newValue);
                },
              ),
            ),
          ],
        ),
        onSaved: (int value) => widget.saveCallback(jsonKey, value),
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

class _IntegerFieldReport extends StatelessWidget {
  final FRCFormFieldData<int> data;
  final String reportValue;
  _IntegerFieldReport(this.data, this.reportValue);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(data.title),
      trailing: new Text(reportValue),
    );
  }
}