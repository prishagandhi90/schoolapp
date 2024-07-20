import 'dart:convert';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/moduls/dashboard/screen/dashboard1_screen.dart';
import 'package:emp_app/app/moduls/verifyotp/model/otp_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class OtpController extends GetxController {
  // final GlobalKey<FormState> oTPFormKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  final ApiController apiController = Get.put(ApiController());
  final _storage = const FlutterSecureStorage();
  final TextEditingController otpController = TextEditingController(); //text: '1234'
  final TextEditingController numberController = TextEditingController(); //text: '8780917338'
  bool isLoadingLogin = false;
  List<OTPModel> otpmodel = [];
  int counter = 10;

  final DashboardController dashboardController = Get.put(DashboardController());

  void clearText() {
    otpController.clear();
  }

  Future<String> otp(String otp, BuildContext context, String deviceToken) async {
    try {
      String url = 'http://117.217.126.127:44166/api/Employee/authentication';
      var jsonbodyObj = {
        "mobileNo": numberController.text,
        "password": "",
        "otp": otp,
        "deviceType": "1",
        "deviceName": "string",
        "osType": "string",
        "deviceToken": deviceToken
      };
      var loginEmp = await apiController.getDynamicData(url, '', jsonbodyObj);
      print(loginEmp);
      if (loginEmp == null) {
        return "false";
      }

      var decodedResp = json.decode(loginEmp);
      if (decodedResp["isSuccess"].toString() == "true") {
        await _storage.write(key: "KEY_TOKENNO", value: decodedResp["data"]["token"]);
        await _storage.write(key: "KEY_LOGINID", value: decodedResp["data"]["login_id"].toString());
        await _storage.write(key: "KEY_EMPID", value: decodedResp["data"]["employeeId"].toString());
        // otpmodel = apiController.parseJson_Flag_otptable(loginEmp, "data");

        dashboardController.employeeName = json.decode(loginEmp)["data"]["employeeName"].toString();
        dashboardController.mobileNumber = json.decode(loginEmp)["data"]["mobileNumber"].toString();
        dashboardController.emailAddress = json.decode(loginEmp)["data"]["emailAddress"].toString();
        dashboardController.empCode = json.decode(loginEmp)["data"]["empCode"].toString();
        dashboardController.empType = json.decode(loginEmp)["data"]["emp_Type"].toString();
        dashboardController.department = json.decode(loginEmp)["data"]["department"].toString();
        dashboardController.designation = json.decode(loginEmp)["data"]["designation"].toString();

        dashboardController.update();
        return "true";
      }

      return "false";
    } catch (e) {
      return "false";
    } finally {
      isLoadingLogin = false;
      update();
    }
  }

  Future otpOnClk(BuildContext context, String otpNo, String deviceToken) async {
    // if (isLoggingIn) return;
    // isLoggingIn = true;
    isLoadingLogin = true;
    update();
    try {
      if (formKey.currentState!.validate()) {
        if (otpController.text != otpNo) {
          print('OTP Controller: ${otpController.text}');
          print('OTP: ${otpNo}');
          Get.snackbar('OTP is incorrect!', 'Please enter correct OTP!', colorText: Colors.white, backgroundColor: Colors.black);
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //   content: Text('OTP is incorrect!'),
          // ));
          // isLoggingIn = false;
          return false;
        }
        formKey.currentState!.save();
        String isValidLogin = "false";
        isLoadingLogin = true;
        update();
        isValidLogin = await otp(otpNo, context, deviceToken);

        update();
        if (isValidLogin == "true") {
          otpController.text = "";
          update();
          // Get.to(const HomeScreen());
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard1Screen()),
          );
        } else {
          Get.snackbar('OTP incorrect!', '', colorText: Colors.white, backgroundColor: Colors.black);
        }
      } else {
        Get.snackbar('Please enter the proper Mobile/OTP!', '', colorText: Colors.white, backgroundColor: Colors.black);
      }
      // isLoggingIn = false;
    } catch (e) {
      print(e);
    } finally {
      isLoadingLogin = false;
      update();
    }
  }
}
