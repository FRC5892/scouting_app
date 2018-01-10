import '../forms.dart';

class PitForm extends FRCFormType {
  PitForm() : super(
    "pitForm",
    <FRCFormFieldData> [
      new FRCFormFieldData<String>(const FRCTextField(), "pitStrategy", "Strategy", NumberCrunchFuncs.dataList),
      new FRCFormFieldData<bool>(const BooleanField(), "pitAutoMove", "Auto Movement", NumberCrunchFuncs.mostRecent),
      new FRCFormFieldData<bool>(const BooleanField(), "pitDeliverExchange", "Power Cubes to Exchange Zone", NumberCrunchFuncs.mostRecent),
      new FRCFormFieldData<bool>(const BooleanField(), "pitDeliverSwitch", "Power Cubes to Switch", NumberCrunchFuncs.mostRecent),
      new FRCFormFieldData<bool>(const BooleanField(), "pitDeliverScale", "Power Cubes to Scale", NumberCrunchFuncs.mostRecent),
      new FRCFormFieldData<bool>(const BooleanField(), "pitHang", "Hanging on Scale", NumberCrunchFuncs.mostRecent),
      new FRCFormFieldData<String>(const FRCTextField(), "pitMalfunction", "Robot Malfunctions", NumberCrunchFuncs.dataList),

      new FRCFormFieldData<String>(const FRCTextField(), "pitComments", "Other Comments", NumberCrunchFuncs.dataList)
    ]
  );

  @override
  String title(int teamNumber) => "Pit Interview for $teamNumber";
}