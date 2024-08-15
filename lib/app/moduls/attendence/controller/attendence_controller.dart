import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/app_custom_widget/custom_month_picker.dart';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/mispunch/model/mispunchtable_model.dart';
import 'package:emp_app/app/moduls/attendence/model/attendencetable_model.dart';
import 'package:emp_app/app/moduls/attendence/model/attpresenttable_model.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendenceController extends GetxController {
  final ApiController apiController = Get.put(ApiController());
  var bottomBarController = Get.put(BottomBarController());
  late List<MispunchTable> mispunchtable = [];
  late List<Attendencetable> attendencetable = [];
  late List<AttPresentTable> attpresenttable = [];
  String tokenNo = '', loginId = '', empId = '';
  bool isLoading = true;
  var isLoading1 = false.obs;
  RxInt MonthSel_selIndex = (-1).obs;
  String YearSel_selIndex = "";
  var selectedYear = ''.obs;

  List<String> years = ['2023', '2024'];
  final ScrollController attendanceScrollController = ScrollController();
  final ScrollController monthScrollControllerSummary = ScrollController();
  final ScrollController monthScrollControllerDetail = ScrollController();

  @override
  void onInit() {
    super.onInit();
    // if (MonthSel_selIndex.value != -1 && YearSel_selIndex.isNotEmpty) {
    //   getattendeceprsnttable();
    //   getattendeceinfotable();
    // }
    attendanceScrollController.addListener(() {
      if (attendanceScrollController.position.userScrollDirection == ScrollDirection.forward) {
        hideBottomBar = false.obs;
        update();
        // print("=====Up");
        bottomBarController.update();
        // update(0.0, true);
      } else if (attendanceScrollController.position.userScrollDirection == ScrollDirection.reverse) {
        hideBottomBar = true.obs;
        update();
        bottomBarController.update();
        // print("=====Down");
      }
    });

    DateTime now = DateTime.now();
    MonthSel_selIndex.value = now.month - 1;
    YearSel_selIndex = now.year.toString();
    setCurrentMonthYear("SummaryScreen");
  }

  ScrollController createScrollController() {
    return ScrollController();
  }

  void setCurrentMonthYear(String screenName) {
    DateTime now = DateTime.now();

    // if (ScreenName == "SummaryScreen") {
    //   MonthSel_selIndex.value = now.month - 1;
    // }

    MonthSelectionScreen(
      selectedMonthIndex: MonthSel_selIndex.value,
      scrollController: screenName == "DetailScreen" ? monthScrollControllerDetail : monthScrollControllerSummary,
      onPressed: (index) {
        upd_MonthSelIndex(index);
        showHideMsg();
      },
    );

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (monthScrollController.hasClients) {
    //     double itemWidth = Get.context!.size!.width / 3; // Adjust this based on your item width
    //     monthScrollController.animateTo(
    //       MonthSel_selIndex.value * itemWidth - Get.context!.size!.width / 2 + itemWidth / 2,
    //       duration: Duration(milliseconds: 500),
    //       curve: Curves.easeInOut,
    //     );
    //   }
    // });

    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    });

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

  // void clearData() {
  //   MonthSel_selIndex.value = -1;
  //   YearSel_selIndex = "";
  //   attendencetable.clear();
  //   attpresenttable.clear();
  //   isLoading1.value = false;
  // }

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
    // selectedYear.value = years[index];
    update();
    await fetchDataIfReady();
  }

  Future fetchDataIfReady() async {
    if (MonthSel_selIndex.value != -1 && YearSel_selIndex.isNotEmpty) {
      await getattendeceprsnttable();
      await getattendeceinfotable();
    }
  }

  Future<dynamic> getattendeceinfotable() async {
    try {
      isLoading1.value = true;
      String url = 'http://117.217.126.127:44166/api/Employee/GetEmpAttendDtl_EmpInfo';
      // var jsonbodyObj = {"loginId": loginId, "empId": empId, "monthYr": selectedMonthYear!.value};

      // loginId = await _storage.read(key: "KEY_LOGINID") ?? '';
      // tokenNo = await _storage.read(key: "KEY_TOKENNO") ?? '';
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString('KEY_LOGINID') ?? "";
      tokenNo = await pref.getString('KEY_TOKENNO') ?? "";

      String monthYr = getMonthYearFromIndex(MonthSel_selIndex.value, YearSel_selIndex);
      var jsonbodyObj = {"loginId": loginId, "empId": empId, "monthYr": monthYr};
      var empmonthyrtable = await apiController.getDynamicData(url, tokenNo, jsonbodyObj);
      attendencetable = apiController.parseJson_Flag_attendence(empmonthyrtable, 'data');

      isLoading1.value = false;
      update();
      return attendencetable;
    } catch (e) {
      isLoading1.value = false;
      update();
    }
    return [];
  }

  Future<dynamic> getattendeceprsnttable() async {
    try {
      isLoading1.value = true;
      String url = 'http://117.217.126.127:44166/api/Employee/GetEmpAttendSumm_EmpInfo';
      // loginId = await _storage.read(key: "KEY_LOGINID") ?? '';
      // tokenNo = await _storage.read(key: "KEY_TOKENNO") ?? '';
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString('KEY_LOGINID') ?? "";
      tokenNo = await pref.getString('KEY_TOKENNO') ?? "";

      String monthYr = getMonthYearFromIndex(MonthSel_selIndex.value, YearSel_selIndex);
      var jsonbodyObj = {"loginId": loginId, "empId": empId, "monthYr": monthYr};
      var empmonthyrtable = await apiController.getDynamicData(url, tokenNo, jsonbodyObj);
      attpresenttable = apiController.parseJson_Flag_attprsnt(empmonthyrtable, 'data');
      isLoading1.value = false;
      update();
      return attpresenttable;
    } catch (e) {
      isLoading1.value = false;
      update();
    }
    return [];
  }

  // String getMonthYearFromIndex(int index) {
  //   List<String> months = ['Jan24', 'Feb24', 'Mar24', 'Apr24', 'May24', 'Jun24', 'Jul24', 'Aug24', 'Sep24', 'Oct24', 'Nov24', 'Dec24'];
  //   if (index >= 0 && index < months.length) {
  //     return months[index];
  //   }
  //   return 'Select year and month';
  // }
  String getMonthYearFromIndex(int index, String year) {
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    // List<String> years = ['23', '24', '25']; // Example year suffixes (adjust as needed)
    if (year == '2024') {
      year = '24';
    } else {
      year = '23';
    }

    if (index >= 0 && index < months.length && year.isNotEmpty && year != "") {
      return '${months[index]}${year}'; // Format as 'Jan24'
    }
    return 'Select year and month';
  }

  String split_go_leftRight(String string1, String flag) {
    string1 = string1.replaceAll('\r', ' ');
    List<String> parts = string1.split(' ');

    // If the string has fewer than 3 parts, just return the original string
    if (parts.length < 1) {
      // print("The string has fewer than 3 parts.");
      return "";
    }

    String firstPart = parts.sublist(0, 2).join(' ');
    String secondPart = parts.sublist(2).join(' ');

    if (flag == 'left')
      return firstPart;
    else if (flag == 'right') return secondPart;

    return '';
  }
}

class CustomWidthCell extends StatelessWidget {
  final Widget child;
  final double width;

  const CustomWidthCell({super.key, required this.child, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: child,
    );
  }
}
