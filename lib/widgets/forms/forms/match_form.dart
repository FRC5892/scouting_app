import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

class MatchForm extends FRCFormType {
  MatchForm() : super(
    "matchForm",
    <FRCFormFieldData> [ // updating this does not work automatically like other forms! be sure to check _build()!
      // pre-match [0:2]
      new FRCFormFieldData<int>(const IntegerField(), "matchMatchNumber", "Match Number", (_) => "(various)"),
      new FRCFormFieldData<int>(const IntegerField(), "matchPositionNumber", "Position Number", (_) => "(various)"),

      // autonomous [2:4]
      new FRCFormFieldData<bool>(const BooleanField(), "matchAutoMobility", "Auto Line", NumberCrunchFuncs.percentage),
      new FRCFormFieldData<int>(const IntegerField(), "matchAutoCubes", "Power Cubes Delivered", NumberCrunchFuncs.average),

      // teleop [4:11]
      new FRCFormFieldData<String>(const FRCTextField(), "matchStrategy", "Strategy", NumberCrunchFuncs.dataList),
      new FRCFormFieldData<int>(const IntegerField(), "matchCubesSw1tch", "Cubes to Own Switch", NumberCrunchFuncs.average),
      new FRCFormFieldData<int>(const IntegerField(), "matchCubesScale", "Cubes to Scale", NumberCrunchFuncs.average),
      new FRCFormFieldData<int>(const IntegerField(), "matchCubesSw2tch", "Cubes to Enemy Switch", NumberCrunchFuncs.average),
      new FRCFormFieldData<int>(const IntegerField(), "matchCubesExchange", "Cubes to Exchange", NumberCrunchFuncs.average),
      new FRCFormFieldData<bool>(const BooleanField(), "matchHang", "Hang on Scale", NumberCrunchFuncs.percentage),
      new FRCFormFieldData<int>(const IntegerField(), "matchPenalties", "Penalties", NumberCrunchFuncs.average),

      // post-match [11:12]
      new FRCFormFieldData<String>(const FRCTextField(), "matchComments", "Other Comments", NumberCrunchFuncs.dataList),
    ],
    _build,
  );

  static Widget _build(BuildContext context, List<Widget> fields) {
    return new ListView(
      addAutomaticKeepAlives: true,
      children: <Widget>[
        new ListHeader("Pre-Match"),
        fields[0],
        fields[1],

        new ListHeader("Autonomous"),
        fields[2],
        fields[3],

        new ListHeader("TeleOp"),
        fields[4],
        fields[5],
        fields[6],
        fields[7],
        fields[8],
        fields[9],
        fields[10],

        new ListHeader("Post-Match"),
        fields[11],
      ],
    );
  }

  @override
  String title(int teamNumber) => "Match Report for $teamNumber";
}