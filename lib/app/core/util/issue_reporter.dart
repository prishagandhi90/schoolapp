import 'package:schoolapp/app/core/service/api_service.dart';
import 'package:schoolapp/app/core/service/device_info_service.dart';
import 'package:schoolapp/app/core/util/const_api_url.dart';
import 'package:get/get.dart';

final deviceInfo = DeviceInfoService().getDeviceInfo();

class IssueReporter {
  static Future<void> reportIssue({
    required String screen,
    required String issue,
    required String loginID,
    required String tokenNo,
    required String empID,
    required String deviceInfo,
  }) async {
    final url = ConstApiUrl.empPostIssue;

    final jsonBody = {
      "screenName": screen,
      "errorMessage": issue,
      "loginID": loginID,
      "tokenNo": tokenNo,
      "empID": empID,
      "deviceInfo": deviceInfo,
    };

    try {
      final ApiController apiController = Get.put(ApiController());
      var response = await apiController.parseJsonBody(url, "", jsonBody);
    } catch (e) {
      print("❌ Error reporting issue: $e");
    }
  }
}
