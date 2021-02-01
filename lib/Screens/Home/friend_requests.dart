import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_shift/models/helper.dart';
import 'package:helpdesk_shift/screens/home/addPost.dart';
import 'package:helpdesk_shift/screens/home/helpers_profile.dart';
import 'package:timeago/timeago.dart' as tAgo;

class FriendRequests extends StatefulWidget {
  @override
  _FriendRequestsState createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> {
  Stream requestStream;
  String onlineUser;
  List requestList;

  var userCollection = FirebaseFirestore.instance.collection('userData');
  initState() {
    super.initState();
    getCurrentUserUid();
    getrequestStream();
  }

  getCurrentUserUid() async {
    var firebaseuser = FirebaseAuth.instance.currentUser;
    setState(() {
      onlineUser = firebaseuser.uid;
    });
  }

  getrequestStream() async {
    // var userDoc = userCollection.doc(onlineUser).get().then((value) => {
    //       setState(() {
    //         List.from(value.data()['followRequest']).forEach((element) {
    //           //then add the data to the List<Offset>, now we have a type Offset
    //           requestList.add(element);
    //         });
    //       })
    //     });

    // print(requestList);
    var followRequestDoc = userCollection
        .doc(onlineUser)
        .collection('followRequest')
        .orderBy('time', descending: true)
        .snapshots();

    setState(() {
      requestStream = followRequestDoc;
    });
  }

  acceptRequest(String uid) async {
    var usernamedoc = await userCollection.doc(onlineUser).get();

    userCollection
        .doc(onlineUser)
        .collection('followRequest')
        .doc(uid)
        .delete();

    var documentFollow = await userCollection
        .doc(onlineUser)
        .collection('FriendsList')
        .doc(uid)
        .get();

    if (!documentFollow.exists) {
      userCollection.doc(onlineUser).collection('FriendsList').doc(uid).set({
        'friendUid': uid,
        'timeOfConnection': DateTime.now(),
        'name': usernamedoc.data()['name'].toString(),
        'photoURL': usernamedoc.data()['photoURL'].toString(),
      });
      setState(() {});

      userCollection.doc(uid).collection('FriendsList').doc(onlineUser).set({
        'friendUid': onlineUser,
        'timeOfConnection': DateTime.now(),
        'name': usernamedoc.data()['name'].toString(),
        'photoURL': usernamedoc.data()['photoURL'].toString(),
      });
    }
  }

  deleteRequest(String uid) async {
    userCollection
        .doc(onlineUser)
        .collection('followRequest')
        .doc(uid)
        .delete();
    userCollection.doc(onlineUser).update({
      'followRequest': FieldValue.arrayRemove([uid]),
    });
    userCollection.doc(onlineUser).update({
      'FriendsList': FieldValue.arrayUnion([uid]),
    });
    userCollection.doc(uid).update({
      'FriendsList': FieldValue.arrayUnion([onlineUser]),
    });
    setState(() {
      // isSent = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder(
          stream: requestStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text(
                      "Getting Requests...",
                      style: myStyle(20, Colors.black),
                    )
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot requestDoc = snapshot.data.docs[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HelperProfile(
                                helper: Helper.fromMap(requestDoc.data()))));
                  },
                  child: Column(
                    children: [
                      Card(
                        color: Colors.grey[900],
                        child: ListTile(
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  // sendRequest(requestDoc.data()['uid']);
                                },
                                child: Container(
                                  // padding: const EdgeInsets.only(left: 2.0),
                                  // padding: const EdgeInsets.all(.0),

                                  width: 100,
                                  // height: 35,

                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.check_circle_outline,
                                            color: Colors.green[400]),
                                        onPressed: () {
                                          acceptRequest(
                                              requestDoc.data()['senderUid']);
                                        },
                                      ),
                                      // SizedBox(width: 5),
                                      IconButton(
                                        icon: Icon(Icons.cancel_outlined,
                                            color: Colors.red[400]),
                                        onPressed: () {
                                          deleteRequest(
                                              requestDoc.data()['senderUid']);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          leading: Container(
                            padding: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    right: new BorderSide(
                                        width: 1.0, color: Colors.white24))),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  NetworkImage(requestDoc.data()['photoURL']),
                            ),
                          ),
                          title: Column(
                            children: [
                              Text(
                                requestDoc.data()['name'].toUpperCase(),
                                style:
                                    myStyle(10, Colors.yellow, FontWeight.bold),
                              ),
                              Text(
                                "wants to be your friend! Would you mind accepting their invitaion?",
                                style:
                                    myStyle(10, Colors.white, FontWeight.w300),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              tAgo
                                  .format(requestDoc.data()['time'].toDate())
                                  .toString(),
                              style: myStyle(10, Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}
