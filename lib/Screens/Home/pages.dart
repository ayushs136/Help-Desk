import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_2/models/customer.dart';
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
    // Customer customer;

    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return Scaffold(
            body: UserProfile(customer: snapshot.data),
          );
        } else {
          return Container();
        }
      },
      future: getCustomerData(context),
    );
  }

  Future<Customer> getCustomerData(BuildContext context) async {
    final uid = await Provider.of(context).auth.getCurrentUID();
    // Customer customer = Customer();

    DocumentSnapshot userData = await Firestore.instance
        .collection('userData')
        .document(uid)
        .collection("Personal Details")
        .document()
        .get();

    // customer.fr

    return Customer.fromMap(userData.data);
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
