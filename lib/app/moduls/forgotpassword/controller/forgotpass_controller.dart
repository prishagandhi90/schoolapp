import 'dart:convert';

import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/moduls/login/controller/login_controller.dart';
import 'package:emp_app/app/moduls/verifyotp/model/mobileno_model.dart';
import 'package:emp_app/app/moduls/verifyotp/screen/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotpassController extends GetxController {
  final passFormKey = GlobalKey<FormState>();
  // static final passFormKey = GlobalKey<FormState>();
  final TextEditingController numberController = TextEditingController();
  final ApiController apiController = Get.put(ApiController());
  late MobileTable mobileTable;
  bool isLoadingLogin = false;
  String devToken = "";
  // Sends OTP to the entered mobile number using the API
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

  // Validates the form and navigates to OTP screen if OTP is received
  Future<void> requestOTP(BuildContext context) async {
    isLoadingLogin = true;
    String mobNo = numberController.text;
    update();
    try {
      if (passFormKey.currentState!.validate()) {
        MobileTable? response = await sendotp();
        // If OTP is received successfully
        if (response != null && response.otpNo != null && response.otpNo != "") {
          final respOTP = response.otpNo.toString();
          var loginController = Get.put(LoginController());
          loginController.responseOTPNo = respOTP;
          loginController.update();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                mobileNumber: mobNo,
                deviceToken: devToken,
                fromLogin: false,
              ),
            ),
          );
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
