import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

export 'constants.dart';
export 'managers/storage_manager.dart';
export 'managers/firebase_manager.dart';
export 'widgets/forms/forms.dart';
export 'widgets/screens/home/home_screen.dart';
export 'widgets/screens/intro_screen.dart';
export 'widgets/dialogs/pushing_dialog.dart';

void main() {
  runApp(new MaterialApp(
    title: "FRC Scouting",
    theme: new ThemeData(
      primarySwatch: Colors.orange,
    ),
    home: new IntroScreen(),
    routes: <String, WidgetBuilder> {
      "/home": (_) => new HomeScreen(),
    },
  ));
}