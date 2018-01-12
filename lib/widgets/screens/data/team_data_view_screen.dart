import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

class TeamDataViewScreen extends StatelessWidget {
  final int teamNumber;
  TeamDataViewScreen(this.teamNumber);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Team $teamNumber Reports"),
        actions: <Widget> [
          new IconButton(
            icon: const Icon(Icons.format_list_bulleted),
            onPressed: () => Navigator.push(context, new MaterialPageRoute(builder: (_) =>
              new TeamDataListScreen(teamNumber)
            )),
            tooltip: "View individual forms",
          ),
        ],
      ),
      body: new Column(
        children: <Widget>[
          new TeamNumberHeader(teamNumber),
          new FutureBuilder(
            future: StorageManager.getReportsForTeam(teamNumber),
            builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none: return const Text("Something went wrong.");
                case ConnectionState.waiting: return const Text("Loading...");
                default:
                  if (snapshot.hasError) return new Text(snapshot.error);
                  return new TeamReportsView(snapshot.data);
              }
            },
          ),
        ],
      ),
    );
  }
}

class TeamNumberHeader extends StatelessWidget {
  final int teamNumber;
  TeamNumberHeader(this.teamNumber);

  static TextStyle wordTeamStyle(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return new TextStyle(
      fontSize: 24.0,
      color: themeData.textTheme.caption.color
    );
  }

  static TextStyle numberStyle(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return new TextStyle(
      fontSize: 96.0,
      color: themeData.accentColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 35.0),
      alignment: AlignmentDirectional.centerEnd,
      constraints: const BoxConstraints(),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 15.0, 0.0),
            child: new Text("Team", style: wordTeamStyle(context)),
          ),
          new Text(teamNumber.toString(), style: numberStyle(context)),
        ],
      ),
    );
  }
}

class TeamReportsView extends StatefulWidget {
  final Map<String, dynamic> reports;
  TeamReportsView(this.reports);

  @override
  _TeamReportsViewState createState() => new _TeamReportsViewState();
}

class _TeamReportsViewState extends State<TeamReportsView> {
  int expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.all(15.0),
      child: new ExpansionPanelList(
        expansionCallback: (int panelIndex, bool isExpanded) => setState(() => expandedIndex = isExpanded ? -1 : panelIndex),
        children: <ExpansionPanel>[
          _makeReportPanel("Pit Interviews", "pitForm", expandedIndex == 0, widget.reports),
          _makeReportPanel("Match Statistics", "matchForm", expandedIndex == 1, widget.reports)
        ],
      ),
    );
  }
}

ExpansionPanel _makeReportPanel(String title, String formType, bool isExpanded, Map<String, dynamic> reports) {
  return new ExpansionPanel(
    headerBuilder: (BuildContext context, bool expanded) => new Container(
      alignment: AlignmentDirectional.center,
      child: new Text(title, style: Theme.of(context).textTheme.title),
    ),
    body: new Container(
      constraints: const BoxConstraints(maxHeight: 290.0), // height assumes two reports per team. change if necessary.
      child: new FRCFormReportView(reports, FRCFormTypeManager.instance.getTypeByCodeName(formType)),
    ),
    isExpanded: isExpanded,
  );
}