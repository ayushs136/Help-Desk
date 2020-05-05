import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_2/models/helper.dart';
import 'package:helpdesk_2/screens/authentication/provider_widget.dart';

import 'package:helpdesk_2/screens/home/user_profile.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
    );
  }
}

class YourGuides extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Helper Helper;

    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return Scaffold(
            body: UserProfile(helper: snapshot.data),
          );
        } else {
          return Container();
        }
      },
      future: getHelperData(context),
    );
  }

  Future<Helper> getHelperData(BuildContext context) async {
    final uid = await Provider.of(context).auth.getCurrentUID();
    // Helper Helper = Helper();

    DocumentSnapshot userData = await Firestore.instance
        .collection('userData')
        .document(uid)
        .collection("Personal Details")
        .document()
        .get();

    // Helper.fr

    return Helper.fromMap(userData.data);
  }
}

class Feeds extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
    );
  }
}
