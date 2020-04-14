import 'package:flutter/material.dart';
import 'package:helpdesk_2/models/customer.dart';
import 'package:helpdesk_2/screens/authentication/auth_services.dart';
import 'package:helpdesk_2/screens/authentication/provider_widget.dart';
import 'package:helpdesk_2/screens/home/UpdateSkills.dart';

import 'package:helpdesk_2/screens/home/customers_near_by.dart';
import 'package:helpdesk_2/screens/home/pages.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  final List<Widget> _children = [CustomersNearBy(), YourGuides(), Feeds()];
  @override
  Widget build(BuildContext context) {
    final newCustomer = new Customer();
    return Scaffold(

      backgroundColor: Color(0xff000000),
      appBar: AppBar(
        backgroundColor: Color(0xff232d36),
        title: Text("Helpers"),
                            elevation: 30,

        actionsIconTheme:
            IconThemeData(color: Colors.white, opacity: 10, size: 90),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.update),
            
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdateSkills(
                            customer: newCustomer,
                          )));
            },
          ),
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: () async {
              try {
                AuthServices auth = Provider.of(context).auth;
                await auth.signOut();
                print("Signed out");
              } catch (e) {
                print(e + " error siging out");
              }
            },
          ),
          Visibility(
            // visible:visible(),
            child: IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.of(context).pushNamed("/convertUser");
              },
            ),
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xff232d36),
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                title: new Text(
                  "Home",
                  style: TextStyle(color: Colors.white),
                )),
            BottomNavigationBarItem(
                icon: new Icon(Icons.web),
                title: new Text(
                  "Google ",
                  style: TextStyle(color: Colors.white),
                )),
            // BottomNavigationBarItem(
            //     icon: new Icon(Icons.dehaze),
            //     title: new Text(
            //       "Feeds",
            //       style: TextStyle(color: Colors.white),
            //     ))
          ]),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }



  
}
