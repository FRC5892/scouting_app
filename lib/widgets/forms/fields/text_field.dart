import 'package:flutter/material.dart';

import 'package:scouting_app/main.dart';

class FRCTextField extends FRCFormFieldType<String> {
  const FRCTextField() : super(formFill: _formFill,
  dataView: _dataView, dataReport: _dataReport);

  static Widget _formFill(FRCFormFieldData<String> data, FRCFormSaveCallback saveCallback) => new _TextFieldFill(data, saveCallback);
  static Widget _dataView(FRCFormFieldData<String> data, String value) => new _TextFieldView(data, value);
  static Widget _dataReport(FRCFormFieldData<String> data, String reportValue) {
    if (reportValue?.startsWith(REPORT_LIST_PREFIX) ?? false) return new _TextListReport(data, reportValue);
    return new _TextFieldView(data, reportValue);
  }
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

  static const int MAX_CHARS = 40;

  @override
  Widget build(BuildContext context) {
    if (value?.length > MAX_CHARS)
      return new ListTile(
        title: new Text(data.title),
        trailing: new GestureDetector(
          child: new Text("(tap to expand)",
            style: new TextStyle(color: Theme.of(context).buttonColor),
          ),
          onTap: () => showDialog(context: context, child: new TextAlertDialog(value)),
        ),
      );
    return new ListTile(
      title: new Text(data.title),
      trailing: new Text(value ?? ""),
    );
  }
}

class _TextListReport extends StatelessWidget {
  final FRCFormFieldData<String> data;
  final List<String> values;
  _TextListReport(this.data, String valueStr) :
    values = valueStr.substring(REPORT_LIST_PREFIX.length).split(REPORT_LIST_SEP)
      .where((s) => s.length > 1).toList();

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(data.title),
      trailing: new IconButton(
        icon: new Icon(Icons.launch),
        onPressed: values.length > 0
          ? () => Navigator.push(context, new MaterialPageRoute(builder: (_) => new _TextListReportScreen(data.title, values)))
          : null,
      ),
    );
  }
}

class _TextListReportScreen extends StatelessWidget {
  final String title;
  final List<String> values;
  _TextListReportScreen(this.title, this.values);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: new ListView.builder(
        itemCount: values.length,
        itemBuilder: (context, index) {
          Widget textWidget = new Container(
            padding: new EdgeInsets.all(10.0),
            child: new Text(values[index], style: new TextStyle(fontSize: 15.0)),
          );
          if (index == 0) return textWidget;
          return new Column(
            children: <Widget>[
              new Divider(),
              textWidget,
            ],
          );
        },
      ),
    );
  }
}