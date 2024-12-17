import 'dart:convert';

import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/app/moduls/verifyotp/model/dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetpassController extends GetxController {
  final resetpassKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  final ApiController apiController = Get.put(ApiController());
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  var getData = Get.arguments;
  String mobileNo = '';
  String otp = '';

  @override
  void onInit() {
    super.onInit();
    if (getData != null) {
      mobileNo = getData['mobileNo'];
      otp = getData['otp'];
    }
  }

  resetPassWordApi() async {
    String url = ConstApiUrl.generatenewpass;

    var jsonbodyObj = {"mobileNo": mobileNo, "password": passwordController.text.trim()};
    var decodedResp = await apiController.parseJsonBody(url, '', jsonbodyObj);

    ResponseDashboardData responseDashboardData = ResponseDashboardData.fromJson(jsonDecode(decodedResp));
    if (responseDashboardData.statusCode == 200) {
      if (responseDashboardData.isSuccess.toString().toLowerCase() == "true") {
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: responseDashboardData.message);
      } else {
        Get.rawSnackbar(message: responseDashboardData.message);
      }
    } else if (responseDashboardData.statusCode == 400) {
      Get.rawSnackbar(message: responseDashboardData.message.toString());
    } else if (responseDashboardData.statusCode == 404) {
      Get.rawSnackbar(message: "Not found!");
    } else if (responseDashboardData.statusCode == 500) {
      Get.rawSnackbar(message: "Internal server error");
    } else {
      Get.rawSnackbar(message: AppString.failedtorequestotp);
    }
    // isLoadingLogin = false;
    // return MobileTable();
    return null;
  }
}
