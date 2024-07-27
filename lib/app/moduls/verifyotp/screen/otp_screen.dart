import 'dart:async';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/dashboard/screen/dashboard1_screen.dart';
import 'package:emp_app/app/moduls/verifyotp/controller/otp_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
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
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 15.0, color: AppColor.black, fontFamily: CommonFontStyle.plusJakartaSans),
        children: [
          TextSpan(text: AppString.requestnewotp),
          otpController.counter > 0
              ? TextSpan(
                  text: '${otpController.counter}',
                  style: TextStyle(color: AppColor.red, fontFamily: CommonFontStyle.plusJakartaSans),
                )
              : TextSpan(
                  text: AppString.resend,
                  style: TextStyle(color: AppColor.primaryColor, fontFamily: CommonFontStyle.plusJakartaSans),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      startTimer();
                      // resendM();
                    },
                ),
        ],
      ),
    );
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
      Get.snackbar('RespOTP: ${widget.otpNo}', '', colorText: AppColor.white, backgroundColor: AppColor.black);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('RespOTP: ${widget.otpNo}')));
    });
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = Color.fromARGB(255, 94, 157, 168);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 22,
        color: AppColor.primaryColor,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
    );

    return Scaffold(
      backgroundColor: AppColor.backgroundcolor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Form(
                          key: otpController.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                              Text(
                                AppString.verifyyiurnumber,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                              Text(
                                "Please enter the 6 digit code we set to \n+919318****07",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                ),
                              ),
                              const SizedBox(height: 50),
                              Pinput(
                                controller: otpController.isLoadingLogin ? null : otpController.otpController,
                                showCursor: true,
                                length: 6,
                                keyboardType: TextInputType.number,
                                defaultPinTheme: defaultPinTheme,
                                separatorBuilder: (index) => const SizedBox(width: 8),
                                onCompleted: (pin) async {
                                  print('onCompOTP: ${widget.otpNo}');
                                  otpController.isLoadingLogin ? null : await otpController.otpOnClk(context, widget.otpNo, deviceTok);

                                  // PersistentNavBarNavigator.pushNewScreen(
                                  //   context,
                                  //   screen: Dashboard1Screen(),
                                  //   withNavBar: true,
                                  //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                  // ).then((value) {
                                  //   // hideBottomBar.value = false;
                                  //   // controller.getDashboardData();
                                  // });
                                },
                                onChanged: (value) {},
                              ),
                              const SizedBox(height: 20),
                              Container(
                                alignment: AlignmentDirectional.centerStart,
                                child: textWidgetInfo(),
                              ),
                              const SizedBox(height: 50),
                              SizedBox(
                                height: MediaQuery.of(context).size.width * 0.11,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: otpController.isLoadingLogin
                                      ? null
                                      : () async {
                                          if (otpController.otpController.text.isEmpty || otpController.otpController.text.length < 6) {
                                            Get.snackbar(AppString.error, AppString.plzentervalidotp,
                                                colorText: AppColor.white, backgroundColor: AppColor.black);
                                          } else {
                                            await otpController.otpOnClk(context, widget.otpNo, widget.deviceToken);

                                            // PersistentNavBarNavigator.pushNewScreen(
                                            //   context,
                                            //   screen: Dashboard1Screen(),
                                            //   withNavBar: true,
                                            //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                            // ).then((value) {
                                            //   // hideBottomBar.value = false;
                                            //   // controller.getDashboardData();
                                            // });
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.lightgreen,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: otpController.isLoadingLogin
                                      ? const CircularProgressIndicator()
                                      : Text(
                                          AppString.verify,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: AppColor.black,
                                            fontFamily: CommonFontStyle.plusJakartaSans,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Image.asset(
                            AppImage.logo,
                            width: MediaQuery.of(context).size.width * 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
