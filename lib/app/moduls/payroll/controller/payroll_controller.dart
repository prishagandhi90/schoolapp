import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/moduls/attendence/screen/attendance_screen.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/mispunch/screen/mispunch_screen.dart';
import 'package:emp_app/app/moduls/payroll/model/payroll_model.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  String tokenNo = '', loginId = '';
  final _storage = const FlutterSecureStorage();
  @override
  void onInit() {
    super.onInit();
    getProfileData();
    hideBottomBar.value = false;
    update();
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
          screen: const AttendanceScreen(),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        ).then((value) {
          // hideBottomBar.value = false;
          // controller.getDashboardData();
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
        ).then((value) {
          // hideBottomBar.value = false;
          // controller.getDashboardData();
        });
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
      default:
    }
  }
}
