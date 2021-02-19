import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:helpdesk_shift/models/helper.dart';
import 'package:helpdesk_shift/screens/home/custom_tile.dart';
import 'package:helpdesk_shift/screens/home/helpers_profile.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var helperSearchList = [];
  String query = "";
  TextEditingController searchController = TextEditingController();
  var currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // gettingUsers();
    fetchAllUsers(currentUser);
    // print("hgfhg");
  }

  fetchAllUsers(var currentUser) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("userData").get();
    List helperList = [];
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        // print(querySnapshot.docs[i].data());
        var map = querySnapshot.docs[i].data();
        helperList.add(Helper.fromMap(map));
        // print("FetchAll USers $helperList");
      }
    }
    setState(() {
      // print("GettingUsers $list");
      helperSearchList = helperList;
    });
    return helperList;
  }

  // gettingUsers() {
  //   fetchAllUsers(currentUser).then((list) {
  //     setState(() {
  //       print("GettingUsers $list");
  //       helperSearchList = list;
  //     });
  //   });
  // }

  searchAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff3282b8),
      elevation: 0,
      bottom: PreferredSize(
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: TextField(
              controller: searchController,
              onChanged: (val) {
                setState(() {
                  query = val;
                });
              },
              cursorColor: Colors.black,
              autofocus: true,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 35),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => searchController.clear());
                      // searchController.clear();
                    }),
                border: InputBorder.none,
                hintText: "Search Name or Skills",
                hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color(0xffffffff)),
              ),
            ),
          ),
          preferredSize: const Size.fromHeight(kToolbarHeight - 30)),
    );
  }

  buildSuggestions(String query) {
    // print("dshfshf $helperSearchList");
    final List suggestionList = query.isEmpty
        ? []
        : helperSearchList.where((user) {
            String _query = query.toLowerCase();
            print(user);
            String _getName = user.name.toString().toLowerCase();
            String _getSkill1 = user.skills[0].toString().toLowerCase();
            String _getSkill2 = user.skills[1].toString().toLowerCase();
            String _getSkill3 = user.skills[2].toString().toLowerCase();
            String _getSkill4 = user.skills[3].toString().toLowerCase();

            bool matchesName = _getName.contains(_query);
            bool matchesSkill1 = _getSkill1.contains(_query);
            bool matchesSkill2 = _getSkill2.contains(_query);
            bool matchesSkill3 = _getSkill3.contains(_query);
            bool matchesSkill4 = _getSkill4.contains(_query);

            return (matchesName ||
                matchesSkill1 ||
                matchesSkill2 ||
                matchesSkill3 ||
                matchesSkill4);
          }).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        Helper searchedUser = Helper(
            uid: suggestionList[index].uid,
            photoURL: suggestionList[index].photoURL,
            name: suggestionList[index].name,
            email: suggestionList[index].email,
            isAvailable: suggestionList[index].isAvailable,
            skills: suggestionList[index].skills,
            phone: suggestionList[index].phone);

        return CustomTile(
          mini: false,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HelperProfile(helperUid: searchedUser.uid)));
          },
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(searchedUser.photoURL),
          ),
          title: Text(
            searchedUser.name,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: searchedUser.isAvailable
              ? Text(
                  "Available",
                  // .substring(1, (searchedUser.skills.toString().length - 1)),
                  style: TextStyle(color: Colors.green, fontSize: 12),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                )
              : Text(
                  "Not Available",
                  // .substring(1, (searchedUser.skills.toString().length - 1)),
                  style: TextStyle(color: Colors.red, fontSize: 12),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: buildSuggestions(query),
      ),
    );
  }
}
