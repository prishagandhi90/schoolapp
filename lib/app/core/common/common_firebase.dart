import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/notification/screen/notification_screen.dart';
import 'package:emp_app/firebase_options.dart';
import 'package:emp_app/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

Future<void> InitFirebaseSettings() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(BottomBarController());
  // await Firebase.initializeApp();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.web, // 👈 Yeh line important hai!
    );
  } else
    await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // This runs when user taps on local notification
      print('Local notification clicked!');
      Get.to(() => NotificationScreen()); // Ya koi aur logic
    },
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // String? title = message.notification?.title ?? message.data['title'];
  // String? body = message.notification?.body ?? message.data['body'];
  // print('Message title: ${message.notification!.title}');
  // print('Message body: ${message.notification!.body}');
  // if (title != null && title.toLowerCase() == 'code blue') {
  //   await player.setAudioSource(AudioSource.asset('assets/sounds/codeblue.mp3'));
  //   player.play();
  //   Get.to(() => CodeAlertScreen(codeType: body.toString(), patientId: "patientId"));
  // } else if (title != null && title.toLowerCase() == 'code red') {
  //   // await player.setAudioSource(AudioSource.asset('assets/sounds/codered.mp3'));
  //   // player.play();
  //   Get.to(() => CodeAlertScreen(codeType: title, patientId: "patientId"));
  // }
  print("Handling a background message: ${message.messageId}");
}
