import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

export 'widgets/screens/intro_screen.dart';
export 'widgets/screens/forms_home.dart';
export 'widgets/screens/data_home.dart';
export 'widgets/home_scaffold_ui.dart';

void main() {
  runApp(new MaterialApp(
    title: "FRC Scouting",
    theme: new ThemeData(
      primarySwatch: Colors.orange,
    ),
    home: new IntroScreen(),
    routes: <String, WidgetBuilder> {
      "/forms": (_) => new FormsHome(), // home for filling out forms
      "/data": (_) => new DataHome(), // home for viewing filled-out forms
    },
  ));
}