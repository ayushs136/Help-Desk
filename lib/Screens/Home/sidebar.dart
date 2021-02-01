import 'package:flutter/material.dart';
import 'package:helpdesk_shift/provider/assets.dart';
import 'package:helpdesk_shift/screens/home/navigation_view.dart';
import 'package:helpdesk_shift/screens/home/search.dart';
import 'package:helpdesk_shift/screens/home/user_profile.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SideBarMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Stack(children: [
              Container(
                child: Image.asset(
                  Assets.helpDeskLogo,
                ),
              ),
              Text(
                "Help Desk",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ]),
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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Home()),
              // );
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
