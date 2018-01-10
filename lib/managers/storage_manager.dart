import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scouting_app/main.dart';

class StorageManager {
  static final Future<Null> _initFuture = _init();

  static Directory _formsDir;
  static Directory _dataDir;
  static StreamController<Null> _formsChangeController = new StreamController<Null>.broadcast();
  static StreamController<Null> _dataChangeController = new StreamController<Null>.broadcast();

  static Stream<Null> get formsChangeNotifier => _formsChangeController.stream;
  static Stream<Null> get dataChangeNotifier => _dataChangeController.stream;

  static void _formsChanged() => _formsChangeController.add(null);
  static void _dataChanged() => _dataChangeController.add(null);

  static Future<Null> _init() async {
    String rootDir = (await getApplicationDocumentsDirectory()).path;
    _formsDir = new Directory("$rootDir/forms");
    _dataDir = new Directory("$rootDir/data");
    if (!await _formsDir.exists()) {
      await Future.wait(<Future> [
        _formsDir.create(),
        _dataDir.create(),
        _initDataTrackingFile(),
      ]);
    }
  }

  static Future<Null> _initDataTrackingFile() async {
    File trackingFile = new File("${_dataDir.path}/tracking.csv");
    await trackingFile.create(recursive: true);
    await trackingFile.writeAsString("\r\n0\r\nfalse"); // i think the csv library needs CRLF?
  }

  static Stream<FormWithMetadata> getForms() async* {
    await _initFuture;
    await for (FileSystemEntity f in _formsDir.list()) {
      if (f is File) {
        yield new FormWithMetadata(JSON.decode(await f.readAsString()),
          uid: f.path.split('/').last.split('.').first,
          timestamp: await f.lastModified(),
        );
      }
    }
  }

  static Future<FormWithMetadata> getFormWithUid(String uid) async {
    await _initFuture;
    File formFile = new File("${_formsDir.path}/$uid.json");
    return new FormWithMetadata(JSON.decode(await formFile.readAsString()),
      uid: uid,
      timestamp: await formFile.lastModified(),
    );
  }

  static Future<List<int>> getTrackedTeams() async {
    await _initFuture;
    String csvStr = await new File("${_dataDir.path}/tracking.csv").readAsString();
    List<List<dynamic>> csv = const CsvToListConverter().convert(csvStr);
    try {
      return csv[0]..removeWhere((o) => o is! int);
    } on RangeError {
      return <int> [];
    }
  }

  static Future<Null> setTrackedTeams(List<int> track) async {
    File csvFile = new File("${_dataDir.path}/tracking.csv");
    List<List<dynamic>> csv = const CsvToListConverter().convert(await csvFile.readAsString());
    if (csv.length < 3) csv..length = 3..[0] = track;
    else csv[0] = track;
    await csvFile.writeAsString(const ListToCsvConverter().convert(csv), flush: true);
    _dataChanged();
  }

  static Future<DateTime> getLastPullTimestamp() async {
    await _initFuture;
    String csvStr = await new File("${_dataDir.path}/tracking.csv").readAsString();
    List<List<dynamic>> csv = const CsvToListConverter().convert(csvStr);
    return new DateTime.fromMillisecondsSinceEpoch(csv.length > 1 ? csv[1][0] : 0);
  }

  static Future<Null> setLastPullTimestamp(DateTime timestamp) async {
    await _initFuture;
    File csvFile = new File("${_dataDir.path}/tracking.csv");
    List<List<dynamic>> csv = const CsvToListConverter().convert(await csvFile.readAsString());
    if (csv.length < 3) csv..length = 3..[1] = <int> [timestamp.millisecondsSinceEpoch];
    else csv[1][0] = timestamp.millisecondsSinceEpoch;
    await csvFile.writeAsString(const ListToCsvConverter().convert(csv), flush: true);
  }

  static Stream<FormWithMetadata> getDataForTeam(int teamNumber) async* {
    await _initFuture;
    Directory teamDir = new Directory("${_dataDir.path}/$teamNumber");
    if (await teamDir.exists()) {
      await for (FileSystemEntity f in teamDir.list()) {
        if (f is File && !f.path.contains(GENERATED_REPORT)) {
          Map<String, dynamic> json = JSON.decode(await f.readAsString());
          yield new FormWithMetadata(json,
            uid: f.path.split('/').last.split('.').first,
            timestamp: new DateTime.fromMillisecondsSinceEpoch(json[MapKeys.TIMESTAMP]),
          );
        }
      }
    }
  }

  static Future<Map<String, dynamic>> getReportsForTeam(int teamNumber) async {
    await _initFuture;
    if (await getCrunchingNumbers()) throw "Currently generating reports; check back later.";
    File reportFile = new File("${_dataDir.path}/$teamNumber/$GENERATED_REPORT.json");
    if (!await reportFile.exists()) throw "This team has no report.";
    return JSON.decode(await reportFile.readAsString());
  }

  static Future<bool> getCrunchingNumbers() async {
    await _initFuture;
    File csvFile = new File("${_dataDir.path}/tracking.csv");
    List<List<dynamic>> csv = const CsvToListConverter().convert(await csvFile.readAsString());
    return csv.length > 2 ? csv[2][0] == "true" : false;
  }

  static Future<Null> setCrunchingNumbers(bool isCrunching) async {
    await _initFuture;
    File csvFile = new File("${_dataDir.path}/tracking.csv");
    List<List<dynamic>> csv = const CsvToListConverter().convert(await csvFile.readAsString());
    if (csv.length < 3) csv..length = 3..[2] = <bool> [isCrunching];
    else csv[2][0] = isCrunching;
    await csvFile.writeAsString(const ListToCsvConverter().convert(csv), flush: true);
  }

  static Future<Null> addForm(Map<String, dynamic> form) async {
    await _initFuture;
    String uid = randomUID();
    await new File("${_formsDir.path}/$uid.json").writeAsString(JSON.encode(form), flush: true);
    _formsChanged();
  }

  static Future<Null> addData(Map<String, dynamic> data, int teamNumber, String uid) async {
    await _initFuture;
    File dataFile = new File("${_dataDir.path}/$teamNumber/$uid.json");
    await dataFile.create(recursive: true);
    await dataFile.writeAsString(JSON.encode(data), flush: true);
    _dataChanged();
  }

  static Future<Null> deleteFormWithUid(String uid) async {
    await _initFuture;
    await new File("${_formsDir.path}/$uid.json").delete();
    _formsChanged();
  }

  static Future<Null> deleteAllForms() async {
    await _initFuture;
    await _formsDir.delete(recursive: true);
    await _formsDir.create();
    _formsChanged();
  }

  static Future<Null> deleteDataForTeam(int teamNumber) async {
    await _initFuture;
    await new Directory("${_dataDir.path}/$teamNumber").delete(recursive: true);
    _dataChanged();
  }

  static Future<Null> deleteAllData() async {
    await _initFuture;
    await for (FileSystemEntity f in _dataDir.list()) {
      f.delete(recursive: true);
    }
    _initDataTrackingFile().then((_) => _dataChanged());
  }
}