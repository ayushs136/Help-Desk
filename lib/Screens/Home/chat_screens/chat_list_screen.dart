import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_2/data/db/models/contact.dart';
import 'package:helpdesk_2/provider/user_provider.dart';
import 'package:helpdesk_2/data/service/chat_service.dart';
import 'package:helpdesk_2/screens/home/chat_screens/widgets/contact_view.dart';
import 'package:helpdesk_2/screens/home/chat_screens/widgets/new_chat_button.dart';
import 'package:provider/provider.dart';

import 'quite_box.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: customAppBar(context),
      floatingActionButton: NewChatButton(),
      body: ChatListContainer(),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final ChatService _chatMethods = ChatService();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContact(
            userId: userProvider.getHelper.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;
              if (docList.isEmpty) {
                return QuietBox();
              } else {
                return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: docList.length,
                  itemBuilder: (context, index) {
                    Contact contact = Contact.fromMap(docList[index].data);
                    return ContactView(contact);
                  },
                );
              }
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}

// //  return CustomTile(
//                   mini: false,
//                   onTap: () {},
//                   title: Text(
//                     "The CS Guy",
//                     style: TextStyle(
//                         color: Colors.white, fontFamily: "Arial", fontSize: 19),
//                   ),
//                   subtitle: Text(
//                     "Hello",
//                     style: TextStyle(
//                       color: Color(0xff8f8f8f),
//                       fontSize: 14,
//                     ),
//                   ),
//                   leading: Container(
//                     constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
//                     child: Stack(
//                       children: <Widget>[
//                         CircleAvatar(
//                           maxRadius: 30,
//                           backgroundColor: Colors.grey,
//                           backgroundImage: NetworkImage(
//                               "https://yt3.ggpht.com/a/AGF-l7_zT8BuWwHTymaQaBptCy7WrsOD72gYGp-puw=s900-c-k-c0xffffffff-no-rj-mo"),
//                         ),
//                         Align(
//                           alignment: Alignment.bottomRight,
//                           child: Container(
//                             height: 13,
//                             width: 13,
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Color(0xff46dc64),
//                                 border:
//                                     Border.all(color: Colors.black, width: 2)),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 );

// CustomAppBar customAppBar(BuildContext context) {
//   return CustomAppBar(
//     leading: IconButton(
//       icon: Icon(
//         Icons.notifications,
//         color: Colors.white,
//       ),
//       onPressed: () {},
//     ),
//     title: UserCircle(initials),
//     centerTitle: true,
//     actions: <Widget>[
//       IconButton(
//         icon: Icon(
//           Icons.search,
//           color: Colors.white,
//         ),
//         onPressed: () {
//           Navigator.pushNamed(context, "/search_screen");
//         },
//       ),
//       IconButton(
//         icon: Icon(
//           Icons.more_vert,
//           color: Colors.white,
//         ),
//         onPressed: () {},
//       ),
//     ],
//   );
// }
