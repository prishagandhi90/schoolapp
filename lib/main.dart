import 'dart:io';
import 'package:schoolapp/app/core/common/common_firebase.dart';
import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/app_string.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:schoolapp/app/moduls/force_update/controller/force_update_controller.dart';
import 'package:schoolapp/app/moduls/internetconnection/binding/nointernet_binding.dart';
import 'package:schoolapp/app/moduls/internetconnection/controller/nointernet_controller.dart';
import 'package:schoolapp/app/moduls/notification/screen/notification_screen.dart';
import 'package:schoolapp/app/moduls/routes/app_pages.dart';
import 'package:schoolapp/my_navigator_observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
RxBool hideBottomBar = false.obs;
final AudioPlayer player = AudioPlayer();

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
    bool isLoggedIn = prefs.getString(AppString.keyToken) != null && prefs.getString(AppString.keyToken) != '' && !isSuperAdmin ? true : false;

    bool isForceUpdate = await ForceUpdateController().isForceUpdateRequired();

    // Set up Firebase messaging
    await setupFirebaseMessaging();

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      if (kReleaseMode) exit(1);
    };

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
            popGesture: true,
            defaultTransition: Transition.cupertino,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: AppColor.white),
              useMaterial3: true,
            ),
            // home: widget.isLoggedIn ? BottomBarView() : LoginScreen(),
            initialRoute: AppPages.getInitialRoute(isLoggedIn, isForceUpdate),
            getPages: AppPages.routes,
            navigatorObservers: [
              // NavigatorObserver(),
              MyNavigatorObserver(),
            ],
          );
        },
      ),
    );
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
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    // print('Received a message while in the foreground!');
    // print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }

    // print('📲 Foreground message received!');
    // print('🔹 Data: ${message.data}');

    // String? title = message.notification?.title ?? message.data['title'];
    // String? body = message.notification?.body ?? message.data['body'];

    // if (title != null && (title.toLowerCase() == 'code blue' || title.toLowerCase() == 'code red')) {
    //   // Play custom sound
    //   if (title.toLowerCase() == 'code blue') {
    //     await player.setAudioSource(AudioSource.asset('assets/sounds/codeblue.mp3'));
    //     player.play();
    //   } else if (title.toLowerCase() == 'code red') {
    //     await player.setAudioSource(AudioSource.asset('assets/sounds/codered.mp3'));
    //     player.play();
    //   }

    //   // Navigate to alert screen
    //   Get.to(() => CodeAlertScreen(codeType: body.toString(), patientId: "patientId"));
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;

    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //       notification.hashCode,
    //       notification.title,
    //       notification.body,
    //       NotificationDetails(
    //         android: AndroidNotificationDetails(
    //           '1',
    //           'channel.name',
    //           channelDescription: 'channel.description',
    //           icon: android.smallIcon,
    //         ),
    //       ),
    //     );
    //   }
    // } else {
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
    // }
  });

  void _handleNotificationNavigation(RemoteMessage message) async {
    print('hvg:' + message.data.toString());
    // String? title = message.notification?.title ?? message.data['title'];
    Get.to(() => NotificationScreen());
  }

  // Listen for when the app is opened from a notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    if (message.notification != null) {
      // String? title = message.notification?.title ?? message.data['title'];
      // String? body = message.notification?.body ?? message.data['body'];
      // print('Message title: ${message.notification!.title}');
      // print('Message body: ${message.notification!.body}');
      // if (title != null && title.toLowerCase() == 'code blue') {
      //   await player.setAudioSource(AudioSource.asset('assets/sounds/codeblue.mp3'));
      //   player.play();
      //   Get.to(() => CodeAlertScreen(codeType: body.toString(), patientId: "patientId"));
      // } else if (title != null && title.toLowerCase() == 'code red') {
      //   await player.setAudioSource(AudioSource.asset('assets/sounds/codered.mp3'));
      //   player.play();
      //   Get.to(() => CodeAlertScreen(codeType: title, patientId: "patientId"));
      // } else {
      _handleNotificationNavigation(message);
      // }
    }
  });

  RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
  if (initialMessage != null) {
    print('App launched from notification (terminated):');
    // if (title != null && title.toLowerCase() == 'code blue') {
    //   await player.setAudioSource(AudioSource.asset('assets/sounds/codeblue.mp3'));
    //   player.play();
    //   Get.to(() => CodeAlertScreen(codeType: body.toString(), patientId: "patientId"));
    // } else if (title != null && title.toLowerCase() == 'code red') {
    //   // await player.setAudioSource(AudioSource.asset('assets/sounds/codered.mp3'));
    //   // player.play();
    //   Get.to(() => CodeAlertScreen(codeType: title, patientId: "patientId"));
    // } else {
    _handleNotificationNavigation(initialMessage);
    // }
  }
}
