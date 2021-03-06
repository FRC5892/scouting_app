import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scouting_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseManager {
  static final FirebaseManager instance = new FirebaseManager._();

  FirebaseManager._();

  // assume only one instance of pushForms() or getData() will be running at a time.
  Future<Null> pushForms() async {
    FirebaseUser user = await _signIn();
    SharedPreferences sPrefs = await SharedPreferences.getInstance();
    String teamCode = sPrefs.getString(MapKeys.TEAM_CODE);
    await for (FormWithMetadata f in StorageManager.getForms()) {
      CollectionReference colRef = Firestore.instance.collection("data/$teamCode/${f.form[MapKeys.TEAM_NUMBER]}");
      f.form..[MapKeys.TIMESTAMP] = (f.timestamp.millisecondsSinceEpoch / 1000).truncate()
        ..remove(MapKeys.TEAM_NUMBER);
      await colRef.document(f.uid).setData(f.form);
    }
    await StorageManager.deleteAllForms();
    await _signOut();
  }

  Future<Null> getData() async {
    FirebaseUser user = await _signIn();
    SharedPreferences sPrefs = await SharedPreferences.getInstance();
    String teamCode = sPrefs.getString(MapKeys.TEAM_CODE);
    DocumentReference teamDocRef = Firestore.instance.document("data/$teamCode");
    List<dynamic> futureResults = await Future.wait(<Future> [
      StorageManager.getTrackedTeams(), StorageManager.getLastPullTimestamp()
    ]);
    List<int> teamNumbers = futureResults[0]; int lastPull = futureResults[1].millisecondsSinceEpoch;

    Iterable<Future> finished = teamNumbers.map((teamNumber) {
      Query query = teamDocRef.getCollection(teamNumber.toString())
          .where(MapKeys.TIMESTAMP, isGreaterThan: (lastPull / 1000).truncate());
      return query.snapshots.first..then(_saveDataFromSnapshotCallback(teamNumber));
    });
    await Future.wait(finished);

    await StorageManager.setLastPullTimestamp(new DateTime.now());
    await _signOut();
  }

  Function _saveDataFromSnapshotCallback(int teamNumber) {
    return (QuerySnapshot snapshot) {
      snapshot.documents.forEach((doc) {
        StorageManager.addData(doc.data..[MapKeys.TIMESTAMP] *= 1000, teamNumber, doc.documentID);
      });
    };
  }

  Future<FirebaseUser> _signIn() async {
    FirebaseUser user = await FirebaseAuth.instance.signInAnonymously();
    return user;
  }

  Future<Null> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}