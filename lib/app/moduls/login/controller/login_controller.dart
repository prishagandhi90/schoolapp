import 'dart:convert';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/bottombar/screen/bottom_bar_screen.dart';
import 'package:emp_app/app/moduls/verifyotp/controller/otp_controller.dart';
import 'package:emp_app/app/moduls/verifyotp/model/mobileno_model.dart';
import 'package:emp_app/app/moduls/verifyotp/screen/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  bool isObscured = true;
  bool isVerifyingOtp = false;
  String devToken = "";
  bool isLoadingLogin = false;
  bool withPaasword = false;
  bool hidePassword = true;
  final TextEditingController numberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  // static final formKey = GlobalKey<FormState>();
  final ApiController apiController = Get.put(ApiController());
  late MobileTable mobileTable;
  String responseOTPNo = "";

  @override
  void onInit() {
    super.onInit();
    // saveLoginStatus();
    // update();
  }

  // Future<void> saveLoginStatus() async {
  //   var dashboardController = Get.put(DashboardController());
  //   await dashboardController.getDashboardDataUsingToken();
  // }

  Future<MobileTable?> sendotp() async {
    isLoadingLogin = true;
    update();
    try {
      String url = ConstApiUrl.empSendEMPMobileOtpAPI;

      var jsonbodyObj = {"mobileNo": numberController.text};
      var decodedResp = await apiController.parseJsonBody(url, '', jsonbodyObj);
      ResponseMobileNo responseMobileNo = ResponseMobileNo.fromJson(jsonDecode(decodedResp));

      if (responseMobileNo.statusCode == 200) {
        if (responseMobileNo.data != null) {
          isLoadingLogin = false;
          mobileTable = responseMobileNo.data!;
          update();
          return mobileTable;
        } else {
          Get.rawSnackbar(message: "No data found!");
        }
      } else if (responseMobileNo.statusCode == 400) {
        Get.rawSnackbar(message: responseMobileNo.message.toString());
      } else if (responseMobileNo.statusCode == 404) {
        Get.rawSnackbar(message: "Not found!");
      } else if (responseMobileNo.statusCode == 500) {
        Get.rawSnackbar(message: "Internal server error");
      } else {
        Get.rawSnackbar(message: AppString.failedtorequestotp);
      }
      // isLoadingLogin = false;
      // return MobileTable();
      return null;
    } catch (e) {
      isLoadingLogin = false;
      print('Error: $e');
      return null;
    } finally {
      isLoadingLogin = false;
      update();
    }
  }

  Future<void> requestLogin(BuildContext context) async {
    if (withPaasword && passwordController.text.isEmpty) {
      Get.rawSnackbar(message: "Password can not be empty");
      return;
    }

    isLoadingLogin = true;
    update();
    try {
      if (withPaasword) {
        final OtpController otpController = Get.put(OtpController());
        otpController.numberController.text = numberController.text;
        update();
        String isValidLogin = "false";
        isValidLogin = await otpController.getDashboardData("", context, otpController.deviceTok, passwordController.text);
        if (isValidLogin == "true") {
          final bottomBarController = Get.put(BottomBarController());
          bottomBarController.resetAndInitialize();
          await bottomBarController.loadPayrollScreens_Rights();

          Get.offAll(() => BottomBarView(), binding: BindingsBuilder(() {
            Get.put(BottomBarController());
          }));
        }
        // else {
        //   Get.snackbar(
        //     AppString.otpincorrect,
        //     '',
        //     colorText: AppColor.white,
        //     backgroundColor: AppColor.black,
        //     duration: const Duration(seconds: 1),
        //   );
        // }
      } else {
        if (loginFormKey.currentState!.validate()) {
          MobileTable? response = await sendotp();
          if (response != null && response.otpNo != null && response.otpNo != "") {
            final respOTP = response.otpNo.toString();
            var loginController = Get.put(LoginController());
            loginController.responseOTPNo = respOTP;
            loginController.update();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(
                  mobileNumber: numberController.text,
                  deviceToken: devToken,
                  fromLogin: true,
                ),
              ),
            );
            // }
          }
          // else {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text(AppString.failedtorequestotp)),
          //   );
          // }
        }
      }
    } catch (e) {
      // Handle exception
    } finally {
      isLoadingLogin = false;
      update();
    }
  }
}
