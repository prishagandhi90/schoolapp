import 'package:device_preview/device_preview.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/internetconnection/binding/nointernet_binding.dart';
import 'package:emp_app/app/moduls/internetconnection/controller/nointernet_controller.dart';
import 'package:emp_app/app/moduls/login/controller/login_controller.dart';
import 'package:emp_app/app/moduls/routes/app_pages.dart';
import 'package:emp_app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.isLoggedIn});
  final bool isLoggedIn;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  var loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    Get.put(BottomBarController());
    _firebaseMessaging.requestPermission();
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

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('Message title: ${message.notification!.title}');
        print('Message body: ${message.notification!.body}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(NoInternetController());
    return GetMaterialApp(
      initialBinding: NoInternetBinding(),
      debugShowCheckedModeBanner: false,
      // useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      builder: EasyLoading.init(),
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      // home: widget.isLoggedIn ? BottomBarView() : LoginScreen(),
      initialRoute: AppPages.getInitialRoute(widget.isLoggedIn),
      getPages: AppPages.routes,
      navigatorObservers: [
        NavigatorObserver(),
      ],
    );
  }
}
