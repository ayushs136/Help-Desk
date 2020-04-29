import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_2/models/customer.dart';
import 'package:helpdesk_2/screens/authentication/provider_widget.dart';

class UserProfile extends StatefulWidget {




  final Customer customer;
  UserProfile({this.customer});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  //  Future<Customer> getCustomerData(BuildContext context) async {
  //   final uid = await Provider.of(context).auth.getCurrentUID();
  //   // Customer customer = Customer();

  //   DocumentSnapshot userData = await Firestore.instance
  //       .collection('userData')
  //       .document(uid)
  //       .collection("Personal Details")
  //       .document()
  //       .get();

  //   // customer.fr

  //   return Customer.fromMap(userData.data);
  // }

  @override
  Widget build(BuildContext context) {
    print('7dsjalkfj     ${widget.customer.name}');

    return Scaffold(
      backgroundColor: Color(0xff133041),
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.grey[800],
        elevation: 0.0,
        // actions: <Widget>[
        //   ListTile(
        //     title: Text(
        //     '${userData.displayName}',
        //       style: TextStyle(
        //         fontSize: 30,
        //       ),
        //     ),
        //     subtitle: Text(
        //       userData.email,
        //       style: TextStyle(fontSize: 30),
        //     ),
        //   ),
        // ]),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 40.0,
                backgroundImage: NetworkImage(
                  '',
                ),
              ),
            ),
            Divider(
              color: Colors.grey[800],
              height: 60.0,
            ),
            Text(
              'NAME',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '${widget.customer.name}',
              style: TextStyle(
                color: Colors.amberAccent[200],
                fontWeight: FontWeight.bold,
                fontSize: 28.0,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 30.0),
            Text(
              'Last Seen',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,
              ),
            ),
           
            SizedBox(height: 30.0),
            Text(
              'User Id',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '${widget.customer.skills}',

              // '8',
              style: TextStyle(
                color: Colors.amberAccent[200],
                fontWeight: FontWeight.bold,
                fontSize: 28.0,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 30.0),
            Row(
              children: <Widget>[
                Icon(
                  Icons.email,
                  color: Colors.grey[400],
                ),
                SizedBox(width: 10.0),
                Text(
                  ' ${widget.customer.email}',
                  // 'chun.li@thenetninja.co.uk',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 18.0,
                    letterSpacing: 1.0,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
