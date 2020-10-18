import 'package:flutter/material.dart';
import 'package:helpdesk_2/data/service/auth_service.dart';

class ProviderWidget extends InheritedWidget {
  final AuthService auth;
  ProviderWidget({Key key, Widget child, this.auth}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static ProviderWidget of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ProviderWidget) as ProviderWidget);
}
