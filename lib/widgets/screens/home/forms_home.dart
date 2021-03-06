import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

enum _FormPopupMenuAction {EDIT, DELETE}

class FormsHome extends StatefulWidget implements HomeView {
  @override
  List<Widget> actions(BuildContext context) {
    return <Widget> [
      new Builder(builder: (BuildContext context) => new IconButton(icon: const Icon(Icons.cloud_upload), onPressed: () =>
        showDialog(context: context, barrierDismissible: false, child: new FirebasePushDialog())
          .then((r) {
            if (!r) Scaffold.of(context).showSnackBar(const SnackBar(
              content: const Text("Push failed. Check your Internet conection."),
              backgroundColor: ERROR_COLOR,
            ));
        })
      )),
      new PopupMenuButton<String>(
        icon: const Icon(Icons.add),
        onSelected: (t) async {
          int teamNumber = await showDialog(context: context, child: new TeamNumberEntryDialog());
          if (teamNumber != null) FRCFormTypeManager.instance.fillForm(context, t, teamNumber);
        },
        itemBuilder: (_) => const <PopupMenuItem<String>> [
          const PopupMenuItem(
            value: "pitForm",
            child: const Text("Pit Interview"),
          ),
          const PopupMenuItem(
            value: "matchForm",
            child: const Text("Match Report"),
          ),
        ],
      ),
      new PopupMenuButton<VoidCallback>(
        icon: const Icon(Icons.more_vert),
        onSelected: (cb) => cb(),
        itemBuilder: (_) => const <PopupMenuItem<VoidCallback>> [
          const PopupMenuItem(
            value: StorageManager.deleteAllForms,
            child: const Text("Clear all forms"),
          ),
        ],
      ),
    ];
  }

  @override
  Widget body(BuildContext context) => this;

  @override
  _FormsHomeState createState() => new _FormsHomeState();
}

class _FormsHomeState extends State<FormsHome> {
  List<_FormMetaEntry> formMeta;
  StreamSubscription<Null> _formChangeSubscription;

  @override
  void initState() {
    super.initState();
    _formChangeSubscription = StorageManager.formsChangeNotifier.listen(
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

  ValueChanged<_FormPopupMenuAction> popupMenuHandler(int index) {
    return (action) async {
      switch (action) {
        case _FormPopupMenuAction.EDIT:
          FormWithMetadata form = await StorageManager.getFormWithUid(formMeta[index].uid);
          FRCFormTypeManager.instance.editForm(context, form.form, formMeta[index].uid);
          break;
        case _FormPopupMenuAction.DELETE:
          StorageManager.deleteFormWithUid(formMeta[index].uid);
      }
    };
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
          trailing: new Row(
            children: <Widget>[
              new Text(dateTimeToReasonableString(meta.timestamp)),
              new PopupMenuButton<_FormPopupMenuAction>(
                onSelected: popupMenuHandler(index),
                itemBuilder: (_) => const <PopupMenuItem<_FormPopupMenuAction>> [
                  const PopupMenuItem(
                    value: _FormPopupMenuAction.EDIT,
                    child: const Text("Edit"),
                  ),
                  const PopupMenuItem(
                    value: _FormPopupMenuAction.DELETE,
                    child: const Text("Delete"),
                  ),
                ]
              ),
            ],
          ),
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
    _formChangeSubscription.cancel();
    super.dispose();
  }
}

class _FormMetaEntry {
  final String title;
  final int teamNumber;
  final String uid;
  final DateTime timestamp;
  final FRCFormType type;
  const _FormMetaEntry({this.title, this.teamNumber, this.uid, this.timestamp, this.type});
}