import 'package:flutter/material.dart';
import 'forms.dart';

typedef Widget FRCFormFieldBuilder<T>(BuildContext context, FRCFormFieldData<T> data, FRCFormSaveCallback saveCallback);
typedef Widget FRCFormFieldValueBuilder<T>(BuildContext context, FRCFormFieldData<T> data, T value);

class FRCFormFieldType<T> {
  final FRCFormFieldBuilder<T> formFillBuilder;
  // TODO final FRCFormFieldValueBuilder<T> formEditBuilder;
  final FRCFormFieldValueBuilder<T> dataViewBuilder;

  FRCFormFieldType(this.formFillBuilder, this.dataViewBuilder);
}

class FRCFormFieldData<T> {
  final FRCFormFieldType<T> type;
  final String jsonKey;
  final String title;
  FRCFormFieldData(this.type, this.jsonKey, this.title);

  // convenience methods
  Widget buildFill(BuildContext context, FRCFormSaveCallback saveCallback) => type.formFillBuilder(context, this, saveCallback);
  Widget buildView(BuildContext context, T value) => type.dataViewBuilder(context, this, value);
}