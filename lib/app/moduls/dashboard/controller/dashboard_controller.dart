import 'dart:convert';
import 'package:emp_app/app/core/util/api_error_handler.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/bottombar/screen/bottom_bar_screen.dart';
import 'package:emp_app/app/moduls/common/module.dart';
import 'package:emp_app/app/moduls/dashboard/model/profiledata_model.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/app/moduls/notification/controller/notification_controller.dart';
import 'package:emp_app/app/moduls/verifyotp/model/dashboard_model.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardController extends GetxController {
  String tokenNo = '', loginId = '', empId = '';

  RxBool isLoading = true.obs;
  late List<Profiletable> profiletable = [];
  String employeeName = "",
      mobileNumber = "",
      emailAddress = "",
      empCode = "",
      empType = "",
      department = "",
      designation = "",
      isSuperAdmin = "",
      isPharmacyUser = "",
      notificationCount = "";

  late DashboardTable dashboardTable;
  List<ModuleScreenRights> empModuleScreenRightsTable = [];
  final notificationController = Get.put(NotificationController());

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDashboardDataUsingToken();
      fetchModuleRights();
      hideBottomBar.value = false;
      update();
    });
  }

  Future<List<ModuleScreenRights>> fetchModuleRights() async {
    try {
      // String url = 'http://117.217.126.127:44166/api/Employee/GetEmpSummary_Dashboard';
      String url = ConstApiUrl.empAppModuleRights;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      empId = await pref.getString(AppString.keyEmpId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "EmpId": empId, "ModuleName": "Payroll"};
      if (loginId != "") {
        final ApiController apiController = Get.find<ApiController>();
        var decodedResp = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
        ResponseModuleData responseModuleData = ResponseModuleData.fromJson(jsonDecode(decodedResp));

        if (responseModuleData.statusCode == 200) {
          if (responseModuleData.data != null && responseModuleData.data!.isNotEmpty) {
            isLoading.value = false;
            empModuleScreenRightsTable = responseModuleData.data!;
            update();
            return empModuleScreenRightsTable;
          } else {
            return [];
          }
        } else if (responseModuleData.statusCode == 401) {
          pref.clear();
          Get.offAll(const LoginScreen());
          Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
        } else if (responseModuleData.statusCode == 400) {
          empModuleScreenRightsTable = [];
        } else {
          Get.rawSnackbar(message: "Something went wrong");
        }
        update();
      }
    } catch (e) {
      isLoading.value = false;
      update();
    }
    return [];
  }

  Future<void> gridOnClk(int index, BuildContext context) async {
    final DashboardController dashboardController = Get.put(DashboardController());
    bool hasModuleAccess = dashboardController.empModuleScreenRightsTable.isNotEmpty &&
        dashboardController.empModuleScreenRightsTable.any((element) => element.moduleSeq == (index + 1) && element.rightsYN == 'Y');
    if (hasModuleAccess == false) {
      // if (hasModuleAccess == false) {
      Get.snackbar(
        AppString.noRights,
        '',
        colorText: AppColor.white,
        backgroundColor: AppColor.black,
        duration: const Duration(seconds: 2),
      );
      return;
    }

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
        var bottomBarController = Get.put(BottomBarController());
        bottomBarController.isIPDHome.value = true;
        bottomBarController.isPayrollHome.value = false;
        bottomBarController.isPharmacyHome.value = false;
        hideBottomBar.value = false;
        // bottomBarController.onItemTapped(0, true, context);
        bottomBarController.resetAndInitialize_new(0);
        Get.offAll(() => BottomBarView(), binding: BindingsBuilder(() {
          Get.put(BottomBarController());
        }));
        // Get.snackbar(
        //   AppString.comingsoon,
        //   '',
        //   colorText: AppColor.white,
        //   backgroundColor: AppColor.black,
        //   duration: const Duration(seconds: 1),
        // );
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
        var bottomBarController = Get.put(BottomBarController());
        bottomBarController.isPharmacyHome.value = true;
        bottomBarController.isPayrollHome.value = false;
        bottomBarController.isIPDHome.value = false;
        hideBottomBar.value = false;
        // bottomBarController.onItemTapped(0, true, context);
        bottomBarController.resetAndInitialize_new(0);
        Get.offAll(() => BottomBarView(), binding: BindingsBuilder(() {
          Get.put(BottomBarController());
        }));
        // Get.snackbar(
        //   AppString.comingsoon,
        //   '',
        //   colorText: AppColor.white,
        //   backgroundColor: AppColor.black,
        //   duration: const Duration(seconds: 1),
        // );
        break;
      case 7:
        var bottomBarController = Get.put(BottomBarController());
        hideBottomBar.value = false;
        bottomBarController.isIPDHome.value = false;
        bottomBarController.isPharmacyHome.value = false;
        bottomBarController.isPayrollHome.value = true;
        bottomBarController.resetAndInitialize_new(0);
        Get.offAll(() => BottomBarView(), binding: BindingsBuilder(() {
          Get.put(BottomBarController());
        }));
        // Get.until((route) => route.isFirst);
        // bottomBarController.resetAndInitializeToScreen(0);
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      isLoading.value = true;
      update();

      String token = prefs.getString(AppString.keyToken) ?? '';
      String loginId = prefs.getString(AppString.keyLoginId) ?? '';
      String empId = prefs.getString(AppString.keyEmpId) ?? ''; // Assuming empCode = empID

      if (token.isNotEmpty && loginId.isNotEmpty) {
        var jsonbodyObj = {"loginId": loginId};
        String url = ConstApiUrl.empGetDashboardListAPI;
        final ApiController apiController = Get.put(ApiController());
        var decodedResp = await apiController.parseJsonBody(url, token, jsonbodyObj);
        ResponseDashboardData responseDashboardData = ResponseDashboardData.fromJson(jsonDecode(decodedResp));

        if (responseDashboardData.statusCode == 200) {
          if (responseDashboardData.data != null) {
            dashboardTable = responseDashboardData.data!;
            employeeName = dashboardTable.employeeName.toString();
            mobileNumber = dashboardTable.mobileNumber.toString();
            emailAddress = dashboardTable.emailAddress.toString();
            empCode = dashboardTable.empCode.toString();
            empType = dashboardTable.empType.toString();
            department = dashboardTable.department.toString();
            designation = dashboardTable.designation.toString();
            isSuperAdmin = dashboardTable.isSuperAdmin.toString();
            isPharmacyUser = dashboardTable.isPharmacyUser.toString();
            notificationCount = dashboardTable.notificationCount.toString();
            update();
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
        // Handle missing login or token
      }
    } catch (e) {
      // 🔥 Custom error handler call here
      ApiErrorHandler.handleError(
        screenName: "DashboardScreen",
        error: e.toString(),
        loginID: prefs.getString(AppString.keyLoginId) ?? '',
        tokenNo: prefs.getString(AppString.keyToken) ?? '',
        empID: prefs.getString(AppString.keyEmpId) ?? '',
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // Future<void> getDashboardDataUsingToken() async {
  //   try {
  //     isLoading.value = true;
  //     update();
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     if (prefs.getString(AppString.keyToken) != null && prefs.getString(AppString.keyToken) != '') {
  //       String token = prefs.getString(AppString.keyToken) ?? '';
  //       String loginId = prefs.getString(AppString.keyLoginId) ?? '';
  //       var jsonbodyObj = {"loginId": loginId};
  //       String url = ConstApiUrl.empGetDashboardListAPI;
  //       final ApiController apiController = Get.put(ApiController());
  //       var decodedResp = await apiController.parseJsonBody(url, token, jsonbodyObj);
  //       ResponseDashboardData responseDashboardData = ResponseDashboardData.fromJson(jsonDecode(decodedResp));

  //       if (responseDashboardData.statusCode == 200) {
  //         if (responseDashboardData.data != null) {
  //           dashboardTable = responseDashboardData.data!;
  //           // var dashboardController = Get.put(DashboardController());
  //           employeeName = dashboardTable.employeeName.toString();
  //           mobileNumber = dashboardTable.mobileNumber.toString();
  //           emailAddress = dashboardTable.emailAddress.toString();
  //           empCode = dashboardTable.empCode.toString();
  //           empType = dashboardTable.empType.toString();
  //           department = dashboardTable.department.toString();
  //           designation = dashboardTable.designation.toString();
  //           isSuperAdmin = dashboardTable.isSuperAdmin.toString();
  //           isPharmacyUser = dashboardTable.isPharmacyUser.toString();

  //           // dashboardController.update();
  //           update();
  //         } else {
  //           Get.rawSnackbar(message: "No data found!");
  //         }
  //         update();
  //       } else if (responseDashboardData.statusCode == 401) {
  //         prefs.clear();
  //         Get.offAll(LoginScreen());
  //         Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
  //       }
  //     } else {
  //       // Get.rawSnackbar(message: "Something went wrong");
  //     }
  //   } catch (e) {
  //     isLoading.value = false;
  //     print('Error: $e');
  //   } finally {
  //     isLoading.value = false;
  //     update();
  //   }
  // }
}
