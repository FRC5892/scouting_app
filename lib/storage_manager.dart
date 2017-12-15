import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:scouting_app/main.dart';

abstract class StorageManager {
  static File _forms; static Map<String, dynamic> _formsContent;
  static File _data; static Map<String, dynamic> _dataContent; // this might be a terrible idea.

  static Future<Null> _init() async {
    if (_forms != null) return;
    print('StorageManager._init');
    String dir = (await getApplicationDocumentsDirectory()).path;
    _forms = new File("$dir/forms.json");
    _data = new File("$dir/data.json");
    try {
      List<String> jsons = await Future.wait(<Future<String>>[
        _forms.readAsString(), _data.readAsString()
      ]);
      _formsContent = JSON.decode(jsons[0]);
      _dataContent = JSON.decode(jsons[1]);
    } on FileSystemException { // should handle creation
      print('StorageManager._init - creating files');
      _formsContent = <String, dynamic> {
        MapKeys.FORM_LIST_NAME: <Map<String, dynamic>> [],
      };
      _dataContent = <String, dynamic> {
        MapKeys.TRACKING_LIST_NAME: <int> [],
        MapKeys.DATA_MAP_NAME: <String, dynamic> {},
      };
      await _save();
    }
  }

  static Future<Null> _save({bool forms, bool data}) async {
    if (forms ?? (data == null))
      _forms.writeAsString(JSON.encode(_formsContent));
    if (data ?? (forms == null))
      _data.writeAsString(JSON.encode(_dataContent));
  }

  static Future<Map<String, dynamic>> getForms() async {
    print('StorageManager.getForms');
    await _init();
    return new Map<String, dynamic>.from(_formsContent);
  }

  static Future<Map<String, dynamic>> getData() async {
    await _init();
    return new Map<String, dynamic>.from(_dataContent);
  }

  static Future<Null> addForm(Map<String, dynamic> form) async {
    await _init();
    _formsContent["forms"].add(form);
  }

  static Future<Null> deleteEverything([bool doInit = false]) { // TODO get rid of this when done debugging
    return Future.wait(<Future> [
      _forms.delete(), _data.delete()
    ]).then((_) {if (doInit) _init();});
  }
}