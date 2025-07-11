import 'dart:async';
import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/app_const.dart';
import 'package:schoolapp/app/core/util/app_font_name.dart';
import 'package:schoolapp/app/core/util/app_image.dart';
import 'package:schoolapp/app/core/util/app_string.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:schoolapp/app/modules/login/controller/login_controller.dart';
import 'package:schoolapp/app/modules/verifyotp/controller/otp_controller.dart';
import 'package:schoolapp/app/modules/verifyotp/model/mobileno_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.mobileNumber,
    required this.deviceToken,
    required this.fromLogin,
  });

  final String mobileNumber;
  final String deviceToken;
  final bool fromLogin;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final OtpController otpController = Get.put(OtpController());
  final LoginController loginController = Get.put(LoginController());

  @override
  void dispose() {
    otpController.timer?.cancel();
    otpController.otpController.clear();
    super.dispose();
  }

  void startTimer() {
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
      var loginController = Get.put(LoginController());
      MobileTable? response = await loginController.sendotp();
      final respOTP = response!.otpNo.toString();
      setState(() {
        loginController.responseOTPNo = respOTP;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppString.failedtoresendotp)),
      );
    }
  }

  Widget textWidgetInfo() {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: getDynamicHeight(size: 0.017),
          color: AppColor.black,
          fontFamily: CommonFontStyle.plusJakartaSans,
        ),
        children: [
          TextSpan(text: AppString.requestnewotp),
          otpController.secondsRemaining.value > 0
              ? TextSpan(
                  text:
                      "0${(otpController.secondsRemaining.value / 60).floor().toStringAsFixed(0)} : ${(otpController.secondsRemaining.value % 60).toString().padLeft(2, '0')}",
                  style: TextStyle(color: AppColor.red),
                )
              : TextSpan(
                  text: AppString.resend,
                  style: TextStyle(color: AppColor.primaryColor),
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
    super.initState();
    startTimer();
    otpController.numberController.text = widget.mobileNumber;
  }

  @override
  Widget build(BuildContext context) {
    Sizes.init(context);

    final defaultPinTheme = PinTheme(
      width: getDynamicHeight(size: 0.06),
      height: getDynamicHeight(size: 0.06),
      textStyle: TextStyle(
        fontSize: getDynamicHeight(size: 0.024),
        color: AppColor.primaryColor,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.012)),
        border: Border.all(color: AppColor.primaryColor),
      ),
    );

    String maskedNumber = otpController.maskMobileNumber(widget.mobileNumber);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.backgroundcolor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: getDynamicHeight(size: 0.06),
              horizontal: getDynamicHeight(size: 0.02),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Form(
                  key: otpController.formKey1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          AppImage.venuslogo,
                          width: getDynamicHeight(size: 0.45),
                        ),
                      ),
                      SizedBox(height: getDynamicHeight(size: 0.03)),
                      Text(
                        AppString.verifyyiurnumber,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: getDynamicHeight(size: 0.024),
                          fontFamily: CommonFontStyle.plusJakartaSans,
                        ),
                      ),
                      SizedBox(height: getDynamicHeight(size: 0.02)),
                      Text(
                        "Please enter the 6 digit code we sent to \n+91 $maskedNumber",
                        style: TextStyle(
                          fontSize: getDynamicHeight(size: 0.017),
                          fontFamily: CommonFontStyle.plusJakartaSans,
                        ),
                      ),
                      SizedBox(height: getDynamicHeight(size: 0.06)),
                      Pinput(
                        controller: otpController.isLoadingLogin ? null : otpController.otpController,
                        showCursor: true,
                        length: 6,
                        keyboardType: TextInputType.number,
                        defaultPinTheme: defaultPinTheme,
                        separatorBuilder: (index) => SizedBox(width: getDynamicHeight(size: 0.01)),
                        onChanged: (value) {},
                      ),
                      SizedBox(height: getDynamicHeight(size: 0.025)),
                      Container(
                        alignment: AlignmentDirectional.centerStart,
                        child: textWidgetInfo(),
                      ),
                      SizedBox(height: getDynamicHeight(size: 0.06)),
                      SizedBox(
                        height: getDynamicHeight(size: 0.06),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: otpController.isLoadingLogin
                              ? null
                              : () async {
                                  if (otpController.otpController.text.isEmpty || otpController.otpController.text.length < 6) {
                                    Get.snackbar(
                                      AppString.error,
                                      AppString.plzentervalidotp,
                                      colorText: AppColor.white,
                                      backgroundColor: AppColor.black,
                                      duration: const Duration(seconds: 1),
                                    );
                                  } else {
                                    otpController.fromLogin = widget.fromLogin;
                                    otpController.update();
                                    await otpController.otpOnClk(
                                      context,
                                      loginController.responseOTPNo,
                                      otpController.deviceTok,
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.lightgreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                getDynamicHeight(size: 0.012),
                              ),
                            ),
                          ),
                          child: otpController.isLoadingLogin
                              ? const CircularProgressIndicator()
                              : Text(
                                  AppString.verify,
                                  style: TextStyle(
                                    fontSize: getDynamicHeight(size: 0.022),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
