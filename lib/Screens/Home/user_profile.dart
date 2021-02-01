import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpdesk_shift/models/helper.dart';
import 'package:helpdesk_shift/models/skills.dart';
import 'package:helpdesk_shift/screens/authentication/auth_services.dart';
import 'package:helpdesk_shift/screens/authentication/provider_widget.dart';
import 'package:helpdesk_shift/screens/home/UpdateSkills.dart';

class UserProfile extends StatefulWidget {
  final Helper helper;
  UserProfile({this.helper});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final newHelper = new Helper();
  final newSkills = new Skills();

  updateAvailability(bool isAvailable) async {
    Map<String, bool> data = Map();

    data['isAvailable'] = isAvailable;

    final uid = await ProviderWidget.of(context).auth.getCurrentUID();
    await FirebaseFirestore.instance
        .collection('userData')
        .doc(uid)
        .set(data, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    Future<Helper> getHelperData(BuildContext context) async {
      // Helper Helper = Helper();
      final uid = await ProviderWidget.of(context).auth.getCurrentUID();
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('userData')
          .doc(uid)
          .get();
      print(userData.data()['name']);
      // Helper.fr

      return Helper.fromMap(userData.data());
    }

    return FutureBuilder(
      future: getHelperData(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            floatingActionButton: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black)),
              color: Colors.teal,
              child: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateSkills(
                              helper: newHelper,
                              skills: newSkills,
                            )));
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            backgroundColor: Color(0xff000000),
            appBar: AppBar(
              actions: [
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
              ],
              centerTitle: true,
              title: Text(
                "Helper's Profile",
                textAlign: TextAlign.center,
              ),
              backgroundColor: Color(0xff000000),
              elevation: 0.0,
              // actions: <Widget>[
              //   ListTile(
              //     title: Text(
              //     '${userData.displayName}',
              //       style: TextStyle(
              //         fontSize: 30,
              //       ),
              //     ),
              //     subtitle: Text(
              //       userData.email,
              //       style: TextStyle(fontSize: 30),
              //     ),
              //   ),
              // ]),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                        radius: 40.0,
                        backgroundImage: NetworkImage(
                          // 'https://lh3.googleusercontent.com/-5axQsnH1ZuM/AAAAAAAAAAI/AAAAAAAAAAA/xAYbnZ7p5AM/s190-p/photo.jpg',
                          snapshot.data.photoURL,
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey[800],
                      height: 60.0,
                    ),
                    Text(
                      'Helper\'s Name',
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      snapshot.data.name,
                      style: TextStyle(
                        color: Colors.amberAccent[200],
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0,
                        letterSpacing: 2.0,
                      ),
                    ),
                    // SizedBox(height: 30.0),
                    // Text(
                    //   'Last Seen',
                    //   style: TextStyle(
                    //     color: Colors.grey,
                    //     letterSpacing: 2.0,
                    //   ),
                    // ),

                    SizedBox(height: 30.0),
                    Text(
                      'Skill set',
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      snapshot.data.skills[0] +
                          "\n" +
                          snapshot.data.skills[1] +
                          "\n" +
                          snapshot.data.skills[2] +
                          "\n" +
                          snapshot.data.skills[3],

                      // '8',
                      style: TextStyle(
                        color: Colors.amberAccent[200],
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        letterSpacing: 2.0,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.email,
                          color: Colors.grey[400],
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          snapshot.data.email,
                          // 'chun.li@thenetninja.co.uk',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 15.0,
                            letterSpacing: 1.0,
                          ),
                        ),
                        SizedBox(width: 20.0),
                      ],
                    ),

                    SizedBox(width: 20.0),
                    // Text(
                    //   "\nIs Available?",
                    //   style: TextStyle(
                    //     color: Colors.grey[400],
                    //     fontSize: 20.0,
                    //     letterSpacing: 2.0,
                    //   ),
                    // ),

                    SwitchListTile(
                      value: snapshot.data.isAvailable,
                      // secondary: Icon(
                      //   FontAwesomeIcons.dashcube,
                      //   color: Colors.grey[400],
                      // ),
                      title: Text(
                        "Is Available?",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 20.0,
                          letterSpacing: 2.0,
                        ),
                      ),
                      subtitle: Text(
                        "(Show visibility in Helpers list)",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 15.0,
                        ),
                      ),

                      activeColor: Colors.white,
                      // hoverColor: Colors.black,
                      activeTrackColor: Colors.green,
                      inactiveTrackColor: Colors.red,
                      onChanged: (bool val) {
                        setState(() {
                          snapshot.data.isAvailable = val;
                        });
                        updateAvailability(val);
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container(
              alignment: Alignment.center, child: CircularProgressIndicator());
        }
      },
    );
  }
}
