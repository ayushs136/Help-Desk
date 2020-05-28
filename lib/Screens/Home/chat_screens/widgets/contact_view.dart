import 'package:flutter/material.dart';
import 'package:helpdesk_2/models/contact.dart';
import 'package:helpdesk_2/models/helper.dart';
import 'package:helpdesk_2/provider/user_provider.dart';
import 'package:helpdesk_2/resources/chat_methods.dart';
import 'package:helpdesk_2/screens/authentication/auth_services.dart';
import 'package:helpdesk_2/screens/home/chat_screens/chat_screens.dart';
import 'package:helpdesk_2/screens/home/chat_screens/widgets/cached_image.dart';
import 'package:helpdesk_2/screens/home/chat_screens/widgets/online_dot_indicator.dart';
import 'package:helpdesk_2/services/customTile.dart';
import 'package:provider/provider.dart';

import 'last_message_container.dart';

class ContactView extends StatelessWidget {

    final Contact contact;

  ContactView(this.contact);


final AuthServices _auth = AuthServices();




  @override 
  Widget build(BuildContext context){
      return FutureBuilder<Helper>(
      future: _auth.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Helper helper = snapshot.data;

          return ViewLayout(
            contact: helper,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
      
  }
}


class ViewLayout extends StatelessWidget{
    final Helper contact;
    
    final ChatMethods _chatMethods = ChatMethods();
 ViewLayout({
    @required this.contact,
  });



  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    
          return CustomTile(
            mini: false,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(receiver: contact,)));
            },
            title: Text(
            (contact!=null?contact.name:null) !=null?contact.name:"..",
              style: TextStyle(
                  color: Colors.white, fontFamily: "Arial", fontSize: 19),
            ),
            subtitle: LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
          senderId: userProvider.getHelper.uid,
          receiverId: contact.uid,
        ),
      ),
            leading: Container(
              constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
              child: Stack(
                children: <Widget>[
                  CachedImage(contact.photoURL, radius:80, isRound:true),
                  OnlineDotIndicator(uid:contact.uid),
                ],
              ),
            ),
          );
   }   }
     