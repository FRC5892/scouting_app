import 'package:flutter/material.dart';

// TODO handle Firebase auth, etc.
class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Navigator.pushReplacementNamed(context, "/home"); // this crashes
    (BuildContext context) async { // this is so stupid.
      Navigator.pushReplacementNamed(context, "/home");
    }(context); // TODO find less dumb solution
    return const Text("Don't worry about this.");
  }
}