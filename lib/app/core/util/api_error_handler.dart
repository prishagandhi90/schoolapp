import 'package:emp_app/app/core/service/device_info_service.dart';
import 'issue_reporter.dart';

class ApiErrorHandler {
  static Future<void> handleError({
    // 👈 async method
    required String screenName,
    required dynamic error,
    required String loginID,
    required String tokenNo,
    required String empID,
  }) async {
    String errorMessage = error.toString();

    // ✅ Await the future
    final deviceInfo = await DeviceInfoService().getDeviceInfo();

    // // ✅ Show snackbar to user
    // Get.snackbar(
    //   "⚠️ Error in $screenName",
    //   errorMessage,
    //   snackPosition: SnackPosition.BOTTOM,
    //   backgroundColor: Colors.red.shade600,
    //   colorText: Colors.white,
    //   margin: EdgeInsets.all(12),
    //   duration: Duration(seconds: 4),
    // );

    // ✅ Send to backend
    IssueReporter.reportIssue(
      screen: screenName,
      issue: errorMessage,
      loginID: loginID,
      tokenNo: tokenNo,
      empID: empID,
      deviceInfo: deviceInfo,
    );
  }
}
