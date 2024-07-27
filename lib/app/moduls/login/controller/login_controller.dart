import 'dart:convert';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/model/dropdown_G_model.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/verifyotp/screen/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // List<Dropdown_Glbl> dropdown_G = [];
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

  // loginApiCall(BuildContext context) async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   AndroidDeviceInfo? androidInfo;
  //   IosDeviceInfo? iosInfo;
  //   final deviceNames = DeviceMarketingNames();
  //   String? singleDeviceName;
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String apiUrl = ConstApiUrl.loginWithPassword;
  //   if (Platform.isAndroid) {
  //     androidInfo = await deviceInfo.androidInfo;
  //   } else {
  //     singleDeviceName = await deviceNames.getSingleName();
  //     iosInfo = await deviceInfo.iosInfo;
  //   }
  //   Map data = {
  //     "mobileNo": numberController.text.trim(),
  //     "password": passwordController.text.trim(),
  //     "deviceType": Platform.isAndroid ? '1' : '2',
  //     "otp": "",
  //     "deviceName": Platform.isAndroid
  //         ? androidInfo!.model.toString()
  //         : singleDeviceName.toString(),
  //     "osType": Platform.isAndroid
  //         ? androidInfo?.version.release.toString()
  //         : iosInfo!.systemVersion.toString(),
  //     "deviceToken": "string"
  //   };
  //   diopackage.Response finalData =
  //       await ApiController.postWithDioForlogin(apiUrl, data);
  //   if (finalData.statusCode == 200) {
  //     LoginModel loginResponse = LoginModel.fromJson(finalData.data);
  //     if (loginResponse.isSuccess.toString().toLowerCase() ==
  //         "true".toLowerCase()) {
  //       LocalPref.saveDataPref('token', loginResponse.data?.token ?? '');
  //       prefs.setString(
  //           'loginId', loginResponse.data?.loginId.toString() ?? '');
  //       prefs.setString('token', loginResponse.data?.token ?? '');
  //       prefs.setString('username', loginResponse.data?.doctorName ?? '');
  //       // prefs.setBool('biometric', BiometricAuth.isBiomerticOn ?? false);
  //       // Get.offAll(const BottomBarView());
  //     } else {
  //       Get.rawSnackbar(message: finalData.data["message"]);
  //     }
  //   } else if (finalData.statusCode == 400) {
  //     Get.rawSnackbar(message: finalData.data["message"]);
  //   } else if (finalData.statusCode == 404) {
  //     Get.rawSnackbar(message: "User not found.");
  //   } else if (finalData.statusCode == 500) {
  //     if (!Get.isSnackbarOpen) {
  //       Get.rawSnackbar(message: "Internal server error");
  //     }
  //   } else {
  //     Get.rawSnackbar(message: finalData.data["message"]);
  //   }
  // }

  // Future<String> otp(String otp, BuildContext context, String deviceToken) async {
  //   try {
  //     String url = 'http://117.217.126.127:44166/api/Employee/authentication';
  //     var jsonbodyObj = {
  //       "mobileNo": numberController.text,
  //       "password": "",
  //       "otp": otp,
  //       "deviceType": "1",
  //       "deviceName": "string",
  //       "osType": "string",
  //       "deviceToken": deviceToken
  //     };
  //     var loginEmp = await apiController.getDynamicData(url, '', jsonbodyObj);
  //     print(loginEmp);
  //     if (loginEmp == null) {
  //       return "false";
  //     }

  //     var decodedResp = json.decode(loginEmp);
  //     if (decodedResp["isSuccess"].toString() == "true") {
  //       await _storage.write(key: "KEY_TOKENNO", value: decodedResp["data"]["token"]);
  //       await _storage.write(key: "KEY_LOGINID", value: decodedResp["data"]["login_id"].toString());
  //       await _storage.write(key: "KEY_EMPID", value: decodedResp["data"]["employeeId"].toString());
  //     }

  //     return decodedResp["isSuccess"].toString();
  //   } catch (e) {
  //     isLoading = false;
  //     update();
  //   }
  //   return "false";
  // }

  // Future<String> otp(String otp, BuildContext context, String deviceToken) async {
  //   try {
  //     String url = 'http://117.217.126.127:44166/api/Employee/authentication';
  //     var jsonbodyObj = {
  //       "mobileNo": numberController.text,
  //       "password": "",
  //       "otp": otp,
  //       "deviceType": "1",
  //       "deviceName": "string",
  //       "osType": "string",
  //       "deviceToken": deviceToken
  //     };
  //     var loginEmp = await apiController.getDynamicData(url, '', jsonbodyObj);
  //     print(loginEmp);
  //     if (loginEmp == null) {
  //       return "false";
  //     }

  //     var decodedResp = json.decode(loginEmp);
  //     if (decodedResp["isSuccess"].toString() == "true") {
  //       await _storage.write(key: "KEY_TOKENNO", value: decodedResp["data"]["token"]);
  //       await _storage.write(key: "KEY_LOGINID", value: decodedResp["data"]["login_id"].toString());
  //       await _storage.write(key: "KEY_EMPID", value: decodedResp["data"]["employeeId"].toString());
  //       return "true";
  //     }

  //     return "false";
  //   } catch (e) {
  //     return "false";
  //   } finally {
  //     isLoadingLogin = false;
  //     update();
  //   }
  // }

  // Future otpOnClk(BuildContext context, String otpNo, String deviceToken) async {
  //   // if (isLoggingIn) return;
  //   // isLoggingIn = true;
  //   isLoadingLogin = true;
  //   update();
  //   try {
  //     if (OTPFormKey.currentState!.validate()) {
  //       if (otpController.text != otpNo) {
  //         print('OTP Controller: ${otpController.text}');
  //         print('OTP: ${otpNo}');
  //         Get.snackbar('OTP is incorrect!', 'Please enter correct OTP!', colorText: Colors.white, backgroundColor: Colors.black);
  //         // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         //   content: Text('OTP is incorrect!'),
  //         // ));
  //         // isLoggingIn = false;
  //         return false;
  //       }
  //       OTPFormKey.currentState!.save();
  //       String isValidLogin = "false";
  //       isLoadingLogin = true;
  //       update();
  //       isValidLogin = await otp(otpNo, context, deviceToken);

  //       update();
  //       if (isValidLogin == "true") {
  //         otpController.text = "";
  //         update();
  //         // Get.to(const HomeScreen());
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => const DashboardScreen()),
  //         );
  //       } else {
  //         Get.snackbar('OTP incorrect!', '', colorText: Colors.white, backgroundColor: Colors.black);
  //       }
  //     } else {
  //       Get.snackbar('Please enter the proper Mobile/OTP!', '', colorText: Colors.white, backgroundColor: Colors.black);
  //     }
  //     // isLoggingIn = false;
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     isLoadingLogin = false;
  //     update();
  //   }
  // }

  // Future otpOnClk(BuildContext context, String otpNo) async {
  //   if (formKey.currentState!.validate()) {
  //     formKey.currentState!.save();
  //     String isValidLogin = "false";
  //     isValidLogin = await otp(otpNo, context);
  //     if (isValidLogin != "true") {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('UserName / Password is incorrect!'),
  //       ));
  //       return;
  //     }
  //     Get.to(const HomeScreen());
  //     // Navigator.push(
  //     //   context,
  //     //   MaterialPageRoute(builder: (context) => const HomeScreen()),
  //     // );
  // }
  // }
}
