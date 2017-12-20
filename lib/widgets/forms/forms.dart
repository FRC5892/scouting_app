import 'package:flutter/material.dart';
import 'forms.dart';

export 'form_types.dart';
export 'form_views.dart';
export 'form_fields.dart';

// move/refactor maybe? meh.
typedef Widget ParameterWidgetBuilder<T>(BuildContext context, T value);

class FRCFormTypeManager {
  static final FRCFormTypeManager instance = new FRCFormTypeManager._();
  FRCFormTypeManager._();

  Map<String, FRCFormType> _formTypes;

  void register(FRCFormType formType) {
    if (_formTypes.containsKey(formType.codeName))
      throw "Duplicate form code name: ${formType.codeName}";
    _formTypes[formType.codeName] = formType;
  }
}