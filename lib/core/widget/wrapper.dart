
import 'package:flutter/material.dart';
import 'package:helpdesk_2/Screens/Home/home.dart';
import 'package:helpdesk_2/data/db/models/user.dart';
import 'package:provider/provider.dart';
import '../../Screens/Authenticate/sign_in.dart';


// class Wrapper extends StatelessWidget {
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     final user = Provider.of<User>(context);
//
//     print(user);
//
//     // return either home or authentication widget
//     if(user==null){
//       print("Signed out");
//     return SignIn();
//     }
//     else{
//       print("Signed in");
//       return Home();
//     }
//   }
// }
