import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/app_custom_widget/custom_month_picker.dart';
import 'package:emp_app/app/core/model/dropdown_G_model.dart';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/mispunch/model/mispunchtable_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class MispunchController extends GetxController {
  late List<Dropdown_Glbl> monthyr = [];
  final _storage = const FlutterSecureStorage();
  final ApiController apiController = Get.put(ApiController());
  var bottomBarController = Get.put(BottomBarController());
  String tokenNo = '', loginId = '', empId = '';
  var isLoading = false.obs;
  Dropdown_Glbl? selectedMonthYear;
  late List<MispunchTable> mispunchtable = [];
  RxInt MonthSel_selIndex = (-1).obs;
  String YearSel_selIndex = "";
  var selectedYear = ''.obs;
  List<String> years = ['2023', '2024'];
  final ScrollController monthScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    // setCurrentMonthYear();
  }

  void setCurrentMonthYear() {
    DateTime now = DateTime.now();
    MonthSel_selIndex.value = now.month - 1;

    MonthSelectionScreen(
      selectedMonthIndex: MonthSel_selIndex.value,
      scrollController: monthScrollController,
      onPressed: (index) {
        upd_MonthSelIndex(index);
        showHideMsg();
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (monthScrollController.hasClients) {
        double itemWidth = 80;
        double screenWidth = Get.context!.size!.width;
        double screenCenter = screenWidth / 2;
        double selectedMonthPosition = MonthSel_selIndex.value * itemWidth;
        double targetScrollPosition = selectedMonthPosition - screenCenter + itemWidth / 2;
        double maxScrollExtent = monthScrollController.position.maxScrollExtent;
        double minScrollExtent = monthScrollController.position.minScrollExtent;
        if (targetScrollPosition < minScrollExtent) {
          targetScrollPosition = minScrollExtent;
        } else if (targetScrollPosition > maxScrollExtent) {
          targetScrollPosition = maxScrollExtent;
        }

        monthScrollController.animateTo(
          targetScrollPosition,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
    YearSel_selIndex = now.year.toString();

    CustomDropDown(
      selValue: YearSel_selIndex,
      onPressed: (index) {
        upd_YearSelIndex(index);
        showHideMsg();
      },
    );

    if (MonthSel_selIndex.value != -1 && YearSel_selIndex.isNotEmpty) {
      getmonthyrempinfotable();
    }

    update();
  }

  void clearData() {
    MonthSel_selIndex.value = 0;
    YearSel_selIndex = "";
    mispunchtable.clear();
    isLoading.value = false;
  }

  void upd_MonthSelIndex(int index) async {
    MonthSel_selIndex.value = index;
    update();
    await getmonthyrempinfotable();
  }

  void upd_YearSelIndex(String index) async {
    YearSel_selIndex = index;
    update();
    await fetchDataIfReady();
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

  Future fetchDataIfReady() async {
    if (MonthSel_selIndex.value != -1 && YearSel_selIndex.isNotEmpty) {
      await getmonthyrempinfotable();
    }
  }

  Future<List<Dropdown_Glbl>> getmonthyrempinfo() async {
    try {
      String url = 'http://117.217.126.127:44166/api/Employee/GetMonthYr_EmpInfo';

      tokenNo = await _storage.read(key: "KEY_TOKENNO") ?? '';
      loginId = await _storage.read(key: "KEY_LOGINID") ?? '';
      empId = await _storage.read(key: "KEY_EMPID") ?? '';

      var jsonbodyObj = {"loginId": loginId};

      final EmpMonthYr = await apiController.getDynamicData(url, tokenNo, jsonbodyObj);
      monthyr = apiController.parseJson_Flag_monthyr(EmpMonthYr, "data");
      if (monthyr.length > 0) {
        selectedMonthYear = monthyr[0];
      }
      isLoading.value = false;
      update();
      return monthyr;
    } catch (e) {
      isLoading.value = false;
      update();
    }
    return [];
  }

  Future<dynamic> getmonthyrempinfotable() async {
    try {
      isLoading.value = true;
      String url = 'http://117.217.126.127:44166/api/Employee/GetMisPunchDtl_EmpInfo';
      loginId = await _storage.read(key: "KEY_LOGINID") ?? '';
      tokenNo = await _storage.read(key: "KEY_TOKENNO") ?? '';
      String monthYr = getMonthYearFromIndex(MonthSel_selIndex.value, YearSel_selIndex);
      var jsonbodyObj = {"loginId": loginId, "empId": empId, "monthYr": monthYr};
      var empmonthyrtable = await apiController.getDynamicData(url, tokenNo, jsonbodyObj);
      mispunchtable = apiController.parseJson_Flag_Mispunch(empmonthyrtable, 'data');

      isLoading.value = false;
      update();
      return mispunchtable;
    } catch (e) {
      isLoading.value = false;
      update();
    }
    return [];
  }

  String getMonthYearFromIndex(int index, String year) {
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
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

  List<DataRow> FixedColRowBuilder() {
    return mispunchtable.asMap().entries.map((mispunchData) {
      int index = mispunchData.key;
      MispunchTable team = mispunchData.value;
      return DataRow(
        cells: [
          DataCell(Text((index + 1).toString())),
          DataCell(Text(team.dt.toString().substring(0, 10))),
        ],
      );
    }).toList();
  }

  List<DataRow> ScrollableColRowBuilder() {
    return mispunchtable
        .map((team) => DataRow(
              cells: [
                DataCell(CustomWidthCell(width: 50, child: Text(team.misPunch.toString()))),
                DataCell(CustomWidthCell(width: 150, child: Text(team.punchTime.toString()))),
                DataCell(CustomWidthCell(width: 100, child: Text(team.shiftTime.toString()))),
              ],
            ))
        .toList();
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
