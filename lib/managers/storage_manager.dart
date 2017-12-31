import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'package:scouting_app/main.dart';

class StorageManager {
  static final Future<Null> _initFuture = _init();

  static Directory _formsDir;
  static Directory _dataDir;
  // the analyzer is complaining that i need to close these... when?
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
        new File("$rootDir/data/tracking.csv").create(),
      ]);
    }
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
    return (await new File("${_dataDir.path}/tracking.csv").readAsString())
        .split(',').map(int.parse);
    // remember that there is a good package out there if the csv gets any more involved.
  }

  static Stream<Map<String, dynamic>> getDataForTeam(int teamNumber) async* {
    await _initFuture;
    Directory teamDir = new Directory("${_dataDir.path}/$teamNumber");
    if (await teamDir.exists()) {
      await for (FileSystemEntity f in teamDir.list()) {
        if (f is File) {
          yield JSON.decode(await f.readAsString());
        }
      }
    }
  }

  static Future<Null> addForm(Map<String, dynamic> form) async {
    await _initFuture;
    String uid = randomUID();
    await new File("${_formsDir.path}/$uid.json").writeAsString(JSON.encode(form), flush: true);
    _formsChanged();
  }

  static Future<Null> deleteAllForms() async {
    await _initFuture;
    await for (FileSystemEntity f in _formsDir.list()) {
      f.delete(recursive: true);
    }
    _formsChanged();
  }

  static Future<Null> deleteAllData() async {
    await _initFuture;
    await for (FileSystemEntity f in _dataDir.list()) {
      f.delete(recursive: true);
    }
    await new File("${_dataDir.path}/tracking.csv").create();
    _dataChanged();
  }
}

// TODO move all dis
class FormWithMetadata {
  final Map<String, dynamic> form;
  final String uid;
  final DateTime timestamp;
  FormWithMetadata(this.form, {this.uid, this.timestamp});
}

String randomUID() => new Random().nextInt(4294967296).toString();