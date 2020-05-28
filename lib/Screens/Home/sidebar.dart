import 'package:flutter/material.dart';
import 'package:helpdesk_2/screens/home/navigation_view.dart';
import 'package:helpdesk_2/screens/home/search.dart';
import 'package:helpdesk_2/screens/home/user_profile.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
                      "https://instagram.fbho1-1.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/p750x750/95636461_229623048322195_6694348077617470914_n.jpg?_nc_ht=instagram.fbho1-1.fna.fbcdn.net&_nc_cat=107&_nc_ohc=phhSeZkSWacAX9Hg_p5&oh=e2c4cab6013907fc7cee654b19294d39&oe=5EE4E6C9"
                      // "https://instagram.fbho1-2.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/s750x750/92750829_182431039882498_6308917519176997564_n.jpg?_nc_ht=instagram.fbho1-2.fna.fbcdn.net&_nc_cat=110&_nc_ohc=92i3-nHCOeIAX-IU4jR&oh=9c39bc373b415f04feac535cbaa86205&oe=5EE386F7"
                      ),
                  //  AssetImage(
                  // "assets/icon.png"
                  // ),
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
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
          ListTile(
            title: Text(
              'Your Profile',
              style: TextStyle(fontSize: 20, color: Colors.grey[600]),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfile()),
              );
            },
          ),
          // ListTile(
          //   title: Text(
          //     'Settings',
          //     style: TextStyle(fontSize: 20, color: Colors.grey[600]),
          //   ),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => Home()),
          //     );
          //   },
          // ),
          ListTile(
            title: Text(
              'Search',
              style: TextStyle(fontSize: 20, color: Colors.grey[600]),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
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
                  MaterialPageRoute(
                      builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: Text(
                                "Contact Us",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            body: WebView(
                              initialUrl: 'https://dscrjit.co',
                            ),
                          )),
                );
              }),
        ],
      ),
    );
  }
}
