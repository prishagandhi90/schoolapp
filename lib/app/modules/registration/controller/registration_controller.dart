import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoolapp/app/core/service/api_service.dart';
import 'package:schoolapp/app/core/util/const_api_url.dart';
import 'package:schoolapp/app/modules/login/screen/login_screen.dart';
import 'package:schoolapp/app/modules/registration/reg_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationController extends GetxController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController mobile1Controller = TextEditingController();
  final TextEditingController mobile2Controller = TextEditingController();
  final ApiController apiController = Get.put(ApiController());
  bool isLoading = false;
  final TextEditingController selectedGender = TextEditingController();
  DateTime? selectedDOB;
  // RxString selectedGender = 'Male'.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void pickDate() async {
    DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime(2005),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> saveRegistrationEntry(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      update();

      // String url = "https://yourdomain.com/api/student/register"; // 🔁 Replace with your actual endpoint
      String url = ConstApiUrl.stud_InsUpd_Registration;
      // String loginId = pref.getString(AppString.keyLoginId) ?? "";
      // String tokenNo = pref.getString(AppString.keyToken) ?? "";

      /// 🟡 Create JSON payload from registration form fields
      Map<String, dynamic> jsonBodyObj = {
        "id": 0,
        "name": firstNameController.text.trim(),
        "fatherName": fatherNameController.text.trim(),
        "surname": surnameController.text.trim(),
        "dateOfBirth": dobController.text, // Format must be: "yyyy-MM-ddTHH:mm:ss.SSSZ"
        "gender": selectedGender.text.trim(),
        "address": addressController.text.trim(),
        "pincode": pincodeController.text.trim(),
        "city": cityController.text.trim(),
        "mobile1": mobile1Controller.text.trim(),
        "mobile2": mobile2Controller.text.trim(),
      };

      /// 🔵 API Call via ApiController
      var response = await apiController.parseJsonBody(url, "", jsonBodyObj);
      var responseMap = jsonDecode(response);
      ResponseRegisterModel responseRegisterModel = ResponseRegisterModel.fromJson(jsonDecode(response));

      /// ✅ Handle Response
      if (responseRegisterModel.statusCode == 200 && responseRegisterModel.isSuccess == "true") {
        update();
        Future.delayed(Duration(milliseconds: 500), () {
          if (Get.overlayContext != null) {
            print("Test snackbar after delay ✅");
            Get.rawSnackbar(message: 'Registration successful123!');
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text("Registration successful!")),
            // );
          } else {
            print("❌ Still NULL overlay context");
          }
        });
        // clearData();
      } else if (responseRegisterModel.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Session expired. Please login again.');
      } else {
        Get.rawSnackbar(message: responseMap["message"] ?? "Something went wrong");
      }
    } catch (e) {
      // ApiErrorHandler.handleError(
      //   screenName: "RegistrationScreen",
      //   error: e.toString(),
      //   loginID: pref.getString(AppString.keyLoginId) ?? '',
      //   tokenNo: pref.getString(AppString.keyToken) ?? '',
      //   empID: pref.getString(AppString.keyEmpId) ?? '',
      // );
    } finally {
      isLoading = false;
      update();
    }
  }

  void clearData() {
    firstNameController.clear();
    fatherNameController.clear();
    surnameController.clear();
    dobController.clear();
    addressController.clear();
    pincodeController.clear();
    cityController.clear();
    mobile1Controller.clear();
    mobile2Controller.clear();
    selectedGender.text = "";
  }

  @override
  void onClose() {
    firstNameController.dispose();
    fatherNameController.dispose();
    surnameController.dispose();
    dobController.dispose();
    addressController.dispose();
    pincodeController.dispose();
    cityController.dispose();
    mobile1Controller.dispose();
    mobile2Controller.dispose();
    super.onClose();
  }
}
