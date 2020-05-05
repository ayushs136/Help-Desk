import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_2/models/helper.dart';
import 'package:helpdesk_2/models/skills.dart';
import 'package:helpdesk_2/screens/authentication/provider_widget.dart';

import 'package:helpdesk_2/shared/constants.dart';

class UpdateSkills extends StatefulWidget {
  final Helper helper;
  final Skills skills;

  UpdateSkills({@required this.helper, @required this.skills, Key key});

  @override
  _UpdateSkillsState createState() => _UpdateSkillsState();
}

class _UpdateSkillsState extends State<UpdateSkills> {
  final _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Helper helper = new Helper();
  
    TextEditingController _skill1Controller = new TextEditingController();
    TextEditingController _skill2Controller = new TextEditingController();
    TextEditingController _skill3Controller = new TextEditingController();
    TextEditingController _skill4Controller = new TextEditingController();

    String skill1="", skill2="", skill3="", skill4="";
    List<String> skillsList = [];
    // bool disableButton = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xff232d36),
        title: Text('Update Skills'),
      ),
      body: SingleChildScrollView (
              child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Enter top 4 skills you got!",
              style: TextStyle(color: Colors.grey, fontSize: 22),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: textInputDecoration.copyWith(
                          hintText: "Skill 1 - Best skill",
                          hintStyle: TextStyle(color: Colors.grey)),
                      controller: _skill1Controller,
                      autofocus: true,
                     
                      onChanged: (value) {
                        setState(() {
                          skill1 = value;
                        });
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: textInputDecoration.copyWith(
                          hintText: "Skill 2",
                          hintStyle: TextStyle(color: Colors.grey)),
                      controller: _skill2Controller,
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {
                          skill2 = value;
                        });
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: textInputDecoration.copyWith(
                          hintText: "Skill 3",
                          hintStyle: TextStyle(color: Colors.grey)),
                      controller: _skill3Controller,
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {
                          skill3 = value;
                        });
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: textInputDecoration.copyWith(
                          hintText: "Skill 4",
                          hintStyle: TextStyle(color: Colors.grey)),
                      controller: _skill4Controller,
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {
                          skill4 = value;
                        });
                      }),
                ],
              ),
            ),
            RaisedButton(
              elevation: 10,
              color: Color(0xff232d36),
              onPressed: () async {
               
                // if (skill1 == null &&
                //     skill2 == null &&
                //     skill3 == null &&
                //     skill4 == null) {

                skillsList.add(skill1);
                skillsList.add(skill2);
                skillsList.add(skill3);
                skillsList.add(skill4);
                // setState(() {

                setState(() {
                  widget.helper.skills = skillsList;
                  // widget.skills.skill1 = skill1;
                  // widget.skills.skill2 = skill2;
                  // widget.skills.skill3 = skill3;
                  // widget.skills.skill4 = skill4;
                });
                print("***");
                print(skill1);
                print("***");
                print(skill2);
                print("***");
                print(skill3);
                print("***");
                print(skill4);
                print("***");
                print(skillsList);

                // });
                final uid = await Provider.of(context).auth.getCurrentUID();

                FirebaseUser currentUser;
                currentUser = await _auth.currentUser();
                helper = Helper(
                  email: currentUser.email,
                  name: currentUser.displayName,
                  phone: "",
                  photoURL: currentUser.photoUrl,
                  isAvailable: true,
                  uid: uid,
                  skills: skillsList,
                );
                await _db
                    .collection('userData')
                    .document(uid)
                    .setData(helper.toMap(helper));

                // await _db
                //     .collection("deskview")
                //     .document(uid)
                //     .setData(widget.Helper.toJSON());


                Skills skill;
                skill = Skills(
                  skill1: skill1,
                  skill2: skill2,
                  skill3: skill3,
                  skill4: skill4,
                );
                await _db
                    .collection("skillCollection")
                    .document(uid)
                    .setData(skill.toMap(skill), merge: true);

                Navigator.pop(context);
                // }

                // else{

                //   Navigator.pop(context);
                // }
              },
              
              child: Text(
                'Update Skills',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
