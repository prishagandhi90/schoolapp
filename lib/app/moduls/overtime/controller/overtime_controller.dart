import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OvertimeController extends GetxController {
  var bottomBarController = Get.put(BottomBarController());
  // var leaveController = Get.put(LeaveController());
  var isLoading = false.obs;

  DateTime? selectedFromDate;
  TimeOfDay? selectedFromTime;

  DateTime? selectedToDate;
  TimeOfDay? selectedToTime;

  double oTMinutes = 0;

  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  final DateFormat timeFormat = DateFormat('hh:mm a'); // 12-hour format with AM/PM

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
}
