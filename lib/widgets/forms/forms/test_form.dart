import '../forms.dart';

class TestForm extends FRCFormType {
  TestForm() : super(
    "testForm",
    <FRCFormFieldData> [
      new FRCFormFieldData(const IntegerField(), "field1", "Field 1"),
      new FRCFormFieldData(const IntegerField(), "field2", "Field 2"),
      new FRCFormFieldData(const IntegerField(), "field3", "Field 3"),
    ],
  );

  @override
  String title(int teamNumber) => "Test Form for $teamNumber";
}