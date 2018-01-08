import '../forms.dart';

class TestForm extends FRCFormType {
  TestForm() : super(
    "testForm",
    <FRCFormFieldData> [
      new FRCFormFieldData<int>(const IntegerField(), "field1", "Field 1", NumberCrunchFuncs.average),
      new FRCFormFieldData<int>(const IntegerField(), "field2", "Field 2", NumberCrunchFuncs.average),
      new FRCFormFieldData<int>(const IntegerField(), "field3", "Field 3", NumberCrunchFuncs.mostRecent),
      new FRCFormFieldData<bool>(const BooleanField(), "fieldBool", "Boolean Field", NumberCrunchFuncs.percentage),
    ],
  );

  @override
  String title(int teamNumber) => "Test Form for $teamNumber";
}