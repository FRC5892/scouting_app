import 'dart:async';
import 'dart:math';
import 'package:scouting_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      f.form..[MapKeys.TIMESTAMP] = f.timestamp.millisecondsSinceEpoch
        ..remove(MapKeys.TEAM_NUMBER);
      await colRef.document(f.uid).setData(f.form);
    }
    await StorageManager.deleteAllForms();
    await _signOut(user);
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
          .where(MapKeys.TIMESTAMP, isGreaterThan: lastPull);
      return query.snapshots.first..then(_saveDataFromSnapshot);
    });
    await Future.wait(finished);

    await _signOut(user);
  }

  void _saveDataFromSnapshot(QuerySnapshot snapshot) {
    snapshot.documents.forEach((doc) {
      print("found a document: ${doc.data}");
      StorageManager.addData(doc.data, doc.documentID);
    });
  }

  Future<FirebaseUser> _signIn() async {
    SharedPreferences sPrefs = await SharedPreferences.getInstance();
    FirebaseUser user = await FirebaseAuth.instance.signInAnonymously();
    /*Map<String, dynamic> userData = <String, dynamic> {
      "teamPass": sPrefs.getString(MapKeys.TEAM_PASS),
      "timestamp": new DateTime.now().millisecondsSinceEpoch,
    };
    await Firestore.instance.document("users/${user.uid}").setData(userData);*/
    return user;
  }

  Future<Null> _signOut(FirebaseUser user) async {
    //await Firestore.instance.document("users/${user.uid}").delete();
    await FirebaseAuth.instance.signOut();
  }
}