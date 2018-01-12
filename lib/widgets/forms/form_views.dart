import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'forms.dart';

typedef void FRCFormSaveCallback(String codeName, dynamic value);

class FRCFormFillView extends StatefulWidget {
  final String title;
  final int teamNumber;
  final FRCFormType type;
  final Map<String, dynamic> initValues;
  final String uid;
  FRCFormFillView(this.title, this.teamNumber, this.type, [this.initValues, this.uid]);

  @override
  FRCFormFillViewState createState() => new FRCFormFillViewState();

  static FRCFormFillViewState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<FRCFormFillViewState>());
}

class FRCFormFillViewState extends State<FRCFormFillView> {
  Map<String, dynamic> _saveHolder;

  @override
  void initState() {
    super.initState();
    _saveHolder = new Map<String, dynamic>.from(widget.initValues ?? {});
  }

  dynamic getValue(String key) {
    dynamic ret = _saveHolder[key];
    return ret;
  }
  
  void saveCallback(String key, dynamic value) {
    _saveHolder[key] = value;
  }

  Future<Null> submitCallback(BuildContext context) async {
    Form.of(context).save();
    saveCallback(MapKeys.TEAM_NUMBER, widget.teamNumber);
    saveCallback(MapKeys.FORM_TYPE, widget.type.codeName);
    saveCallback(MapKeys.USER_NAME, (await SharedPreferences.getInstance()).getString(MapKeys.USER_NAME));
    StorageManager.addForm(_saveHolder, widget.uid);
    Navigator.pop(context);
  }

  static FRCFormFillView of(BuildContext context) => context.ancestorWidgetOfExactType(FRCFormFillView);

  @override
  Widget build(BuildContext context) {
    return new Form(
      autovalidate: true,
      child: new Builder(builder: (BuildContext context) => new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
          actions: <Widget> [
            new IconButton(icon: const Icon(Icons.check), onPressed: () => submitCallback(context),),
          ],
        ),
        body: widget.type.buildFormFill(context, saveCallback),
      ),),
    );
  }
}

class FRCFormDataView extends StatelessWidget {
  final String title;
  final Map<String, dynamic> json;
  final FRCFormType type;
  FRCFormDataView(this.title, this.json, this.type);

  @override
  Widget build(BuildContext context) {
    List<dynamic> values = type.fields.map((f) => json[f.jsonKey]).toList(); // returns null if absent
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: type.buildDataView(context, values),
    );
  }
}

// don't put this one in a Scaffold.
class FRCFormReportView extends StatelessWidget {
  final Map<String, dynamic> json;
  final FRCFormType type;
  FRCFormReportView(this.json, this.type);

  @override
  Widget build(BuildContext context) {
    List<dynamic> values = type.fields.map((f) => json[f.jsonKey]).toList();
    return type.buildReportView(context, values);
  }
}