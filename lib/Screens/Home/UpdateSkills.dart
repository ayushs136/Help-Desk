import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_2/models/customer.dart';
import 'package:helpdesk_2/screens/authentication/provider_widget.dart';

import 'package:helpdesk_2/shared/constants.dart';

class UpdateSkills extends StatefulWidget {
  final Customer customer;

  UpdateSkills({@required this.customer, Key key}) : super(key: key);

  @override
  _UpdateSkillsState createState() => _UpdateSkillsState();
}

class _UpdateSkillsState extends State<UpdateSkills> {
    final  _db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = new TextEditingController();
   
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        title: Text('Update Skills'),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Enter top 4 skills you got!", style: TextStyle(color:Colors.grey, fontSize:22),),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: TextField(
              decoration: textInputDecoration.copyWith(hintText: "seperate using coma"),
              controller: _titleController,
              
              autofocus: true,
            ),
          ),
           RaisedButton(
          
             
            onPressed: () async {
                    
                    final uid = await Provider.of(context).auth.getCurrentUID();
                    await _db.collection("deskview").document().setData(widget.customer.toJSON1());
                    await _db
                        .collection('userData')
                        .document(uid)
                        .collection("Personal Details")
                        .add(widget.customer.toJSON());

                    Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text('Update Skills'),
            ),

      
        ],
      ),
    );
  }
}

// 