import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'forms.dart';

typedef void FRCFormSaveCallback(String codeName, dynamic value);

class FRCFormFillView extends StatelessWidget {
  final String title;
  final int teamNumber;
  final FRCFormType type;
  final Map<String, dynamic> _saveHolder = new Map<String, dynamic>();
  FRCFormFillView(this.title, this.teamNumber, this.type);
  
  void saveCallback(String key, dynamic value) => _saveHolder[key] = value;
  Future<Null> submitCallback(BuildContext context) async {
    Form.of(context).save();
    saveCallback(MapKeys.TEAM_NUMBER, teamNumber);
    saveCallback(MapKeys.FORM_TYPE, type.codeName);
    saveCallback(MapKeys.USER_NAME, (await SharedPreferences.getInstance()).getString(MapKeys.USER_NAME));
    saveCallback(MapKeys.TIMESTAMP, new DateTime.now().millisecondsSinceEpoch);
    StorageManager.instance.addForm(_saveHolder);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Form(
      autovalidate: true,
      child: new Builder(builder: (BuildContext context) => new Scaffold(
        appBar: new AppBar(
          title: new Text(title),
          actions: <Widget> [
            new IconButton(icon: new Icon(Icons.check), onPressed: () => submitCallback(context),),
          ],
        ),
        body: type.buildFormFill(context, saveCallback),
      ),),
    );
  }
}

class FRCFormEditView extends StatelessWidget {
  Widget build(BuildContext context) => throw "TODO";
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