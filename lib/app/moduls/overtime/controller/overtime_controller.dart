// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/api_error_handler.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:emp_app/app/moduls/leave/model/headerlist_model.dart';
import 'package:emp_app/app/moduls/leave/model/leave_saveentrylist_model.dart';
import 'package:emp_app/app/moduls/leave/model/leaveentrylist_model.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OvertimeController extends GetxController with SingleGetTickerProviderMixin {
  final bottomBarController = Get.put(BottomBarController());
  bool isLoading = false;
  bool isSaveBtnLoading = false;
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
  int? selectedRowIndex; // Track the selected row index

  RxBool isNotesFieldFocused = false.obs;

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController fromTimeController = TextEditingController();
  TextEditingController toTimeController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController otMinutesController = TextEditingController();
  TextEditingController delayreasonName_OT_Controller = TextEditingController();
  TextEditingController delayreasonId_OT_Controller = TextEditingController();

  final ScrollController overtimeScrollController = ScrollController();

  List<HeaderList> otHeaderList = [];
  List<LeaveEntryList> otentryList = [];

  var inchargeAction = ''.obs;
  var hodAction = ''.obs;
  var hrAction = ''.obs;

  @override
  void onInit() {
    super.onInit();
    tabController_OT = TabController(length: 2, vsync: this);
    tabController_OT.addListener(_handleTabSelection);
    currentTabIndex.value = 0;
    changeTab(0);
    noteController.text = "";
    isLoading = true;
    notesFocusNode.addListener(_onNotesFocusChange);

    update();
    overtimeScrollController.addListener(() {
      if (overtimeScrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (hideBottomBar.value) {
          hideBottomBar.value = false;
          bottomBarController.update();
        }
      } else if (overtimeScrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (!hideBottomBar.value) {
          hideBottomBar.value = true;
          bottomBarController.update();
        }
      }
    });
  }

  void _onNotesFocusChange() {
    if (!notesFocusNode.hasFocus) {
      isNotesFieldFocused.value = notesFocusNode.hasFocus;
      update();
    }
  }

  @override
  void onClose() {
    // leaveScrollController.dispose();
    // tabController_OT.dispose();

    // notesFocusNode.removeListener(_onNotesFocusChange);
    // notesFocusNode.dispose();
    super.onClose();
  }

  void setSelectedRow(int index) {
    selectedRowIndex = index;
  }

  DelayReasonChangeMethod(Map<String, String>? value) async {
    delayreasonId_OT_Controller.text = value!['value'] ?? '';
    delayreasonName_OT_Controller.text = value['text'] ?? '';
  }

  void _handleTabSelection() async {
    if (tabController_OT.indexIsChanging) {
      initialIndex.value = tabController_OT.index;
      if (tabController_OT.index == 1) {
        inchargeAction.value = "";
        hodAction.value = "";
        hrAction.value = "";
        selectedRowIndex = -1;
        await fetchLeaveEntryList("OT");
      }
      update();
    }
  }

  changeTab(int index) async {
    tabController_OT.animateTo(index);
    currentTabIndex.value = index;
    if (index == 1 && otentryList.isEmpty) {
      inchargeAction.value = "";
      hodAction.value = "";
      hrAction.value = "";
      selectedRowIndex = -1;
      await fetchLeaveEntryList("OT"); // Fetch list only if not already fetched
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
      otMinutesController.text = "";
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

  Future<void> selectTime(BuildContext context, TextEditingController controller) async {
    TimeOfDay? picked;
    if (controller.text == null || controller.text == "") {
      picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.input,
      );
    } else {
      try {
        final DateFormat timeFormat = DateFormat('hh:mm a'); // Define the input format
        final DateTime parsedTime = timeFormat.parse(controller.text.trim()); // Parse the time string
        final initialTime = TimeOfDay(hour: parsedTime.hour, minute: parsedTime.minute);

        // Show picker with parsed time as initial time
        picked = await showTimePicker(
          context: context,
          initialTime: initialTime,
          initialEntryMode: TimePickerEntryMode.input,
        );
      } catch (e) {
        // Handle invalid time format
        print("Error parsing time: $e");
        picked = null; // Reset picked if parsing fails
      }
    }

    if (picked != null) {
      // Set minutes to 00
      final adjustedTime = TimeOfDay(hour: picked.hour, minute: picked.minute);
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

   double getResponsiveFontSize(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    return width > 600 ? size * 1.2 : size; // iPad pe 20% zyada, baki normal
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

  // Future<List<SaveLeaveEntryList>> saveOTEntryList(String flag) async {
  //   // var leaveController = Get.find<LeaveController>();
  //   isSaveBtnLoading = true;
  //   await saveLeaveEntryList("OT");
  //   isSaveBtnLoading = false;
  //   // leaveController.resetForm();
  //   // Get.rawSnackbar(message: "Data saved successfully");
  //   return [];
  // }

  Future<List<HeaderList>> fetchHeaderList(String flag) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empLeaveHeaderList;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId, "flag": flag};
      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseHeaderList responseHeaderList = ResponseHeaderList.fromJson(jsonDecode(response));

      if (responseHeaderList.statusCode == 200) {
        if (responseHeaderList.data != null && responseHeaderList.data!.isNotEmpty) {
          isLoading = false;
          otHeaderList = responseHeaderList.data!;
          update();
          return otHeaderList;
        } else {
          otentryList = [];
        }
      } else if (responseHeaderList.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseHeaderList.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "OverTimeScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    isLoading = false;
    return [];
  }

  Future<List<LeaveEntryList>> fetchLeaveEntryList(String flag) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empLeaveEntryListAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId, "flag": flag};
      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseLeaveEntryList responseLeaveEntryList = ResponseLeaveEntryList.fromJson(jsonDecode(response));

      if (responseLeaveEntryList.statusCode == 200) {
        if (responseLeaveEntryList.data != null && responseLeaveEntryList.data!.isNotEmpty) {
          isLoading = false;
          otentryList = responseLeaveEntryList.data!;
          update();
          return otentryList;
        } else {
          otentryList = [];
        }
      } else if (responseLeaveEntryList.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseLeaveEntryList.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
      // overtimeController.update();
    } catch (e) {
      isLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "OverTimeScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    isLoading = false;
    return [];
  }

  Future<List<SaveLeaveEntryList>> saveLeaveEntryList(String flag) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      var leaveController = Get.find<LeaveController>();
      if (!leaveController.validateSaveLeaveEntry(flag)) {
        return [];
      }

      isSaveBtnLoading = true;
      update();
      String url = ConstApiUrl.empSaveLeaveEntryList;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {
        "loginId": loginId,
        "empId": empId,
        "entryType": flag,
        "leaveShortName": "OT",
        "leaveFullName": "OT",
        "fromdate": formatOTDateTime('FromDateTime'),
        "todate": formatOTDateTime('ToDateTime'),
        "reason": "OT",
        "note": noteController.text,
        "leaveDays": 0,
        "overTimeMinutes": int.tryParse(otMinutesController.text) ?? 0,
        "usr_Nm": '',
        "reliever_Empcode": '',
        "delayLVNote": delayreasonId_OT_Controller.text,
      };
      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      print(response);
      ResponseSaveLeaveEntryList responseSaveLeaveEntryList = ResponseSaveLeaveEntryList.fromJson(jsonDecode(response));
      if (responseSaveLeaveEntryList.statusCode == 200) {
        if (responseSaveLeaveEntryList.isSuccess == "true" && responseSaveLeaveEntryList.data?.isNotEmpty == true) {
          if (responseSaveLeaveEntryList.data![0].savedYN == "Y") {
            isSaveBtnLoading = false;
            await fetchLeaveEntryList(flag);
            leaveController.resetForm();
            Get.rawSnackbar(message: "Data saved successfully");
          }
        } else {
          Get.rawSnackbar(message: responseSaveLeaveEntryList.message);
        }
        isSaveBtnLoading = false;
      } else if (responseSaveLeaveEntryList.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseSaveLeaveEntryList.statusCode == 400) {
        isSaveBtnLoading = false;
        Get.rawSnackbar(message: responseSaveLeaveEntryList.message);
      } else {
        isSaveBtnLoading = false;
        Get.rawSnackbar(message: responseSaveLeaveEntryList.message);
      }
      // update();
    } catch (e) {
      print(e);
      // isLoading = false;
      isSaveBtnLoading = false;
      ApiErrorHandler.handleError(
        screenName: "OverTimeScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    // isLoading = false;
    isSaveBtnLoading = false;
    return [];
  }

  String formatOTDateTime(String flag) {
    String jsonDateTime = "";

    if (flag == "FromDateTime") {
      if (selectedFromDate != null && selectedFromTime != null) {
        DateTime fromDateTime = DateTime(
          selectedFromDate!.year,
          selectedFromDate!.month,
          selectedFromDate!.day,
          selectedFromTime!.hour,
          selectedFromTime!.minute,
        );

        // Format to "YYYY-MM-DDTHH:MM:SS" (local time, no UTC conversion)
        jsonDateTime =
            "${fromDateTime.toLocal().toIso8601String().substring(0, 19)}"; // Ensuring format with "T" and no milliseconds
      } else {
        throw Exception("FromDateTime or FromTime is null");
      }
    } else if (flag == "ToDateTime") {
      if (selectedToDate != null && selectedToTime != null) {
        DateTime toDateTime = DateTime(
          selectedToDate!.year,
          selectedToDate!.month,
          selectedToDate!.day,
          selectedToTime!.hour,
          selectedToTime!.minute,
        );

        // Format to "YYYY-MM-DDTHH:MM:SS" (local time, no UTC conversion)
        jsonDateTime =
            "${toDateTime.toLocal().toIso8601String().substring(0, 19)}"; // Ensuring format with "T" and no milliseconds
      } else {
        throw Exception("ToDateTime or ToTime is null");
      }
    } else {
      throw Exception("Invalid flag provided. Use 'FromDateTime' or 'ToDateTime'.");
    }

    return jsonDateTime; // Return the formatted datetime string
  }
}
