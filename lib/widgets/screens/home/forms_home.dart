import 'package:flutter/material.dart';
import 'dart:async';
import 'package:scouting_app/main.dart';

class FormsHome extends StatefulWidget implements HomeView {
  @override
  List<Widget> actions(BuildContext context) {
    return <Widget> [
      new IconButton(icon: new Icon(Icons.cloud_upload), onPressed: null),
      new IconButton(icon: new Icon(Icons.add), onPressed: () {
        Navigator.push(context, new MaterialPageRoute(builder: (_) => new TestForm()));
      }),
      new IconButton(icon: new Icon(Icons.more_vert), onPressed: null),
    ];
  }

  @override
  Widget body(BuildContext context) => this;

  @override
  _FormsHomeState createState() => new _FormsHomeState();
}

class _FormsHomeState extends State<FormsHome> {
  List<List<String>> formMeta;

  Future<Null> syncFormMeta() async {
    print('_FormsHomeState.syncFormMeta');
    Map<String, dynamic> formsContent = await StorageManager.getForms();
    print('_FormsHomeState.syncFormMeta(1): $formsContent');
    List<List<String>> newList = formsContent[MapKeys.FORM_LIST_NAME].map(
      (Map<String, dynamic> input) => <String>[
        input[MapKeys.TEAM_NUMBER], FORM_NAMES[input[MapKeys.FORM_TYPE]],
      ]
    ).toList();
    print('_FormsHomeState.syncFormMeta(2): $newList');
    setState(() => formMeta = newList);
  }

  @override
  Widget build(BuildContext context) {
    if (formMeta == null) syncFormMeta();
    return new ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        try {
          return new ListTile(
            title: new Text(formMeta[index][0]),
            trailing: new Text(formMeta[index][1]),
          );
        } on Object {
          return null;
        }
      },
    );
  }
}