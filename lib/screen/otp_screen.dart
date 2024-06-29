import 'dart:async';
import 'package:emp_app/controller/login_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.mobileNumber, required this.otpNo, required this.deviceToken});
  final String mobileNumber;
  final String otpNo;
  final String deviceToken;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final LoginController loginController = Get.put(LoginController());
  late Timer _timer;
  bool isButtonEnabled = false;
  final formKey = GlobalKey<FormState>();
  bool isTimerOver = false;
  bool isDropdownEnabled = true;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String deviceTok = "";

  void startTimer() {
    setState(() {
      isButtonEnabled = false;
    });
    loginController.counter = 20;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (loginController.counter > 0) {
        setState(() {
          loginController.counter--;
        });
      } else {
        setState(() {
          isButtonEnabled = true;
        });
        timer.cancel();
        onResendOtp();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void onResendOtp() {
    setState(() {
      loginController.counter = 20;
    });
    startTimer();
    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //   content: Text('OTP has been resent. Please check your messages.'),
    // ));
  }

  // void startTimer() {
  //   isButtonEnabled = false;
  //   counter = 20;
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (counter > 0) {
  //       setState(() {
  //         counter--;
  //       });
  //     } else {
  //       _timer.cancel();
  //     }
  //   });
  // }

  Widget textWidgetInfo() {
    if (loginController.counter > 0) {
      return Text(
        "Request otp in ${loginController.counter}",
        style: const TextStyle(
          fontSize: 15.0,
          color: Colors.white,
        ),
      );
    } else {
      return InkWell(
        child: const Text(
          'Resend',
          style: TextStyle(fontSize: 15.0, color: Colors.white),
        ),
        onTap: () {
          startTimer();
          // resendM();
        },
      );
    }
  }

  @override
  void initState() {
    startTimer();
    super.initState();
    print('RespOTP: ${widget.otpNo}');

    _firebaseMessaging.requestPermission();
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('Received a message while in the foreground!');
    //   print('Message data: ${message.data}');

    //   if (message.notification != null) {
    //     print('Message also contained a notification: ${message.notification}');
    //   }
    // });

    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
      print("FCM Token: $token");
      setState(() {
        deviceTok = token.toString();
      });
      // Send this token to your server to register the device
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   // Handle background messages
    //   if (message.notification != null) {
    //     print('Message title: ${message.notification!.title}');
    //     print('Message body: ${message.notification!.body}');
    //     // Navigate to a different screen or update UI
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = Color.fromRGBO(239, 240, 240, 1);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor),
      ),
    );
    return Scaffold(
      backgroundColor: const Color(0xFF74c3c7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                    alignment: AlignmentDirectional.center,
                    child: Image.asset('assets/output-onlinepngtools.png', width: MediaQuery.of(context).size.width * 0.8)),
                const SizedBox(height: 60),
                Text(
                  'Enter OTP',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w800, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text(
                  'We have sent you an OTP on +91 1234567890',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                const SizedBox(height: 30),
                Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  separatorBuilder: (index) => const SizedBox(width: 8),
                  // validator: (value) {
                  //   if (Get.find<LoginController>().apiController['isValid']) {
                  //     return null;
                  //   } else {
                  //     return 'Pin is incorrect';
                  //   }
                  // },
                  onCompleted: (pin) {},
                  onChanged: (value) {},
                  // submittedPinTheme: defaultPinTheme.copyWith(
                  //   decoration: defaultPinTheme.decoration!.copyWith(
                  //     color: fillColor,
                  //     borderRadius: BorderRadius.circular(19),
                  //     border: Border.all(color: focusedBorderColor),
                  //   ),
                  // ),
                ),

                // OtpTextField(
                //   numberOfFields: 6,
                //   keyboardType: TextInputType.number,
                //   borderColor: const Color.fromARGB(255, 209, 208, 209),
                //   focusedBorderColor: const Color.fromARGB(255, 209, 208, 209),
                //   showFieldAsBox: true,
                //   onCodeChanged: (String value) {},
                //   onSubmit: (String value) {},
                // ),
                const SizedBox(height: 30),
                Container(
                  alignment: AlignmentDirectional.centerStart,
                  margin: const EdgeInsets.all(15.0),
                  child: textWidgetInfo(),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.11,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ElevatedButton(
                    onPressed: () {
                      loginController.otpOnClk(context, widget.otpNo, deviceTok);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 23, 53, 109),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Verify', style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
