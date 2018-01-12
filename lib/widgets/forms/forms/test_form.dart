import '../forms.dart';

class TestForm extends FRCFormType {
  TestForm() : super(
    "testForm",
    <FRCFormFieldData> [
      const FRCFormFieldData<int>(const IntegerField(), "field1", "Field 1", NumberCrunchFuncs.average),
      const FRCFormFieldData<int>(const IntegerField(), "field2", "Field 2", NumberCrunchFuncs.average),
      const FRCFormFieldData<int>(const IntegerField(), "field3", "Field 3", NumberCrunchFuncs.mostRecent),
      const FRCFormFieldData<bool>(const BooleanField(), "fieldBool", "Boolean Field", NumberCrunchFuncs.percentage),
      const FRCFormFieldData<String>(const FRCTextField(), "fieldText", "Text Field", NumberCrunchFuncs.mostRecent),
      const FRCFormFieldData<String>(const FRCTextField(), "fieldText2", "Text Field 2", NumberCrunchFuncs.dataList),
    ],
  );

  @override
  String title(int teamNumber) => "Test Form for $teamNumber";
}