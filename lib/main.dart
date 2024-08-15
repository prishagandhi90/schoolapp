import 'package:device_preview/device_preview.dart';
import 'package:emp_app/app/moduls/bottombar/screen/bottom_bar_screen.dart';
import 'package:emp_app/app/moduls/internetconnection/binding/nointernet_binding.dart';
import 'package:emp_app/app/moduls/internetconnection/controller/nointernet_controller.dart';
import 'package:emp_app/app/moduls/login/controller/login_controller.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
RxBool hideBottomBar = false.obs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getString('KEY_TOKENNO') != null && prefs.getString('KEY_TOKENNO') != '' ? true : false;

  // Get.put(BottomBarController());
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(DevicePreview(
    enabled: true,
    builder: (context) => MyApp(
      isLoggedIn: isLoggedIn,
    ),
  ));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

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
    // loginController.saveLoginStatus();
    // hideBottomBar.value = false;
    // var bottomBarController = Get.put(BottomBarController());
    // bottomBarController.update();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(NoInternetController());
    return GetMaterialApp(
      initialBinding: NoInternetBinding(),
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: widget.isLoggedIn ? BottomBarView() : LoginScreen(),
      navigatorObservers: [
        NavigatorObserver(),
      ],
    );
  }
}
