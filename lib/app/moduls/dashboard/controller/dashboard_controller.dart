import 'dart:convert';

import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/bottombar/screen/bottom_bar_screen.dart';
import 'package:emp_app/app/moduls/dashboard/model/profiledata_model.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/app/moduls/payroll/screen/payroll_screen.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardController extends GetxController {
  String tokenNo = '', loginId = '';
  final ApiController apiController = Get.put(ApiController());
  var bottomBarController = Get.put(BottomBarController());
  bool isLoading = true;
  late List<Profiletable> profiletable = [];
  String employeeName = "", mobileNumber = "", emailAddress = "", empCode = "", empType = "", department = "", designation = "";

  @override
  void onInit() {
    super.onInit();
    getProfileData();
    hideBottomBar.value = false;
    update();
  }

  Future<void> gridOnClk(int index, BuildContext context) async {
    switch (index) {
      case 0:
        Get.snackbar(
          'Coming Soon',
          '',
          colorText: Colors.white,
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 1),
        );
        break;
      case 1:
        Get.snackbar(
          'Coming Soon',
          '',
          colorText: Colors.white,
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 1),
        );
        break;
      case 2:
        Get.snackbar(
          'Coming Soon',
          '',
          colorText: Colors.white,
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 1),
        );
        break;
      case 3:
        Get.snackbar(
          'Coming Soon',
          '',
          colorText: Colors.white,
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 1),
        );
        break;
      case 4:
        Get.snackbar(
          'Coming Soon',
          '',
          colorText: Colors.white,
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 1),
        );
        break;
      case 5:
        Get.snackbar(
          'Coming Soon',
          '',
          colorText: Colors.white,
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 1),
        );
        break;
      case 6:
        Get.snackbar(
          'Coming Soon',
          '',
          colorText: Colors.white,
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 1),
        );
        break;
      case 7:
        hideBottomBar.value = false;
        var bottomBarController = Get.put(BottomBarController());
        bottomBarController.update();
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: const PayrollScreen(),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        ).then((value) {
          // hideBottomBar.value = false;
          // var bottomBarController = BottomBarController();
          // bottomBarController.update();
          // controller.getDashboardData();
        });

        break;
      case 8:
        Get.snackbar(
          'Coming Soon',
          '',
          colorText: Colors.white,
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 1),
        );
        break;
      case 9:
        Get.snackbar(
          'Coming Soon',
          '',
          colorText: Colors.white,
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 1),
        );
        break;
      case 10:
        Get.snackbar(
          'Coming Soon',
          '',
          colorText: Colors.white,
          backgroundColor: Colors.black,
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
      String url = 'http://117.217.126.127:44166/api/Employee/GetEmpAttendDtl_EmpInfo';
      var jsonbodyObj = {"loginId": loginId};

      var empmonthyrtable = await apiController.getDynamicData(url, tokenNo, jsonbodyObj);
      // profiletable = apiController.parseJson_Flag_attendence(empmonthyrtable, 'data');

      isLoading = false;
      update();
      return profiletable;
    } catch (e) {
      isLoading = false;
      update();
    }
    return [];
  }

  Future<void> getDashboardData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('KEY_TOKENNO') != null && prefs.getString('KEY_TOKENNO') != '') {
      String token = prefs.getString('KEY_TOKENNO') ?? '';
      String loginId = prefs.getString('KEY_LOGINID') ?? '';
      var jsonbodyObj = {"loginId": loginId};
      String url = 'http://117.217.126.127:44166/api/Employee/GetDashboardList';
      var empmonthyrtable = await apiController.getDynamicData(url, token, jsonbodyObj);
      if (empmonthyrtable != "" && jsonDecode(empmonthyrtable)["statusCode"] == 200) {
        var decodedResp = json.decode(empmonthyrtable);
        if (decodedResp["isSuccess"].toString() == "true") {
          var dashboardController = Get.put(DashboardController());
          dashboardController.employeeName = json.decode(empmonthyrtable)["data"]["employeeName"].toString();
          dashboardController.mobileNumber = json.decode(empmonthyrtable)["data"]["mobileNumber"].toString();
          dashboardController.emailAddress = json.decode(empmonthyrtable)["data"]["emailAddress"].toString();
          dashboardController.empCode = json.decode(empmonthyrtable)["data"]["empCode"].toString();
          dashboardController.empType = json.decode(empmonthyrtable)["data"]["emp_Type"].toString();
          dashboardController.department = json.decode(empmonthyrtable)["data"]["department"].toString();
          dashboardController.designation = json.decode(empmonthyrtable)["data"]["designation"].toString();

          dashboardController.update();
        }
        update();
        Get.offAll(const BottomBarView());
      } else {
        prefs.clear();
        Get.offAll(LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      }
    } else {
      prefs.clear();
      Get.offAll(LoginScreen());
    }

    Get.offAll(LoginScreen());
    // else {
    //   Get.rawSnackbar(message: "Something went wrong");
    // }
  }
}
