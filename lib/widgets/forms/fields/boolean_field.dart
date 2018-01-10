import 'package:flutter/material.dart';

import '../forms.dart';

class BooleanField extends FRCFormFieldType<bool> {
  const BooleanField() : super(formFill: _formFill,
  dataView: _dataView, dataReport: _dataReport);

  static Widget _formFill(FRCFormFieldData<bool> data, FRCFormSaveCallback saveCallback) => new _BooleanFieldFill(data, saveCallback);
  static Widget _dataView(FRCFormFieldData<bool> data, bool value) => new _BooleanFieldView(data, value);
  static Widget _dataReport(FRCFormFieldData<bool> data, String reportValue) => new _BooleanFieldReport(data, reportValue);
}

class _BooleanFieldFill extends StatefulWidget {
  final FRCFormFieldData<bool> data;
  final FRCFormSaveCallback saveCallback;
  _BooleanFieldFill(this.data, this.saveCallback);

  @override
  _BooleanFieldFillState createState() => new _BooleanFieldFillState();
}

class _BooleanFieldFillState extends State<_BooleanFieldFill> {
  bool initValue;

  @override
  void initState() {
    super.initState();
    initValue = FRCFormFillView.of(context)?.getValue(widget.data.jsonKey) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(widget.data.title),
      trailing: new FormField<bool>(
        initialValue: initValue,
        builder: (FormFieldState<bool> field) => new Checkbox(
          value: field.value,
          onChanged: (bool value) {
            field.onChanged(value);
            widget.saveCallback(widget.data.jsonKey, value);
          },
        ),
        onSaved: (bool value) => widget.saveCallback(widget.data.jsonKey, value),
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