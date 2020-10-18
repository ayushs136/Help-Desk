import 'package:flutter/material.dart';
import 'package:helpdesk_2/data/db/models/helper.dart';
import 'package:helpdesk_2/data/service/profile_service.dart';
import 'package:helpdesk_2/Screens/Home/helper_list.dart';
import 'package:helpdesk_2/Screens/Home/search.dart';
import 'package:helpdesk_2/Screens/Home/side_drawer.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Helper>>.value(
        value: ProfileService().userDetails,
        child: Scaffold(
          drawer: SideBarMenu(),
          appBar: AppBar(
            title: Text("Help Desk"),
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () {
                    dynamic results = ProfileService().signOut();
                    print("SignOut Button pressed " + results);
                  },
                  label: Text("Logout"),
                  icon: Icon(Icons.settings_power)),
            ],
          ),
          body: HelperList(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchScreen())),
            child: Icon(Icons.search),
          ),
        ));
  }
}
