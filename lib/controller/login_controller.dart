import 'dart:convert';
import 'package:emp_app/controller/api_controller.dart';
import 'package:emp_app/model/dropdown_G_model.dart';
import 'package:emp_app/screen/home_screen.dart';
import 'package:emp_app/screen/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  List<Dropdown_Glbl> dropdown_G = [];
  bool isLoading = true;
  List<Dropdown_Glbl> userNameList = [];
  List<Dropdown_Glbl> companyList = [];
  List<Dropdown_Glbl> yearList = [];
  Dropdown_Glbl? selectedUserName;
  Dropdown_Glbl? selectedCompany;
  Dropdown_Glbl? selectedYear;
  bool isObscured = true;
  final _storage = const FlutterSecureStorage();
  final TextEditingController numberController = TextEditingController(text: '8780917338');

  final formKey = GlobalKey<FormState>();

  final ApiController apiController = Get.put(ApiController());

  Future<dynamic> sendotp() async {
    try {
      String url = 'http://117.217.126.127:44166/api/EmpLogin/SendEMPMobileOTP';

      var jsonbodyObj = {"mobileNo": numberController.text};
      var loginEmp = await apiController.GetDynamicData(url, '', jsonbodyObj);

      isLoading = false;
      update();
      return loginEmp;
    } catch (e) {
      isLoading = false;
      update();
    }
  }

  Future<void> requestOTP(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final response = await sendotp();
      if (response != null) {
        final RespOTP = json.decode(response)["data"]["otpNo"].toString();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              mobileNumber: numberController.text,
              otpNo: RespOTP,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to request OTP')),
        );
      }
    }
  }

  // Future<void> requestOTP(BuildContext context) async {
  //   if (formKey.currentState!.validate()) {
  //     final response = await sendotp();
  //     if (response != null) {
  //       final RespOTP = json.decode(response)["data"]["otpNo"].toString();
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => OtpScreen(
  //             mobileNumber: numberController.text,
  //             otpNo: RespOTP,
  //           ),
  //         ),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('message' ?? 'Invalid mobile number')),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Failed to request OTP')),
  //     );
  //   }
  // }

  Future<String> otp(String otp, BuildContext context) async {
    try {
      String url = 'http://117.217.126.127:44166/api/Employee/authentication';
      var jsonbodyObj = {
        "mobileNo": numberController.text,
        "password": "",
        "otp": otp,
        "deviceType": "1",
        "deviceName": "string",
        "osType": "string",
        "deviceToken": "string"
      };
      var loginEmp = await apiController.GetDynamicData(url, '', jsonbodyObj);
      print(loginEmp);
      if (loginEmp == null) {
        return "false";
      }

      var decodedResp = json.decode(loginEmp);
      if (decodedResp["isSuccess"].toString() == "true") {
        await _storage.write(key: "KEY_TOKENNO", value: decodedResp["data"]["token"]);
        await _storage.write(key: "KEY_LOGINID", value: decodedResp["data"]["login_id"].toString());
        await _storage.write(key: "KEY_EMPID", value: decodedResp["data"]["employeeId"].toString());
      }

      return decodedResp["isSuccess"].toString();
    } catch (e) {
      isLoading = false;
      update();
    }
    return "false";
  }

  Future otpOnClk(BuildContext context, String otpNo) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      String isValidLogin = "false";
      isValidLogin = await otp(otpNo, context);
      if (isValidLogin != "true" && 1 == 2) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('UserName / Password is incorrect!'),
        ));
        return;
      }
      // Get.to(const HomeScreen());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      // passwordcontroller.clear();
    }
  }
}
