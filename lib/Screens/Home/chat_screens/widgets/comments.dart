import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_shift/screens/home/addPost.dart';

import 'package:timeago/timeago.dart' as tAgo;

class CommentsPage extends StatefulWidget {
  final String documentid;

  const CommentsPage(this.documentid);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  var commentController = TextEditingController();
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('userData');
  CollectionReference postCollection =
      FirebaseFirestore.instance.collection("posts");
  addComment() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userDoc = await userCollection.doc(firebaseUser.uid).get();
    postCollection.doc(widget.documentid).collection('comments').doc().set({
      'comment': commentController.text,
      'uid': userDoc['uid'],
      'username': userDoc['name'],
      'displayImg': userDoc['photoURL'],
      'time': DateTime.now(),
    });
    DocumentSnapshot commentCount =
        await postCollection.doc(widget.documentid).get();
    postCollection.doc(widget.documentid).update({
      'commentsCount': commentCount['commentsCount'] + 1,
    });
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: Icon(Icons.close),
      //   centerTitle: true,
      //   title: Text(
      //     "Comments",
      //     style: myStyle(20),
      //   ),
      // ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: postCollection
                      .doc(widget.documentid)
                      .collection('comments')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    Divider();
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot commentDoc =
                              snapshot.data.docs[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  NetworkImage(commentDoc['displayImg']),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  commentDoc['username'],
                                  style: myStyle(
                                      15, Colors.black, FontWeight.w400),
                                ),
                                SizedBox(width: 15),
                                Text(
                                  commentDoc['comment'],
                                  style: myStyle(
                                    20,
                                    Colors.grey,
                                    FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(tAgo
                                .format(commentDoc['time'].toDate())
                                .toString()),
                          );
                        });
                  },
                ),
              ),
              Divider(),
              ListTile(
                title: TextFormField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: "Add a Comment...",
                    hintStyle: myStyle(18, Colors.grey, FontWeight.bold),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                trailing: OutlineButton(
                  onPressed: () => addComment(),
                  borderSide: BorderSide.none,
                  child: Text(
                    "Publish",
                    style: myStyle(16, Colors.black, FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
