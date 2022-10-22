import 'package:flutter/material.dart';
export 'package:provider/provider.dart';

class DebugSingleton {
  static final DebugSingleton _debugsingleton = DebugSingleton._internal();
  bool debug = false;

  factory DebugSingleton() {
    return _debugsingleton;
  }

  DebugSingleton._internal();
}

class DebugController with ChangeNotifier {
  // static bool _debug = false;
  final _debugSingleton = DebugSingleton();

  get debug => _debugSingleton.debug;

  setDebug(bool value) {
    _debugSingleton.debug = value;
    // print("App is now Logged ${_loggedIn ? "In" : "Off"}");
    notifyListeners();
  }
}
