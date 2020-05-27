import 'package:flutter/material.dart';
import 'package:helpdesk_2/provider/image_upload_provider.dart';
import 'package:helpdesk_2/screens/authentication/auth_services.dart';
import 'package:helpdesk_2/screens/authentication/provider_widget.dart';
import 'package:helpdesk_2/screens/authentication/sign_up.dart';
import 'package:helpdesk_2/screens/home/navigation_view.dart';
import 'package:helpdesk_2/screens/home/onboardingfirst_page.dart';
import 'package:helpdesk_2/shared/loading.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      auth: AuthServices(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<ImageUploadProvider>(
            create: (context) => ImageUploadProvider(),
          ),
        ],
        child: MaterialApp(
          title: 'Help Desk 2.0',
          theme: ThemeData(
            primarySwatch: Colors.teal,
          ),
          home: HomeController(),
          routes: <String, WidgetBuilder>{
            "/signUp": (BuildContext context) =>
                SignUpView(authFormType: AuthFormType.signUp),
            "/signIn": (BuildContext context) =>
                SignUpView(authFormType: AuthFormType.signIn),
            "/home": (BuildContext context) => HomeController(),
            "/anonymousSignIn": (BuildContext context) => SignUpView(
                  authFormType: AuthFormType.anonymous,
                ),
            "/convertUser": (BuildContext context) =>
                SignUpView(authFormType: AuthFormType.convert),
          },
        ),
      ),
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthServices auth = ProviderWidget.of(context).auth;
    return StreamBuilder(
        stream: auth.onAuthStateChange,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final bool signedIn = snapshot.hasData;
            return signedIn ? Home() : OnBoarding();
          }
          return Loading();
        });
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return OnBoarding();
  }
}
