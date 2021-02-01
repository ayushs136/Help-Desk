import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpdesk_shift/models/helper.dart';
import 'package:helpdesk_shift/screens/authentication/provider_widget.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:helpdesk_shift/screens/home/helpers_profile.dart';
import 'package:helpdesk_shift/screens/home/user_profile.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';

// import 'package:intl/intl.dart';

class HelpersNearBy extends StatefulWidget {
  // final  _db = Firestore.instance;

  // DocumentReference doc = _db.document("users").

  @override
  _HelpersNearByState createState() => _HelpersNearByState();
}

class _HelpersNearByState extends State<HelpersNearBy> {
  CollectionReference allUsersCollection =
      FirebaseFirestore.instance.collection('userData');
  SwipeActionController controller;
  Stream userStream;
  bool dataisthere = false;
  bool isSent = false;
  getUserStream() async {
    setState(() {
      userStream = allUsersCollection
          .where("isAvailable", isEqualTo: true)
          .orderBy("name")
          .snapshots();
      print(userStream);
      dataisthere = true;
    });
  }

  List<Helper> helperList;
  String urlTemp =
      "https://www.clipartmax.com/png/middle/271-2719453_korea-circle-person-icon-png.png";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff0f4c75),
        appBar: AppBar(
          title: Text("Helper"),
          centerTitle: true,
          bottomOpacity: 40,
          backgroundColor: Color(0xff3282b8),
          shadowColor: Colors.grey,
          elevation: 20,
        ),
        body: dataisthere == true
            ? StreamBuilder(
                stream: userStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator());
                  return ListView.builder(
                    // shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot userDoc = snapshot.data.docs[index];
                      if (userDoc
                          .data()['followRequest']
                          .contains(currentUser)) {
                        isSent = true;
                      }

                      return BuildHelperCard(
                        helperDocument: userDoc,
                        currentUser: currentUser,
                      );
                    },
                  );
                })
            : Center(child: CircularProgressIndicator()));
  }

  // Stream<QuerySnapshot> getHelperDataStreamSnapshot(
  //     BuildContext context) async* {
  //   // final uid = await Provider.of(context).auth.getCurrentUID();
  //   yield* FirebaseFirestore.instance
  //       .collection("userData")
  //       .where("isAvailable", isEqualTo: true)
  //       .orderBy("name")
  //       .snapshots();
  // }

  // fetchAllUsers(var currentUser) async {
  //   QuerySnapshot querySnapshot =
  //       await FirebaseFirestore.instance.collection("userData").get();

  //   // ignore: deprecated_member_use
  //   List<Helper> helperList = List<Helper>();

  //   for (var i = 0; i < querySnapshot.docs.length; i++) {
  //     if (querySnapshot.docs[i].id != currentUser.uid &&
  //         querySnapshot.docs[i].data()['isAvailable'] == true) {
  //       helperList.add(Helper.fromMap(querySnapshot.docs[i].data()));
  //     }
  //   }

  //   return helperList;
  // }

  var currentUser;

  getCurrentUser() async {
    setState(() {
      currentUser = FirebaseAuth.instance.currentUser;
    });
    return currentUser;
  }

  @override
  void initState() {
    super.initState();
    getUserStream();
    // getCurrentUser().then((user) {
    //   fetchAllUsers(user).then((list) {
    //     setState(() {
    //       helperList = list;
    //     });
    //     // print(helperList);
    //   });
    // });

    // controller = SwipeActionController(selectedIndexPathsChangeCallback:
    //     (changedIndexPaths, selected, currentCount) {
    //   print(
    //       'cell at ${changedIndexPaths.toString()} is/are ${selected ? 'selected' : 'unselected'} ,current selected count is $currentCount');

    //   setState(() {});
    // });
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

}

class BuildHelperCard extends StatefulWidget {
  final DocumentSnapshot helperDocument;
  final currentUser;

  const BuildHelperCard({Key key, this.helperDocument, this.currentUser})
      : super(key: key);
  @override
  _BuildHelperCardState createState() => _BuildHelperCardState();
}

class _BuildHelperCardState extends State<BuildHelperCard> {
  CollectionReference allUsersCollection =
      FirebaseFirestore.instance.collection('userData');
  SwipeActionController controller;
  Stream userStream;
  bool dataisthere = false;
  bool isSent = false;

  var currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() async {
    var firebaseuser = FirebaseAuth.instance.currentUser;
    setState(() {
      currentUser = firebaseuser.uid;
    });
  }

  List<Helper> helperList;
  String urlTemp =
      "https://www.clipartmax.com/png/middle/271-2719453_korea-circle-person-icon-png.png";
  sendRequest(String requesteeUid) async {
    var documentFollow = await allUsersCollection.doc(requesteeUid).get();

    var usernamedoc = await allUsersCollection.doc(currentUser).get();

    var documentFollowRequest = await allUsersCollection
        .doc(requesteeUid)
        .collection('followRequest')
        .doc(currentUser)
        .get();

    if (!documentFollow.data()['followRequest'].contains(currentUser) &&
        !documentFollowRequest.exists) {
      allUsersCollection
          .doc(requesteeUid)
          .collection('followRequest')
          .doc(currentUser)
          .set({
        'senderUid': currentUser,
        'time': DateTime.now(),
        'name': usernamedoc.data()['name'].toString(),
        'photoURL': usernamedoc.data()['photoURL'].toString(),
      });

      allUsersCollection.doc(requesteeUid).update({
        'followRequest': FieldValue.arrayUnion([currentUser]),
      });

      setState(() {
        // followRequest++;
        isSent = true;
        // isfollowing = true;
      });

      // userCollection
      //     .doc(currentUser)
      //     .collection('following')
      //     .doc(requesteeUid)
      //     .set({});
    } else {
      allUsersCollection
          .doc(requesteeUid)
          .collection('followRequest')
          .doc(currentUser)
          .delete();
      allUsersCollection.doc(requesteeUid).update({
        'followRequest': FieldValue.arrayRemove([currentUser]),
      });
      setState(() {
        // followRequest--;
        isSent = false;

        // isfollowing = false;
      });
      allUsersCollection
          .doc(currentUser)
          .collection('following')
          .doc(requesteeUid)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // String uid1 = Firestore.instance.collection("userData").doc(getCurrentUser().uid).documentID;

          // if (helperDocument['uid'] == uid) {
          //  Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) =>UserProfile()));
          // } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Scaffold(
                    body: HelperProfile(
                        helper: Helper.fromMap(widget.helperDocument.data())),
                  )));
          // }
        },
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.lime, width: 1),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              topLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          shadowColor: Colors.grey[300],
          color: Color(0xff1b262c),
          elevation: 10,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 0.0),
                child: ListTile(
                  // children: <Widget>[
                  leading: Column(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                            "${(widget.helperDocument.data()['photoURL'] == null) ? urlTemp : widget.helperDocument.data()['photoURL']}"),
                      ),
                    ],
                  ),

                  title: Text(
                    "${(widget.helperDocument.data()['name'] == null) ? 'N/A' : widget.helperDocument.data()['name'].toString().toUpperCase()}",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  trailing: (widget.helperDocument.data()['uid'] != currentUser)
                      ? InkWell(
                          onTap: () {
                            sendRequest(widget.helperDocument.data()['uid']);
                          },
                          child: (widget.helperDocument
                                  .data()['followRequest']
                                  .contains(currentUser))
                              ? Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white,
                                          offset: Offset(0.0, 1.0), //(x,y)
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                      color: Colors.yellow[700],
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Icon(
                                    Icons.person_search,
                                    color: Colors.blue[700],
                                  )
                                  // : Icon(
                                  //     Icons.check_circle,
                                  //     color: Colors.green[700],
                                  //   )

                                  )
                              : Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white,
                                          offset: Offset(0.0, 1.0), //(x,y)
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                      color: Colors.yellow,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Icon(
                                    Icons.person_add_alt_1_outlined,
                                    color: Colors.black,
                                  )))
                      : InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UserProfile()));
                            // })
                          },
                          child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white,
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Icon(
                                Icons.info,
                                color: Colors.black,
                              ))),
                  // trailing: Column(
                  //   children: [
                  //     OutlineButton(
                  //         onPressed: () {
                  //           createDialogAlert(context).then((onValue) {
                  //             SnackBar mySnackBar = SnackBar(
                  //                 duration: Duration(seconds: 1),
                  //                 content: Text(
                  //                     "${(helperDocument.data()['email'] == null) ? 'N/A' : helperDocument.data()['email']} copied to clipboard! "));
                  //             Scaffold.of(context).showSnackBar(mySnackBar);
                  //           });
                  //           print("Pressed contact button ");
                  //         },
                  //         child: Row(
                  //           children: [
                  //             Text("Connect"),
                  //             Icon(
                  //               Icons.perm_contact_calendar,
                  //               color: Colors.black,
                  //             ),
                  //           ],
                  //         )),
                  //   ],
                  // ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${(widget.helperDocument.data()['skills'] == null) ? 'N/A' : (widget.helperDocument.data()['skills'][0]) + " | " + widget.helperDocument.data()['skills'][1] + " | " + widget.helperDocument.data()['skills'][2] + " | " + widget.helperDocument.data()['skills'][3]}",
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.amber,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SmoothStarRating(
                            color: Colors.yellowAccent,
                            isReadOnly: false,
                            size: 10,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half,
                            defaultIconData: Icons.star_border,
                            starCount: 5,
                            allowHalfRating: true,
                            spacing: 2.0,
                            rating: 2,
                            //  widget.helperDocument
                            //     .data()['rating']
                            //     .toDouble(),
                            onRated: (value) {
                              print("rating value -> $value");
                              print("rating value dd -> ${value.truncate()}");
                            },
                          ),
                          // InkWell(
                          //   onTap: () {},
                          //   child: Icon(
                          //     Icons.star_border_outlined,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          SizedBox(width: 5),
                          Text(
                            "2.3k",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                          SizedBox(width: 15),

                          InkWell(
                            onTap: () {},
                            child: Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 5),
                          // InkWell(
                          //   onTap: () {},
                          //   child: Icon(
                          //     Icons.share,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          // SizedBox(width: 10),
                        ],
                      )
                    ],
                  ),

                  // ],
                ),
              ),
              Row(
                children: <Widget>[
                  // Divider(color: Colors.grey),
                ],
              ),
              Divider(
                color: Colors.teal,
                endIndent: 30,
                indent: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
