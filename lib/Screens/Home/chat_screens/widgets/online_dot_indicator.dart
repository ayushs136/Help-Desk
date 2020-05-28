import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_2/enum/user_state.dart';
import 'package:helpdesk_2/models/helper.dart';
import 'package:helpdesk_2/screens/authentication/auth_services.dart';

class OnlineDotIndicator extends StatelessWidget {
  final String uid;
  final AuthServices _authServices = AuthServices();

  OnlineDotIndicator({
    @required this.uid,
  });


     int stateToNum(UserState userState) {
    switch (userState) {
      case UserState.Offline:
        return 0;

      case UserState.Online:
        return 1;

      default:
        return 2;
    }
  }

   UserState numToState(int number) {
     switch (number) {
      case 0:
        return UserState.Offline;

      case 1:
        return UserState.Online;

      default:
        return UserState.Waiting;
    }
  }

  @override
  Widget build(BuildContext context) {
    getColor(int state) {
      switch (numToState(state)) {
        case UserState.Offline:
          return Colors.red;
        case UserState.Online:
          return Colors.green;
        default:
          return Colors.orange;
      }
    }

    return Align(
      alignment: Alignment.topRight,
      child: StreamBuilder<DocumentSnapshot>(
        stream: _authServices.getUserStream(
          uid: uid,
        ),
        builder: (context, snapshot) {
         Helper helper;

          if (snapshot.hasData && snapshot.data.data != null) {
            helper= Helper.fromMap(snapshot.data.data);
          }

          return Container(
            height: 10,
            width: 10,
            margin: EdgeInsets.only(right: 5, top: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: getColor(helper?.state),
            ),
          );
        },
      ),
    );
  }
}