import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
 
  // filled: true,
 

  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width:1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.teal, width: 1.0)
  ),
);

class Util{
static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String lastNameInitial = nameSplit[1][0];
    return firstNameInitial + lastNameInitial;
  }

}