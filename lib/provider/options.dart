import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
export 'package:provider/provider.dart';

class Options with ChangeNotifier {
  late SharedPreferences _pref;
  final String key = "options";

  final OptionSingleton _options = OptionSingleton();

  OptionSingleton get options => _options;

  _initPrefs() async {
    _pref = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    String? listString = _pref.getString(key);
    if (listString != null) {
      _options.fromMap(json.decode(listString));
    }
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    String stringList = json.encode(_options.toMap());
    _pref.setString(key, stringList);
  }

  Options() {
    _loadFromPrefs();
  }

  void edit({bool? debug, bool? autoStart}) {
    _options.debug = debug ?? _options.debug;
    _options.autoStart = autoStart ?? _options.autoStart;

    _saveToPrefs();
    notifyListeners();
  }
}

class OptionSingleton {
  static final OptionSingleton _optionsingleton = OptionSingleton._internal();
  bool debug = false;
  bool autoStart = false;

  static const String keydebug = 'debug';
  static const String keyautoStart = 'autoStart';

  // OptionSingleton.fromMap(Map map)
  //     : debug = map[keydebug],
  //       autoStart = map[keyautoStart];

  void fromMap(Map map) {
    debug = map[keydebug];
    autoStart = map[keyautoStart];
  }

  Map toMap() {
    return {
      keydebug: debug,
      keyautoStart: autoStart,
    };
  }

  factory OptionSingleton() {
    return _optionsingleton;
  }

  OptionSingleton._internal();
}

// class OptionModel {
//   bool debug;
//   bool autoStart;

//   static const String keydebug = 'debug';
//   static const String keyautoStart = 'autoStart';

//   OptionModel({
//     this.debug = false,
//     this.autoStart = false,
//   });

//   OptionModel.fromMap(Map map)
//       : debug = map[keydebug],
//         autoStart = map[keyautoStart];

//   Map toMap() {
//     return {
//       keydebug: debug,
//       keyautoStart: autoStart,
//     };
//   }
// }
