import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/cupertino.dart';
import 'package:helpdesk_2/enum/user_state.dart';
import 'package:helpdesk_2/provider/user_provider.dart';
import 'package:helpdesk_2/screens/authentication/auth_services.dart';
import 'package:helpdesk_2/screens/authentication/provider_widget.dart';
import 'package:helpdesk_2/screens/home/chat_screens/chat_list_screen.dart';

import 'package:helpdesk_2/screens/home/helper_list_screen.dart';
import 'package:helpdesk_2/screens/home/search.dart';
import 'package:helpdesk_2/screens/home/sidebar.dart';

import 'package:helpdesk_2/screens/home/user_profile.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  // bool _showIcon = false;

  // bool visible() {
  //     AuthFormType authFormType;
  //   if (authFormType == AuthFormType.signIn) {
  //    return false;
  //   }else{
  //     return true;
  //   }
  // }

  int _currentIndex = 0;
  final AuthServices _authServices = AuthServices();
  UserProvider userProvider;

  final List<Widget> _children = [HelpersNearBy(), ChatListScreen(), UserProfile()];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();

      _authServices.setUserState(
        userId: userProvider.getHelper.uid,
        userState: UserState.Online,
      );
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId = (userProvider != null && userProvider.getHelper != null) ? userProvider.getHelper.uid : "";

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null ? _authServices.setUserState(userId: currentUserId, userState: UserState.Online) : print("resume state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null ? _authServices.setUserState(userId: currentUserId, userState: UserState.Offline) : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null ? _authServices.setUserState(userId: currentUserId, userState: UserState.Waiting) : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null ? _authServices.setUserState(userId: currentUserId, userState: UserState.Offline) : print("detached state");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBarMenu(),
      // AppBar(
      //   actions: <Widget>[
      //     RaisedButton(
      //       shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(18.0),
      //           side: BorderSide(color: Colors.black)),
      //       color: Colors.teal,
      //       child: Icon(Icons.edit),
      //       onPressed: () {
      //         Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) => UpdateSkills(
      //                       helper: newHelper,
      //                       skills: newSkills,
      //                     )));
      //       },
      //     ),
      //   ],
      // ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        elevation: 10,
        onPressed: () {
          print("Search pressed");
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xff232d36),
        title: Text("Helpers Desk View"),
        elevation: 30,
        actionsIconTheme: IconThemeData(color: Colors.white, opacity: 10, size: 90),
        actions: <Widget>[
          FlatButton(
            child: Icon(
              Icons.exit_to_app,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () async {
              try {
                AuthServices auth = ProviderWidget.of(context).auth;
                await auth.signOut();
                print("Signed out");
              } catch (e) {
                print(e + " error siging out");
              }
            },
          ),
          // Visibility(
          //   // visible:visible(),
          //   child: IconButton(
          //     icon: Icon(Icons.account_circle),
          //     onPressed: () {
          //       Navigator.of(context).pushNamed("/convertUser");
          //     },
          //   ),
          // ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(backgroundColor: Color(0xff232d36), currentIndex: _currentIndex, onTap: onTabTapped, items: [
        BottomNavigationBarItem(
            icon: new Icon(Icons.people),
            title: new Text(
              "Helpers",
              style: TextStyle(color: Colors.white),
            )),
        BottomNavigationBarItem(
            icon: new Icon(Icons.chat),
            title: new Text(
              "Chats",
              style: TextStyle(color: Colors.white),
            )),
        BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text(
              "Profile",
              style: TextStyle(color: Colors.white),
            )),
      ]),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
