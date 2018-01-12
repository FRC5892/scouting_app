import '../forms.dart';

class PitForm extends FRCFormType {
  PitForm() : super(
    "pitForm",
    <FRCFormFieldData> [
      const FRCFormFieldData<String>(const FRCTextField(), "pitStrategy", "Strategy", NumberCrunchFuncs.dataList),
      const FRCFormFieldData<bool>(const BooleanField(), "pitAutoMove", "Auto Movement", NumberCrunchFuncs.mostRecent),
      const FRCFormFieldData<bool>(const BooleanField(), "pitDeliverExchange", "Power Cubes to Exchange Zone", NumberCrunchFuncs.mostRecent),
      const FRCFormFieldData<bool>(const BooleanField(), "pitDeliverSwitch", "Power Cubes to Switch", NumberCrunchFuncs.mostRecent),
      const FRCFormFieldData<bool>(const BooleanField(), "pitDeliverScale", "Power Cubes to Scale", NumberCrunchFuncs.mostRecent),
      const FRCFormFieldData<bool>(const BooleanField(), "pitHang", "Hanging on Scale", NumberCrunchFuncs.mostRecent),
      const FRCFormFieldData<String>(const FRCTextField(), "pitMalfunction", "Robot Malfunctions", NumberCrunchFuncs.dataList),

      const FRCFormFieldData<String>(const FRCTextField(), "pitComments", "Other Comments", NumberCrunchFuncs.dataList)
    ]
  );

  @override
  String title(int teamNumber) => "Pit Interview for $teamNumber";
}