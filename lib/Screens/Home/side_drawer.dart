import 'package:flutter/material.dart';
import 'package:helpdesk_2/Screens/Home/contact_us.dart';
import 'package:helpdesk_2/Screens/Home/onboarding.dart';
import 'package:helpdesk_2/Screens/Home/setting.dart';
import 'package:helpdesk_2/Screens/Home/show_profile.dart';

class SideBarMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              "Help Desk",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black),
                color: Colors.teal,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      "https://instagram.fbho1-1.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/s640x640/87299723_205952133857688_2353886330815070748_n.jpg?_nc_ht=instagram.fbho1-1.fna.fbcdn.net&_nc_cat=100&_nc_ohc=eHF9TdddMIsAX8k9BLG&oh=8455a6fc09124b383b18e8c6192d5979&oe=5E952463"),
                )),
          ),
          
          ListTile(
            title: Text(
              'Home',
              style: TextStyle(fontSize: 20, color: Colors.grey[600]),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),

          ListTile(
            title: Text(
              'How to use',
              style: TextStyle(fontSize: 20, color: Colors.grey[600]),
            ),
            onTap: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OnBoardingScreen()),
              );
            },
          ),

          ListTile(
            title: Text(
              'Profile',
              style: TextStyle(fontSize: 20, color: Colors.grey[600]),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfile()),
              );
            },
          ),

          ListTile(
            title: Text(
              'Settings',
              style: TextStyle(fontSize: 20, color: Colors.grey[600]),
            ),
            onTap: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              );
            },
          ),

          ListTile(
            title: Text(
              'Contact Us',
              style: TextStyle(fontSize: 20, color: Colors.grey[600]),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactUs()),
              );
            },
          ),
        ],
      ),
    );
  }
}
