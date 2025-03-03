// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_const.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/attendence/controller/attendence_controller.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/common/module.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/moduls/dutyschedule/controller/dutyschedule_controller.dart';
import 'package:emp_app/app/moduls/dutyschedule/screen/dutyschedule_screen.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/app/moduls/lvotApproval/controller/lvotapproval_controller.dart';
import 'package:emp_app/app/moduls/lvotApproval/screen/lvotapproval_screen.dart';
import 'package:emp_app/app/moduls/mispunch/controller/mispunch_controller.dart';
import 'package:emp_app/app/moduls/mispunch/screen/mispunch_screen.dart';
import 'package:emp_app/app/moduls/payroll/model/empsummdash_model.dart';
import 'package:emp_app/app/moduls/payroll/model/payroll_model.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PayrollController extends GetxController with SingleGetTickerProviderMixin {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
  var bottomBarController = Get.put(BottomBarController());
  var isLoading = false.obs;
  late List<Payroll> payrolltable = [];
  TextEditingController textEditingController = TextEditingController();
  String tokenNo = '', loginId = '', empId = '';
  FocusNode focusNode = FocusNode();
  bool hasFocus = false;
  List<EmpSummDashboardTable> empSummDashboardTable = [];
  List<ModuleScreenRights> empModuleScreenRightsTable = [];
  final ScrollController payrollScrollController = ScrollController();
  var isDutyScheduleNavigating = false.obs;
  var isLVOTApprovalNavigating = false.obs;
  var isLoaderPayroll = false.obs;
  var isLVOTAppr_Rights = false.obs;
  List<ModuleScreenRights> screens = [];
  List<Map<String, dynamic>> originalList = List.from(AppConst.payrollgrid);
  List<Map<String, dynamic>> filteredList = [];

  @override
  void onInit() {
    super.onInit();
    loadScreens();
    getProfileData();
    // hideBottomBar.value = false;
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    hideBottomBar.value = false;
    // });

    // focusNode.addListener(() {
    //   hasFocus = focusNode.hasFocus;
    //   update();
    // });
    update();
    payrollScrollController.addListener(() {
      if (payrollScrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (hideBottomBar.value) {
          hideBottomBar.value = false;
          bottomBarController.update();
        }
      } else if (payrollScrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (!hideBottomBar.value) {
          hideBottomBar.value = true;
          bottomBarController.update();
        }
      }
    });
  }

  @override
  void onClose() {
    // focusNode.dispose();
    // textEditingController.dispose();
    super.onClose();
  }

  void loadScreens() async {
    List<ModuleScreenRights> fetchedScreens = await fetchModuleScreens();
    screens = fetchedScreens;
    if (empModuleScreenRightsTable.isNotEmpty && empModuleScreenRightsTable[5].rightsYN == "Y") {
      filteredList = originalList;
    } else {
      originalList
          .removeWhere((element) => element['label'].toString().toLowerCase() == 'lv/ot approval'.toLowerCase());
      filteredList = originalList;
    }
    update();
  }

  Future<List<ModuleScreenRights>> fetchModuleScreens() async {
    try {
      // String url = 'http://117.217.126.127:44166/api/Employee/GetEmpSummary_Dashboard';
      String url = ConstApiUrl.empAppScreenRights;
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
          update();
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
      ResponseEmpSummDashboardData empSummDashboardDataResponse =
          ResponseEmpSummDashboardData.fromJson(jsonDecode(decodedResp));

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
        // attendanceController.update();
        if (bottomBarController.persistentController.value.index != 1) {
          bottomBarController.currentIndex.value = 1;
          bottomBarController.persistentController.value.index = 1;
        }
        bottomBarController.update();
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
        final bottomBarController = Get.put(BottomBarController());
        // final attendanceController = Get.put(AttendenceController());
        // await attendanceController.resetData();
        final leaveController = Get.put(LeaveController());
        await leaveController.resetForm();
        if (bottomBarController.persistentController.value.index != 3) {
          bottomBarController.currentIndex.value = 3;
          bottomBarController.persistentController.value.index = 3;
        }
        bottomBarController.update();
        // Get.snackbar(
        //   AppString.comingsoon,
        //   '',
        //   colorText: AppColor.white,
        //   backgroundColor: AppColor.black,
        //   duration: const Duration(seconds: 1),
        // );
        break;
      case 3:
        final bottomBarController = Get.put(BottomBarController());
        final leaveController = Get.put(LeaveController());
        await leaveController.resetForm();
        if (bottomBarController.persistentController.value.index != 4) {
          bottomBarController.currentIndex.value = 4;
          bottomBarController.persistentController.value.index = 4;
        }
        bottomBarController.update();
        // Get.snackbar(
        //   AppString.comingsoon,
        //   '',
        //   colorText: AppColor.white,
        //   backgroundColor: AppColor.black,
        //   duration: const Duration(seconds: 1),
        // );
        break;
      case 4:
        final bottomBarController = Get.put(BottomBarController());
        final dutyScheduleController = Get.put(DutyscheduleController());
        await dutyScheduleController.resetForm();

        if (isDutyScheduleNavigating.value) return;
        isDutyScheduleNavigating.value = true;

        bottomBarController.currentIndex.value = -1;

        DutyscheduleController dc = Get.put(DutyscheduleController());
        dc.fetchdutyScheduledrpdwn();

        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: const DutyscheduleScreen(),
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
        isDutyScheduleNavigating.value = false;
        break;
      case 5:
        if (isLVOTApprovalNavigating.value) return;
        isLVOTApprovalNavigating.value = true;

        if (empModuleScreenRightsTable.isNotEmpty) {
          if (empModuleScreenRightsTable[5].rightsYN == "N") {
            isLVOTApprovalNavigating.value = false;
            Get.snackbar(
              "You don't have access to this screen",
              '',
              colorText: AppColor.white,
              backgroundColor: AppColor.black,
              duration: const Duration(seconds: 1),
            );
            return;
          }
        }
        final bottomBarController = Get.put(BottomBarController());
        bottomBarController.currentIndex.value = -1;
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: const LvotapprovalScreen(),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        ).then((value) async {
          bottomBarController.persistentController.value.index = 0;
          bottomBarController.currentIndex.value = 0;
          hideBottomBar.value = false;
          var dashboardController = Get.put(DashboardController());
          await dashboardController.getDashboardDataUsingToken();
        });
        final lvotapprovalController = Get.put(LvotapprovalController());
        await lvotapprovalController.resetForm();
        await lvotapprovalController.fetchLeaveOTList("", "LV");
        isLVOTApprovalNavigating.value = false;
        break;
      default:
    }
  }

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

  String getImage(String screenName) {
    switch (screenName.toUpperCase()) {
      case "ATTENDANCE":
        return AppImage.attendance;
      case "MISPUNCH":
        return AppImage.mispunch;
      case "LEAVE":
        return AppImage.leave;
      case "OVERTIME":
        return AppImage.overtime;
      case "DUTY SCHEDULE":
        return AppImage.dutySchedule;
      case "LV/OT APPROVAL":
        return AppImage.lvotapproval;
      default:
        return AppImage.attendance;
    }
  }

  String getScreenName(String screenName) {
    switch (screenName.toUpperCase()) {
      case "ATTENDANCE":
        return AppString.attendance;
      case "MISPUNCH":
        return AppString.mispunch;
      case "LEAVE":
        return AppString.leave;
      case "OVERTIME":
        return AppString.overtime;
      case "DUTY SCHEDULE":
        return AppString.dutyschedule;
      case "LV OT APPROVAL":
        return AppString.lvotapproval;
      default:
        return AppString.attendance;
    }
  }
}
