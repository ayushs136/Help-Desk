import 'package:flutter/material.dart';
import 'package:helpdesk_2/Screens/Home/helper_tile.dart';
import 'package:helpdesk_2/data/db/models/helper.dart';

import 'package:provider/provider.dart';

class HelperList extends StatefulWidget {
  @override
  _HelperListState createState() => _HelperListState();
}

class _HelperListState extends State<HelperList> {
  @override
  Widget build(BuildContext context) {
    final helper = Provider.of<List<Helper>>(context) ?? [];
    // print(rooms.documents);
    helper.forEach((helper) {
     
    });
    return ListView.builder(
      itemCount: helper.length,
      itemBuilder: (context, index) {
        return HelperTile(helper:helper[index]);
      },
    );
  }
}