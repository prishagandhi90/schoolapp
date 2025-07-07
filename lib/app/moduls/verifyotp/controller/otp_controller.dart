// ignore_for_file: dead_code

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:emp_app/app/core/util/api_error_handler.dart';
import 'package:device_marketing_names/device_marketing_names.dart';
import 'package:emp_app/app/core/util/app_const.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/bottombar/screen/bottom_bar_screen.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/moduls/forgotpassword/screen/forgotpass_screen.dart';
import 'package:emp_app/app/moduls/login/controller/login_controller.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/app/moduls/PAYROLL_MAIN/mispunch/controller/mispunch_controller.dart';
import 'package:emp_app/app/moduls/resetpassword/controller/resetpass_controller.dart';
import 'package:emp_app/app/moduls/resetpassword/screen/resetpass_screen.dart';
import 'package:emp_app/app/moduls/routes/app_pages.dart';
import 'package:emp_app/app/moduls/verifyotp/model/dashboard_model.dart';
import 'package:emp_app/app/moduls/verifyotp/model/otp_model.dart';
import 'package:emp_app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpController extends GetxController {
  final formKey1 = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController(); //text: '1234'
  final TextEditingController numberController = TextEditingController(); //text: '8780917338'
  bool isLoadingLogin = false;
  List<OTPModel> otpmodel = [];
  Timer? timer;
  RxInt secondsRemaining = AppConst.OTPTimer.obs;
  RxBool enableResendOtp = false.obs;
  late DashboardTable dashboardTable;
  bool fromLogin = false;
  String deviceTok = "";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void clearText() {
    otpController.clear();
  }

  @override
  void onInit() {
    super.onInit();
    _firebaseMessaging.requestPermission();

    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
      print("FCM Token: $token");
      deviceTok = token.toString();
      update();
    });
  }

  Future<dynamic> sendotp() async {
    isLoadingLogin = true;
    update();
    try {
      // String url = 'http://117.217.126.127:44166/api/EmpLogin/SendEMPMobileOTP';
      String url = ConstApiUrl.empSendEMPMobileOtpAPI;
      var jsonbodyObj = {"mobileNo": numberController.text};

      final ApiController apiController = Get.put(ApiController());
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

  Future<String> getDashboardData(String otp, BuildContext context, String deviceToken, String Password) async {
    AndroidDeviceInfo? androidInfo;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final deviceNames = DeviceMarketingNames();
    IosDeviceInfo? iosInfo;
    String? singleDeviceName;
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (Platform.isAndroid) {
      androidInfo = await deviceInfo.androidInfo;
    } else {
      singleDeviceName = await deviceNames.getSingleName();
      iosInfo = await deviceInfo.iosInfo;
    }
    try {
      // String url = 'http://117.217.126.127:44166/api/Employee/authentication';
      String url = ConstApiUrl.loginWithOTP_Pass;
      var jsonbodyObj = {
        "mobileNo": numberController.text,
        "password": Password,
        "otp": otp,
        "deviceType": "1",
        "deviceName": Platform.isAndroid ? androidInfo!.model.toString() : singleDeviceName.toString(),
        "osType": Platform.isAndroid ? androidInfo?.version.release.toString() : iosInfo!.systemVersion.toString(),
        "deviceToken": deviceToken,
        "firebaseId": deviceToken,
      };

      // var loginEmp = await apiController.getDynamicData(url, '', jsonbodyObj);
      final ApiController apiController = Get.put(ApiController());
      var decodedResp = await apiController.parseJsonBody(url, '', jsonbodyObj);
      ResponseDashboardData responseDashboardData = ResponseDashboardData.fromJson(jsonDecode(decodedResp));
      dashboardTable = responseDashboardData.data!;

      if (responseDashboardData.statusCode == 200) {
        if (responseDashboardData.data != null && responseDashboardData.isSuccess.toString() == "true") {
          await pref.setString(AppString.keyToken, dashboardTable.token ?? '');
          await pref.setString(AppString.keyLoginId, dashboardTable.loginId.toString());
          await pref.setString(AppString.keyEmpId, dashboardTable.employeeId.toString());

          // var dashboardController = Get.put(DashboardController());
          final DashboardController dashboardController = Get.put(DashboardController());
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
          Get.rawSnackbar(message: responseDashboardData.message.toString());
        }
      } else if (responseDashboardData.statusCode == 401) {
        pref.clear();
        Get.offAll(LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseDashboardData.statusCode == 400) {
        Get.rawSnackbar(message: "Data not found!");
      } else if (responseDashboardData.statusCode == 404) {
        Get.rawSnackbar(message: "Not found!");
      } else if (responseDashboardData.statusCode == 500) {
        Get.rawSnackbar(message: "Internal server error");
      } else {
        // Get.rawSnackbar(message: "Something went wrong");
      }
      return "false";
    } catch (e) {
      ApiErrorHandler.handleError(
        screenName: "otpScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
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
      // final OtpController otpController = Get.find();
      await logout();
    }
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('tokenprint ${prefs.getString('token')}');
    hideBottomBar.value = true;

    try {
      await prefs.remove(AppString.keyToken);
      await prefs.remove(AppString.keyLoginId);
      await prefs.remove(AppString.keyEmpId);

      Get.delete<MispunchController>();
      final dashboardController = Get.put(DashboardController());
      dashboardController.employeeName = "";
      dashboardController.mobileNumber = "";
      dashboardController.emailAddress = "";
      dashboardController.empCode = "";
      dashboardController.empType = "";
      dashboardController.department = "";
      dashboardController.designation = "";
      dashboardController.update();

      // Get.offAll(() => LoginScreen());
      Get.offAllNamed(Paths.LOGIN);
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  Future otpOnClk(BuildContext context, String otpNo, String deviceToken) async {
    isLoadingLogin = true;
    // update();
    try {
      // if (1 == 2 && otpController.text != otpNo) {
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

      if (fromLogin) {
        if (formKey1.currentState!.validate()) {
          formKey1.currentState!.save();

          String isValidLogin = "false";
          isLoadingLogin = true;
          // update();
          isValidLogin = await getDashboardData(otpNo, context, deviceToken, "");
          // update();
          if (isValidLogin == "true") {
            otpController.text = "";
            if (dashboardTable.isPasswordSet == "N") {
              showForceChangePasswordDialog();
              return;
            }
            // hideBottomBar.value = false;
            // bottomBarController.update();
            // update();
            // Get.offAll(BottomBarView());
            final bottomBarController = Get.put(BottomBarController());
            bottomBarController.resetAndInitialize();
            await bottomBarController.loadPayrollScreens_Rights();
            Get.offAll(() => BottomBarView(), binding: BindingsBuilder(() {
              Get.put(BottomBarController());
            }));
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
      } else {
        timer?.cancel();
        secondsRemaining = 150.obs;
        enableResendOtp.value = true;

        var resetpassController = Get.put(ResetpassController());
        await resetpassController.updateArguments(numberController.text, otpNo);
        // Get.to(
        //   () => ResetpassScreen(),
        //   // const ResetPasswordView(),
        //   duration: const Duration(milliseconds: 700),
        //   arguments: {"otp": otpNo, 'mobileNo': numberController.text},
        //   binding: ResetPasswordBinding(),
        // );
        Get.toNamed(
          Routes.RESET_PASSWORD,
          arguments: {"otp": otpNo, 'mobileNo': numberController.text},
          // duration: const Duration(milliseconds: 700),
        );
      }
    } catch (e) {
      print(e);
    } finally {
      isLoadingLogin = false;
      // update();
    }
  }

  String maskMobileNumber(String mobileNumber) {
    if (mobileNumber.length < 10) return mobileNumber;
    String start = mobileNumber.substring(0, 3);
    String end = mobileNumber.substring(mobileNumber.length - 3);
    return '$start****$end';
  }

  verifyOtp() async {
    var loginController = Get.put(LoginController());
    if (loginController.responseOTPNo == otpController.text.trim()) {
      if (fromLogin) {
        await getDashboardData(loginController.responseOTPNo, Get.context!, "", "");
        return;
      } else {
        timer?.cancel();
        secondsRemaining = 150.obs;
        enableResendOtp.value = true;
        Get.to(() => ResetpassScreen(),
            // const ResetPasswordView(),
            duration: const Duration(milliseconds: 700),
            arguments: {"otp": loginController.responseOTPNo, 'mobileNo': numberController.text});
      }
    } else {
      Get.rawSnackbar(message: "Otp didn't match");
    }
  }

  void showForceChangePasswordDialog() {
    Get.defaultDialog(
      title: "Reset Password Required",
      middleText: "You need to reset your password before proceeding.",
      barrierDismissible: false,
      confirm: ElevatedButton(
        onPressed: () {
          Get.back(); // Close dialog
          Get.offAll(() => ForgotpassScreen(
                mobileNumber: numberController.text,
              )); // Navigate and remove all previous routes
        },
        child: Text("Reset Now"),
      ),
    );
  }
}
