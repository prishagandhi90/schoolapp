import 'package:device_preview/device_preview.dart';
import 'package:emp_app/app/core/common/common_firebase.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/myapp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
RxBool hideBottomBar = false.obs;

void main() async {
  await InitFirebaseSettings();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getString(AppString.keyToken) != null && prefs.getString(AppString.keyToken) != '' ? true : false;

  runApp(DevicePreview(
    enabled: true,
    builder: (context) => MyApp(
      isLoggedIn: isLoggedIn,
    ),
  ));
}
