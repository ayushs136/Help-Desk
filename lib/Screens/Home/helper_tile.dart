import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpdesk_2/models/helper.dart';

class HelperTile extends StatelessWidget {
  final Helper helper;
  HelperTile({this.helper});

  createDialogAlert(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text("Contact Details"),
            content: Text("${helper.email}"),
            elevation: 5.0,
            
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () {
                    print("Clipboard button pressed");
                    Clipboard.setData(ClipboardData(text: helper.email));
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.content_copy),
                  label: Text("Copy to clipboard")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListTile(
      dense: true,
      contentPadding: EdgeInsets.all(8.0),
      onTap: () {},
      trailing: FlatButton(
          onPressed: () {
            createDialogAlert(context).then((onValue) {
              SnackBar mySnackBar = SnackBar(
                  content: Text("${helper.email} copied to clipboard! "));
              Scaffold.of(context).showSnackBar(mySnackBar);
            });
            print("Pressed contact button ");
          },
          child: Icon(Icons.perm_contact_calendar)),

      title: Text("${helper.name}"),

      // title: Text("Ayush Sharma"),
      subtitle: Text("${helper.skills}"),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(helper.photoURL),
      ),
    ));
  }
}
