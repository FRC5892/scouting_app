import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

export 'test_form.dart';
export 'fields/integer_field.dart';

typedef void FRCFormSaveCallback(String codeName, dynamic value);

abstract class FRCForm extends StatelessWidget {
  final int teamNumber;
  final String formType;
  FRCForm(this.teamNumber, this.formType);

  String title();
  Widget formBody(FRCFormSaveCallback saveCallback);

  final Map<String, dynamic> _saveHolder = new Map<String, dynamic>();
  void saveCallback(String key, dynamic value) => _saveHolder[key] = value;
  void submitCallback(BuildContext context) {
    Form.of(context).save();
    saveCallback("teamNumber", teamNumber);
    saveCallback("formType", formType);
    // TODO save as JSON
    print(_saveHolder);
    StorageManager.addForm(_saveHolder);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Form(
      autovalidate: true,
      child: new Builder(builder: (BuildContext context) => new Scaffold(
        appBar: new AppBar(
          title: new Text(title()),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.check), onPressed: () => submitCallback(context)),
          ],
        ),
        body: formBody(saveCallback),
      )),
    );
  }
}