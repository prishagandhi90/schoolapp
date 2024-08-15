import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_const.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/attendence/screen/attendance_screen.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/moduls/mispunch/screen/mispunch_screen.dart';
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
  final ApiController apiController = Get.put(ApiController());
  TextEditingController textEditingController = TextEditingController();
  String tokenNo = '', loginId = '';
  FocusNode focusNode = FocusNode();
  bool hasFocus = false;
  var dashboardController = Get.put(DashboardController());

  @override
  void onInit() {
    super.onInit();
    getProfileData();
    hideBottomBar.value = false;
    filteredList = originalList;
    focusNode.addListener(() {
      hasFocus = focusNode.hasFocus;
      update();
    });
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
      String url = 'http://117.217.126.127:44166/api/Employee/GetEmpSummary_Dashboard';

      // loginId = await _storage.read(key: "KEY_LOGINID") ?? '';
      // tokenNo = await _storage.read(key: "KEY_TOKENNO") ?? '';
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString('KEY_LOGINID') ?? "";
      tokenNo = await pref.getString('KEY_TOKENNO') ?? "";

      var jsonbodyObj = {"loginId": loginId};

      var empmonthyrtable = await apiController.getDynamicData(url, tokenNo, jsonbodyObj);
      payrolltable = apiController.parseJson_Flag_payroll(empmonthyrtable, 'data');

      isLoading.value = false;
      update();
      return payrolltable;
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
        var bottomBarController = Get.put(BottomBarController());
        bottomBarController.update();
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: AttendanceScreen(),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        ).then((value) async {
          hideBottomBar.value = false;
          await dashboardController.getDashboardData();
        });
        break;
      case 1:
        hideBottomBar.value = false;
        var bottomBarController = Get.put(BottomBarController());
        bottomBarController.update();
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: const MispunchScreen(),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        ).then((value) async {
          hideBottomBar.value = false;
          await dashboardController.getDashboardData();
        });
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
