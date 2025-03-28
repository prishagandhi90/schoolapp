import 'dart:io';
import 'package:device_preview/device_preview.dart';
import 'package:emp_app/app/core/common/common_firebase.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/internetconnection/binding/nointernet_binding.dart';
import 'package:emp_app/app/moduls/internetconnection/controller/nointernet_controller.dart';
import 'package:emp_app/app/moduls/routes/app_pages.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
    bool isSuperAdmin = prefs.getString(AppString.keySuperAdmin) != null &&
            prefs.getString(AppString.keySuperAdmin) != '' &&
            prefs.getString(AppString.keySuperAdmin) == 'True'
        ? true
        : false;
    if (isSuperAdmin) {
      await prefs.setString(AppString.keySuperAdmin, '');
    }
    bool isLoggedIn =
        prefs.getString(AppString.keyToken) != null && prefs.getString(AppString.keyToken) != '' && !isSuperAdmin ? true : false;

    // Set up Firebase messaging
    await setupFirebaseMessaging();

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
      Builder(
        builder: (context) {
          Get.put(NoInternetController());
          Sizes.init(context);
          return GetMaterialApp(
            initialBinding: NoInternetBinding(),
            debugShowCheckedModeBanner: false,
            // useInheritedMediaQuery: true,
            // locale: DevicePreview.locale(context),
            // builder: DevicePreview.appBuilder,
            builder: EasyLoading.init(),
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
              useMaterial3: true,
            ),
            // home: widget.isLoggedIn ? BottomBarView() : LoginScreen(),
            initialRoute: AppPages.getInitialRoute(isLoggedIn),
            getPages: AppPages.routes,
            navigatorObservers: [
              NavigatorObserver(),
            ],
          );
        },
      ),
    );

    //   runApp(
    //     DevicePreview(
    //       enabled: !kReleaseMode,
    //       builder: (context) {
    //         Get.put(NoInternetController());
    //         Sizes.init(context);
    //         return GetMaterialApp(
    //           initialBinding: NoInternetBinding(),
    //           debugShowCheckedModeBanner: false,
    //           // useInheritedMediaQuery: true,
    //           locale: DevicePreview.locale(context),
    //           // builder: DevicePreview.appBuilder,
    //           builder: EasyLoading.init(),
    //           title: 'Flutter Demo',
    //           theme: ThemeData(
    //             colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
    //             useMaterial3: true,
    //           ),
    //           // home: widget.isLoggedIn ? BottomBarView() : LoginScreen(),
    //           initialRoute: AppPages.getInitialRoute(isLoggedIn),
    //           getPages: AppPages.routes,
    //           navigatorObservers: [
    //             NavigatorObserver(),
    //           ],
    //         );
    //       },
    //     ),
    //   );
  } catch (e) {
    print('An error occurred: $e');
    // You can add additional code here to handle the error
  }
}

// Firebase messaging setup function
Future<void> setupFirebaseMessaging() async {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Request notification permission
  await _firebaseMessaging.requestPermission();

  // Listen for foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received a message while in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            '1',
            'channel.name',
            channelDescription: 'channel.description',
            icon: android.smallIcon,
          ),
        ),
      );
    }
  });

  // Listen for when the app is opened from a notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      print('Message title: ${message.notification!.title}');
      print('Message body: ${message.notification!.body}');
    }
  });
}
