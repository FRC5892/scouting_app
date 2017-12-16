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
  StreamSubscription<Map<String, dynamic>> _formMetaSubscription;

  _FormsHomeState() {
    _formMetaSubscription = StorageManager.instance.formsStream.listen(makeFormMeta);
  }

  void makeFormMeta(Map<String, dynamic> formsContent) {
    print('_FormsHomeState.makeFormMeta($formsContent)');
    List<List<String>> newList = formsContent[MapKeys.FORM_LIST_NAME].map(
      (Map<String, dynamic> input) => <String>[
        input[MapKeys.TEAM_NUMBER].toString(), FORM_NAMES[input[MapKeys.FORM_TYPE]],
      ]
    ).toList();
    print('_FormsHomeState.makeFormMeta: $newList');
    setState(() => formMeta = newList);
  }

  @override
  Widget build(BuildContext context) {
    if (formMeta == null) StorageManager.instance.getForms().then(makeFormMeta);
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

  @override
  void dispose() {
    _formMetaSubscription.cancel();
    super.dispose();
  }
}