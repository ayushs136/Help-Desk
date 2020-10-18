import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:helpdesk_2/core/widget/loading.dart';
import 'package:helpdesk_2/data/service/auth_service.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Sign In"),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Want help in learning? \nSign In now!!! ",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GoogleSignInButton(
                    onPressed: () async {
                      print("object");
                      setState(() => loading = true);
                      await _auth.signInWithGoogle();
                      print("Google Sign in Button pressed ");
                    },
                    darkMode: true,
                  ),
                ],
              ),
            ),
          );
  }
}
