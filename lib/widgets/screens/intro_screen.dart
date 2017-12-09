import 'package:flutter/material.dart';

// TODO handle Firebase auth, etc.
class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Navigator.pushReplacementNamed(context, "/forms"); // this crashes
    (BuildContext context) async { // this is so stupid. why does this work.
      Navigator.pushReplacementNamed(context, "/forms"); // i actually do know why it works.
    }(context); // this does not make it any less dumb. TODO find less dumb solution
    return const Text("Don't worry about this.");
  }
}