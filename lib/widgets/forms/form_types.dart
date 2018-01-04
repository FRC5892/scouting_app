import 'package:flutter/material.dart';
import 'package:scouting_app/widgets/forms/forms.dart';

typedef Widget ParameterWidgetBuilder<T>(BuildContext context, T value);

class FRCFormType {
  final String codeName;
  final List<FRCFormFieldData> fields;
  final ParameterWidgetBuilder<List<Widget>> builder; // maybe should just be overridable? w/e.
  FRCFormType(this.codeName, this.fields, [this.builder = defaultBuilder]);

  Widget buildFormFill(BuildContext context, FRCFormSaveCallback saveCallback) {
    return builder(context, fields.map((f) => f.formFill(saveCallback)).toList());
  }

  Widget buildFormEdit(BuildContext context, List values) {
    throw "TODO";
  }

  Widget buildDataView(BuildContext context, List values) {
    List<Widget> pass = [];
    for (int i=0; i<values.length; i++)
      pass.add(fields[i].dataView(values[i]));
    return builder(context, pass);
  }

  Widget buildReportView(BuildContext context, List<String> values) {
    List<Widget> pass = [];
    for (int i=0; i<values.length; i++) {
      pass.add(fields[i].reportView(values[i]));
    }
    return builder(context, pass);
  }

  String title(int teamNumber) => "Form for $teamNumber";

  static Widget defaultBuilder(BuildContext context, List<Widget> fields) {
    return new ListView(
      children: fields,
    );
  }
}