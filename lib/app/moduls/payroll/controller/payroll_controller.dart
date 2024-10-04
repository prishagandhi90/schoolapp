import 'dart:convert';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_const.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/attendence/controller/attendence_controller.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/app/moduls/mispunch/controller/mispunch_controller.dart';
import 'package:emp_app/app/moduls/mispunch/screen/mispunch_screen.dart';
import 'package:emp_app/app/moduls/payroll/model/empsummdash_model.dart';
import 'package:emp_app/app/moduls/payroll/model/payroll_model.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PayrollController extends GetxController {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
  var bottomBarController = Get.put(BottomBarController());
  var isLoading = false.obs;
  late List<Payroll> payrolltable = [];
  TextEditingController textEditingController = TextEditingController();
  String tokenNo = '', loginId = '';
  FocusNode focusNode = FocusNode();
  bool hasFocus = false;
  List<EmpSummDashboardTable> empSummDashboardTable = [];

  @override
  void onInit() {
    super.onInit();
    getProfileData();
    // hideBottomBar.value = false;
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    hideBottomBar.value = false;
    // });
    filteredList = originalList;
    // focusNode.addListener(() {
    //   hasFocus = focusNode.hasFocus;
    //   update();
    // });
    update();
  }

  @override
  void onClose() {
    focusNode.dispose();
    textEditingController.dispose();
    super.onClose();
  }

  Future<dynamic> getProfileData() async {
    try {
      // String url = 'http://117.217.126.127:44166/api/Employee/GetEmpSummary_Dashboard';
      String url = ConstApiUrl.empDashboardSummaryAPI;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId};

      final ApiController apiController = Get.find<ApiController>();
      var decodedResp = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseEmpSummDashboardData empSummDashboardDataResponse = ResponseEmpSummDashboardData.fromJson(jsonDecode(decodedResp));

      if (empSummDashboardDataResponse.statusCode == 200) {
        if (empSummDashboardDataResponse.data != null && empSummDashboardDataResponse.data!.isNotEmpty) {
          isLoading.value = false;
          empSummDashboardTable = empSummDashboardDataResponse.data!;
          update();
          return empSummDashboardTable;
        } else {
          empSummDashboardTable = [];
        }
        update();
      } else if (empSummDashboardDataResponse.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (empSummDashboardDataResponse.statusCode == 400) {
        empSummDashboardTable = [];
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading.value = false;
      update();
    }
    return [];
  }

  Future<void> payrolListOnClk(int index, BuildContext context) async {
    switch (index) {
      case 0:
        hideBottomBar.value = false;
        final bottomBarController = Get.put(BottomBarController());
        final attendanceController = Get.put(AttendenceController());
        // final attendanceController = Get.find<AttendenceController>();
        attendanceController.initialIndex.value = 0;
        attendanceController.resetData();
        attendanceController.update();
        if (bottomBarController.persistentController.value.index != 1) {
          bottomBarController.currentIndex.value = 1;
          bottomBarController.persistentController.value.index = 1;
          // bottomBarController.onItemTapped(1, context);
          // Get.to(attendanceScreen);
        }
        // PersistentNavBarNavigator.pushNewScreen(
        //   context,
        //   screen: AttendanceScreen(),
        //   withNavBar: true,
        //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
        // ).then((value) async {
        //   hideBottomBar.value = false;
        //   final DashboardController dashboardController = Get.find<DashboardController>();
        //   await dashboardController.getDashboardDataUsingToken();
        // });
        break;
      case 1:
        hideBottomBar.value = false;
        final bottomBarController = Get.put(BottomBarController());
        bottomBarController.currentIndex.value = -1;

        // Get.delete<MispunchController>();
        final mispunchController = Get.put(MispunchController());
        mispunchController.resetData();
        mispunchController.update();
        // Get.put(MispunchScreen());
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: const MispunchScreen(),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        ).then((value) async {
          // final bottomBarController = Get.find<BottomBarController>();
          bottomBarController.persistentController.value.index = 0;
          bottomBarController.currentIndex.value = 0;
          hideBottomBar.value = false;
          var dashboardController = Get.put(DashboardController());
          await dashboardController.getDashboardDataUsingToken();
        });
        break;
      case 2:
        // hideBottomBar.value = false;
        // var bottomBarController = Get.put(BottomBarController());
        // PersistentNavBarNavigator.pushNewScreen(
        //   context,
        //   screen: LeaveMainScreen(),
        //   withNavBar: true,
        //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
        // ).then((value) async {
        //   hideBottomBar.value = false;
        //   await dashboardController.getDashboardDataUsingToken();
        // });
        Get.snackbar(
          AppString.comingsoon,
          '',
          colorText: AppColor.white,
          backgroundColor: AppColor.black,
          duration: const Duration(seconds: 1),
        );
        break;
      case 3:
        // hideBottomBar.value = false;
        // // var bottomBarController = Get.put(BottomBarController());
        // final bottomBarController = Get.isRegistered<BottomBarController>()
        //     ? Get.find<BottomBarController>() // If already registered, find it
        //     : Get.put(BottomBarController());
        // bottomBarController.update();
        // PersistentNavBarNavigator.pushNewScreen(
        //   context,
        //   screen: OvertimeMainScreen(),
        //   withNavBar: true,
        //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
        // ).then((value) async {
        //   hideBottomBar.value = false;
        //   await dashboardController.getDashboardDataUsingToken();
        // });
        Get.snackbar(
          AppString.comingsoon,
          '',
          colorText: AppColor.white,
          backgroundColor: AppColor.black,
          duration: const Duration(seconds: 1),
        );
        break;
      default:
    }
  }

  List<Map<String, dynamic>> originalList = AppConst.payrollgrid;
  List<Map<String, dynamic>> filteredList = [];

  void filterSearchResults(String query) {
    List<Map<String, dynamic>> tempList = [];
    if (query.isNotEmpty) {
      tempList = originalList.where((item) => item['label'].toLowerCase().contains(query.toLowerCase())).toList();
    } else {
      tempList = originalList;
    }

    filteredList = tempList;
    update();
  }
}
