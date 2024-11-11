// ignore_for_file: deprecated_member_use

import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:emp_app/app/moduls/leave/model/leave_saveentrylist_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OvertimeController extends GetxController with SingleGetTickerProviderMixin {
  final bottomBarController = Get.put(BottomBarController());
  var isLoading = false.obs;
  String tokenNo = '', loginId = '', empId = '';
  final ApiController apiController = Get.put(ApiController());
  DateTime? selectedFromDate;
  TimeOfDay? selectedFromTime;

  DateTime? selectedToDate;
  TimeOfDay? selectedToTime;
  final FocusNode notesFocusNode = FocusNode();
  double oTMinutes = 0;
  var initialIndex = 0.obs;
  late TabController tabController_OT;
  RxInt currentTabIndex = 0.obs;

  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  final DateFormat timeFormat = DateFormat('hh:mm a'); // 12-hour format with AM/PM

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController fromTimeController = TextEditingController();
  TextEditingController toTimeController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController otMinutesController = TextEditingController();
  TextEditingController delayreasonName_OT_Controller = TextEditingController();
  TextEditingController delayreasonId_OT_Controller = TextEditingController();

  @override
  void onInit() {
    tabController_OT = TabController(length: 2, vsync: this);
    tabController_OT.addListener(_handleTabSelection);
    currentTabIndex.value = 0;
    // changeTab(0);
    noteController.text = "";
    super.onInit();
  }

  // @override
  // void onReady() {
  //   super.onReady();

  //   // Ensure drawer is closed when screen is initialized
  //   if (Scaffold.of(Get.context!).isDrawerOpen) {
  //     Navigator.pop(Get.context!); // Close the drawer if it's open
  //   }
  // }

  @override
  void onClose() {
    // leaveScrollController.dispose();
    noteController.dispose();
    notesFocusNode.dispose();
    tabController_OT.dispose();
    super.onClose();
  }

  DelayReasonChangeMethod(Map<String, String>? value) async {
    delayreasonId_OT_Controller.text = value!['value'] ?? '';
    delayreasonName_OT_Controller.text = value['text'] ?? '';
  }

  void _handleTabSelection() async {
    if (tabController_OT.indexIsChanging) {
      initialIndex.value = tabController_OT.index;
      if (tabController_OT.index == 1) {
        final leaveController = Get.put(LeaveController());
        await leaveController.fetchLeaveEntryList("OT");
      }
      update();
    }
  }

  changeTab(int index) async {
    tabController_OT.animateTo(index);
    currentTabIndex.value = index;
    final leaveController = Get.put(LeaveController());
    if (index == 1 && leaveController.leaveentryList.isEmpty) {
      await leaveController.fetchLeaveEntryList("OT"); // Fetch list only if not already fetched
    }
    update();
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
      controller.text = DateFormat('dd-MM-yyyy').format(picked);
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

  // Future<void> selectTime(BuildContext context, TextEditingController controller) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //     initialEntryMode: TimePickerEntryMode.input,
  //   );
  //   if (picked != null) {
  //     final now = DateTime.now();
  //     final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
  //     controller.text = timeFormat.format(dt);
  //     if (controller == fromTimeController) {
  //       selectedFromTime = picked;
  //     } else if (controller == toTimeController) {
  //       selectedToTime = picked;
  //     }
  //     oTMinutes = 0;
  //     onDateTimeTap();
  //     update();
  //   }
  // }

  // void onDateTimeTap() {
  //   if (validateAndCombineDateTime()) {
  //     DateTime fromDateTime = DateTime(
  //       selectedFromDate!.year,
  //       selectedFromDate!.month,
  //       selectedFromDate!.day,
  //       selectedFromTime!.hour,
  //       selectedFromTime!.minute,
  //     );
  //     // String formattedFromDateTime = DateFormat('dd-MM-yyyy HH:mm:ss').format(fromDateTime);

  //     DateTime toDateTime = DateTime(
  //       selectedToDate!.year,
  //       selectedToDate!.month,
  //       selectedToDate!.day,
  //       selectedToTime!.hour,
  //       selectedToTime!.minute,
  //     );
  //     // String formattedToDateTime = DateFormat('dd-MM-yyyy HH:mm:ss').format(toDateTime);

  //     double totalMinutes = calculateMinutes(fromDateTime, toDateTime);
  //     oTMinutes = totalMinutes;
  //     otMinutesController.text = totalMinutes.toStringAsFixed(0);
  //     // fromDateController.text = formattedFromDateTime.toString();
  //     // toDateController.text = formattedToDateTime.toString();
  //     print('Total Minutes: $totalMinutes');
  //   } else {
  //     print('Please fill all date and time fields correctly.');
  //   }
  // }

  Future<void> selectTime(BuildContext context, TextEditingController controller) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    initialEntryMode: TimePickerEntryMode.input,
  );
  
  if (picked != null) {
    // Set minutes to 00
    final adjustedTime = TimeOfDay(hour: picked.hour, minute: 0);
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, adjustedTime.hour, adjustedTime.minute);

    controller.text = timeFormat.format(dt);

    if (controller == fromTimeController) {
      selectedFromTime = adjustedTime;
    } else if (controller == toTimeController) {
      selectedToTime = adjustedTime;
    }

    oTMinutes = 0;
    onDateTimeTap(); // Recalculate OT minutes with adjusted time
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
      0, // Set minutes to 00
    );

    DateTime toDateTime = DateTime(
      selectedToDate!.year,
      selectedToDate!.month,
      selectedToDate!.day,
      selectedToTime!.hour,
      0, // Set minutes to 00
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

  // String formatDateWithTime(String date) {
  //   DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(date);
  //   return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(parsedDate);
  // }

  Future<List<SaveLeaveEntryList>> saveOTEntryList(String flag) async {
    // var leaveController = Get.put(LeaveController());
    var leaveController = Get.find<LeaveController>();
    await leaveController.saveLeaveEntryList("OT");
    leaveController.resetForm();
    Get.rawSnackbar(message: "Data saved successfully");
    return [];
  }
}
