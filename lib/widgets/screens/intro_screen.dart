import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Navigator.pushReplacementNamed(context, "/home"); // this crashes
    () async {
      SharedPreferences sPrefs = await SharedPreferences.getInstance();
      if (sPrefs.getString(MapKeys.USER_NAME) == null)
        sPrefs.setString(MapKeys.USER_NAME, await showDialog(context: context, child: new TextEntryDialog("Enter name.")));
      Navigator.pushReplacementNamed(context, "/home");
    }();
    return const Scaffold();
  }
}