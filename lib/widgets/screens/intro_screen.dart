import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scouting_app/main.dart';

// TODO handle getting teamCode, teamPass, userName
class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Navigator.pushReplacementNamed(context, "/home"); // this crashes
    () async {
      await SharedPreferences.getInstance()
        ..setString(MapKeys.TEAM_CODE, "someTeamCode")
        ..setString(MapKeys.TEAM_PASS, "someTeamPass")
        ..setString(MapKeys.USER_NAME, "Tom John");
      Navigator.pushReplacementNamed(context, "/home");
    }();
    return const Text("Don't worry about this.");
  }
}