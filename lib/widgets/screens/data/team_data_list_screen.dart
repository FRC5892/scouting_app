import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

class TeamDataListScreen extends StatelessWidget {
  final int teamNumber;
  TeamDataListScreen(this.teamNumber);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Data for $teamNumber"),
      ),
      body: new FutureBuilder(
        future: StorageManager.getDataForTeam(teamNumber).toList(),
        builder: (BuildContext context, AsyncSnapshot<List<FormWithMetadata>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none: return const Text("Something went wrong.");
            case ConnectionState.waiting: return const Text("Loading...");
            default:
              if (snapshot.hasError) return const Text("Something went wrong.");
              return new _TeamDataList(snapshot.data, teamNumber);
          }
        }
      ),
    );
  }
}

class _TeamDataList extends StatelessWidget {
  final List<FormWithMetadata> data;
  final int teamNumber;
  _TeamDataList(this.data, this.teamNumber);

  @override
  Widget build(BuildContext context) {
    List<_FormMetaEntry> formMeta = data.map((f) {
      FRCFormType type = FRCFormTypeManager.instance.getTypeByCodeName(f.form[MapKeys.FORM_TYPE]);
      return new _FormMetaEntry(
        title: type.title(teamNumber),
        author: f.form[MapKeys.USER_NAME],
        uid: f.uid,
        timestamp: f.timestamp,
        type: type,
      );
    }).toList();
    return new ListView.builder(
      itemCount: formMeta.length,
      itemBuilder: (BuildContext context, int index) {
        index = formMeta.length - index - 1;
        _FormMetaEntry meta = formMeta[index];
        return new ListTile(
          title: new Text(meta.title),
          trailing: new Text("${dateTimeToReasonableString(meta.timestamp)} by ${meta.author}"),
          onTap: () async {
            FormWithMetadata f = await StorageManager.getDataWithUid(teamNumber, meta.uid);
            Navigator.push(context, new MaterialPageRoute(builder: (_) =>
              new FRCFormDataView(meta.title, f.form, meta.type)
            ));
          },
        );
      },
    );
  }
}

class _FormMetaEntry {
  final String title;
  final String author;
  final String uid;
  final DateTime timestamp;
  final FRCFormType type;
  const _FormMetaEntry({this.title, this.author, this.uid, this.timestamp, this.type});
}