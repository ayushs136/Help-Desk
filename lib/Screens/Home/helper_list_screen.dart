import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpdesk_2/models/helper.dart';
import 'package:helpdesk_2/screens/home/UpdateSkills.dart';
import 'package:helpdesk_2/screens/home/helpers_profile.dart';
import 'package:helpdesk_2/screens/home/user_profile.dart';

import 'package:intl/intl.dart';
import 'package:helpdesk_2/screens/authentication/provider_widget.dart';

class HelpersNearBy extends StatefulWidget {
  // final  _db = Firestore.instance;

  // DocumentReference doc = _db.document("users").

  @override
  _HelpersNearByState createState() => _HelpersNearByState();
}

class _HelpersNearByState extends State<HelpersNearBy> {
  List<Helper> helperList;
  String urlTemp =
      "https://www.clipartmax.com/png/middle/271-2719453_korea-circle-person-icon-png.png";
  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder(
            stream: getHelperDataStreamSnapshot(context),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator());
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildHelperCard(
                      context, snapshot.data.documents[index]);
                },
              );
            }));
  }

  Stream<QuerySnapshot> getHelperDataStreamSnapshot(
      BuildContext context) async* {
    // final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance.collection("userData").snapshots();
  }

  Future<List<Helper>> fetchAllUsers(FirebaseUser currentUser) async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("userData").getDocuments();

    List<Helper> helperList = List<Helper>();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
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
  Widget buildHelperCard(
      BuildContext context, DocumentSnapshot HelperDocument) {
    createDialogAlert(BuildContext context) {
      return showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return AlertDialog(
              title: Text("Contact Details"),
              content: Text(
                  "${(HelperDocument['email'] == null) ? 'N/A' : HelperDocument['email']}"),
              elevation: 5.0,
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      print("Clipboard button pressed");
                      Clipboard.setData(ClipboardData(
                          text:
                              "${(HelperDocument['email'] == null) ? 'N/A' : HelperDocument['email']}"));
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.content_copy),
                    label: Text("Copy to clipboard")),
              ],
            );
          });
    }
Helper helper;
    return new Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: FlatButton(
        onPressed: () {
          print("${HelperDocument['uid']}");
          
          // helper = new Helper(
          //   email: HelperDocument['email'],
          //   isAvailable: HelperDocument['isAvailable'],
          //   name: HelperDocument['name'],
          //   phone: HelperDocument['phone'],
          //   photoURL: HelperDocument['photoURL'],
          //   skills: HelperDocument['skills'],
          //   uid: HelperDocument['uid'],
          // );

          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
            Scaffold(
              body: HelperProfile(helper: Helper.fromMap(HelperDocument.data)),
            )
          
          
          ));
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
                    backgroundImage: NetworkImage(
                        "${(HelperDocument['photoURL'] == null) ? urlTemp : HelperDocument['photoURL']}",
                        // "${Helper['photoURL']}",
                        scale: 0.2),
                    maxRadius: 20,
                  ),
                  title: Text(
                    "${(HelperDocument['name'] == null) ? 'N/A' : HelperDocument['name']}",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),

                  trailing: FlatButton(
                      onPressed: () {
                        createDialogAlert(context).then((onValue) {
                          SnackBar mySnackBar = SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text(
                                  "${(HelperDocument['email'] == null) ? 'N/A' : HelperDocument['email']} copied to clipboard! "));
                          Scaffold.of(context).showSnackBar(mySnackBar);
                        });
                        print("Pressed contact button ");
                      },
                      child: Icon(Icons.perm_contact_calendar)),

                  subtitle: Text(
                    "${(HelperDocument['skills'] == null) ? 'N/A' : HelperDocument['skills'].toString()}",
                    style: TextStyle(fontSize: 13, color: Colors.white),
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
