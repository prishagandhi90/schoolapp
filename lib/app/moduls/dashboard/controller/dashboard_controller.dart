import 'dart:convert';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/bottombar/screen/bottom_bar_screen.dart';
import 'package:emp_app/app/moduls/dashboard/model/profiledata_model.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/app/moduls/routes/app_pages.dart';
import 'package:emp_app/app/moduls/verifyotp/model/dashboard_model.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardController extends GetxController {
  String tokenNo = '', loginId = '';

  RxBool isLoading = true.obs;
  late List<Profiletable> profiletable = [];
  String employeeName = "",
      mobileNumber = "",
      emailAddress = "",
      empCode = "",
      empType = "",
      department = "",
      designation = "";
  late DashboardTable dashboardTable;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDashboardDataUsingToken();
      hideBottomBar.value = false;
      update();
    });
  }

  Future<void> gridOnClk(int index, BuildContext context) async {
    switch (index) {
      case 0:
        Get.snackbar(
          AppString.comingsoon,
          '',
          colorText: AppColor.white,
          backgroundColor: AppColor.black,
          duration: const Duration(seconds: 1),
        );
        break;
      case 1:
        Get.snackbar(
          AppString.comingsoon,
          '',
          colorText: AppColor.white,
          backgroundColor: AppColor.black,
          duration: const Duration(seconds: 1),
        );
        break;
      case 2:
        Get.snackbar(
          AppString.comingsoon,
          '',
          colorText: AppColor.white,
          backgroundColor: AppColor.black,
          duration: const Duration(seconds: 1),
        );
        break;
      case 3:
        Get.snackbar(
          AppString.comingsoon,
          '',
          colorText: AppColor.white,
          backgroundColor: AppColor.black,
          duration: const Duration(seconds: 1),
        );
        break;
      case 4:
        Get.snackbar(
          AppString.comingsoon,
          '',
          colorText: AppColor.white,
          backgroundColor: AppColor.black,
          duration: const Duration(seconds: 1),
        );
        break;
      case 5:
        Get.snackbar(
          AppString.comingsoon,
          '',
          colorText: AppColor.white,
          backgroundColor: AppColor.black,
          duration: const Duration(seconds: 1),
        );
        break;
      case 6:
        // var bottomBarController = Get.put(BottomBarController());
        // bottomBarController.isPharmacyHome.value = true;
        // hideBottomBar.value = false;
        // bottomBarController.onItemTapped(0, true, context);
        Get.snackbar(
          AppString.comingsoon,
          '',
          colorText: AppColor.white,
          backgroundColor: AppColor.black,
          duration: const Duration(seconds: 1),
        );
        break;
      case 7:
        var bottomBarController = Get.put(BottomBarController());
        hideBottomBar.value = false;
        // Get.until((route) {
        //   print(route.settings); // This will print the route settings to debug
        //   return route.settings == Routes.Payroll;
        // });
        bottomBarController.onItemTapped(0, false, context);

        // var bottomBarController = Get.put(BottomBarController());
        // bottomBarController.isPharmacyHome.value = false;
        // // hideBottomBar.value = false;
        // // bottomBarController.onItemTapped(0, false, context);
        // // bottomBarController.resetAndInitialize();
        // bottomBarController.resetAndInitializeToScreen(0);

        // Get.offAll(() => BottomBarView(), binding: BindingsBuilder(() {
        //   Get.put(BottomBarController());
        // }));

        break;
      case 8:
        Get.snackbar(
          AppString.comingsoon,
          '',
          colorText: AppColor.white,
          backgroundColor: AppColor.black,
          duration: const Duration(seconds: 1),
        );
        break;
      case 9:
        Get.snackbar(
          AppString.comingsoon,
          '',
          colorText: AppColor.white,
          backgroundColor: AppColor.black,
          duration: const Duration(seconds: 1),
        );
        break;
      case 10:
        Get.snackbar(
          AppString.comingsoon,
          '',
          colorText: AppColor.white,
          backgroundColor: AppColor.black,
          duration: const Duration(seconds: 1),
        );
        break;
    }
  }

  void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  Future<dynamic> getProfileData() async {
    try {
      // String url = 'http://117.217.126.127:44166/api/Employee/GetEmpAttendDtl_EmpInfo';
      String url = ConstApiUrl.empAttendanceDtlAPI;
      var jsonbodyObj = {"loginId": loginId};

      final ApiController apiController = Get.put(ApiController());
      var empmonthyrtable = await apiController.getDynamicData(url, tokenNo, jsonbodyObj);

      isLoading.value = false;
      update();
      return profiletable;
    } catch (e) {
      isLoading.value = false;
      update();
    }
    return [];
  }

  Future<void> getDashboardDataUsingToken() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString(AppString.keyToken) != null && prefs.getString(AppString.keyToken) != '') {
        String token = prefs.getString(AppString.keyToken) ?? '';
        String loginId = prefs.getString(AppString.keyLoginId) ?? '';
        var jsonbodyObj = {"loginId": loginId};
        String url = ConstApiUrl.empGetDashboardListAPI;
        final ApiController apiController = Get.put(ApiController());
        var decodedResp = await apiController.parseJsonBody(url, token, jsonbodyObj);
        ResponseDashboardData responseDashboardData = ResponseDashboardData.fromJson(jsonDecode(decodedResp));

        if (responseDashboardData.statusCode == 200) {
          if (responseDashboardData.data != null) {
            dashboardTable = responseDashboardData.data!;
            var dashboardController = Get.put(DashboardController());
            dashboardController.employeeName = dashboardTable.employeeName.toString();
            dashboardController.mobileNumber = dashboardTable.mobileNumber.toString();
            dashboardController.emailAddress = dashboardTable.emailAddress.toString();
            dashboardController.empCode = dashboardTable.empCode.toString();
            dashboardController.empType = dashboardTable.empType.toString();
            dashboardController.department = dashboardTable.department.toString();
            dashboardController.designation = dashboardTable.designation.toString();

            dashboardController.update();
          } else {
            Get.rawSnackbar(message: "No data found!");
          }
          update();
        } else if (responseDashboardData.statusCode == 401) {
          prefs.clear();
          Get.offAll(LoginScreen());
          Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
        }
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
    } catch (e) {
      isLoading.value = false;
      print('Error: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
