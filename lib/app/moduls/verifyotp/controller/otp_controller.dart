import 'dart:async';
import 'dart:convert';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/bottombar/screen/bottom_bar_screen.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/app/moduls/verifyotp/model/otp_model.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpController extends GetxController {
  var bottomBarController = Get.put(BottomBarController());
  final formKey1 = GlobalKey<FormState>();
  final ApiController apiController = Get.put(ApiController());
  final _storage = const FlutterSecureStorage();
  final TextEditingController otpController = TextEditingController(); //text: '1234'
  final TextEditingController numberController = TextEditingController(); //text: '8780917338'
  bool isLoadingLogin = false;
  List<OTPModel> otpmodel = [];
  Timer? timer;
  RxInt secondsRemaining = 90.obs;
  final DashboardController dashboardController = Get.put(DashboardController());

  void clearText() {
    otpController.clear();
  }

  @override
  void onInit() {
    super.onInit();
    // bottomBarController.update();
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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('KEY_TOKENNO', decodedResp["data"]["token"] ?? '');
        await prefs.setString('KEY_LOGINID', decodedResp["data"]["login_id"].toString() ?? '');
        await prefs.setString('KEY_EMPID', decodedResp["data"]["employeeId"].toString() ?? '');
        // await _storage.write(key: "KEY_TOKENNO", value: decodedResp["data"]["token"]);
        // await _storage.write(key: "KEY_LOGINID", value: decodedResp["data"]["login_id"].toString());
        // await _storage.write(key: "KEY_EMPID", value: decodedResp["data"]["employeeId"].toString());
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

  Future<void> showLogoutDialog(BuildContext context) async {
    bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
    if (shouldLogout == true) {
      final OtpController otpController = Get.find();
      await otpController.logout();
    }
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('tokenprint ${prefs.getString('token')}');
    hideBottomBar.value = true;
    bottomBarController.update();
    try {
      await prefs.remove("KEY_TOKENNO");
      await prefs.remove("KEY_LOGINID");
      await prefs.remove("KEY_EMPID");

      dashboardController.employeeName = "";
      dashboardController.mobileNumber = "";
      dashboardController.emailAddress = "";
      dashboardController.empCode = "";
      dashboardController.empType = "";
      dashboardController.department = "";
      dashboardController.designation = "";
      dashboardController.update();

      Get.offAll(() => LoginScreen());
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  Future otpOnClk(BuildContext context, String otpNo, String deviceToken) async {
    isLoadingLogin = true;
    update();
    try {
      if (formKey1.currentState!.validate()) {
        if (otpController.text != otpNo) {
          print('OTP Controller: ${otpController.text}');
          print('OTP: $otpNo');
          Get.snackbar(
            'OTP is incorrect!',
            'Please enter correct OTP!',
            colorText: Colors.white,
            backgroundColor: Colors.black,
            duration: const Duration(seconds: 1),
          );
          return false;
        }
        formKey1.currentState!.save();
        String isValidLogin = "false";
        isLoadingLogin = true;
        update();
        isValidLogin = await otp(otpNo, context, deviceToken);
        update();
        if (isValidLogin == "true") {
          // await _storage.write(key: "KEY_TOKENNO", value: decodedResp["data"]["token"]);
          // await _storage.write(key: "KEY_LOGINID", value: decodedResp["data"]["login_id"].toString());
          // await _storage.write(key: "KEY_EMPID", value: decodedResp["data"]["employeeId"].toString());
          otpController.text = "";
          bottomBarController.update();
          update();
          Get.offAll(BottomBarView());
        } else {
          Get.snackbar(
            'OTP incorrect!',
            '',
            colorText: Colors.white,
            backgroundColor: Colors.black,
            duration: const Duration(seconds: 1),
          );
        }
      } else {
        Get.snackbar(
          'Please enter the proper Mobile/OTP!',
          '',
          colorText: Colors.white,
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 1),
        );
      }
    } catch (e) {
      print(e);
    } finally {
      isLoadingLogin = false;
      update();
    }
  }

  String maskMobileNumber(String mobileNumber) {
    if (mobileNumber.length < 10) return mobileNumber;
    String start = mobileNumber.substring(0, 3);
    String end = mobileNumber.substring(mobileNumber.length - 3);
    return '$start****$end';
  }
}
