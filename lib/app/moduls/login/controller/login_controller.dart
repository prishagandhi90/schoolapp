import 'dart:convert';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/verifyotp/model/mobileno_model.dart';
import 'package:emp_app/app/moduls/verifyotp/screen/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  bool isObscured = true;
  bool isVerifyingOtp = false;
  String devToken = "";
  bool isLoadingLogin = false;
  final TextEditingController numberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final ApiController apiController = Get.put(ApiController());
  late MobileTable mobileTable;
  String responseOTPNo = "";

  @override
  void onInit() {
    super.onInit();
    // saveLoginStatus();
    update();
  }

  // Future<void> saveLoginStatus() async {
  //   var dashboardController = Get.put(DashboardController());
  //   await dashboardController.getDashboardDataUsingToken();
  // }

  Future<MobileTable> sendotp() async {
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
        Get.rawSnackbar(message: "Data not found!");
      } else if (responseMobileNo.statusCode == 404) {
        Get.rawSnackbar(message: "Not found!");
      } else if (responseMobileNo.statusCode == 500) {
        Get.rawSnackbar(message: "Internal server error");
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      isLoadingLogin = false;
      return MobileTable();
    } catch (e) {
      isLoadingLogin = false;
      print('Error: $e');
      return MobileTable();
    } finally {
      isLoadingLogin = false;
      update();
    }
  }

  Future<void> requestOTP(BuildContext context) async {
    isLoadingLogin = true;
    update();
    try {
      if (formKey.currentState!.validate()) {
        MobileTable response = await sendotp();
        if (response != null) {
          // final respOTP = json.decode(response)["data"]["otpNo"].toString();
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
              ),
            ),
          );
          // }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppString.failedtorequestotp)),
          );
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
