import 'dart:convert';

import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/leave/model/leavedays_model.dart';
import 'package:emp_app/app/moduls/leave/model/leavenames_model.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveController extends GetxController {
  var bottomBarController = Get.put(BottomBarController());
  final count = 0.obs;
  void increment() => count.value++;
  var isLoading = false.obs;
  List<LeaveDays> leavedays = [];
  String tokenNo = '', loginId = '', empId = '';
  final ApiController apiController = Get.put(ApiController());
  TextEditingController formDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  final ScrollController leaveScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();

    leaveScrollController.addListener(() {
      if (leaveScrollController.position.userScrollDirection == ScrollDirection.forward) {
        hideBottomBar = false.obs;
        update();
        bottomBarController.update();
      } else if (leaveScrollController.position.userScrollDirection == ScrollDirection.reverse) {
        hideBottomBar = true.obs;
        update();
        bottomBarController.update();
      }
    });
  }

  Future<void> selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = DateFormat('dd-MM-yyyy').format(picked);
      update();
    }
  }

  // Future<void> calculateDaysAndFetchLeaveNames() async {
  //   DateTime fromDate = DateTime.parse(formDateController.text);
  //   DateTime toDate = DateTime.parse(toDateController.text);

  //   // Validate dates
  //   if (!toDate.isAfter(fromDate) && !toDate.isAtSameMomentAs(fromDate)) {
  //     Get.snackbar('Invalid Date', 'To date must be after or equal to From date');
  //     return;
  //   }

  //   try {
  //     isLoading.value = true;

  //     // Fetch leave days
  //     await fetchLeaveDays(fromDate, toDate);

  //     // Fetch leave names
  //     await fetchLeaveNames();

  //     // Logic to enable dropdowns or perform other actions based on the fetched data
  //     if (leaveDays.isNotEmpty && nameList.isNotEmpty) {
  //       // Your logic here
  //     } else {
  //       // Handle empty or invalid data
  //     }
  //   } catch (e) {
  //     Get.rawSnackbar(message: "Something went wrong");
  //   } finally {
  //     isLoading.value = false;
  //     update();
  //   }
  // }

  // Future<List<Data>> fetchLeaveDays(DateTime fromDate, DateTime toDate) async {
  //   try {
  //     SharedPreferences pref = await SharedPreferences.getInstance();
  //     loginId = pref.getString(AppString.keyLoginId) ?? "";
  //     tokenNo = pref.getString(AppString.keyToken) ?? "";
  //     String url = ConstApiUrl.empLeaveDaysAPI;

  //     var jsonBody = {
  //       'loginId': loginId,
  //       'empId': empId,
  //       'fromDate': formDateController.text,
  //       'toDate': toDateController.text,
  //     };

  //     var decodedResp = await apiController.parseJsonBody(url, tokenNo, jsonBody);
  //     LeaveDays leaveDaysResponse = LeaveDays.fromJson(jsonDecode(decodedResp));

  //     if (leaveDaysResponse.statusCode == 200) {
  //       leavedays = leaveDaysResponse.days;
  //     } else if (leaveDaysResponse.statusCode == 401) {
  //       pref.clear();
  //       Get.offAll(const LoginScreen());
  //       Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
  //     } else {
  //       leaveDays.clear();
  //       Get.rawSnackbar(message: "Unable to fetch leave days");
  //     }
  //   } catch (e) {
  //     leaveDays.clear();
  //     Get.rawSnackbar(message: "Error fetching leave days");
  //   }
  //   return [];
  // }

  // Future<List<LeavenamesModel>> fetchLeaveNames() async {
  //   try {
  //     String url = "http://117.217.126.127/api/Employee/GetLeaveNames";
  //     var response = await apiController.getData(url);

  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //       nameList.value = List<String>.from(data.map((item) => item['leaveName']));
  //     } else {
  //       nameList.clear();
  //       Get.rawSnackbar(message: "Unable to fetch leave names");
  //     }
  //   } catch (e) {
  //     nameList.clear();
  //     Get.rawSnackbar(message: "Error fetching leave names");
  //   }
  //   return [];
  // }

  final List<String> nameList = [
    'Privilege Leave',
    'Casual Leave',
    'Sick Leave',
    'Holiday Off',
    'Covid Off',
    'Maternity Leave',
    'Leave Without Pay',
  ];
}
