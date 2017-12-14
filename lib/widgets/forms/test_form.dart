import 'package:flutter/material.dart';

import 'forms.dart';

class TestForm extends FRCForm {
  TestForm() : super(5892, "testForm");

  @override
  String title() => "Test Form for $teamNumber";

  @override
  Widget formBody(FRCFormSaveCallback saveCallback) {
    print('TestForm.formBody');
    return new ListView(
      children: <Widget>[
        new IntegerField("field1", "Field 1", saveCallback),
        new IntegerField("field2", "Field 2", saveCallback),
        new IntegerField("field3", "Field 3", saveCallback),
      ],
    );
  }
}

class ShittyTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("Shitty Test"),
      ),
      body: new TextField(),
    );
  }
}