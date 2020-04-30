import 'package:flutter/material.dart';
import 'package:helpdesk_2/screens/authentication/auth_services.dart';

class Provider extends InheritedWidget {
  final AuthServices auth;
  Provider({Key key, Widget child, this.auth}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static Provider of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(Provider) as Provider);
}
