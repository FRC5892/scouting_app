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
    Map<String, dynamic> forms = await StorageManager.instance.getForms();
    await Future.wait(forms[MapKeys.FORM_LIST_NAME].map((Map<String, dynamic> form) {
      CollectionReference colRef = Firestore.instance.collection("data/$teamCode/${form[MapKeys.TEAM_NUMBER]}");
      return colRef.document(new Random().nextInt(4294967296).toString()).setData(form);
    }));
    await StorageManager.instance.clearForms();
    await _signOut(user);
  }

  Future<Null> getData() async => throw "TODO";

  Future<FirebaseUser> _signIn() async {
    print('FirebaseManager._signIn');
    SharedPreferences sPrefs = await SharedPreferences.getInstance();
    print("teamCode: ${sPrefs.getString("teamCode")}");
    print("teamPass: ${sPrefs.getString("teamPass")}");
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