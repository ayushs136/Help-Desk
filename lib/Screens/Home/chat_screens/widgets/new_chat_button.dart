import 'package:flutter/material.dart';

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xff00b6f3), Color(0xff0184dc)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(50)),
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: 25,
      ),
      padding: EdgeInsets.all(15),
    );
  }
}
