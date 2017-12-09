import 'package:flutter/material.dart';

class HomeScaffoldUI {
  static const Map<int, String> ROUTE_NAMES = const {
    0: "/forms", 1: "/data"
  };

  static AppBar makeAppBar(BuildContext context, {List<Widget> actions}) {
    return new AppBar(
      key: const Key("HomeAppBar"),
      title: const Text("FRC Scouting"),
      actions: actions,
    );
  }

  static BottomNavigationBar makeNavBar(BuildContext context, int index) {
    return new BottomNavigationBar(
      key: const Key("HomeNavigationBar"),
      currentIndex: index,
      items: <BottomNavigationBarItem> [
        const BottomNavigationBarItem(icon: const Icon(Icons.crop_landscape), title: const Text("Forms")), // TODO find icons
        const BottomNavigationBarItem(icon: const Icon(Icons.ac_unit), title: const Text("Data")),
      ],
      onTap: (int value) => Navigator.pushReplacementNamed(context, ROUTE_NAMES[value]), // TODO this looks stupid
    );
  }
}