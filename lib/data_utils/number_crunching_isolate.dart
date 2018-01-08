import 'dart:isolate';

import '../constants.dart';
import '../widgets/forms/forms.dart';

class NumberCrunchInitMessage {
  final SendPort reportPort;
  final Map<int, List<FormWithMetadata>> data; // Map<teamNumber, List<formData>>
  NumberCrunchInitMessage(this.reportPort, this.data);
}

class NumberCrunchTeamReport {
  final int teamNumber;
  final Map<String, dynamic> report;
  NumberCrunchTeamReport(this.teamNumber, this.report);
}

Isolate _crunchingIsolate;

ReceivePort spawnNumberCrunchingIsolate(Map<int, List<FormWithMetadata>> data) {
  try {
    _crunchingIsolate.kill(priority: Isolate.IMMEDIATE);
  } on NoSuchMethodError {} // ?. doesn't work for some reason
  ReceivePort ret = new ReceivePort();
  NumberCrunchInitMessage initMsg = new NumberCrunchInitMessage(ret.sendPort, data);
  Isolate.spawn(crunchNumbers, initMsg).then((i) => _crunchingIsolate = i);
  return ret;
}

// starting point for the isolate.
void crunchNumbers(NumberCrunchInitMessage message) {
  SendPort reportPort = message.reportPort;
  message.data.forEach((teamNumber, formData) {
    Map<String, List<FormWithMetadata>> sepData = new Map();
    formData.forEach((data) {
      sepData..putIfAbsent(data.form[MapKeys.FORM_TYPE], () => [])
        ..[data.form[MapKeys.FORM_TYPE]].add(data);
    });
    Map<String, String> report = new Map();
    sepData.forEach((formCode, data) {
      FRCFormType type = FRCFormTypeManager.instance.getTypeByCodeName(formCode);
      type.fields.forEach((field) {
        report[field.jsonKey] = field.numberCrunchFunc(data.map((datum) =>
          new TimeAssociatedDatum(datum.form[field.jsonKey], datum.timestamp)));
      });
    });
    reportPort.send(new NumberCrunchTeamReport(teamNumber, report));
  });
  reportPort.send(DONE_MESSAGE);
}