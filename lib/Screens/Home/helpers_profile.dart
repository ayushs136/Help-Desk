import 'package:flutter/material.dart';
import 'package:helpdesk_2/data/db/models/helper.dart';
import 'package:helpdesk_2/screens/home/chat_screens/chat_screens.dart';

class HelperProfile extends StatefulWidget {
  final Helper helper;
  HelperProfile({this.helper});
  @override
  _HelperProfileState createState() => _HelperProfileState();
}

class _HelperProfileState extends State<HelperProfile> {
  String urlTemp =
      "https://www.clipartmax.com/png/middle/271-2719453_korea-circle-person-icon-png.png";
  @override
  Widget build(BuildContext context) {
    print(widget.helper);

    // Future<Helper> getHelperData(BuildContext context) async {
    //   // Helper Helper = Helper();
    //   final uid = await Provider.of(context).auth.getCurrentUID();
    //   DocumentSnapshot userData =
    //       await Firestore.instance.collection('userData').document(uid).get();
    //     print(userData.data['name']);
    //   // Helper.fr

    //   return Helper.fromMap(userData.data);
    // }

    // return FutureBuilder(
    //   future: getHelperData(context),
    //   builder: (context, snapshot) {

    //     if(snapshot.hasData){

    return Scaffold(
      backgroundColor: Color(0xff000000),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Helper's Profile",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color(0xff000000),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundImage: NetworkImage(
                    // 'https://lh3.googleusercontent.com/-5axQsnH1ZuM/AAAAAAAAAAI/AAAAAAAAAAA/xAYbnZ7p5AM/s190-p/photo.jpg',
                    // snapshot.data.photoURL,
                    "${(widget.helper.photoURL == null) ? urlTemp : widget.helper.photoURL.toString()}",
                  ),
                ),
              ),
              Divider(
                color: Colors.grey[800],
                height: 60.0,
              ),
              Text(
                'Helper\'s Name',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                "${widget.helper.name}",
                // snapshot.data.name,
                style: TextStyle(
                  color: Colors.amberAccent[200],
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                  letterSpacing: 2.0,
                ),
              ),
              // SizedBox(height: 30.0),
              // Text(
              //   'Last Seen',
              //   style: TextStyle(
              //     color: Colors.grey,
              //     letterSpacing: 2.0,
              //   ),
              // ),

              SizedBox(height: 30.0),
              Text(
                'Skill set',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                "${widget.helper.skills[0]} \n${widget.helper.skills[1]} \n${widget.helper.skills[2]} \n${widget.helper.skills[3]} \n ",

                //  snapshot.data.skills[0]+"\n"+snapshot.data.skills[1]+"\n"+
                //  snapshot.data.skills[2]+"\n"+snapshot.data.skills[3],

                // '8',
                style: TextStyle(
                  color: Colors.amberAccent[200],
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
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
                    "${widget.helper.email}",

                    // snapshot.data.email,
                    // 'chun.li@thenetninja.co.uk',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 15.0,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(width: 20.0),
                ],
              ),

              SizedBox(width: 20.0),
              Text(
                "\nIs Available?",
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 20.0,
                  letterSpacing: 2.0,
                ),
              ),
              Text(
                "${(widget.helper.isAvailable == true) ? '\n Yes' : '\n No'}",

                // snapshot.data.email,
                // 'chun.li@thenetninja.co.uk',
                style: TextStyle(
                  color: (widget.helper.isAvailable == true)
                      ? Colors.greenAccent
                      : Colors.redAccent,
                  fontSize: 18.0,
                  letterSpacing: 1.0,
                ),
              ),

              (widget.helper.isAvailable == true)
                      ?RaisedButton(

                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChatScreen(receiver: widget.helper,)));

                },
                color:Color(0xff0184dc),
                child: Text(
                  "Ask for Help!",
                  // snapshot.data.email,
                  // 'chun.li@thenetninja.co.uk',
                  style: TextStyle(
                    color: Color(0xff19191b),
                    fontSize: 20.0,
                    letterSpacing: 1.0,
                  ),
                ),
              ):Container(),



            ],
          ),
        ),
      ),
    );
    // }
    // else{
    //   return Container(
    //     alignment:Alignment.center,child: CircularProgressIndicator());
    // }

    // );
  }
}
