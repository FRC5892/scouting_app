import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

export 'widgets/screens/intro_screen.dart';
export 'widgets/screens/home/home_screen.dart';

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