import 'package:flutter/material.dart';
export 'package:provider/provider.dart';

class GoogleProvider with ChangeNotifier {
  static bool _loggedIn = false;
  get loggedIn => _loggedIn;

  setLoggedin(bool value) {
    _loggedIn = value;
    // print("App is now Logged ${_loggedIn ? "In" : "Off"}");
    notifyListeners();
  }
}
