import 'package:flutter/material.dart';
import 'package:helpdesk/Screens/Authenticate/authentication.dart';
import 'package:helpdesk/Screens/wrapper.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     return StreamProvider<User>.value(
      value: AuthService().user,
        child: MaterialApp(
          
          title: "Help Desk",
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Wrapper(),
        
      ),
    );
    
}

}
