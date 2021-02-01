import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpdesk_shift/models/helper.dart';
import 'package:helpdesk_shift/screens/home/chat_screens/widgets/comments.dart';
import 'package:helpdesk_shift/screens/home/addPost.dart';
import 'package:helpdesk_shift/screens/home/friend_requests.dart';
import 'package:helpdesk_shift/screens/home/helpers_profile.dart';
import 'package:helpdesk_shift/screens/home/user_profile.dart';

import 'package:timeago/timeago.dart' as tAgo;

// import 'package:helpdesk_shift/models/helper.dart';
// import 'package:helpdesk_shift/screens/home/ad.dart' as ad;
// import 'package:helpdesk_shift/screens/home/chat_screens/widgets/cached_image.dart';
// import 'package:helpdesk_shift/screens/home/friend_requests.dart';
// import 'package:helpdesk_shift/screens/home/helpers_profile.dart';
// import 'package:helpdesk_shift/screens/home/user_profile.dart';

class Feeds extends StatefulWidget {
  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {
  bool darkMode = true;
  @override
  Widget build(BuildContext context) {
    // Stream tweetStream;
    // String uid;
    // CollectionReference postCollection =
    //     FirebaseFirestore.instance.collection("posts");

    // getTweetStream() async {
    //   setState(() {
    //     tweetStream =
    //         postCollection.orderBy('time', descending: true).snapshots();
    //   });
    // }

    // getCurrentUserUid() async {
    //   var firebaseuser = FirebaseAuth.instance.currentUser;
    //   setState(() {
    //     uid = firebaseuser.uid;
    //   });
    // }

    // initState() {
    //   super.initState();
    //   getTweetStream();
    //   getCurrentUserUid();
    // }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Helpers Feeds",
          style: TextStyle(color: darkMode ? Colors.white : Colors.black),
        ),
        centerTitle: true,
        bottomOpacity: 40,
        backgroundColor: darkMode ? Colors.black : Colors.white,
        shadowColor: Colors.grey,
        elevation: 20,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(FontAwesomeIcons.userFriends,
              color: darkMode ? Colors.white : Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Switch(
              activeTrackColor: Colors.white,
              activeColor: Colors.black,
              inactiveTrackColor: Colors.black,
              inactiveThumbColor: Colors.white,
              value: darkMode,
              onChanged: (bool val) {
                setState(() {
                  darkMode = val;
                  // print(darkMode);
                });
              },
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FriendRequests()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(FontAwesomeIcons.redditSquare,
                  color: darkMode ? Colors.white : Colors.black),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(child: PostStream(darkMode: darkMode)),
    );
  }
}

class PostStream extends StatefulWidget {
  // final Stream userStream;
  // final String uid;
  final bool darkMode;

  const PostStream({Key key, this.darkMode}) : super(key: key);
  // const PostStream({Key key, this.userStream, this.uid}) : super(key: key);
  @override
  _PostStreamState createState() => _PostStreamState();
}

class _PostStreamState extends State<PostStream> {
  Stream tweetStream;
  String uid;
  // bool darkMode = false;

  CollectionReference postCollection =
      FirebaseFirestore.instance.collection("posts");
  String likedName = '';
  getTweetStream() async {
    setState(() {
      tweetStream =
          postCollection.orderBy('time', descending: true).snapshots();
    });
  }

  getCurrentUserUid() async {
    var firebaseuser = FirebaseAuth.instance.currentUser;
    setState(() {
      uid = firebaseuser.uid;
    });
  }

  initState() {
    super.initState();
    getTweetStream();
    getCurrentUserUid();
  }

  // var postCollection = FirebaseFirestore.instance.collection('posts');
  likepost(String documentId) async {
    var firebaseuser = FirebaseAuth.instance.currentUser;
    DocumentSnapshot documentSnapshot =
        await postCollection.doc(documentId).get();

    if (documentSnapshot['likes'].contains(firebaseuser.uid)) {
      postCollection.doc(documentId).update({
        'likes': FieldValue.arrayRemove([firebaseuser.uid]),
      });
    } else {
      postCollection.doc(documentId).update({
        'likes': FieldValue.arrayUnion([firebaseuser.uid]),
      });
    }
  }

  sharePost(String documentid, String tweet) async {
    // Share.text("Quitter", tweet, 'text/plain');
    DocumentSnapshot documentSnapshot =
        await postCollection.doc(documentid).get();
    postCollection
        .doc(documentid)
        .update({'shares': documentSnapshot['shares'] + 1});
  }

  @override
  Widget build(BuildContext context) {
    // bool isPressed = false;
    return StreamBuilder(
        stream: tweetStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
                Text(
                  "Getting posts...",
                  style: myStyle(20, Colors.white),
                )
              ],
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot helperDoc = snapshot.data.docs[index];
              // FirebaseFirestore.instance
              //     .collection("userData")
              //     .doc(helperDoc.data()['likes'][0].toString())
              //     .get()
              //     .then((val) => {
              //           setState(() {
              //             // likedName = val.data()['name'];
              //           })
              //         });

              return Column(
                children: [
//                   Card(
//                     elevation: 10,
//                     color: Colors.blue[10],
//                     child: ListTile(
//                       trailing: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Container(
//                               child: Icon(
//                             Icons.more_vert,
//                             color: Colors.grey,
//                           )),
//                           SizedBox(height: 10),

//                           Text(
//                             tAgo
//                                 .format(helperDoc.data()['time'].toDate())
//                                 .toString(),
//                             style: myStyle(10, Colors.grey, FontWeight.bold),
//                           ),
//                           // SizedBox(height: 5),
//                           // InkWell(
//                           //   onTap: () {
//                           //     print("gdg");
//                           //   },
//                           //   child: Container(
//                           //     padding: const EdgeInsets.only(left: 10.0),
//                           //     // padding: const EdgeInsets.all(.0),
//                           //     decoration: BoxDecoration(
//                           //         color: Colors.black,
//                           //         borderRadius: BorderRadius.circular(5),
//                           //         border: Border.all(color: Colors.grey)),
//                           //     width: 90,
//                           //     height: 35,
//                           //     child: Center(
//                           //       child: Row(
//                           //         children: [
//                           //           Icon(Icons.person_add,
//                           //               color: Colors.white, size: 16),
//                           //           SizedBox(width: 7),
//                           //           Text(
//                           //             " Connect",
//                           //             style: myStyle(10, Colors.white),
//                           //           ),
//                           //         ],
//                           //       ),
//                           //     ),
//                           //   ),
//                           // ),
//                         ],
//                       ),
//                       leading: InkWell(
//                         onTap: () {
//                           if (helperDoc.data()['uid'] != uid) {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => HelperProfile(
//                                       helper: Helper.fromMap(helperDoc.data())),
//                                 ));
//                           } else {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => UserProfile(),
//                                 ));
//                           }
//                         },
//                         child: CircleAvatar(
//                           radius: 20,
//                           backgroundColor: Colors.white,
//                           backgroundImage: NetworkImage(
//                               helperDoc.data()['photoURL'] == null
//                                   ? ''
//                                   : helperDoc.data()['photoURL']),
//                         ),
//                       ),
//                       title: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: 20),
//                           Text(
//                             helperDoc.data()['username'],
//                             style: myStyle(15, Colors.black, FontWeight.w600),
//                           ),
//                           SizedBox(height: 10),
//                           Divider(
//                             color: Colors.grey,
//                           )
//                         ],
//                       ),
//                       contentPadding: EdgeInsets.all(0.3),
//                       subtitle: Container(
//                         // color: Colors.black,
//                         child: Padding(
//                           padding: const EdgeInsets.all(0.001),
//                           child: Column(
//                             // crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               if (helperDoc.data()['type'] == 1)
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(
//                                     helperDoc.data()['tweet'],
//                                     style: myStyle(
//                                         12, Colors.black, FontWeight.w400),
//                                   ),
//                                 ),
//                               if (helperDoc.data()['type'] == 2)
//                                 Image(
//                                   image:
//                                       NetworkImage(helperDoc.data()['image']),
//                                 ),
//                               if (helperDoc.data()['type'] == 3)
//                                 Column(
//                                   children: [
//                                     Text(
//                                       helperDoc.data()['tweet'],
//                                       style: myStyle(
//                                           12, Colors.black, FontWeight.w400),
//                                     ),
//                                     SizedBox(height: 10),
//                                     InkWell(
//                                       onDoubleTap: () {
//                                         likepost(helperDoc.data()['id']);
//                                       },
//                                       child: Container(
//                                         padding: EdgeInsets.all(10),
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(20)),
//                                         child: Image(
//                                           image: NetworkImage(
//                                               helperDoc.data()['image']),
//                                         ),
// // Flexible(
// //                                         fit: FlexFit.loose,
// //                                         child: new Image.network(
// //                                           "https://images.pexels.com/photos/672657/pexels-photo-672657.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
// //                                           fit: BoxFit.cover,
// //                                         ),
// //                                       ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               Divider(color: Colors.grey),
//                               SizedBox(height: 10),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () => Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 CommentsPage(helperDoc['id']))),
//                                     child: Row(
//                                       children: [
//                                         Icon(
//                                           Icons.comment,
//                                           color: Colors.black,
//                                           size: 20,
//                                         ),
//                                         SizedBox(width: 10.0),
//                                         Text(
//                                           helperDoc
//                                               .data()['commentsCount']
//                                               .toString(),
//                                           style: myStyle(15, Colors.black,
//                                               FontWeight.bold),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   InkWell(
//                                     onTap: () =>
//                                         likepost(helperDoc.data()['id']),
//                                     child: Row(
//                                       children: [
//                                         helperDoc.data()['likes'].contains(uid)
//                                             ? Icon(
//                                                 Icons.favorite,
//                                                 color: Colors.red,
//                                                 size: 20,
//                                               )
//                                             : Icon(
//                                                 Icons.favorite_border,
//                                                 color: Colors.black,
//                                                 size: 20,
//                                               ),
//                                         SizedBox(width: 10.0),
//                                         Text(
//                                           helperDoc
//                                               .data()['likes']
//                                               .length
//                                               .toString(),
//                                           style: myStyle(15, Colors.black,
//                                               FontWeight.bold),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   InkWell(
//                                     onTap: () => sharePost(
//                                         helperDoc.data()['id'],
//                                         helperDoc.data()['tweet']),
//                                     child: Row(
//                                       children: [
//                                         Icon(
//                                           Icons.share,
//                                           color: Colors.black,
//                                           size: 20,
//                                         ),
//                                         SizedBox(width: 10.0),
//                                         Text(
//                                           helperDoc.data()['shares'].toString(),
//                                           style: myStyle(15, Colors.black,
//                                               FontWeight.bold),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
                  // Divider(
                  //   color: Colors.black,
                  // ),

                  Container(
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(8.0),
                      color: widget.darkMode ? Colors.black : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: widget.darkMode ? Colors.white : Colors.black,
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                          offset: Offset(
                              2.0, 2.0), // shadow direction: bottom right
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      if (helperDoc.data()['uid'] != uid) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HelperProfile(
                                                      helper: Helper.fromMap(
                                                          helperDoc.data())),
                                            ));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UserProfile(),
                                            ));
                                      }
                                    },
                                    child: new Container(
                                      height: 40.0,
                                      width: 40.0,
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new NetworkImage(
                                                helperDoc.data()['photoURL'] ==
                                                        null
                                                    ? ''
                                                    : helperDoc
                                                        .data()['photoURL'])),
                                      ),
                                    ),
                                  ),
                                  new SizedBox(
                                    width: 10.0,
                                  ),
                                  new Text(
                                    helperDoc.data()['username'],
                                    style: TextStyle(
                                        color: widget.darkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                              new IconButton(
                                icon: Icon(Icons.more_vert, color: Colors.grey),
                                onPressed: null,
                              )
                            ],
                          ),
                        ),
                        if (helperDoc.data()['type'] == 1)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              helperDoc.data()['tweet'],
                              style: myStyle(
                                  12,
                                  widget.darkMode ? Colors.white : Colors.black,
                                  FontWeight.w400),
                            ),
                          ),
                        if (helperDoc.data()['type'] == 2)
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Container(
                              // fit: FlexFit.loose,
                              child: CachedNetworkImage(
                                imageUrl: helperDoc.data()['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        if (helperDoc.data()['type'] == 3)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  helperDoc.data()['tweet'],
                                  style: myStyle(
                                      12,
                                      widget.darkMode
                                          ? Colors.white
                                          : Colors.black,
                                      FontWeight.w400),
                                ),
                              ),
                              SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (c) {
                                    return Scaffold(
                                        backgroundColor: widget.darkMode
                                            ? Colors.white
                                            : Colors.black,
                                        body: Center(
                                          child: Hero(
                                            tag: 'picHero' +
                                                helperDoc.data()['id'],
                                            child: CachedNetworkImage(
                                                imageUrl:
                                                    helperDoc.data()['image'] ==
                                                            null
                                                        ? ''
                                                        : helperDoc
                                                            .data()['image']),
                                          ),
                                        ));
                                  }));
                                },
                                onDoubleTap: () {
                                  likepost(helperDoc.data()['id']);
                                },
                                child: InteractiveViewer(
                                  maxScale: 5.0,
                                  child: SafeArea(
                                    // fit: FlexFit.loose,
                                    child: Hero(
                                      tag: 'picHero' + helperDoc.data()['id'],
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            helperDoc.data()['image'] == null
                                                ? ''
                                                : helperDoc.data()['image'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () =>
                                        likepost(helperDoc.data()['id']),
                                    child: Row(
                                      children: [
                                        // SizedBox(height: 30),
                                        // Divider(
                                        //   color: Colors.grey,
                                        // ),
                                        helperDoc.data()['likes'].contains(uid)
                                            ? Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                                // size: 20,
                                              )
                                            : Icon(
                                                FontAwesomeIcons.heart,
                                                color: widget.darkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                                // size: 20,
                                              ),
                                        SizedBox(width: 10.0),
                                        Text(
                                          (helperDoc.data()['likes'].length + 1)
                                              .toString(),
                                          style: myStyle(
                                              15,
                                              widget.darkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  new SizedBox(
                                    width: 16.0,
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CommentsPage(helperDoc['id']))),
                                    child: Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.comment,
                                          color: widget.darkMode
                                              ? Colors.white
                                              : Colors.black,
                                          size: 20,
                                        ),
                                        SizedBox(width: 10.0),
                                        Text(
                                          helperDoc
                                              .data()['commentsCount']
                                              .toString(),
                                          style: myStyle(
                                              15,
                                              widget.darkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  new SizedBox(
                                    width: 16.0,
                                  ),
                                  InkWell(
                                    onTap: () => sharePost(
                                        helperDoc.data()['id'],
                                        helperDoc.data()['tweet']),
                                    child: Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.paperPlane,
                                          color: widget.darkMode
                                              ? Colors.white
                                              : Colors.black,
                                          size: 20,
                                        ),
                                        SizedBox(width: 10.0),
                                        Text(
                                          helperDoc.data()['shares'].toString(),
                                          style: myStyle(
                                              15,
                                              widget.darkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              new Icon(
                                FontAwesomeIcons.bookmark,
                                color: widget.darkMode
                                    ? Colors.white
                                    : Colors.black,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Liked by " +
                                likedName +
                                " and " +
                                (helperDoc.data()['likes'].length).toString() +
                                " others",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: widget.darkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                        // Padding(
                        //   padding:
                        //       const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: <Widget>[
                        //       new Container(
                        //         height: 40.0,
                        //         width: 40.0,
                        //         decoration: new BoxDecoration(
                        //           shape: BoxShape.circle,
                        //           image: new DecorationImage(
                        //               fit: BoxFit.fill,
                        //               image: new NetworkImage(
                        //                   "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg")),
                        //         ),
                        //       ),
                        //       new SizedBox(
                        //         width: 10.0,
                        //       ),
                        //       Expanded(
                        //         child: new TextField(
                        //           decoration: new InputDecoration(
                        //             border: InputBorder.none,
                        //             hintText: "Add a comment...",
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            tAgo
                                .format(helperDoc.data()['time'].toDate())
                                .toString(),
                            style: myStyle(10, Colors.grey, FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        });
  }
}
