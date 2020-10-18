import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:helpdesk_2/Screens/authentication/provider_widget.dart';
import 'package:helpdesk_2/main.dart';

class GoogleLogIn extends StatefulWidget {
  @override
  _GoogleLogInState createState() => _GoogleLogInState();
}

class _GoogleLogInState extends State<GoogleLogIn> {
  bool isLoginPressed = true;
  @override
  Widget build(BuildContext context) {
    final _auth = ProviderWidget.of(context).auth;

    return Scaffold(
      body: isLoginPressed
          ? GoogleSignInButton(
              darkMode: true,
              onPressed: () async {
                setState(() {
                  isLoginPressed = false;
                });
                try {
                  await _auth.signInWithGoogle().then((FirebaseUser user) {
                    if (user != null) {
                      _auth.addDataToDb(user);
                    } else {
                      print("error in login");
                    }
                  });

                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeController()));

                  // _auth.addDataToDb();

                } catch (e) {
                  print(e);
                }
              },
            )
          : CircularProgressIndicator(),
    );
  }
}
