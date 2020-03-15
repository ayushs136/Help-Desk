
import 'package:flutter/material.dart';
import 'package:helpdesk/Screens/Home/home.dart';
import 'package:helpdesk/models/user.dart';
import 'package:provider/provider.dart';

import 'Authenticate/sign_in.dart';


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    print(user);
    
    // return either home or authentication widget
    if(user==null){
      print("Signed out");
    return SignIn();
    }
    else{
      print("Signed in");
      return Home();
    }
  }
}
