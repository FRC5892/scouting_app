import 'package:flutter/material.dart';

import 'package:scouting_app/main.dart';

class DataHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: HomeScaffoldUI.makeAppBar(context),
      bottomNavigationBar: HomeScaffoldUI.makeNavBar(context, 1),
    );
  }
}