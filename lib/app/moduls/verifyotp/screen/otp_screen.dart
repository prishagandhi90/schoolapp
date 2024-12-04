// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_const.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/login/controller/login_controller.dart';
import 'package:emp_app/app/moduls/verifyotp/controller/otp_controller.dart';
import 'package:emp_app/app/moduls/verifyotp/model/mobileno_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.mobileNumber, required this.deviceToken});
  final String mobileNumber;
  final String deviceToken;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final OtpController otpController = Get.put(OtpController());
  final LoginController loginController = Get.put(LoginController());
  bool isButtonEnabled = false;
  bool isTimerOver = false;
  bool isDropdownEnabled = true;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String deviceTok = "";

  @override
  void dispose() {
    otpController.timer!.cancel();
    otpController.otpController.clear();
    super.dispose();
  }

  void onResendOtp() {
    setState(() {
      otpController.secondsRemaining.value = AppConst.OTPTimer;
    });
    startTimer();
  }

  void startTimer() {
    isButtonEnabled = false;
    otpController.secondsRemaining.value = AppConst.OTPTimer;
    otpController.timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpController.secondsRemaining.value > 0) {
        setState(() {
          otpController.secondsRemaining.value--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void resendOTP(BuildContext context) async {
    otpController.secondsRemaining.value = AppConst.OTPTimer;
    otpController.update();
    startTimer();
    try {
      // final response = await otpController.sendotp();
      var loginController = Get.put(LoginController());
      MobileTable response = await loginController.sendotp();
      // final respOTP = json.decode(response)["data"]["otpNo"].toString();
      final respOTP = response.otpNo.toString();
      setState(() {
        // widget.otpNo = respOTP;
        loginController.responseOTPNo = respOTP;
      });
      // Get.snackbar('RespOTP: $respOTP', '', colorText: AppColor.white, backgroundColor: AppColor.black);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppString.failedtoresendotp),
        ),
      );
    }
  }

  Widget textWidgetInfo() {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 15.0, color: AppColor.black, fontFamily: CommonFontStyle.plusJakartaSans),
        children: [
          TextSpan(text: AppString.requestnewotp),
          otpController.secondsRemaining.value > 0
              ? TextSpan(
                  text:
                      "0${(otpController.secondsRemaining.value / 60).floor().toStringAsFixed(0)} : ${(otpController.secondsRemaining.value % 60).toString().length == 1 ? '0' : ''}${otpController.secondsRemaining.value % 60}",
                  style: TextStyle(color: AppColor.red, fontFamily: CommonFontStyle.plusJakartaSans),
                )
              : TextSpan(
                  text: AppString.resend,
                  style: TextStyle(color: AppColor.primaryColor, fontFamily: CommonFontStyle.plusJakartaSans),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      resendOTP(context);
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
    print('RespOTP: ${loginController.responseOTPNo}');
    otpController.numberController.text = widget.mobileNumber;
    // showSnackBar();
    _firebaseMessaging.requestPermission();

    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
      print("FCM Token: $token");
      setState(() {
        deviceTok = token.toString();
      });
    });
  }

  showSnackBar() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.snackbar('RespOTP: ${loginController.responseOTPNo}', '',
          colorText: AppColor.white, backgroundColor: AppColor.black);
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 22,
        color: AppColor.primaryColor,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.primaryColor),
      ),
    );
    String maskedNumber = otpController.maskMobileNumber(widget.mobileNumber);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                          key: otpController.formKey1,
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
                                "Please enter the 6 digit code we sent to \n+91 $maskedNumber",
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
                                // onCompleted: (pin) async {
                                //   print('onCompOTP: ${loginController.responseOTPNo}');
                                //   otpController.isLoadingLogin
                                //       ? null
                                //       : await otpController.otpOnClk(context, loginController.responseOTPNo, deviceTok);
                                // },
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
                                          if (otpController.otpController.text.isEmpty ||
                                              otpController.otpController.text.length < 6) {
                                            Get.snackbar(
                                              AppString.error,
                                              AppString.plzentervalidotp,
                                              colorText: AppColor.white,
                                              backgroundColor: AppColor.black,
                                              duration: const Duration(seconds: 1),
                                            );
                                          } else {
                                            await otpController.otpOnClk(
                                                context, loginController.responseOTPNo, widget.deviceToken);
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
                        MediaQuery.of(context).viewInsets.bottom > 0
                            ? const Spacer()
                            : Align(
                                alignment: Alignment.bottomCenter,
                                child: Image.asset(
                                  'assets/Venus_Hospital_New_Logo-removebg-preview.png',
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
