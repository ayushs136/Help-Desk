import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:helpdesk_2/models/helper.dart';
import 'package:helpdesk_2/screens/home/custom_tile.dart';
import 'package:helpdesk_2/screens/home/helpers_profile.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<List<Helper>> fetchAllUsers(FirebaseUser currentUser) async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("userData").getDocuments();
    List<Helper> helperList = List<Helper>();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        helperList.add(Helper.fromMap(querySnapshot.documents[i].data));
      }
    }
    return helperList;
  }

  List<Helper> helperSearchList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      fetchAllUsers(user).then((List<Helper> list) {
        setState(() {
          helperSearchList = list;
        });
      });
    });
  }

  searchAppBar(BuildContext context) {
    return GradientAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
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
                hintText: "Search",
                hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Color(0xffffffff)),
              ),
            ),
          ),
          preferredSize: const Size.fromHeight(kToolbarHeight + 20)),
    );
  }

  buildSuggestions(String query) {
    final List<Helper> suggestionList = query.isEmpty
        ? []
        : helperSearchList.where((Helper user) {
            String _query = query.toLowerCase();
            String _getName = user.name.toLowerCase();
            String _getSkill1 = user.skills[0].toString().toLowerCase();
            String _getSkill2 = user.skills[1].toString().toLowerCase();
            String _getSkill3 = user.skills[2].toString().toLowerCase();
            String _getSkill4 = user.skills[3].toString().toLowerCase();

            bool matchesName = _getName.contains(_query);
            bool matchesSkill1 = _getSkill1.contains(_query);
            bool matchesSkill2 = _getSkill2.contains(_query);
            bool matchesSkill3 = _getSkill3.contains(_query);
            bool matchesSkill4 = _getSkill4.contains(_query);


            return (matchesName||matchesSkill1||matchesSkill2||matchesSkill3||matchesSkill4);
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
                    builder: (context) => HelperProfile(helper: searchedUser)));
          },
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(searchedUser.photoURL),
          ),
          title: Text(
            searchedUser.email,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            searchedUser.name,
            style: TextStyle(color: Color(0xff8f8f8f)),
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
