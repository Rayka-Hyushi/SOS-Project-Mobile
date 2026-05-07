import 'package:flutter/cupertino.dart';

import 'model/user.dart';

class UserSession extends ChangeNotifier {
  User? _user;
  User? get user => _user;
  bool get isAuthenticated => _user != null;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void clearSession() {
    _user = null;
    notifyListeners();
  }
}