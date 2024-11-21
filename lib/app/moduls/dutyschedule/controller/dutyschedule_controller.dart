import 'dart:convert';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/dutyschedule/model/dropdown_model.dart';
import 'package:emp_app/app/moduls/dutyschedule/model/shiftDuty_model.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DutyscheduleController extends GetxController {
  String tokenNo = '', loginId = '', empId = '';
  bool isLoading = false;
  final ApiController apiController = Get.put(ApiController());
  List<sheduledrpdwnlst> Sheduledrpdwnlst = [];
  List<DutySchSftData> dutySchSftData = [];
  final bottomBarController = Get.put(BottomBarController());
  TextEditingController DutyDropdownNameController = TextEditingController();
  TextEditingController DutyDropdownValueController = TextEditingController();
  final ScrollController dutyScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();

    dutyScrollController.addListener(() {
      if (dutyScrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (hideBottomBar.value) {
          hideBottomBar.value = false;
          bottomBarController.update();
        }
      } else if (dutyScrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (!hideBottomBar.value) {
          hideBottomBar.value = true;
          bottomBarController.update();
        }
      }
    });
  }

  Future<List<sheduledrpdwnlst>> fetchdutyScheduledrpdwn() async {
    try {
      isLoading = true;
      String url = ConstApiUrl.empdutyscheduledrpdwnList;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponsedrpdwnList rsponsedropden = ResponsedrpdwnList.fromJson(jsonDecode(response));

      if (rsponsedropden.statusCode == 200) {
        Sheduledrpdwnlst = rsponsedropden.data!;
        isLoading = false;

        sheduledrpdwnlst? currentWeek = getCurrentWeek(Sheduledrpdwnlst);
        DutyDropdownNameController.text = currentWeek!.name ?? '';
        DutyDropdownValueController.text = currentWeek.value ?? '';
        await getShiftData();
        // update(); // UI refresh karna
      } else if (rsponsedropden.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (rsponsedropden.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading = false;
      update();
    }
    return [];
  }

  DutyScheduleChangeMethod(Map<String, String>? value) async {
    DutyDropdownValueController.text = value!['value'] ?? '';
    DutyDropdownNameController.text = value['text'] ?? '';
    update();
    getShiftData();
  }

  String getCurrentWeekDate() {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;

    // Start of current week (Monday)
    DateTime startOfWeek = now.subtract(Duration(days: currentWeekday - 1));
    // End of current week (Sunday)
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    // Format the dates to "day month"
    String startDate = DateFormat("d MMMM").format(startOfWeek);
    String endDate = DateFormat("d MMMM").format(endOfWeek);

    return "$startDate-$endDate";
  }

  // Method to get the current week data
  sheduledrpdwnlst? getCurrentWeek(List<sheduledrpdwnlst> weekList) {
    DateTime today = DateTime.now(); // Current date

    for (var week in weekList) {
      try {
        // Extract date range from the 'name' column (e.g., "14-Oct~20-Oct")
        String dateRange = week.name!.split(' ')[1];
        List<String> dates = dateRange.split('~');

        // Parse 'from' and 'to' dates using the DateFormat from intl package
        DateTime fromDate = DateFormat('dd-MMM').parse(dates[0]);
        DateTime toDate = DateFormat('dd-MMM').parse(dates[1]);

        // Adjust the year to match current year (as only day & month are provided)
        fromDate = DateTime(today.year, fromDate.month, fromDate.day);
        toDate = DateTime(today.year, toDate.month, toDate.day);

        // Check if today falls between the 'from' and 'to' dates (inclusive)
        if (today.isAfter(fromDate.subtract(Duration(days: 1))) && today.isBefore(toDate.add(Duration(days: 1)))) {
          return week; // Return the matching week data
        }
      } catch (e) {
        print('Error parsing date for week: ${week.name}, Error: $e');
      }
    }
    return null; // No matching week found
  }

  Future<List<DutySchSftData>> getShiftData() async {
    // List<Map<String, String>> _getCurrentWeekData() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Monday
    List<Map<String, String>> weekData = [];

    for (int i = 0; i < 7; i++) {
      DateTime date = startOfWeek.add(Duration(days: i));
      String formattedDate = DateFormat('d\nMMM').format(date); // Format: day \n month
      weekData.add({
        'date': formattedDate,
      });
      try {
        isLoading = true;
        String url = ConstApiUrl.empDutyScheduleShiftReport;
        SharedPreferences pref = await SharedPreferences.getInstance();
        loginId = await pref.getString(AppString.keyLoginId) ?? "";
        tokenNo = await pref.getString(AppString.keyToken) ?? "";
        empId = await pref.getString(AppString.keyEmpId) ?? "";

        var jsonbodyObj = {"loginId": loginId, "empId": empId, "DtRange": DutyDropdownNameController.text};

        var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
        ResponseGetDutyScheduleShift responseGetDutyScheduleShift = ResponseGetDutyScheduleShift.fromJson(jsonDecode(response));

        if (responseGetDutyScheduleShift.statusCode == 200) {
          dutySchSftData = responseGetDutyScheduleShift.data!;
          isLoading = false;
        } else if (responseGetDutyScheduleShift.statusCode == 401) {
          pref.clear();
          Get.offAll(const LoginScreen());
          Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
        } else if (responseGetDutyScheduleShift.statusCode == 400) {
          dutySchSftData = []; // Set to empty list to show "No Data Found"
          isLoading = false;
        } else {
          Get.rawSnackbar(message: "Something went wrong");
        }
        update();
      } catch (e) {
        isLoading = false;
        update();
      }
      return [];
    }
    return [];
    // return weekData;
  }
}
