import 'dart:convert';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/model/dropdown_G_model.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/bottombar/screen/bottom_bar_screen.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/moduls/verifyotp/screen/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  List<Dropdown_Glbl> userNameList = [];
  List<Dropdown_Glbl> companyList = [];
  List<Dropdown_Glbl> yearList = [];
  Dropdown_Glbl? selectedUserName;
  Dropdown_Glbl? selectedCompany;
  Dropdown_Glbl? selectedYear;
  bool isObscured = true;
  bool isVerifyingOtp = false;
  String devToken = "";
  bool isLoadingLogin = false;
  final TextEditingController numberController = TextEditingController(text: '8780917338'); //text: '8780917338'
  final formKey = GlobalKey<FormState>();
  final ApiController apiController = Get.put(ApiController());

  @override
  void onInit() {
    super.onInit();
    saveLoginStatus();
    update();
  }

  Future<void> saveLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('KEY_TOKENNO') != null && prefs.getString('KEY_TOKENNO') != '') {
      print('Before token: ${prefs.getString('KEY_TOKENNO').toString()}');
      String url = 'http://117.217.126.127:44166/api/Employee/authentication';
      var jsonbodyObj = {
        "mobileNo": numberController.text,
        "password": "",
        "otp": "123456",
        "deviceType": "1",
        "deviceName": "string",
        "osType": "string",
        "deviceToken": prefs.getString('KEY_TOKENNO').toString()
      };
      var loginEmp = await apiController.getDynamicData(url, '', jsonbodyObj);
      print(loginEmp);

      var decodedResp = json.decode(loginEmp);
      if (decodedResp["isSuccess"].toString() == "true") {
        var dashboardController = Get.put(DashboardController());
        dashboardController.employeeName = json.decode(loginEmp)["data"]["employeeName"].toString();
        dashboardController.mobileNumber = json.decode(loginEmp)["data"]["mobileNumber"].toString();
        dashboardController.emailAddress = json.decode(loginEmp)["data"]["emailAddress"].toString();
        dashboardController.empCode = json.decode(loginEmp)["data"]["empCode"].toString();
        dashboardController.empType = json.decode(loginEmp)["data"]["emp_Type"].toString();
        dashboardController.department = json.decode(loginEmp)["data"]["department"].toString();
        dashboardController.designation = json.decode(loginEmp)["data"]["designation"].toString();

        dashboardController.update();
      }

      update();
      Get.offAll(const BottomBarView());
    }
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
