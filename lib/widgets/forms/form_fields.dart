import 'package:flutter/material.dart';

import 'forms.dart';

typedef Widget FRCFormFieldFill<T>(FRCFormFieldData<T> data, FRCFormSaveCallback saveCallback);
typedef Widget FRCFormFieldView<T>(FRCFormFieldData<T> data, T value);

class FRCFormFieldType<T> {
  final FRCFormFieldFill<T> formFill;
  // TODO final FRCFormFieldData<T> formEdit;
  final FRCFormFieldView<T> dataView;

  const FRCFormFieldType(this.formFill, this.dataView);
}

class FRCFormFieldData<T> {
  final FRCFormFieldType<T> type;
  final String jsonKey;
  final String title;
  final NumberCrunchFunc<T> numberCrunchFunc;
  FRCFormFieldData(this.type, this.jsonKey, this.title, this.numberCrunchFunc);

  // convenience methods
  Widget formFill(FRCFormSaveCallback saveCallback) => type.formFill(this, saveCallback);
  Widget dataView(T value) => type.dataView(this, value);
}