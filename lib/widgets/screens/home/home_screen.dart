import 'package:flutter/material.dart';

import 'package:scouting_app/main.dart';
import 'home_screen.dart';

export 'data_home.dart';
export 'forms_home.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FormsHome forms = new FormsHome();
  final DataHome data = new DataHome();

  int index = 0;

  @override
  Widget build(BuildContext context) {
    HomeView current = index == 0 ? forms : data;
    return new Scaffold(
      appBar: new AppBar(
        key: const Key("HomeScreenAppBar"),
        title: const Text("FRC Scouting"),
        actions: current.actions(context),
      ),
      body: current.body(context),
      bottomNavigationBar: new BottomNavigationBar(
        key: const Key("HomeNavigationBar"),
        currentIndex: index,
        items: <BottomNavigationBarItem> [
          const BottomNavigationBarItem(icon: const Icon(Icons.format_list_bulleted), title: const Text("Forms")), // TODO find good icons
          const BottomNavigationBarItem(icon: const Icon(Icons.insert_chart), title: const Text("Data")),
        ],
        onTap: (int value) => setState(() => index = value),
      ),
    );
  }
}

abstract class HomeView {
  List<Widget> actions(BuildContext context);
  Widget body(BuildContext context);
}