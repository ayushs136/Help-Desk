import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:helpdesk_shift/screens/authentication/auth_services.dart';
import 'package:helpdesk_shift/screens/authentication/provider_widget.dart';

final primaryColor = const Color(0xff232d36);
final grayColor = const Color(0xFF939393);

enum AuthFormType { signIn, signUp, reset, anonymous, convert }

class SignUpView extends StatefulWidget {
  final AuthFormType authFormType;

  const SignUpView({ this.authFormType});

  @override
  _SignUpViewState createState() =>
      _SignUpViewState(authFormType: this.authFormType);
}

class _SignUpViewState extends State<SignUpView> {
  AuthFormType authFormType;
  bool isLoginPressed = true;
  _SignUpViewState({this.authFormType});

  final formKey = GlobalKey<FormState>();

  String _email, _password, _name, _warning;

  void switchFormState(String state) {
    formKey.currentState.reset();
    if (state == "signUp") {
      setState(() {
        authFormType = AuthFormType.signUp;
      });
    } else if (state == "signIn") {
      setState(() {
        authFormType = AuthFormType.signIn;
      });
    } else if (state == "home") {
      Navigator.of(context).pop();
    }
  }

  bool validate() {
    final form = formKey.currentState;
    if (authFormType == AuthFormType.anonymous) {
      return true;
    }
    form.save();

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    // final form = formKey.currentState;
    // form.save();

    if (validate()) {
      print("submit function");
      try {
        final auth = ProviderWidget.of(context).auth;
        switch (authFormType) {
          case AuthFormType.signIn:
            String uid =
                await auth.signInWithEmailAndPassword(_email, _password);
            print("User Signed in: " + uid);
            Navigator.of(context).pushReplacementNamed("/home");
            break;

          case AuthFormType.signUp:
            // String uid = await auth.createUserWithEmailAndPassword(
            //     _email, _password, _name);
            // print("New user signed up: " + uid);
            Navigator.of(context).pushReplacementNamed("/home");
            break;
          case AuthFormType.reset:
            print("password reset email sent");
            await auth.sendPasswordResetEmail(_email);
            _warning = "A password reset link has been sent to $_email";
            setState(() {
              authFormType = AuthFormType.signIn;
            });
            break;
          case AuthFormType.anonymous:
            await auth.signInAnonymously();
            // Navigator.of(context).pushReplacementNamed("/home");
            Navigator.of(context).pushReplacementNamed("/signUp");
            break;
          case AuthFormType.convert:
            // await auth.convertUserWithEmail(_email, _password, _name);
            print("converting user");
            Navigator.of(context).pop();
            break;
        }
      } catch (e) {
        setState(() {
          _warning = e.message;
        });
        print(e.message + " error in signing up with email");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    if (authFormType == AuthFormType.anonymous) {
      submit();
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: true,
        backgroundColor: primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitDoubleBounce(
              color: Colors.white,
            ),
            Text(
              "Loading",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: true,
        body: Container(
          color: primaryColor,
          height: _height,
          width: _width,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  SizedBox(height: _height * 0.05),
                  showAlert(),
                  SizedBox(height: _height * 0.05),
                  buildHeader(),
                  SizedBox(height: _height * 0.05),
                  Form(
                    key: formKey,
                    child: Column(
                      children: buildInputs() + buildButtons(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget showAlert() {
    if (_warning != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Icon(Icons.error_outline),
            Expanded(
              child: AutoSizeText(
                _warning,
                maxLines: 3,
              ),
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _warning = null;
                });
              },
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  AutoSizeText buildHeader() {
    String _headerText;
    if (authFormType == AuthFormType.signIn) {
      _headerText = "Sign In";
    } else if (authFormType == AuthFormType.reset) {
      _headerText = "Reset Password";
    } else {
      _headerText = "Create New Account";
    }
    return AutoSizeText(
      _headerText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 35,
        color: Colors.white,
      ),
    );
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];

//reset form type

    if (authFormType == AuthFormType.reset) {
      textFields.add(TextFormField(
        enabled: false,
        style: TextStyle(fontSize: 22),
        validator: EmailValidator.validate,
        decoration: buildSignUpInputDecoration("Email"),
        onSaved: (value) => _email = value,
      ));

      textFields.add(SizedBox(
        height: 22,
      ));

      return textFields;
    }

// add name if user in sign up
    if ([AuthFormType.signUp, AuthFormType.convert].contains(authFormType)) {
      textFields.add(TextFormField(
        enabled: false,
        style: TextStyle(fontSize: 22),
        validator: NameValidator.validate,
        decoration: buildSignUpInputDecoration("Full name"),
        onSaved: (value) => _name = value,
      ));
    }
    textFields.add(SizedBox(
      height: 22,
    ));

//add email and password
    textFields.add(
      TextFormField(
        enabled: false,
        style: TextStyle(fontSize: 22),
        validator: EmailValidator.validate,
        decoration: buildSignUpInputDecoration("Email"),
        onSaved: (value) => _email = value,
      ),
    );

    textFields.add(SizedBox(
      height: 22,
    ));
    textFields.add(
      TextFormField(
        enabled: false,
        style: TextStyle(fontSize: 22),
        obscureText: true,
        validator: PasswordValidator.validate,
        decoration: buildSignUpInputDecoration("Password"),
        onSaved: (value) => _password = value,
      ),
    );
    textFields.add(SizedBox(
      height: 22,
    ));
    return textFields;
  }

  InputDecoration buildSignUpInputDecoration(String hint) {
    return InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.white,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.0)),
        contentPadding: const EdgeInsets.only(left: 14.0, bottom: 10, top: 10));
  }

  List<Widget> buildButtons() {
    String _switchButton, _newFromState, _submitButtonText;
    bool _showForgotPassword = false;
    bool _showSocial = true;

    if (authFormType == AuthFormType.signIn) {
      _switchButton = "Create New Account";
      _newFromState = "signUp";
      _submitButtonText = "Sign In";
      _showForgotPassword = true;
    } else if (authFormType == AuthFormType.reset) {
      _switchButton = "Return to Sign In";
      _newFromState = "signIn";
      _submitButtonText = "Submit";
      _showSocial = false;
    } else if (authFormType == AuthFormType.convert) {
      _switchButton = "Cancel";
      _newFromState = "home";
      _submitButtonText = "Sign Up";
    } else {
      _switchButton = "Have an Account? Sign In";
      _newFromState = "signIn";
      _submitButtonText = "Sign Up";
    }

    return [
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: RaisedButton(
          onPressed: () {
            submit();
            print("button pressed");
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Colors.white,
          textColor: primaryColor,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              _submitButtonText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
            ),
          ),
        ),
      ),
      showForgotPassword(_showForgotPassword),
      FlatButton(
        onPressed: () {
          switchFormState(_newFromState);
        },
        child: Text(
          _switchButton,
          style: TextStyle(color: Colors.white),
        ),
      ),
      buildSocialIcons(_showSocial),
    ];
  }

  Widget showForgotPassword(bool visible) {
    return Visibility(
      child: FlatButton(
        child: Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          setState(() {
            authFormType = AuthFormType.reset;
          });
        },
      ),
      visible: visible,
    );
  }

  Widget buildSocialIcons(bool visible) {
    final _auth = ProviderWidget.of(context).auth;
    return Visibility(
      child: Column(
        children: <Widget>[
          Divider(
            color: Colors.white,
          ),
          SizedBox(height: 10),
          isLoginPressed
              ? GoogleSignInButton(
                  darkMode: true,
                  onPressed: () async {
                    setState(() {
                      isLoginPressed = false;
                    });
                    try {
                      if (authFormType == AuthFormType.convert) {
                        // _auth.convertWithGoogle();
                        Navigator.of(context).pop();
                      } else {
                        await _auth
                            .signInWithGoogle()
                            .then((FirebaseUser user) {
                          if (user != null) {
                            _auth.addDataToDb(user);
                          } else {
                            print("error in login");
                          }
                        });

                        Navigator.of(context).pushReplacementNamed("/home");

                        // _auth.addDataToDb();
                      }
                    } catch (e) {
                      _warning = e.message;
                      print(e);
                    }
                  },
                )
              : CircularProgressIndicator(),
        ],
      ),
      visible: visible,
    );
  }
}
