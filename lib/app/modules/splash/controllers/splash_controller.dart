import 'package:dio/dio.dart' as diopackage;
import 'package:get/get.dart';
import 'package:schoolapp/app/core/util/const_api_url.dart';
import 'package:schoolapp/app/modules/bottombar/screen/bottom_bar_screen.dart';
import 'package:schoolapp/app/modules/internetconnection/controller/nointernet_controller.dart';
import 'package:schoolapp/app/modules/internetconnection/view/nointernet_screen.dart';
import 'package:schoolapp/app/modules/login/screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  bool apiCall = false;
  @override
  void onInit() {
    super.onInit();
    // gotToNextPage();
    fetchData();
  }

  Future<void> fetchData() async {
    String url1 = "${ConstApiUrl.baseURL}/weatherforecast";
    // "http://117.217.126.127:44166/weatherforecast";
    apiCall = false;
    var dio = diopackage.Dio();
    try {
      // Try fetching data from the active URL
      final response = await dio
          .get(
            url1,
            options: diopackage.Options(
              validateStatus: (_) => true,
            ),
          )
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        ConstApiUrl.initailUrl = "${ConstApiUrl.baseURL}/api";
        // 'http://117.217.126.127:44166/api';
        update();
        // gotToNextPage();
      } else {
        await fetchDataFromSecondUrl();
        throw Exception('Failed to load data from active URL');
      }
    } catch (e) {
      if (!apiCall) {
        await fetchDataFromSecondUrl();
      }
    }
  }

  Future<void> fetchDataFromSecondUrl() async {
    apiCall = true;
    String url2 = "${ConstApiUrl.baseSecondURL}/weatherforecast";
    // "http://103.251.17.214:44166/weatherforecast";
    var dio = diopackage.Dio();

    try {
      final response = await dio
          .get(
            url2,
            options: diopackage.Options(
              validateStatus: (_) => true,
            ),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        ConstApiUrl.initailUrl = "${ConstApiUrl.baseSecondURL}/api";
        // update();
        // 'http://103.251.17.214:44166/api';
        // gotToNextPage();
      } else {
        Get.offAll(const NoInternetView());
        throw Exception('Failed to load data from active URL');
      }
    } catch (e) {
      Get.offAll(const NoInternetView());
    }
  }

  gotToNextPage() async {
    await Future.delayed(const Duration(seconds: 1));
    var control = Get.put(NoInternetController());
    if (control.connectionType.value == 0) {
    } else {
      if (control.connectionType.value == 1 || control.connectionType.value == 2 || control.connectionType.value == 3) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await Future.delayed(const Duration(seconds: 2));
        if (prefs.getString('token') != null && prefs.getString('token') != '') {
          if (prefs.getBool('biometric') == true) {
            // Get.offAll(const BiometricauthView());
          } else {
            // final OtpController otpController = Get.put(OtpController());
            // if (otpController.dashboardTable.isPasswordSet == "N") {
            //   otpController.showForceChangePasswordDialog();
            //   return;
            // }
            Get.offAll(BottomBarView());
          }
        } else {
          Get.offAll(const LoginScreen());
        }
      }
    }
  }
}
