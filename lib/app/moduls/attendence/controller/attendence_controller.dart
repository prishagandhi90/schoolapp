import 'package:emp_app/app/app_custom_widget/emp_att_dtl_extra_data.dart';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/mispunch/model/mispunchtable_model.dart';
import 'package:emp_app/app/moduls/attendence/model/attendencetable_model.dart';
import 'package:emp_app/app/moduls/attendence/model/attpresenttable_model.dart';
import 'package:emp_app/app/core/model/dropdown_G_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';


class AttendenceController extends GetxController {
  final ApiController apiController = Get.put(ApiController());
  var bottomBarController = Get.put(BottomBarController());
  late List<Dropdown_Glbl> monthyr = [];
  late List<MispunchTable> mispunchtable = [];
  late List<Attendencetable> attendencetable = [];
  late List<AttPresentTable> attpresenttable = [];
  String tokenNo = '', loginId = '', empId = '';
  bool isLoading = true;
  var isLoading1 = false.obs;
  Dropdown_Glbl? selectedMonthYear;
  final _storage = const FlutterSecureStorage();
  RxInt MonthSel_selIndex = (-1).obs;
  String YearSel_selIndex = "";
  var selectedYear = ''.obs;
  List<String> years = ['2023', '2024'];

  @override
  void onInit() {
    super.onInit();
    if (MonthSel_selIndex.value != -1 && YearSel_selIndex.isNotEmpty) {
      getattendeceprsnttable();
      getattendeceinfotable();
    }
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

  // void upd_YearSelIndex(int index) {
  //   YearSel_selIndex.value = index;
  //   selectedYear.value = years[index];
  //   update();
  //   fetchDataIfReady();
  // }

  void upd_YearSelIndex(String index) async {
    YearSel_selIndex = index;
    // selectedYear.value = years[index];
    update();
    await fetchDataIfReady();
  }

  // Check if both month and year are selected and fetch data
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
      loginId = await _storage.read(key: "KEY_LOGINID") ?? '';
      tokenNo = await _storage.read(key: "KEY_TOKENNO") ?? '';
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
      loginId = await _storage.read(key: "KEY_LOGINID") ?? '';
      tokenNo = await _storage.read(key: "KEY_TOKENNO") ?? '';
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
    List<String> years = ['23', '24', '25']; // Example year suffixes (adjust as needed)
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

  // List<DataRow> FixedColRowBuilder() {
  //   return mispunchtable.asMap().entries.map((mispunchData) {
  //     MispunchTable team = mispunchData.value;
  //     return DataRow(
  //       cells: [
  //         const DataCell(Card(
  //           child: Text('data'),
  //         )),
  //         DataCell(Text(team.dt.toString().substring(0, 10))),
  //       ],
  //     );
  //   }).toList();
  // }

  // List<DataRow> ScrollableColRowBuilder() {
  //   return mispunchtable
  //       .map((team) => DataRow(
  //             cells: [
  //               DataCell(CustomWidthCell(width: 50, child: Text(team.misPunch.toString()))),
  //               DataCell(CustomWidthCell(width: 150, child: Text(team.punchTime.toString()))),
  //               DataCell(CustomWidthCell(width: 100, child: Text(team.shiftTime.toString()))),
  //               // DataCell(Text(team.misPunch.toString())),
  //               // DataCell(Text(team.punchTime.toString())),
  //               // DataCell(Text(team.shiftTime.toString())),
  //             ],
  //           ))
  //       .toList();
  // }

  // List<DataRow> fixedColRowBuilderattprsnt() {
  //   var topdata = attpresenttable.asMap().entries.map((attData1) {
  //     AttPresentTable team = attData1.value;
  //     return DataRow(
  //       cells: [
  //         DataCell(Text(team.toTP.toString())),
  //         DataCell(Text(team.toTA.toString())),
  //       ],
  //     );
  //   }).toList();
  //   return topdata;
  // }

  // List<DataRow> scrollableColRowBuilderattprsnt() {
  //   var att = attpresenttable
  //       .map((team) => DataRow(
  //             cells: [
  //               DataCell(Text(team.toTDAYS.toString())),
  //               DataCell(Text(team.p.toString())),
  //               DataCell(Text(team.a.toString())),
  //               DataCell(Text(team.wo.toString())),
  //               DataCell(Text(team.co.toString())),
  //               DataCell(Text(team.pl.toString())),
  //               DataCell(Text(team.sl.toString())),
  //               DataCell(Text(team.cl.toString())),
  //               DataCell(Text(team.ho.toString())),
  //               DataCell(Text(team.ml.toString())),
  //               DataCell(Text(team.ch.toString())),
  //               DataCell(Text(team.lCEGMIN.toString())),
  //               DataCell(Text(team.lCEGCNT.toString())),
  //               DataCell(Text(team.nOTHRS.toString())),
  //               DataCell(Text(team.cOTHRS.toString())),
  //               DataCell(Text(team.ttLOTHRS.toString())),
  //               DataCell(Text(team.dutYHRS.toString())),
  //               DataCell(Text(team.dutYST.toString())),
  //             ],
  //           ))
  //       .toList();
  //   return att;
  // }

  List<DataRow> fixedColRowBuilderattndence() {
    return attendencetable.asMap().entries.map((attData) {
      Attendencetable team = attData.value;
      return DataRow(
        cells: [
          DataCell(
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(color: const Color.fromARGB(255, 199, 199, 199), borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [Text(team.atTDATE.toString())],
              ),
            ),
          ),
          DataCell(Text(team.iN.toString())),
          DataCell(Text(team.out.toString())),
          DataCell(Text(team.lCEGMIN.toString())),
          DataCell(IconButton(
            icon: const Icon(Icons.arrow_drop_down_circle),
            onPressed: () {
              Get.to(
                EmpAttDtlExtraData(
                  punch: team.punch!,
                  shift: team.shift!,
                  lv: team.lv!,
                  st: team.st!,
                  oTENTMIN: team.oTENTMIN!,
                  oTMIN: team.oTMIN!,
                  lc: team.lc!,
                  eg: team.eg!,
                ),
              );
            },
          )),
          // DataCell(Text(team.punch.toString())),
          // DataCell(Text(team.shift.toString())),
          // DataCell(Text(team.lv.toString())),
          // DataCell(Text(team.st.toString())),
          // DataCell(Text(team.oTENTMIN.toString())),
          // DataCell(Text(team.oTMIN.toString())),
          // DataCell(Text(team.lc.toString())),
          // DataCell(Text(team.eg.toString())),
        ],
      );
    }).toList();
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
