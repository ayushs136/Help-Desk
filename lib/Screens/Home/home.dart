import 'package:flutter/material.dart';
import 'package:helpdesk_2/Screens/Authenticate/authentication.dart';
import 'package:helpdesk_2/Screens/Home/helper_list.dart';
import 'package:helpdesk_2/Screens/Home/search.dart';
import 'package:helpdesk_2/Screens/Home/side_drawer.dart';
import 'package:helpdesk_2/models/helper.dart';
import 'package:provider/provider.dart';
import 'helper_tile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Helper>>.value(
        value: DatabaseServices().userDetails,
        child: Scaffold(
          drawer: SideBarMenu(),
          appBar: AppBar(
            title: Text("Help Desk"),
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () {
                    dynamic results = AuthService().signOut();
                    print("SignOut Button pressed " + results);
                  },
                  label: Text("Logout"),
                  icon: Icon(Icons.settings_power)),
            ],
          ),
          body: HelperList(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // SearchHelper();
            },
            child: Icon(Icons.search),
          ),
        ));
  }
}
