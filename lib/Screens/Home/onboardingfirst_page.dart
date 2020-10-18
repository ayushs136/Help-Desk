import 'package:flutter/material.dart';
import 'package:helpdesk_2/Screens/authentication/provider_widget.dart';
import 'package:helpdesk_2/screens/authentication/google_login.dart';
import 'package:helpdesk_2/screens/home/custom_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:helpdesk_2/main.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final primaryColor = const Color(0xff232d36);

  bool isLoginPressed = true;

  @override
  Widget build(BuildContext context) {
    final _auth = ProviderWidget.of(context).auth;

    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: _width,
        height: _height,
        color: primaryColor,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: _height * 0.30,
                  ),
                  Text(
                    "Welcome",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  SizedBox(
                    height: _height * 0.07,
                  ),
                  Text(
                    "Looking for help? \nGet here!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  SizedBox(
                    height: _height * 0.10,
                  ),
                  RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 30, right: 30),
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 28,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialog(
                              title: "Would you like to create a free account?",
                              description:
                                  "with an account, your data will be securely saved, allowing us to know you better!",
                              primaryButtonText: "Create my Account",
                              primaryButtonRoute: "/signUp",
                              secondaryButtonText: "Maybe Later",
                              secondaryButtonRoute: "/anonymousSignIn",
                            );
                          });
                    },
                  ),
                  SizedBox(
                    height: _height * 0.10,
                  ),
                  isLoginPressed
                      ? GoogleSignInButton(
                          darkMode: true,
                          onPressed: () async {
                            setState(() {
                              isLoginPressed = false;
                            });
                            try {
                              await _auth
                                  .signInWithGoogle()
                                  .then((FirebaseUser user) {
                                if (user != null) {
                                  _auth
                                      .authenticateUser(user)
                                      .then((isNewUser) {
                                    if (isNewUser) {
                                      _auth.addDataToDb(user);
                                    } else {}
                                  });
                                } else {
                                  print("error in login");
                                }
                              });

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => HomeController()));

                              // _auth.addDataToDb();

                            } catch (e) {
                              print(e);
                            }
                          },
                        )
                      : CircularProgressIndicator(),
                  // FlatButton(
                  //   onPressed: () {
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GoogleLogIn()));
                  //     // Navigator.of(context).pushReplacementNamed("/signIn");
                  //   },
                  //   child: Text(
                  //     "Sign In",
                  //     style: TextStyle(color: Colors.white, fontSize: 25),
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Text(
                    "Only Google sign In available!",
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
