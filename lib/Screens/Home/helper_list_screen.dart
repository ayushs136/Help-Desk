import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpdesk_2/models/customer.dart';
import 'package:intl/intl.dart';
import 'package:helpdesk_2/screens/authentication/provider_widget.dart';

class CustomersNearBy extends StatefulWidget {
  // final  _db = Firestore.instance;

  // DocumentReference doc = _db.document("users").

  @override
  _CustomersNearByState createState() => _CustomersNearByState();
}

class _CustomersNearByState extends State<CustomersNearBy> {
  List<Customer> helperList;
  String urlTemp = "https://www.clipartmax.com/png/middle/271-2719453_korea-circle-person-icon-png.png";
  @override
  Widget build(BuildContext context) {
    //   return Scaffold(
    //     body: Container(
    //       child: buildCustomerCard(context),
    //     ),
    //   );
    // }
    return Container(
        child: StreamBuilder(
            stream: getCustomerDataStreamSnapshot(context),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return const Text(
                  "Loading...",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                );
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildCustomerCard(
                      context, snapshot.data.documents[index]);
                },
              );
            }));
  }

  Stream<QuerySnapshot> getCustomerDataStreamSnapshot(
      BuildContext context) async* {
    // final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance.collection("userData").snapshots();
  }

  Future<List<Customer>> fetchAllUsers(FirebaseUser currentUser) async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("userData").getDocuments();

    List<Customer> helperList = List<Customer>();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        helperList.add(Customer.fromMap(querySnapshot.documents[i].data));
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
      fetchAllUsers(user).then((List<Customer> list) {
        setState(() {
          helperList = list;
        });
        print(helperList);
      });
    });
  }

  // return ListView.builder(
  //   itemCount: helperList.length,
  //   itemBuilder: (context, index) {
  //     Customer helper = Customer(
  //         uid: helperList[index].uid,
  //         email: helperList[index].email,
  //         name: helperList[index].name,
  //         photoURL: helperList[index].photoURL,
  //         isAvailable: helperList[index].isAvailable,
  //         skills: helperList[index].skills);

  //     return
  Widget buildCustomerCard(BuildContext context, DocumentSnapshot customer) {
    createDialogAlert(BuildContext context) {
      return showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return AlertDialog(
              title: Text("Contact Details"),
              content: Text(
                  "${(customer['email'] == null) ? 'N/A' : customer['email']}"),
              elevation: 5.0,
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      print("Clipboard button pressed");
                      Clipboard.setData(ClipboardData(
                          text:
                              "${(customer['email'] == null) ? 'N/A' : customer['email']}"));
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.content_copy),
                    label: Text("Copy to clipboard")),
              ],
            );
          });
    }

    return new Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: FlatButton(
        onPressed: () {},
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
                        "${(customer['photoURL'] == null) ? urlTemp : customer['photoURL']}",
                        scale: 0.2),
                    maxRadius: 20,
                  ),
                  title: Text(
                    "${(customer['name'] == null) ? 'N/A' : customer['name']}",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),

                  trailing: FlatButton(
                      onPressed: () {
                        createDialogAlert(context).then((onValue) {
                          SnackBar mySnackBar = SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text(
                                  "${(customer['email'] == null) ? 'N/A' : customer['email']} copied to clipboard! "));
                          Scaffold.of(context).showSnackBar(mySnackBar);
                        });
                        print("Pressed contact button ");
                      },
                      child: Icon(Icons.perm_contact_calendar)),

                  subtitle: Text(
                    "${(customer['skills'] == null) ? 'N/A' : customer['skills'].toString()}",
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
