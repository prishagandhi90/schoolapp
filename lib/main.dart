import 'package:device_preview/device_preview.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/dashboard/screen/dashboard1_screen.dart';
import 'package:emp_app/app/moduls/internetconnection/binding/nointernet_binding.dart';
import 'package:emp_app/app/moduls/internetconnection/controller/nointernet_controller.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
RxBool hideBottomBar = false.obs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(BottomBarController());
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(DevicePreview(
    enabled: true,
    builder: (context) => const MyApp(),
  ));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // String otpNo = "";

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

    // _firebaseMessaging.getToken().then((String? token) {
    //   assert(token != null);
    //   print("FCM Token: $token");
    //   setState(() {
    //     deviceToken = token!;
    //   });

    //   // Send this token to your server to register the device
    // });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle background messages
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
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: LoginNumber(),
      // home: Dashboard1Screen(),
    );
  }
}
