import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

class FormsHome extends StatefulWidget implements HomeView {
  @override
  List<Widget> actions(BuildContext context) {
    return <Widget> [
      new IconButton(icon: new Icon(Icons.cloud_upload), onPressed: () =>
        showDialog(context: context, barrierDismissible: false, child: new FirebasePushDialog()) // TODO handle errors
      ),
      new IconButton(icon: new Icon(Icons.add), onPressed: () {
        FRCFormTypeManager.instance.fillForm(context, "testForm", 5892);
      }),
      new IconButton(icon: new Icon(Icons.more_vert), onPressed: StorageManager.deleteAllForms),
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
    _formMetaSubscription = StorageManager.formsChangeNotifier.listen(
        (_) => StorageManager.getForms().toList().then(makeFormMeta)
    );
  }

  // maybe, eventually, upgrade this to something cool. like a StreamBuilder or something.
  void makeFormMeta(List<FormWithMetadata> forms) {
    List<_FormMetaEntry> newList = forms.map((f) {
      FRCFormType type = FRCFormTypeManager.instance.getTypeByCodeName(f.form[MapKeys.FORM_TYPE]);
      return new _FormMetaEntry(
        title: type.title(f.form[MapKeys.TEAM_NUMBER]),
        teamNumber: f.form[MapKeys.TEAM_NUMBER],
        uid: f.uid,
        timestamp: f.timestamp,
        type: type,
      );
    }).toList();
    setState(() => formMeta = newList);
  }

  @override
  Widget build(BuildContext context) {
    if (formMeta == null) StorageManager.getForms().toList().then(makeFormMeta);
    return new ListView.builder(
      itemCount: formMeta?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        index = formMeta.length - index - 1; // reverse
        _FormMetaEntry meta = formMeta[index];
        return new ListTile(
          title: new Text(meta.title),
          trailing: new Text(meta.timestamp.toString()),
          onTap: () async {
            FormWithMetadata f = await StorageManager.getFormWithUid(meta.uid);
            Navigator.push(context, new MaterialPageRoute(builder: (_) =>
            new FRCFormDataView(meta.title, f.form, meta.type)
            ));
          },
        );
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
  final String uid;
  final DateTime timestamp;
  final FRCFormType type;
  _FormMetaEntry({this.title, this.teamNumber, this.uid, this.timestamp, this.type});
}