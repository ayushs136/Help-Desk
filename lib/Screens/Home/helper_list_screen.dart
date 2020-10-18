import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpdesk_2/data/db/models/helper.dart';

import 'package:helpdesk_2/screens/home/helpers_profile.dart';

// import 'package:intl/intl.dart';

class HelpersNearBy extends StatefulWidget {
  // final  _db = Firestore.instance;

  // DocumentReference doc = _db.document("users").

  @override
  _HelpersNearByState createState() => _HelpersNearByState();
}

class _HelpersNearByState extends State<HelpersNearBy> {
  List<Helper> helperList;
  String urlTemp = "https://www.clipartmax.com/png/middle/271-2719453_korea-circle-person-icon-png.png";

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder(
            stream: getHelperDataStreamSnapshot(context),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container(alignment: Alignment.center, child: CircularProgressIndicator());
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildHelperCard(context, snapshot.data.documents[index]);
                },
              );
            }));
  }

  Stream<QuerySnapshot> getHelperDataStreamSnapshot(BuildContext context) async* {
    // final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance.collection("userData").where("isAvailable", isEqualTo: true).orderBy("name").snapshots();
  }

  Future<List<Helper>> fetchAllUsers(FirebaseUser currentUser) async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection("userData").getDocuments();

    List<Helper> helperList = List<Helper>();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid && querySnapshot.documents[i].data['isAvailable'] == true) {
        helperList.add(Helper.fromMap(querySnapshot.documents[i].data));
      }
    }

    return helperList;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await FirebaseAuth.instance.currentUser();
    return currentUser;
  }

  @override
  void initState() {
    super.initState();

    getCurrentUser().then((FirebaseUser user) {
      fetchAllUsers(user).then((List<Helper> list) {
        setState(() {
          helperList = list;
        });
        // print(helperList);
      });
    });
  }

  // return ListView.builder(
  //   itemCount: helperList.length,
  //   itemBuilder: (context, index) {
  //     Helper helper = Helper(
  //         uid: helperList[index].uid,
  //         email: helperList[index].email,
  //         name: helperList[index].name,
  //         photoURL: helperList[index].photoURL,
  //         isAvailable: helperList[index].isAvailable,
  //         skills: helperList[index].skills);

  //     return
  Widget buildHelperCard(BuildContext context, DocumentSnapshot helperDocument) {
    createDialogAlert(BuildContext context) {
      return showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return AlertDialog(
              title: Text("Contact Details"),
              content: Text("${(helperDocument['email'] == null) ? 'N/A' : helperDocument['email']}"),
              elevation: 5.0,
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      print("Clipboard button pressed");
                      Clipboard.setData(ClipboardData(text: "${(helperDocument['email'] == null) ? 'N/A' : helperDocument['email']}"));
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.content_copy),
                    label: Text("Copy to clipboard")),
              ],
            );
          });
    }

    return new Container(
      decoration: BoxDecoration(),
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: FlatButton(
        onPressed: () {
          // helper = new Helper(
          //   email: helperDocument['email'],
          //   isAvailable: helperDocument['isAvailable'],
          //   name: helperDocument['name'],
          //   phone: helperDocument['phone'],
          //   photoURL: helperDocument['photoURL'],
          //   skills: helperDocument['skills'],
          //   uid: helperDocument['uid'],
          // );
          // final uid = Provider.of(context).auth.getCurrentUID();
          // print("${helperDocument['uid']}");
          // String uid1 = Firestore.instance.collection("userData").document(getCurrentUser().uid).documentID;

          // if (helperDocument['uid'] == uid) {
          //  Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) =>UserProfile()));
          // } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Scaffold(
                    body: HelperProfile(helper: Helper.fromMap(helperDocument.data)),
                  )));
          // }
        },
        child: Card(
          color: Color(0xff054640),
          elevation: 30,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: ListTile(
                  // children: <Widget>[
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage("${(helperDocument['photoURL'] == null) ? urlTemp : helperDocument['photoURL']}",
                        // "${Helper['photoURL']}",
                        scale: 0.2),
                    maxRadius: 20,
                  ),
                  title: Text(
                    "${(helperDocument['name'] == null) ? 'N/A' : helperDocument['name'].toString().toUpperCase()}",
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                  ),

                  trailing: FlatButton(
                      onPressed: () {
                        createDialogAlert(context).then((onValue) {
                          SnackBar mySnackBar = SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text("${(helperDocument['email'] == null) ? 'N/A' : helperDocument['email']} copied to clipboard! "));
                          Scaffold.of(context).showSnackBar(mySnackBar);
                        });
                        print("Pressed contact button ");
                      },
                      child: Icon(Icons.perm_contact_calendar)),

                  subtitle: Text(
                    "${(helperDocument['skills'] == null) ? 'N/A' : (helperDocument['skills'][0]) + '\n' + helperDocument['skills'][1] + '\n' + helperDocument['skills'][2] + '\n' + helperDocument['skills'][3]}",
                    style: TextStyle(fontSize: 13, color: Colors.amber, fontWeight: FontWeight.w300),
                  ),

                  // ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  children: <Widget>[],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
