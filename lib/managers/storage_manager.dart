import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:scouting_app/main.dart';

class StorageManager {
  static final StorageManager instance = new StorageManager._();

  File _forms; Map<String, dynamic> _formsContent; // this might be a terrible idea.
  File _data; Map<String, dynamic> _dataContent; // it could take up a lot of memory,
  // though reading from the file every time might be equally dumb.

  Future<Null> _initFuture;
  StreamController<Map<String, dynamic>> _formsChangeController;
  StreamController<Map<String, dynamic>> _dataChangeController;

  StorageManager._() {
    _initFuture = _init();
    _formsChangeController = new StreamController<Map<String, dynamic>>.broadcast();
    _dataChangeController = new StreamController<Map<String, dynamic>>.broadcast();
  }

  Stream<Map<String, dynamic>> get formsStream => _formsChangeController.stream;
  Stream<Map<String, dynamic>> get dataStream => _dataChangeController.stream;

  Future<Null> _init() async {
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
      await Future.wait(<Future<Null>>[clearForms(), clearData()]);
    }
  }

  Future<Null> clearForms() {
    _formsContent = <String, dynamic> {
      MapKeys.FORM_LIST_NAME: <Map<String, dynamic>> [],
    };
    formsChanged();
    return _save(forms: true);
  }

  Future<Null> clearData() {
    _dataContent = <String, dynamic> {
      MapKeys.LAST_GET_TIMESTAMP_NAME: 0,
      MapKeys.TRACKING_LIST_NAME: <int> [],
      MapKeys.DATA_MAP_NAME: <String, dynamic> {},
    };
    return _save(data: true);
  }

  void formsChanged() {
    _formsChangeController.add(new Map.from(_formsContent));
  }

  void dataChanged() {
    _dataChangeController.add(new Map.from(_dataContent));
  }

  Future<Null> _save({bool forms, bool data}) async {
    if (forms ?? (data == null))
      _forms.writeAsString(JSON.encode(_formsContent), flush: true); // TODO flush when app closed
    if (data ?? (forms == null))
      _data.writeAsString(JSON.encode(_dataContent), flush: true);
  }

  Future<Map<String, dynamic>> getForms() async {
    await _initFuture;
    return new Map<String, dynamic>.from(_formsContent);
  }

  Future<Map<String, dynamic>> getData() async {
    await _initFuture;
    return new Map<String, dynamic>.from(_dataContent);
  }

  Future<Null> addForm(Map<String, dynamic> form) async {
    await _initFuture;
    _formsContent["forms"].add(form);
    formsChanged();
    _save(forms: true);
  }
}