// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:helpdesk_shift/models/customer.dart';
// import 'package:helpdesk_shift/screens/authentication/provider_widget.dart';
// import 'package:helpdesk_shift/services/database.dart';
// import 'dart:async';
// import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

// class NewTripDateView extends StatefulWidget {

//   final Customer customer;

//   NewTripDateView({required this.customer, Key key}) : super(key: key);

//   @override
//   _NewTripDateViewState createState() => _NewTripDateViewState();
// }

// class _NewTripDateViewState extends State<NewTripDateView> {
//   // final customerCollection = NewTripDateView._db.collection('customer');
//   final _db = DatabaseServices.db;

//   DateTime _fromDate = DateTime.now();

//   DateTime _toDate = DateTime.now().add(Duration(days: 7));

//   Future displayDateRangePicker(BuildContext context) async {
//     final List<DateTime> picked = await DateRagePicker.showDatePicker(
//       context: context,
//       initialFirstDate: _fromDate,
//       initialLastDate: _toDate,
//       firstDate: new DateTime(DateTime.now().year - 50),
//       lastDate: new DateTime(DateTime.now().year + 50),
//     );

//     if (picked != null && picked.length == 2) {
//       setState(() {
//         _fromDate = picked[0];
//         _toDate = picked[1];
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Select Dates'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
             
//               RaisedButton(
//                 child: Text("Select Dates!"),
//                 onPressed: () async {
//                   displayDateRangePicker(context);
//                 },
//               ),
//               Padding(
//                   padding: const EdgeInsets.all(30.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: <Widget>[
//                       Text(
//                           "From: ${DateFormat('dd/MM/yyyy').format(_fromDate).toString()} \nTo: ${DateFormat('dd/MM/yyyy').format(_toDate).toString()}"),
//                     ],
//                   )),
//               RaisedButton(
//                   onPressed: () async {
                    
//                     final uid = await Provider.of(context).auth.getCurrentUID();
//                     await _db.collection("deskview").add(widget.customer.toJSON());
//                     await _db
//                         .collection('userData')
//                         .document(uid)
//                         .collection("Personal Details")
//                         .add(widget.customer.toJSON());

//                     Navigator.of(context).popUntil((route) => route.isFirst);
//                   },
//                   child: Text('Continue')),
//             ],
//           ),
//         ));
//   }
// }
