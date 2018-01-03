import 'dart:isolate';
import '../constants.dart';
import '../widgets/forms/forms.dart';

class NumberCrunchInitMessage {
  final SendPort reportPort;
  final Map<int, List<Map<String, dynamic>>> data; // Map<teamNumber, List<formData>>
  NumberCrunchInitMessage(this.reportPort, this.data);
}

class NumberCrunchTeamReport {
  final int teamNumber;
  final Map<String, dynamic> report;
  NumberCrunchTeamReport(this.teamNumber, this.report);
}

// starting point for the isolate.
void crunchNumbers(NumberCrunchInitMessage message) {
  SendPort reportPort = message.reportPort;
  message.data.forEach((teamNumber, formData) {
    Map<String, List<Map<String, dynamic>>> sepData = new Map();
    formData.forEach((data) {
      sepData..putIfAbsent(data[MapKeys.FORM_TYPE], () => [])
        ..[data[MapKeys.FORM_TYPE]].add(data);
    });
    Map<String, dynamic> report = new Map();
    sepData.forEach((formCode, data) {
      FRCFormType type = FRCFormTypeManager.instance.getTypeByCodeName(formCode);
      type.fields.forEach((field) {
        report[field.jsonKey] = field.numberCrunchFunc(data.map((d) => d[field.jsonKey]).where((d) => d != null));
      });
    });
    reportPort.send(new NumberCrunchTeamReport(teamNumber, report));
  });
  reportPort.send("done");
}