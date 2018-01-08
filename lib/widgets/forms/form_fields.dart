import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'forms.dart';

typedef Widget FRCFormFieldFill<T>(FRCFormFieldData<T> data, FRCFormSaveCallback saveCallback);
typedef Widget FRCFormFieldView<T>(FRCFormFieldData<T> data, T value);
typedef Widget FRCFormFieldReport<T>(FRCFormFieldData<T> data, String reportValue);

class FRCFormFieldType<T> {
  final FRCFormFieldFill<T> formFill;
  // TODO final FRCFormFieldEdit<T> formEdit;
  final FRCFormFieldView<T> dataView;
  final FRCFormFieldReport<T> dataReport;

  const FRCFormFieldType({@required this.formFill, //@required this.formEdit,
    @required this.dataView, @required this.dataReport});
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
  Widget reportView(String value) => type.dataReport(this, value);
}