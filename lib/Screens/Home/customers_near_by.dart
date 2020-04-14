import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:helpdesk_2/screens/authentication/provider_widget.dart';


class CustomersNearBy extends StatelessWidget {
  // final  _db = Firestore.instance;

  // DocumentReference doc = _db.document("users").

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder(
            stream: getCustomerDataStreamSnapshot(context),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return const Text(
                  "Loading...",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                );
              return new ListView.builder(
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
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance.collection("deskview").snapshots();
  }

  Widget buildCustomerCard(BuildContext context, DocumentSnapshot customer) {
    createDialogAlert(BuildContext context) {
      return showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return AlertDialog(
              title: Text("Contact Details"),
              content: Text("${customer['email']}"),
              elevation: 5.0,
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      print("Clipboard button pressed");
                      Clipboard.setData(ClipboardData(text: customer['email']));
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
                    backgroundImage:
                        NetworkImage(customer['photoURL'], scale: 0.2),
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
                              content: Text(
                                  "${customer['email']} copied to clipboard! "));
                          Scaffold.of(context).showSnackBar(mySnackBar);
                        });
                        print("Pressed contact button ");
                      },
                      child: Icon(Icons.perm_contact_calendar)),

                  subtitle: Text(
                    customer['skills'].toString(),
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
