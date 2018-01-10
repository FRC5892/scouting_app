import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scouting_app/main.dart';

export 'constants.dart';
export 'data_utils/number_crunching.dart';
export 'data_utils/number_crunching_isolate.dart';
export 'managers/firebase_manager.dart';
export 'managers/storage_manager.dart';
export 'widgets/dialogs/team_number_entry_dialog.dart';
export 'widgets/dialogs/text_alert_dialog.dart';
export 'widgets/dialogs/working_dialogs.dart';
export 'widgets/dialogs/yesno_alert_dialog.dart';
export 'widgets/forms/forms.dart';
export 'widgets/screens/data/team_data_view_screen.dart';
export 'widgets/screens/data/team_tracking_manage_screen.dart';
export 'widgets/screens/home/home_screen.dart';
export 'widgets/screens/intro_screen.dart';
export 'widgets/misc/list_header.dart';

void main() {
  //debugPaintSizeEnabled = true; // import the flutter rendering library
  runApp(new MaterialApp(
    title: "FRC Scouting",
    theme: new ThemeData(
      primarySwatch: Colors.orange,
      accentColor: Colors.orangeAccent,
    ),
    home: new IntroScreen(),
    routes: <String, WidgetBuilder> {
      "/home": (_) => new HomeScreen(),
      "/data/manageTeams": (_) => new TeamTrackingManagementScreen(),
    },
  ));
}