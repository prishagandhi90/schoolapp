import 'package:emp_app/controller/api_controller.dart';
import 'package:emp_app/model/dropdown_G_model.dart';
import 'package:emp_app/model/mispunchtable_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class AttendenceController extends GetxController {
  final ApiController apiController = Get.put(ApiController());
  late List<Dropdown_Glbl> monthyr = [];
  late List<MispunchTable> mispunchtable = [];
  String tokenNo = '', loginId = '', empId = '';
  bool isLoading = true;
  Dropdown_Glbl? selectedMonthYear;
  final _storage = const FlutterSecureStorage();

  Future<List<Dropdown_Glbl>> getmonthyr_empinfo() async {
    try {
      String url = 'http://117.217.126.127:44166/api/Employee/GetMonthYr_EmpInfo';

      tokenNo = await _storage.read(key: "KEY_TOKENNO") ?? '';
      loginId = await _storage.read(key: "KEY_LOGINID") ?? '';
      empId = await _storage.read(key: "KEY_EMPID") ?? '';

      var jsonbodyObj = {"loginId": loginId};

      final EmpMonthYr = await apiController.GetDynamicData(url, tokenNo, jsonbodyObj);
      monthyr = apiController.ParseJson_Flag(EmpMonthYr, "data");
      if (monthyr.length > 0) {
        selectedMonthYear = monthyr[0];
      }
      isLoading = false;
      update();
      return monthyr;
    } catch (e) {
      isLoading = false;
      update();
    }
    return [];
  }

  Future MonthYr_OnClick(Dropdown_Glbl? value) async {
    selectedMonthYear = value;
    update();
  }

  Future<dynamic> getmonthyrempinfotable() async {
    try {
      String url = 'http://117.217.126.127:44166/api/Employee/GetMisPunchDtl_EmpInfo';
      var jsonbodyObj = {"loginId": loginId, "empId": empId, "monthYr": selectedMonthYear!.value};

      var empmonthyrtable = await apiController.GetDynamicData(url, tokenNo, jsonbodyObj);
      mispunchtable = apiController.ParseJson_Flag1(empmonthyrtable, 'data');

      isLoading = false;
      update();
      return mispunchtable;
    } catch (e) {
      isLoading = false;
      update();
    }
    return [];
  }

  List<DataRow> FixedColRowBuilder() {
    // Assuming teamsData is a list of team objects
    return mispunchtable.asMap().entries.map((attData) {
      int index = attData.key;
      MispunchTable team = attData.value;
      return DataRow(
        cells: [
          DataCell(Text('${(index + 1).toString()}')),
          DataCell(Text('${team.dt.toString()}'.substring(0, 10))),
          // DataCell(Text('${team.}')),
          // Add more DataCells as needed for other columns
        ],
      );
    }).toList();
  }

  List<DataRow> ScrollableColRowBuilder() {
    // Assuming teamsData is a list of team objects
    return mispunchtable
        .map((team) => DataRow(
              cells: [
                DataCell(Text('${team.misPunch.toString()}')),
                DataCell(Text('${team.punchTime.toString()}')),
                DataCell(Text('${team.shiftTime.toString()}')),
                // Add more DataCells as needed for other columns
              ],
            ))
        .toList();
  }
}
