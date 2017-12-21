import 'package:flutter/material.dart';
import 'dart:async';
import 'package:scouting_app/main.dart';

class FormsHome extends StatefulWidget implements HomeView {
  @override
  List<Widget> actions(BuildContext context) {
    return <Widget> [
      new IconButton(icon: new Icon(Icons.cloud_upload), onPressed: null),
      new IconButton(icon: new Icon(Icons.add), onPressed: () {
        FRCFormTypeManager.instance.fillForm(context, "testForm", 5892);
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
  List<_FormMetaEntry> formMeta;
  StreamSubscription<Map<String, dynamic>> _formMetaSubscription;

  _FormsHomeState() {
    _formMetaSubscription = StorageManager.instance.formsStream.listen(makeFormMeta);
  }

  void makeFormMeta(Map<String, dynamic> formsContent) {
    print('_FormsHomeState.makeFormMeta($formsContent)');
    List<_FormMetaEntry> newList = formsContent[MapKeys.FORM_LIST_NAME].map(
      (Map<String, dynamic> input) {
        FRCFormType type = FRCFormTypeManager.instance.getTypeByCodeName(input[MapKeys.FORM_TYPE]);
        return new _FormMetaEntry(
          title: type.title(input[MapKeys.TEAM_NUMBER]),
          teamNumber: input[MapKeys.TEAM_NUMBER],
          type: type,
        );
      }).toList();
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
            title: new Text(formMeta[index].title),
            onTap: () async {
              Map<String, dynamic> formsContent = await StorageManager.instance.getForms();
              Map<String, dynamic> json = formsContent[MapKeys.FORM_LIST_NAME][index];
              Navigator.push(context, new MaterialPageRoute(builder: (_) =>
                new FRCFormDataView(formMeta[index].title, json, formMeta[index].type)
              ));
            },
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

class _FormMetaEntry {
  final String title;
  final int teamNumber;
  final FRCFormType type;
  _FormMetaEntry({this.title, this.teamNumber, this.type});
}