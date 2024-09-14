import 'dart:convert';

import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:emp_app/app/moduls/leave/model/leave_saveentrylist_model.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OvertimeController extends GetxController {
  var bottomBarController = Get.put(BottomBarController());
  // var leaveController = Get.put(LeaveController());
  var isLoading = false.obs;
  String tokenNo = '', loginId = '', empId = '';
  final ApiController apiController = Get.put(ApiController());
  DateTime? selectedFromDate;
  TimeOfDay? selectedFromTime;

  DateTime? selectedToDate;
  TimeOfDay? selectedToTime;

  double oTMinutes = 0;

  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  final DateFormat timeFormat = DateFormat('hh:mm a'); // 12-hour format with AM/PM

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController fromTimeController = TextEditingController();
  TextEditingController toTimeController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController otMinutesController = TextEditingController();
  TextEditingController delayReasonController = TextEditingController();
  @override
  void onInit() {
    //var leaveController = Get.put(LeaveController());
    //leaveController.fetchLeaveEntryList("OT");
    super.onInit();
  }

  // Function to validate and combine date and time
  bool validateAndCombineDateTime() {
    // Checking if any variable is null
    if (selectedFromDate == null || selectedFromTime == null || selectedToDate == null || selectedToTime == null) {
      return false; // One or more fields are empty
    }

    // Combine SelectedFromDate and SelectedFromTime into DateTime
    DateTime selectedFromDateTime = DateTime(
      selectedFromDate!.year,
      selectedFromDate!.month,
      selectedFromDate!.day,
      selectedFromTime!.hour,
      selectedFromTime!.minute,
    );

    // Combine SelectedToDate and SelectedToTime into DateTime
    DateTime selectedToDateTime = DateTime(
      selectedToDate!.year,
      selectedToDate!.month,
      selectedToDate!.day,
      selectedToTime!.hour,
      selectedToTime!.minute,
    );

    // Validating that both DateTime objects have date and time
    if (selectedFromDateTime.isBefore(selectedToDateTime)) {
      // If all checks passed, return true
      return true;
    } else {
      // If selectedFromDateTime is after selectedToDateTime, return false
      return false;
    }
  }

  Future<void> selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
      if (controller == fromDateController) {
        selectedFromDate = picked;
      } else if (controller == toDateController) {
        // Assuming you have a toDateController
        selectedToDate = picked;
      }
      oTMinutes = 0;
      onDateTimeTap();
      update();
    }
  }

  Future<void> selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (picked != null) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      controller.text = timeFormat.format(dt);
      if (controller == fromTimeController) {
        selectedFromTime = picked;
      } else if (controller == toTimeController) {
        selectedToTime = picked;
      }
      oTMinutes = 0;
      onDateTimeTap();
      update();
    }
  }

  void onDateTimeTap() {
    if (validateAndCombineDateTime()) {
      DateTime fromDateTime = DateTime(
        selectedFromDate!.year,
        selectedFromDate!.month,
        selectedFromDate!.day,
        selectedFromTime!.hour,
        selectedFromTime!.minute,
      );

      DateTime toDateTime = DateTime(
        selectedToDate!.year,
        selectedToDate!.month,
        selectedToDate!.day,
        selectedToTime!.hour,
        selectedToTime!.minute,
      );

      double totalMinutes = calculateMinutes(fromDateTime, toDateTime);
      oTMinutes = totalMinutes;
      otMinutesController.text = totalMinutes.toStringAsFixed(0);
      print('Total Minutes: $totalMinutes');
    } else {
      print('Please fill all date and time fields correctly.');
    }
  }

  double calculateMinutes(DateTime fromDateTime, DateTime toDateTime) {
    Duration difference = toDateTime.difference(fromDateTime);
    double totalMinutes = difference.inMinutes.toDouble();
    return totalMinutes;
  }

  String formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return timeFormat.format(dt);
  }

  String formatDateWithTime(String date) {
    DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(date);
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(parsedDate);
  }

  Future<List<SaveLeaveEntryList>> saveOTEntryList(String flag) async {
    try {
      update();
      isLoading.value = true;
      String url = ConstApiUrl.empSaveLeaveEntryList;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {
        "loginId": loginId,
        "empId": empId,
        "entryType": flag,
        "leaveShortName": "OT",
        "leaveFullName": "OT",
        "fromdate": flag == "OT" ? formatDateWithTime(fromDateController.text) : fromDateController.text,
        "todate": flag == "OT" ? formatDateWithTime(toDateController.text) : toDateController.text,
        "reason": "OT",
        "note": noteController.text,
        "leaveDays": 0,
        "overTimeMinutes": int.tryParse(otMinutesController.text) ??0,
        "usr_Nm": '',
        "reliever_Empcode": '',
        "delayLVNote": delayReasonController.text,
      };
      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      print(response);
      ResponseSaveLeaveEntryList responseSaveLeaveEntryList = ResponseSaveLeaveEntryList.fromJson(jsonDecode(response));
      if (responseSaveLeaveEntryList.statusCode == 200) {
        if (responseSaveLeaveEntryList.isSuccess == "true" && responseSaveLeaveEntryList.data?.isNotEmpty == true) {
          if (responseSaveLeaveEntryList.data![0].savedYN == "Y") {
            Get.rawSnackbar(message: responseSaveLeaveEntryList.message);
            // resetForm();
          }
        } else {
          Get.rawSnackbar(message: "Data not saved");
        }
      } else if (responseSaveLeaveEntryList.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseSaveLeaveEntryList.statusCode == 400) {
        isLoading.value = false;
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      print(e);
      isLoading.value = false;
    }
    return [];
  }
}
