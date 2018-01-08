import 'package:flutter/material.dart';

import '../forms.dart';

class FRCTextField extends FRCFormFieldType<String> {
  const FRCTextField() : super(formFill: _formFill,
  dataView: _dataView, dataReport: _dataReport);

  static Widget _formFill(FRCFormFieldData<String> data, FRCFormSaveCallback saveCallback) => new _TextFieldFill(data, saveCallback);
  static Widget _dataView(FRCFormFieldData<String> data, String value) => new _TextFieldView(data, value);
  static Widget _dataReport(FRCFormFieldData<String> data, String reportValue) => new _TextFieldView(data, reportValue);
}

class _TextFieldFill extends StatelessWidget {
  final FRCFormFieldData<String> data;
  final FRCFormSaveCallback saveCallback;
  _TextFieldFill(this.data, this.saveCallback);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(data.title),
      trailing: new Container(
        constraints: new BoxConstraints(maxWidth: 200.0),
        child: new TextFormField(
          initialValue: "",
          onSaved: (String value) => saveCallback(data.jsonKey, value),
        ),
      )
    );
  }
}

class _TextFieldView extends StatelessWidget {
  final FRCFormFieldData<String> data;
  final String value;
  _TextFieldView(this.data, this.value);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(data.title),
      trailing: new Text(value ?? ""),
    );
  }
}