import 'package:flutter/widgets.dart';
import 'package:helpdesk_shift/models/helper.dart';
import 'package:helpdesk_shift/screens/authentication/auth_services.dart';

class UserProvider with ChangeNotifier {
  Helper _helper;
  AuthServices _authServices = AuthServices();

  Helper get getHelper => _helper;

  Future<void> refreshUser() async {
    Helper helper = await _authServices.getUserDetails();
    _helper = helper;
    notifyListeners();
  }
}
