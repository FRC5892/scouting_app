import '../forms.dart';

class TestForm extends FRCFormType {
  TestForm() : super(
    "testForm",
    <FRCFormFieldData> [
      new FRCFormFieldData<int>(const IntegerField(), "field1", "Field 1", NumberCrunchFuncs.average),
      new FRCFormFieldData<int>(const IntegerField(), "field2", "Field 2", NumberCrunchFuncs.average),
      new FRCFormFieldData<int>(const IntegerField(), "field3", "Field 3", NumberCrunchFuncs.mostRecent),
      new FRCFormFieldData<bool>(const BooleanField(), "fieldBool", "Boolean Field", NumberCrunchFuncs.percentage),
      new FRCFormFieldData<String>(const FRCTextField(), "fieldText", "Text Field", NumberCrunchFuncs.mostRecent),
      new FRCFormFieldData<String>(const FRCTextField(), "fieldText2", "Text Field 2", NumberCrunchFuncs.dataList),
    ],
  );

  @override
  String title(int teamNumber) => "Test Form for $teamNumber";
}