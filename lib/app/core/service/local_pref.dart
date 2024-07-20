import 'dart:convert';

import 'package:emp_app/app/core/utils.dart';

class LocalPref {
  static void saveDataPref(String key, String value) {
    Utils.getStorage.write(key, value);
    print("$key : $value data saved in pref");
  }

  static dynamic getPrefData(String key) {
    var userData = Utils.getStorage.read(key);
    if (userData != null) {
      return (jsonDecode(userData));
    } else {
      return null;
    }
  }
}

// LoginResponse userData = LoginResponse();
