import 'dart:io';
import 'package:device_preview/device_preview.dart';
import 'package:emp_app/app/core/common/common_firebase.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/myapp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
RxBool hideBottomBar = false.obs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await InitFirebaseSettings();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn =
        prefs.getString(AppString.keyToken) != null && prefs.getString(AppString.keyToken) != '' ? true : false;

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      if (kReleaseMode) exit(1);
    };

    // runApp(
    //   MyApp(
    //     isLoggedIn: isLoggedIn,
    //   ),
    // );

    runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => MyApp(
          isLoggedIn: isLoggedIn,
        ),
      ),
    );
  } catch (e) {
    print('An error occurred: $e');
    // You can add additional code here to handle the error
  }
}
