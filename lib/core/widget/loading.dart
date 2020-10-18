import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff133041),
      child: Center(
        child: SpinKitDoubleBounce(
          color: Color(0xff27ce67),
          size: 50.0,
        ),
      ),
    );
  }
}
