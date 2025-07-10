import 'dart:convert';
import 'package:schoolapp/app/core/service/api_service.dart';
import 'package:schoolapp/app/core/util/api_error_handler.dart';
import 'package:schoolapp/app/core/util/app_string.dart';
import 'package:schoolapp/app/core/util/const_api_url.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForceUpdateController extends GetxController {
  final ApiController apiController = Get.put(ApiController());

  Future<Map<String, dynamic>> fetchUpdateInfoFromAPI() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      String url = ConstApiUrl.empForceUpdateAPI;
      var response = await apiController.parseJsonBody(url, '', '');

      if (response != null && response != 'NetworkError' && response != 'Error') {
        var decodedData = jsonDecode(response); // bas ek simple decode

        if (decodedData is List && decodedData.isNotEmpty) {
          var data = decodedData[0];
          String? forceUpdYN = data['forceUpdYN'];
          String? latestVersion = data['versionName'] ?? '';

          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          String currentVersion = packageInfo.version;

          if (currentVersion != latestVersion && forceUpdYN == 'Y') {
            return {
              'forceUpdYN': forceUpdYN,
              'versionName': data['versionName'] ?? '',
            };
          }
        }
      }
      return {};
    } catch (e) {
      ApiErrorHandler.handleError(
        screenName: "ForceUpdateScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
      return {};
    }
  }

  // 👉 YE naya function add karo
  Future<bool> isForceUpdateRequired() async {
    Map<String, dynamic> updateInfo = await fetchUpdateInfoFromAPI();

    String forceUpdYN = updateInfo['forceUpdYN'] ?? 'N';

    return forceUpdYN == 'Y';
  }
}
