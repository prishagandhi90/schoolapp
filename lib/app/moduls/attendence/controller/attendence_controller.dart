import 'dart:convert';
import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/app_custom_widget/common_methods.dart';
import 'package:emp_app/app/moduls/attendence/model/attendencetable_model.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/app/moduls/mispunch/model/mispunchtable_model.dart';
import 'package:emp_app/app/moduls/attendence/model/attpresenttable_model.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendenceController extends GetxController {
  final ApiController apiController = Get.put(ApiController());
  final bottomBarController = Get.put(BottomBarController());
  late List<MispunchTable> mispunchtable = [];
  List<AttendenceSummarytable> attendenceSummaryTable = [];
  List<AttendanceDetailTable> attendenceDetailTable = [];
  String tokenNo = '', loginId = '', empId = '';
  bool isLoading = true;
  var isLoader = false.obs;
  var MonthSel_selIndex = (-1).obs;
  String YearSel_selIndex = "";
  var selectedYear = ''.obs;
  List<String> years = getLastTwoYears();
  var monthScrollControllerSummary = ScrollController();
  var monthScrollControllerDetail = ScrollController();
  var attendanceScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    DateTime now = DateTime.now();
    MonthSel_selIndex.value = now.month - 1;
    YearSel_selIndex = now.year.toString();

    setCurrentMonthYear("SummaryScreen");
    update();

    attendanceScrollController.addListener(() {
      if (attendanceScrollController.position.userScrollDirection == ScrollDirection.forward) {
        hideBottomBar = false.obs;
        update();
        bottomBarController.update();
      } else if (attendanceScrollController.position.userScrollDirection == ScrollDirection.reverse) {
        hideBottomBar = true.obs;
        update();
        bottomBarController.update();
      }
    });
  }

  @override
  void onClose() {
    // attendanceScrollController.dispose(); //
    monthScrollControllerSummary.dispose();
    // monthScrollControllerDetail.dispose();
    super.onClose();
  }

  void setCurrentMonthYear(String screenName) {
    if (monthScrollControllerDetail.hasClients) {
      double itemWidth = 80; // Adjust this based on your item width
      double screenWidth = Get.context!.size!.width;
      double screenCenter = screenWidth / 2;
      double selectedMonthPosition = MonthSel_selIndex.value * itemWidth;
      double targetScrollPosition = selectedMonthPosition - screenCenter + itemWidth / 2;

      // Ensure the calculated position is within valid scroll range
      double maxScrollExtent = monthScrollControllerDetail.position.maxScrollExtent;
      double minScrollExtent = monthScrollControllerDetail.position.minScrollExtent;
      if (targetScrollPosition < minScrollExtent) {
        targetScrollPosition = minScrollExtent;
      } else if (targetScrollPosition > maxScrollExtent) {
        targetScrollPosition = maxScrollExtent;
      }

      monthScrollControllerDetail.animateTo(
        targetScrollPosition,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    if (monthScrollControllerSummary.hasClients) {
      double itemWidth = 80; // Adjust this based on your item width
      double screenWidth = Get.context!.size!.width;
      double screenCenter = screenWidth / 2;
      double selectedMonthPosition = MonthSel_selIndex.value * itemWidth;
      double targetScrollPosition = selectedMonthPosition - screenCenter + itemWidth / 2;

      // Ensure the calculated position is within valid scroll range
      double maxScrollExtent = monthScrollControllerSummary.position.maxScrollExtent;
      double minScrollExtent = monthScrollControllerSummary.position.minScrollExtent;
      if (targetScrollPosition < minScrollExtent) {
        targetScrollPosition = minScrollExtent;
      } else if (targetScrollPosition > maxScrollExtent) {
        targetScrollPosition = maxScrollExtent;
      }

      monthScrollControllerSummary.animateTo(
        targetScrollPosition,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    CustomDropDown(
      selValue: YearSel_selIndex,
      onPressed: (index) {
        upd_YearSelIndex(index);
        showHideMsg();
      },
    );

    if (MonthSel_selIndex.value != -1 && YearSel_selIndex.isNotEmpty) {
      getattendeceprsnttable();
      getattendeceinfotable();
    }
    update();
  }

  void upd_MonthSelIndex(int index) async {
    MonthSel_selIndex.value = index;
    update();
    if (MonthSel_selIndex.value != -1 && YearSel_selIndex.isNotEmpty) {
      await getattendeceprsnttable();
      await getattendeceinfotable();
    }
  }

  void showHideMsg() {
    String msg = "";
    if (MonthSel_selIndex.value == -1 && YearSel_selIndex.isEmpty) {
      msg = "Please select Month and Year!";
    } else if (MonthSel_selIndex.value == -1 && YearSel_selIndex.isNotEmpty) {
      msg = "Please select Month!";
    } else if (MonthSel_selIndex.value != -1 && YearSel_selIndex.isEmpty) {
      msg = "Please select Year!";
    }

    if (msg.isNotEmpty) {
      Get.rawSnackbar(message: msg);
    }
  }

  void upd_YearSelIndex(String index) async {
    YearSel_selIndex = index;
    update();
    await fetchDataIfReady();
  }

  Future fetchDataIfReady() async {
    if (MonthSel_selIndex.value != -1 && YearSel_selIndex.isNotEmpty) {
      await getattendeceprsnttable();
      await getattendeceinfotable();
    }
  }

  Future<List<AttendanceDetailTable>> getattendeceinfotable() async {
    try {
      isLoader.value = true;
      String url = ConstApiUrl.empAttendanceDtlAPI;

      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      String monthYr = getMonthYearFromIndex(MonthSel_selIndex.value, YearSel_selIndex);
      var jsonbodyObj = {"loginId": loginId, "empId": empId, "monthYr": monthYr};

      var decodedResp = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseAttendenceDetail detailResponse = ResponseAttendenceDetail.fromJson(jsonDecode(decodedResp));

      if (detailResponse.statusCode == 200) {
        if (detailResponse.data != null && detailResponse.data!.isNotEmpty) {
          isLoader.value = false;
          attendenceDetailTable = detailResponse.data!;
          update();
          return attendenceDetailTable;
        } else {
          attendenceDetailTable = [];
        }
        update();
      } else if (detailResponse.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (detailResponse.statusCode == 400) {
        attendenceDetailTable = [];
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoader.value = false;
      update();
    }
    isLoader.value = false;
    return [];
  }

  Future<List<AttendenceSummarytable>> getattendeceprsnttable() async {
    try {
      isLoader.value = true;
      // String url = 'http://117.217.126.127:44166/api/Employee/GetEmpAttendSumm_EmpInfo';
      String url = ConstApiUrl.empAttendanceSummaryAPI;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      String monthYr = getMonthYearFromIndex(MonthSel_selIndex.value, YearSel_selIndex);
      var jsonbodyObj = {"loginId": loginId, "empId": empId, "monthYr": monthYr};

      var decodedResp = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseAttendenceSummary summaryResponse = ResponseAttendenceSummary.fromJson(jsonDecode(decodedResp));
      if (summaryResponse.statusCode == 200) {
        if (summaryResponse.data != null && summaryResponse.data!.isNotEmpty) {
          isLoader.value = false;
          attendenceSummaryTable = summaryResponse.data!;
          update();
          return attendenceSummaryTable;
        } else {
          attendenceSummaryTable = [];
        }
        update();
      } else if (summaryResponse.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (summaryResponse.statusCode == 400) {
        attendenceSummaryTable = [];
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoader.value = false;
      update();
    }
    isLoader.value = false;
    return [];
  }

  String getMonthYearFromIndex(int index, String year) {
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    if (index >= 0 && index < months.length && year.isNotEmpty && year != "") {
      return '${months[index]}${year.substring(year.length - 2)}'; // Format as 'Jan24'
    }
    return 'Select year and month';
  }
}
