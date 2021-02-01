import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_shift/enum/view_state.dart';
import 'package:helpdesk_shift/main.dart';

import 'package:helpdesk_shift/models/helper.dart';
import 'package:helpdesk_shift/models/message.dart';
import 'package:helpdesk_shift/provider/image_upload_provider.dart';
import 'package:helpdesk_shift/resources/chat_methods.dart';

import 'package:helpdesk_shift/screens/home/chat_screens/widgets/cached_image.dart';
import 'package:helpdesk_shift/services/appbar.dart';
import 'package:helpdesk_shift/services/customTile.dart';
import 'package:helpdesk_shift/services/pickImage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final Helper receiver;

  ChatScreen({this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textFieldController = TextEditingController();
  ChatMethods _chatMethods = ChatMethods();
  ScrollController _listScrollController = ScrollController();
  Helper sender;
  Reference _storageReference;
  FocusNode textFieldFocus = FocusNode();
  String _currentUserId;
  ImageUploadProvider _imageUploadProvider;
  bool isWriting = false;
  getCurrentUser() async {
    var currentUser;
    currentUser = FirebaseAuth.instance.currentUser;
    return currentUser;
  }

  @override
  void initState() {
    super.initState();

    getCurrentUser().then((user) {
      _currentUserId = user.uid;

      setState(() {
        sender = Helper(
          uid: user.uid,
          name: user.displayName,
          photoURL: user.photoUrl,
          email: user.email,
          phone: user.phoneNumber,
        );
      });
    });
  }

  showKeyboard() => textFieldFocus.requestFocus();
  hideKeyboard() => textFieldFocus.unfocus();

  @override
  Widget build(BuildContext context) {
    // RaisedButton(
    //   child: Text("Change View State"),
    //   onPressed: () {
    //     _imageUploadProvider.getViewState == ViewState.LOADING
    //         ? _imageUploadProvider.setToIdle()
    //         : _imageUploadProvider.setToLoading();
    //   },
    // ),
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          _imageUploadProvider.getViewState == ViewState.LOADING
              ? Container(
                  child: CircularProgressIndicator(),
                  margin: EdgeInsets.only(right: 15),
                  alignment: Alignment.centerRight,
                )
              : Container(),
          chatControls(),
        ],
      ),
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chats")
          .doc(_currentUserId)
          .collection(widget.receiver.uid)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }
        // SchedulerBinding.instance.addPostFrameCallback((_) {
        //   _listScrollController.animateTo(
        //       _listScrollController.position.minScrollExtent,
        //       curve: Curves.easeInOut,
        //       duration: Duration(milliseconds: 250));
        // });
        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: snapshot.data.docs.length,
          controller: _listScrollController,
          reverse: true,
          itemBuilder: (context, index) {
            // mention the arrow syntax if you get the time
            return chatMessageItem(snapshot.data.docs[index]);
          },
        );
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message _message = Message.fromMap(snapshot.data());

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: _message.senderId == _currentUserId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _message.senderId == _currentUserId
            ? senderLayout(_message)
            : receiverLayout(_message),
      ),
    );
  }

  Widget senderLayout(Message message) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: Color(0xff2b343b),
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: getMessage(message),
      ),
    );
  }

  getMessage(Message message) {
    Timestamp t = message.timestamp;
    DateTime d = t.toDate();
    return message.type != "image"
        ? Row(
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Text(
                  message.message,
                  overflow: TextOverflow.clip,
                  maxLines: 30,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,

                    //  overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Text(
                  DateFormat('jm').format(d).toString(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          )
        : message.type != null
            ? GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                    return Scaffold(
                        body: Center(
                      child: Hero(
                        tag: 'myHero',
                        child: CachedNetworkImage(imageUrl: message.photoUrl),
                      ),
                    ));
                  }));
                },
                child: Hero(
                    tag: 'myHero',
                    child: CachedNetworkImage(imageUrl: message.photoUrl)))
            : Text("Url was null");
  }

  Widget receiverLayout(Message message) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: Color(0xff1e2225),
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(message),
      ),
    );
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    sendMessage() {
      var text = textFieldController.text;

      Message _message = Message(
        receiverId: widget.receiver.uid,
        senderId: sender.uid,
        message: text,
        timestamp: Timestamp.now(),
        type: 'text',
      );

      setState(() {
        isWriting = false;
      });

      textFieldController.text = "";

      _chatMethods.addMessageToDb(_message, sender, widget.receiver);
    }

    Future<String> uploadImageToStorage(File image) async {
      try {
        _storageReference = FirebaseStorage.instance
            .ref()
            .child('${DateTime.now().millisecondsSinceEpoch}');
        UploadTask _storageUploadTask = _storageReference.putFile(image);

        var url = await (await _storageUploadTask).ref.getDownloadURL();

        return url;
      } catch (e) {
        print(e + "in pic upload");
        return null;
      }
    }

    void setImageMsg(String url, String receiverId, String senderId) async {
      Message _message;
      _message = Message.imageMessage(
        message: "IMAGE",
        receiverId: receiverId,
        senderId: senderId,
        photoUrl: url,
        timestamp: Timestamp.now(),
        type: 'image',
      );

      var map = _message.toImageMap();

      // set
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(_message.senderId)
          .collection(_message.receiverId)
          .add(map);

      await FirebaseFirestore.instance
          .collection("chats")
          .doc(_message.receiverId)
          .collection(_message.senderId)
          .add(map);
    }

    void uploadImage(
        {File image,
        String receivedId,
        String senderId,
        ImageUploadProvider imageUploadProvider}) async {
      imageUploadProvider.setToLoading();
      String url = await uploadImageToStorage(image);
      imageUploadProvider.setToIdle();
      setImageMsg(url, receivedId, senderId);
    }

    pickImage({ImageSource source}) async {
      File selectedImage = await DatabaseServices.pickImage(source: source);
      uploadImage(
          image: selectedImage,
          receivedId: widget.receiver.uid,
          senderId: _currentUserId,
          imageUploadProvider: _imageUploadProvider);
    }

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: Colors.black,
          builder: (context) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        child: Icon(
                          Icons.close,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Content and tools",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      ModalTile(
                        title: "Media",
                        subtitle: "Share Photos and Video",
                        icon: Icons.image,
                        onTap: () => pickImage(source: ImageSource.gallery),
                      ),
                      ModalTile(
                          title: "File",
                          subtitle: "Share files",
                          icon: Icons.tab),
                      ModalTile(
                          title: "Contact",
                          subtitle: "Share contacts",
                          icon: Icons.contacts),
                      ModalTile(
                          title: "Location",
                          subtitle: "Share a location",
                          icon: Icons.add_location),
                      ModalTile(
                          title: "Schedule Call",
                          subtitle: "Arrange a skype call and get reminders",
                          icon: Icons.schedule),
                      ModalTile(
                          title: "Create Poll",
                          subtitle: "Share polls",
                          icon: Icons.poll)
                    ],
                  ),
                ),
              ],
            );
          });
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff00b6f3), Color(0xff0184dc)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Stack(alignment: Alignment.centerRight, children: [
              TextField(
                focusNode: textFieldFocus,
                controller: textFieldController,
                style: TextStyle(
                  color: Colors.white,
                ),
                onChanged: (val) {
                  (val.length > 0 && val.trim() != "")
                      ? setWritingTo(true)
                      : setWritingTo(false);
                },
                decoration: InputDecoration(
                  hintText: "Type a message",
                  hintStyle: TextStyle(
                    color: Color(0xff8f8f8f),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(51.0),
                      ),
                      borderSide: BorderSide.none),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  filled: true,
                  fillColor: Color(0xff272c35),
                ),
              ),
              // IconButton(
              //   splashColor: Colors.transparent,
              //   highlightColor: Colors.transparent,
              //   onPressed: () {
              //     showKeyboard();
              //   },
              //   icon: Icon(Icons.face),
              // ),
            ]),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.record_voice_over),
                ),
          isWriting
              ? Container()
              : GestureDetector(
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                  onTap: () {
                    pickImage(source: ImageSource.camera);
                  },
                ),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xff00b6f3), Color(0xff0184dc)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 15,
                    ),
                    onPressed: () => sendMessage(),
                  ))
              : Container()
        ],
      ),
    );
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomeController()));
            })
      ],
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        widget.receiver.name,
      ),
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;
  const ModalTile({this.title, this.subtitle, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        onTap: onTap,
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xff1e2225),
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: Color(0xff8f8f8f),
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Color(0xff8f8f8f),
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
