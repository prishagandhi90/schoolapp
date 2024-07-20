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
  RxInt YearSel_selIndex = (-1).obs;
  var selectedYear = ''.obs;
  List<String> years = ['2023', '2024'];

  @override
  void onInit() {
    super.onInit();
    getmonthyrempinfotable();
  }

  void upd_MonthSelIndex(int index) async {
    MonthSel_selIndex.value = index;
    update();
    await getmonthyrempinfotable();
  }

  void upd_YearSelIndex(int index) {
    YearSel_selIndex.value = index;
    selectedYear.value = years[index];
    fetchDataIfReady();
  }

  // Check if both month and year are selected and fetch data
  void fetchDataIfReady() {
    if (MonthSel_selIndex.value != -1 && YearSel_selIndex.value != -1) {
      getmonthyrempinfotable();
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

  // Future monthYr_OnClick(Dropdown_Glbl? value) async {
  //   selectedMonthYear = value;
  //   update();
  // }

  Future<dynamic> getmonthyrempinfotable() async {
    try {
      isLoading.value = true;
      String url = 'http://117.217.126.127:44166/api/Employee/GetMisPunchDtl_EmpInfo';
      // var jsonbodyObj = {"loginId": loginId, "empId": empId, "monthYr": selectedMonthYear!.value};
      loginId = await _storage.read(key: "KEY_LOGINID") ?? '';
      tokenNo = await _storage.read(key: "KEY_TOKENNO") ?? '';
      String monthYr = getMonthYearFromIndex(MonthSel_selIndex.value, YearSel_selIndex.value);
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

  String getMonthYearFromIndex(int index, int yearIndex) {
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    List<String> years = ['23', '24', '25']; // Example year suffixes (adjust as needed)

    if (index >= 0 && index < months.length && yearIndex >= 0 && yearIndex < years.length) {
      return '${months[index]}${years[yearIndex]}'; // Format as 'Jan24'
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
                // DataCell(Text(team.misPunch.toString())),
                // DataCell(Text(team.punchTime.toString())),
                // DataCell(Text(team.shiftTime.toString())),
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
    return Container(
      width: width,
      child: child,
    );
  }
}
