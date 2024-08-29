import 'dart:convert';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/leave/model/leaveReliverName_model.dart';
import 'package:emp_app/app/moduls/leave/model/leavedays_model.dart';
import 'package:emp_app/app/moduls/leave/model/leavedelayreason_model.dart';
import 'package:emp_app/app/moduls/leave/model/leaveentrylist_model.dart';
import 'package:emp_app/app/moduls/leave/model/leavenames_model.dart';
import 'package:emp_app/app/moduls/leave/model/leavereason_model.dart';
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
  List<LeaveNamesTable> leavename = [];
  List<LeaveReasonTable> leavereason = [];
  List<LeaveDelayReason> leavedelayreason = [];
  List<LeaveReliverName> leaverelivername = [];
  List<LeaveEntryList> leaveentryList = [];
  String tokenNo = '', loginId = '', empId = '';
  final ApiController apiController = Get.put(ApiController());
  TextEditingController formDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  final ScrollController leaveScrollController = ScrollController();
  RxString days = ''.obs; // To store the calculated days
  RxBool isDaysFieldEnabled = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchLeaveNames();
    await fetchLeaveReason();
    await fetchLeaveDelayReason();
    await fetchLeaveReliverName();
    update();
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
    formDateController.addListener(_updateDays);
    toDateController.addListener(_updateDays);
  }

  void _updateDays() {
    final String formDateText = formDateController.text;
    final String toDateText = toDateController.text;

    DateTime? fromDate = formDateText.isNotEmpty ? DateFormat('dd-MM-yyyy').parse(formDateText, true) : null;
    DateTime? toDate = toDateText.isNotEmpty ? DateFormat('dd-MM-yyyy').parse(toDateText, true) : null;

    if (fromDate != null && toDate != null) {
      int daysCount = toDate.difference(fromDate).inDays + 1;

      // Set days based on the difference
      if (daysCount <= 1) {
        days.value = daysCount.toString(); // Show 1 or 0.5
      } else {
        days.value = daysCount.toString(); // Show the actual number of days
      }

      isDaysFieldEnabled.value = true;
      //getLeaveDays(); // Fetch leave data based on the new dates
    } else {
      days.value = 'Select';
      isDaysFieldEnabled.value = false;
    }
    update();
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

  Future<List<Data>> getLeaveDays() async {
    try {
      isLoading.value = true;
      String url = ConstApiUrl.empLeaveDaysAPI;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      DateTime? fromDate = formDateController.text.isNotEmpty ? DateFormat('dd-MM-yyyy').parse(formDateController.text, true) : null;
      DateTime? toDate = toDateController.text.isNotEmpty ? DateFormat('dd-MM-yyyy').parse(toDateController.text, true) : null;

      if (fromDate != null && toDate != null) {
        // Calculate the days difference
        int daysCount = toDate.difference(fromDate).inDays + 1;

        days.value = daysCount.toString();
        isDaysFieldEnabled.value = true;

        var jsonbodyObj = {"loginId": loginId, "empId": empId, "fromDate": fromDate.toIso8601String(), "toDate": toDate.toIso8601String()};

        var decodedResp = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
        LeaveDays leaveDays = LeaveDays.fromJson(jsonDecode(decodedResp));
        if (leaveDays.statusCode == 200) {
          isLoading.value = false;
          if (leaveDays.data != null) {
            update();
            return leaveDays.data!; // Return the days from the API response
          } else {
            Get.rawSnackbar(message: "No data found!");
          }
        } else if (leaveDays.statusCode == 401) {
          pref.clear();
          Get.offAll(const LoginScreen());
          Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
        } else if (leaveDays.statusCode == 400) {
          isLoading.value = false;
        } else {
          Get.rawSnackbar(message: "Something went wrong");
        }
        update();
      } else {
        Get.rawSnackbar(message: "Please select both From Date and To Date");
        // Reset days field and disable it if dates are not selected
        days.value = '';
        isDaysFieldEnabled.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      update();
    }
    return [];
  }

  Future<List<LeaveNamesTable>> fetchLeaveNames() async {
    try {
      isLoading.value = true;
      String url = ConstApiUrl.empLeaveNamesAPI;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseLeaveNames leaveNames = ResponseLeaveNames.fromJson(jsonDecode(response));

      if (leaveNames.statusCode == 200) {
        leavename.clear();
        leavename = leaveNames.data!;
        // leavename.addAll(leaveNames.data?.map((e) => e.name ?? "").toList() ?? []);
      } else if (leaveNames.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (leaveNames.statusCode == 400) {
        isLoading.value = false;
      } else {
        Get.rawSnackbar(message: "Somethin g went wrong");
      }
      update();
    } catch (e) {
      isLoading.value = false;
      update();
    }
    return [];
  }

  Future<List<LeaveReasonTable>> fetchLeaveReason() async {
    try {
      isLoading.value = true;
      String url = ConstApiUrl.empLeaveReasonAPI;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      RsponseLeaveReason rsponseLeaveReason = RsponseLeaveReason.fromJson(jsonDecode(response));

      if (rsponseLeaveReason.statusCode == 200) {
        leavereason.clear();
        leavereason = rsponseLeaveReason.data!;
        // leavename.addAll(leaveNames.data?.map((e) => e.name ?? "").toList() ?? []);
      } else if (rsponseLeaveReason.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (rsponseLeaveReason.statusCode == 400) {
        isLoading.value = false;
      } else {
        Get.rawSnackbar(message: "Somethin g went wrong");
      }
      update();
    } catch (e) {
      isLoading.value = false;
      update();
    }
    return [];
  }

  Future<List<LeaveDelayReason>> fetchLeaveDelayReason() async {
    try {
      isLoading.value = true;
      String url = ConstApiUrl.empLeaveDelayReasonAPI;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseLeaveDelayReason rsponseLeaveDelayReason = ResponseLeaveDelayReason.fromJson(jsonDecode(response));

      if (rsponseLeaveDelayReason.statusCode == 200) {
        leavedelayreason.clear();
        leavedelayreason = rsponseLeaveDelayReason.data!;
        // leavename.addAll(leaveNames.data?.map((e) => e.name ?? "").toList() ?? []);
      } else if (rsponseLeaveDelayReason.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (rsponseLeaveDelayReason.statusCode == 400) {
        isLoading.value = false;
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

  Future<List<LeaveDelayReason>> fetchLeaveReliverName() async {
    try {
      update();
      isLoading.value = true;
      String url = ConstApiUrl.empLeaveReliverNameAPI;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};
      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseLeaveReliverName responseLeaveReliverName = ResponseLeaveReliverName.fromJson(jsonDecode(response));

      if (responseLeaveReliverName.statusCode == 200) {
        leaverelivername.clear();
        leaverelivername = responseLeaveReliverName.data!;
        // leavename.addAll(leaveNames.data?.map((e) => e.name ?? "").toList() ?? []);
      } else if (responseLeaveReliverName.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseLeaveReliverName.statusCode == 400) {
        isLoading.value = false;
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

  Future<List<LeaveEntryList>> fetchLeaveEntryList() async {
    try {
      update();
      isLoading.value = true;
      String url = ConstApiUrl.empLeaveEntryListAPI;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};
      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseLeaveEntryList responseLeaveEntryList = ResponseLeaveEntryList.fromJson(jsonDecode(response));

      if (responseLeaveEntryList.statusCode == 200) {
        leaveentryList.clear();
        leaveentryList = responseLeaveEntryList.data!;
        // leavename.addAll(leaveNames.data?.map((e) => e.name ?? "").toList() ?? []);
      } else if (responseLeaveEntryList.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseLeaveEntryList.statusCode == 400) {
        isLoading.value = false;
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
}
