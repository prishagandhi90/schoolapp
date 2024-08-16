import 'dart:convert';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/moduls/verifyotp/screen/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  bool isObscured = true;
  bool isVerifyingOtp = false;
  String devToken = "";
  bool isLoadingLogin = false;
  final TextEditingController numberController = TextEditingController(text: '8780917338');
  final formKey = GlobalKey<FormState>();
  final ApiController apiController = Get.put(ApiController());

  @override
  void onInit() {
    super.onInit();
    // saveLoginStatus();
    update();
  }

  Future<void> saveLoginStatus() async {
    var dashboardController = Get.put(DashboardController());
    await dashboardController.getDashboardData();
  }

  Future<dynamic> sendotp() async {
    isLoadingLogin = true;
    update();
    try {
      String url = 'http://117.217.126.127:44166/api/EmpLogin/SendEMPMobileOTP';

      var jsonbodyObj = {"mobileNo": numberController.text};
      var loginEmp = await apiController.getDynamicData(url, '', jsonbodyObj);

      isLoadingLogin = false;
      update();
      return loginEmp;
    } catch (e) {
      //
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
        final response = await sendotp();
        if (response != null) {
          final respOTP = json.decode(response)["data"]["otpNo"].toString();
          // final SharedPreferences prefs = await SharedPreferences.getInstance();
          // if (prefs.getString('token') != null && prefs.getString('token') != '') {
          //   await saveLoginStatus();
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('${prefs.getString('token').toString()}')),
          //   );
          //   print(prefs.getString('token'));
          // } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                mobileNumber: numberController.text,
                otpNo: respOTP,
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
