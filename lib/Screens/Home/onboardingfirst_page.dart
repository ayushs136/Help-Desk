import 'package:flutter/material.dart';
import 'package:helpdesk_2/screens/home/custom_dialog.dart';

class OnBoarding extends StatelessWidget {
  final primaryColor = const Color(0xff75A2EA);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: _width,
        height: _height,
        color: primaryColor,
        child: SafeArea(
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
                              secondaryButtonRoute: "/anonymousSignIn",
                              secondaryButtonText: "Maybe Later",
                              
                              );
                        });
                  },
                ),
                SizedBox(
                  height: _height * 0.10,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("/signIn");
                  },
                  child: Text(
                    "Sign In",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
