import 'dart:async';
import 'dart:convert';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/bottombar/screen/bottom_bar_screen.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/app/moduls/verifyotp/model/dashboard_model.dart';
import 'package:emp_app/app/moduls/verifyotp/model/otp_model.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpController extends GetxController {
  var bottomBarController = Get.put(BottomBarController());
  final formKey1 = GlobalKey<FormState>();
  final ApiController apiController = Get.put(ApiController());
  final TextEditingController otpController = TextEditingController(); //text: '1234'
  final TextEditingController numberController = TextEditingController(); //text: '8780917338'
  bool isLoadingLogin = false;
  List<OTPModel> otpmodel = [];
  Timer? timer;
  RxInt secondsRemaining = 10.obs;
  final DashboardController dashboardController = Get.put(DashboardController());
  late DashboardTable dashboardTable;

  void clearText() {
    otpController.clear();
  }

  @override
  void onInit() {
    super.onInit();
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

  Future<String> getDashboardData(String otp, BuildContext context, String deviceToken) async {
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

      // var loginEmp = await apiController.getDynamicData(url, '', jsonbodyObj);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var decodedResp = await apiController.parseJsonBody(url, '', jsonbodyObj);
      ResponseDashboardData responseDashboardData = ResponseDashboardData.fromJson(jsonDecode(decodedResp));
      dashboardTable = responseDashboardData.data!;

      if (responseDashboardData.statusCode == 200) {
        if (responseDashboardData.data != null && responseDashboardData.isSuccess.toString() == "true") {
          await prefs.setString('KEY_TOKENNO', dashboardTable.token ?? '');
          await prefs.setString('KEY_LOGINID', dashboardTable.loginId.toString());
          await prefs.setString('KEY_EMPID', dashboardTable.employeeId.toString());

          dashboardController.employeeName = dashboardTable.employeeName.toString();
          dashboardController.mobileNumber = dashboardTable.mobileNumber.toString();
          dashboardController.emailAddress = dashboardTable.emailAddress.toString();
          dashboardController.empCode = dashboardTable.empCode.toString();
          dashboardController.empType = dashboardTable.empType.toString();
          dashboardController.department = dashboardTable.department.toString();
          dashboardController.designation = dashboardTable.designation.toString();

          dashboardController.update();
          return "true";
        } else {
          Get.rawSnackbar(message: "No data found!");
        }
      } else if (responseDashboardData.statusCode == 401) {
        prefs.clear();
        Get.offAll(LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseDashboardData.statusCode == 400) {
        Get.rawSnackbar(message: "Data not found!");
      } else if (responseDashboardData.statusCode == 404) {
        Get.rawSnackbar(message: "Not found!");
      } else if (responseDashboardData.statusCode == 500) {
        Get.rawSnackbar(message: "Internal server error");
      } else {
        Get.rawSnackbar(message: "Something went wrong");
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
          title: Text(AppString.logout),
          content: Text(AppString.areyousuretologout),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(AppString.no),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(AppString.yes),
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
            AppString.otpisincorrect,
            AppString.plzentercorrectotp,
            colorText: AppColor.white,
            backgroundColor: AppColor.black,
            duration: const Duration(seconds: 1),
          );
          return false;
        }
        formKey1.currentState!.save();
        String isValidLogin = "false";
        isLoadingLogin = true;
        update();
        isValidLogin = await getDashboardData(otpNo, context, deviceToken);
        update();
        if (isValidLogin == "true") {
          otpController.text = "";
          hideBottomBar.value = false;
          bottomBarController.update();
          update();
          Get.offAll(BottomBarView());
        } else {
          Get.snackbar(
            AppString.otpincorrect,
            '',
            colorText: AppColor.white,
            backgroundColor: AppColor.black,
            duration: const Duration(seconds: 1),
          );
        }
      } else {
        Get.snackbar(
          AppString.plzenterproperotp,
          '',
          colorText: AppColor.white,
          backgroundColor: AppColor.black,
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
