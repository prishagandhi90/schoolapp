import 'dart:convert';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/moduls/common/module.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class CommonMethods {
  static Future<List<ModuleScreenRights>> fetchModuleScreens(String moduleName) async {
    try {
      String url = ConstApiUrl.empAppScreenRights;
      SharedPreferences pref = await SharedPreferences.getInstance();
      String loginId = pref.getString(AppString.keyLoginId) ?? "";
      String empId = pref.getString(AppString.keyEmpId) ?? "";
      String tokenNo = pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {
        "loginId": loginId,
        "EmpId": empId,
        "ModuleName": moduleName,
      };

      if (loginId.isNotEmpty) {
        // final ApiController apiController = Get.find<ApiController>();
        final ApiController apiController = Get.isRegistered<ApiController>() ? Get.find<ApiController>() : Get.put(ApiController());
        var decodedResp = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
        ResponseModuleData responseModuleData = ResponseModuleData.fromJson(jsonDecode(decodedResp));

        if (responseModuleData.statusCode == 200) {
          return responseModuleData.data ?? [];
        } else if (responseModuleData.statusCode == 401) {
          pref.clear();
          Get.offAll(const LoginScreen());
          Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
        } else if (responseModuleData.statusCode == 400) {
          return [];
        } else {
          Get.rawSnackbar(message: "Something went wrong");
        }
      }
    } catch (e) {
      Get.rawSnackbar(message: "Error: ${e.toString()}");
    }
    return [];
  }
}
