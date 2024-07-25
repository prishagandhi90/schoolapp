import 'dart:async';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/moduls/verifyotp/controller/otp_controller.dart';
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
  final OtpController otpController = Get.put(OtpController());
  late Timer _timer;
  bool isButtonEnabled = false;
  bool isTimerOver = false;
  bool isDropdownEnabled = true;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String deviceTok = "";

  void startTimer() {
    setState(() {
      isButtonEnabled = false;
    });
    otpController.counter = 20;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpController.counter > 0) {
        setState(() {
          otpController.counter--;
        });
      } else {
        setState(() {
          isButtonEnabled = true;
        });
        timer.cancel();
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
      otpController.counter = 20;
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
    if (otpController.counter > 0) {
      return Text(
        "Request otp in ${otpController.counter}",
        style: TextStyle(fontSize: 15.0, color: Colors.white, fontFamily: CommonFontStyle.plusJakartaSans),
      );
    } else {
      return InkWell(
        child: Text(
          'Resend',
          style: TextStyle(fontSize: 15.0, color: Colors.white, fontFamily: CommonFontStyle.plusJakartaSans),
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
    otpController.numberController.text = widget.mobileNumber;
    showSnackBar();
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

  showSnackBar() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.snackbar('RespOTP: ${widget.otpNo}', '', colorText: Colors.white, backgroundColor: Colors.black);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('RespOTP: ${widget.otpNo}')));
    });
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
            child: Form(
              key: otpController.formKey,
              child: Column(
                children: [
                  Align(
                      alignment: AlignmentDirectional.center,
                      child: Image.asset('assets/output-onlinepngtools.png', width: MediaQuery.of(context).size.width * 0.8)),
                  const SizedBox(height: 60),
                  Text(
                    'Enter OTP',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontFamily: CommonFontStyle.plusJakartaSans, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'We have sent you an OTP on +91 1234567890',
                    style: TextStyle(color: Colors.white, fontSize: 17, fontFamily: CommonFontStyle.plusJakartaSans),
                  ),
                  const SizedBox(height: 30),
                  Pinput(
                    controller: otpController.isLoadingLogin ? null : otpController.otpController,
                    showCursor: true,
                    length: 6,
                    keyboardType: TextInputType.number,
                    defaultPinTheme: defaultPinTheme,
                    separatorBuilder: (index) => const SizedBox(width: 8),
                    // validator: (value) {
                    //   if (Get.find<LoginController>().apiController['isValid']) {
                    //     return null;
                    //   } else {
                    //     return 'Pin is incorrect';
                    //   }
                    // },
                    onCompleted: (pin) async {
                      print('onCompOTP: ${widget.otpNo}');
                      otpController.isLoadingLogin ? null : await otpController.otpOnClk(context, widget.otpNo, deviceTok);
                    },
                    onChanged: (value) {},
                    // submittedPinTheme: defaultPinTheme.copyWith(
                    //   decoration: defaultPinTheme.decoration!.copyWith(
                    //     color: fillColor,
                    //     borderRadius: BorderRadius.circular(19),
                    //     border: Border.all(color: focusedBorderColor),
                    //   ),
                    // ),
                  ),
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
                        onPressed: otpController.isLoadingLogin
                            ? null
                            : () async {
                                if (otpController.otpController.text.isEmpty || otpController.otpController.text.length < 6) {
                                  Get.snackbar('Error', 'Please enter valid OTP', colorText: Colors.white, backgroundColor: Colors.black);
                                } else {
                                  // await loginController.otpOnClk(context, loginController.otpController.text, widget.deviceToken);
                                  await otpController.otpOnClk(context, widget.otpNo, widget.deviceToken);
                                }
                              },
                        // loginController.otpOnClk(context, widget.otpNo, deviceTok);

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 23, 53, 109),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: otpController.isLoadingLogin
                            ? const CircularProgressIndicator()
                            : Text('Verify OTP', style: TextStyle(color: Colors.white, fontFamily: CommonFontStyle.plusJakartaSans))),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
