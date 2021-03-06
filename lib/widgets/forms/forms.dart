import 'dart:math';

import 'package:flutter/material.dart';

import 'forms.dart';

export 'package:scouting_app/data_utils/number_crunching.dart';
export 'package:scouting_app/constants.dart';

export 'fields/boolean_field.dart';
export 'fields/integer_field.dart';
export 'fields/text_field.dart';
export 'form_fields.dart';
export 'form_types.dart';
export 'form_views.dart';
export 'forms/test_form.dart';
export 'forms/pit_form.dart';
export 'forms/match_form.dart';

class FRCFormTypeManager {
  static final FRCFormTypeManager instance = new FRCFormTypeManager._();

  Map<String, FRCFormType> _formTypes = new Map<String, FRCFormType>();

  FRCFormTypeManager._() {
    _register(new TestForm());
    _register(new PitForm());
    _register(new MatchForm());
  }

  void _register(FRCFormType formType) {
    if (_formTypes.containsKey(formType.codeName))
      throw "Duplicate form code name: ${formType.codeName}";
    _formTypes[formType.codeName] = formType;
  }
  
  void fillForm(BuildContext context, String codeName, int teamNumber) {
    FRCFormType type = _formTypes[codeName];
    Navigator.push(context, new MaterialPageRoute(builder: (_) =>
      new FRCFormFillView(type.title(teamNumber), teamNumber, type)
    ));
  }
  
  void editForm(BuildContext context, Map<String, dynamic> form, String uid) {
    FRCFormType type = _formTypes[form[MapKeys.FORM_TYPE]];
    int teamNumber = form[MapKeys.TEAM_NUMBER];
    Navigator.push(context, new MaterialPageRoute(builder: (_) =>
      new FRCFormFillView(type.title(teamNumber), teamNumber, type, form, uid)));
  }

  FRCFormType getTypeByCodeName(String codeName) => _formTypes[codeName];
}

class FormWithMetadata {
  final Map<String, dynamic> form;
  final String uid;
  final DateTime timestamp;
  FormWithMetadata(this.form, {this.uid, this.timestamp});
}

String randomUID() => new Random().nextInt(4294967296).toString();