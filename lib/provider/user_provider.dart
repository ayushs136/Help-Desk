import 'package:flutter/widgets.dart';
import 'package:helpdesk_2/data/db/models/helper.dart';
import 'package:helpdesk_2/data/service/auth_service.dart';

class UserProvider with ChangeNotifier {
  Helper _helper;
  AuthService _authServices = AuthService();

  Helper get getHelper => _helper;

  Future<void> refreshUser() async {
    Helper helper = await _authServices.getUserDetails();
    _helper = helper;
    notifyListeners();
  }
}
