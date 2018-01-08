import 'package:flutter/material.dart';

import '../forms.dart';

class BooleanField extends FRCFormFieldType<bool> {
  const BooleanField() : super(formFill: _formFill,
  dataView: _dataView, dataReport: _dataReport);

  static Widget _formFill(FRCFormFieldData<bool> data, FRCFormSaveCallback saveCallback) => new _BooleanFieldFill(data, saveCallback);
  static Widget _dataView(FRCFormFieldData<bool> data, bool value) => new _BooleanFieldView(data, value);
  static Widget _dataReport(FRCFormFieldData<bool> data, String reportValue) => new _BooleanFieldReport(data, reportValue);
}

class _BooleanFieldFill extends StatelessWidget {
  final FRCFormFieldData<bool> data;
  final FRCFormSaveCallback saveCallback;
  _BooleanFieldFill(this.data, this.saveCallback);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(data.title),
      trailing: new FormField<bool>(
        initialValue: false,
        builder: (FormFieldState<bool> field) => new Checkbox(
          value: field.value,
          onChanged: field.onChanged,
        ),
        onSaved: (bool value) => saveCallback(data.jsonKey, value),
      ),
    );
  }
}

class _BooleanFieldView extends StatelessWidget {
  final FRCFormFieldData<bool> data;
  final bool value;
  _BooleanFieldView(this.data, this.value);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(data.title),
      trailing: new Text((value ?? "").toString()),
    );
  }
}

class _BooleanFieldReport extends StatelessWidget {
  final FRCFormFieldData<bool> data;
  final String reportValue;
  _BooleanFieldReport(this.data, this.reportValue);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(data.title),
      trailing: new Text(reportValue),
    );
  }
}