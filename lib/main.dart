import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

export 'constants.dart';
export 'managers/storage_manager.dart';
export 'managers/firebase_manager.dart';
export 'widgets/forms/forms.dart';
export 'widgets/dialogs/team_number_entry_dialog.dart';
export 'widgets/dialogs/yesno_alert_dialog.dart';
export 'widgets/screens/home/home_screen.dart';
export 'widgets/screens/intro_screen.dart';
export 'widgets/dialogs/working_dialogs.dart';
export 'widgets/screens/data/team_tracking_manage_screen.dart';

void main() {
  runApp(new MaterialApp(
    title: "FRC Scouting",
    theme: new ThemeData(
      primarySwatch: Colors.orange,
    ),
    home: new IntroScreen(),
    routes: <String, WidgetBuilder> {
      "/home": (_) => new HomeScreen(),
      "/data/manageTeams": (_) => new TeamTrackingManagementScreen(),
    },
  ));
}