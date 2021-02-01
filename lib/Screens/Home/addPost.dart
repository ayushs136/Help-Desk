import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_string/random_string.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

myStyle(double fontSize,
    [Color color = Colors.white, FontWeight fw = FontWeight.w100]) {
  return GoogleFonts.roboto(
    fontSize: fontSize,
    fontWeight: fw,
    color: color,
  );
}

class _AddPostState extends State<AddPost> {
  File imagePath;
  TextEditingController tweetController = TextEditingController();
  bool uploading = false;
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('userData');
  CollectionReference postCollection =
      FirebaseFirestore.instance.collection("posts");
  Reference postPictures = FirebaseStorage.instance.ref().child('postPictures');

  pickImage(ImageSource imgSource) async {
    final image = await ImagePicker().getImage(source: imgSource);
    setState(() {
      imagePath = File(image.path);
    });
    Navigator.pop(context);
  }

  optionsDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () => pickImage(ImageSource.gallery),
                child: Text(
                  "Gallery",
                  style: myStyle(15, Colors.black),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => pickImage(ImageSource.camera),
                child: Text(
                  "Camera",
                  style: myStyle(15, Colors.black),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: myStyle(15, Colors.black),
                ),
              )
            ],
          );
        });
  }

  uploadImage(String id) async {
    UploadTask uploadTask = postPictures.child(id).putFile(imagePath);
    // TaskSnapshot taskSnapshot = uploadTask.snapshot;
    String downloadurl = await (await uploadTask).ref.getDownloadURL();
    return downloadurl;
  }

  postTweet() async {
    setState(() {
      uploading = true;
    });
    var firebaseuser = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userdoc = await userCollection.doc(firebaseuser.uid).get();
    // var allDocs = await postCollection.get();
    // int length = allDocs.docs.length;
    var randomText = randomAlphaNumeric(10);
    //only tweet
    if (tweetController.text != '' && imagePath == null) {
      postCollection.doc(userdoc.data()['uid'] + "-" + randomText).set({
        'username': userdoc.data()['name'],
        'photoURL': userdoc.data()['photoURL'],
        'uid': firebaseuser.uid,
        'id': userdoc.data()['uid'] + "-" + randomText,
        'tweet': tweetController.text,
        'likes': [],
        'commentsCount': 0,
        'shares': 0,
        'type': 1,
        'time': DateTime.now(),
      });
      Navigator.pop(context);
    }
    //only image
    else if (tweetController.text == null && imagePath != null) {
      String imageurl =
          await uploadImage(userdoc.data()['uid'] + "-" + randomText);
      postCollection.doc(userdoc.data()['uid'] + "-" + randomText).set({
        'username': userdoc.data()['name'],
        'photoURL': userdoc.data()['photoURL'],
        'uid': firebaseuser.uid,
        'id': userdoc.data()['uid'] + "-" + randomText,
        'image': imageurl,
        'likes': [],
        'commentsCount': 0,
        'shares': 0,
        'type': 2,
        'time': DateTime.now(),
      });
      Navigator.pop(context);
    }
    //tweet and image
    else if (tweetController.text != '' && imagePath != null) {}
    String imageurl =
        await uploadImage(userdoc.data()['uid'] + "-" + randomText);
    postCollection.doc(userdoc.data()['uid'] + "-" + randomText).set({
      'username': userdoc.data()['name'],
      'photoURL': userdoc.data()['photoURL'],
      'uid': firebaseuser.uid,
      'id': userdoc.data()['uid'] + "-" + randomText,
      'image': imageurl,
      'tweet': tweetController.text,
      'likes': [],
      'commentsCount': 0,
      'shares': 0,
      'type': 3,
      'time': DateTime.now(),
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => postTweet(),
        child: Icon(Icons.publish),
      ),
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.close,
            size: 32,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Add Queet",
          style: myStyle(20, Colors.white, FontWeight.bold),
        ),
        actions: [
          InkWell(
              onTap: () => optionsDialog(),
              child: Icon(Icons.add_a_photo, size: 30))
        ],
      ),
      body: uploading == false
          ? Column(
              children: [
                Expanded(
                  child: TextField(
                    controller: tweetController,
                    maxLength: null,
                    style: myStyle(20, Colors.black),
                    decoration: InputDecoration(
                        labelText: "What's happening now?",
                        labelStyle: myStyle(25, Colors.grey, FontWeight.bold),
                        border: InputBorder.none),
                  ),
                ),
                imagePath == null
                    ? Container()
                    : MediaQuery.of(context).viewInsets.bottom > 0
                        ? Container()
                        : Image(
                            width: 400,
                            height: 200,
                            image: FileImage(imagePath),
                          )
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text(
                    "Uploading...",
                    style: myStyle(20, Colors.black),
                  )
                ],
              ),
            ),
    );
  }
}
