import 'package:flutter/material.dart';
import 'forms.dart';

export 'form_types.dart';
export 'form_views.dart';
export 'form_fields.dart';

export 'fields/integer_field.dart';

export 'forms/test_form.dart';

class FRCFormTypeManager {
  static final FRCFormTypeManager instance = new FRCFormTypeManager._();
  FRCFormTypeManager._() {
    // register forms
    new TestForm();
  }

  Map<String, FRCFormType> _formTypes;

  void register(FRCFormType formType) {
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
}