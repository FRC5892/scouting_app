import 'package:flutter/material.dart';

// TODO handle Firebase auth, etc.
class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Navigator.pushReplacementNamed(context, "/home"); // this crashes
    () async {
      Navigator.pushReplacementNamed(context, "/home");
    }();
    return const Text("Don't worry about this.");
  }
}