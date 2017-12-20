import 'package:scouting_app/widgets/forms/forms.dart';
import 'package:flutter/material.dart';

class FRCFormType {
  final String codeName;
  final List<FRCFormFieldData> fields;
  final ParameterWidgetBuilder<List<Widget>> builder;
  FRCFormType(this.codeName, this.fields, [this.builder = defaultBuilder]) {
    FRCFormTypeManager.instance.register(this);
  }

  Widget buildFormFill(BuildContext context, FRCFormSaveCallback saveCallback) {
    return builder(context, fields.map((f) => f.buildFill(context, saveCallback)).toList());
  }

  Widget buildFormEdit(BuildContext context, List values) {
    throw "TODO";
  }

  Widget buildDataView(BuildContext context, List values) {
    List<Widget> pass = [];
    for (int i=0; i<values.length; i++)
      pass.add(fields[i].buildView(context, values[i]));
    return builder(context, pass);
  }

  static Widget defaultBuilder(BuildContext context, List<Widget> fields) {
    return new ListView(
      children: fields,
    );
  }
}