import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OvertimeController extends GetxController {
  var bottomBarController = Get.put(BottomBarController());
  
  var isLoading = false.obs;

  DateTime? selectedDate;
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  TimeOfDay? selectedTime;
  final DateFormat timeFormat = DateFormat('hh:mm a'); // 12-hour format with AM/PM

  String formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return timeFormat.format(dt);
  }
}
