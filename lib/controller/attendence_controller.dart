import 'package:emp_app/controller/api_controller.dart';
import 'package:emp_app/model/attendencetable_model.dart';
import 'package:emp_app/model/attpresenttable_model.dart';
import 'package:emp_app/model/dropdown_G_model.dart';
import 'package:emp_app/model/mispunchtable_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class AttendenceController extends GetxController {
  final ApiController apiController = Get.put(ApiController());
  late List<Dropdown_Glbl> monthyr = [];
  late List<MispunchTable> mispunchtable = [];
  late List<Attendencetable> attendencetable = [];
  late List<AttPresentTable> attpresenttable = [];
  String tokenNo = '', loginId = '', empId = '';
  bool isLoading = true;
  Dropdown_Glbl? selectedMonthYear;
  final _storage = const FlutterSecureStorage();

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
      isLoading = false;
      update();
      return monthyr;
    } catch (e) {
      isLoading = false;
      update();
    }
    return [];
  }

  Future monthYr_OnClick(Dropdown_Glbl? value) async {
    selectedMonthYear = value;
    update();
  }

  Future monthYr_OnClick1(Dropdown_Glbl? value) async {
    selectedMonthYear = value;
    update();
  }

  Future<dynamic> getmonthyrempinfotable() async {
    try {
      String url = 'http://117.217.126.127:44166/api/Employee/GetMisPunchDtl_EmpInfo';
      var jsonbodyObj = {"loginId": loginId, "empId": empId, "monthYr": selectedMonthYear!.value};

      var empmonthyrtable = await apiController.getDynamicData(url, tokenNo, jsonbodyObj);
      mispunchtable = apiController.parseJson_Flag_Mispunch(empmonthyrtable, 'data');

      isLoading = false;
      update();
      return mispunchtable;
    } catch (e) {
      isLoading = false;
      update();
    }
    return [];
  }

  Future<dynamic> getattendeceinfotable() async {
    try {
      String url = 'http://117.217.126.127:44166/api/Employee/GetEmpAttendDtl_EmpInfo';
      var jsonbodyObj = {"loginId": loginId, "empId": empId, "monthYr": selectedMonthYear!.value};

      var empmonthyrtable = await apiController.getDynamicData(url, tokenNo, jsonbodyObj);
      attendencetable = apiController.parseJson_Flag_attendence(empmonthyrtable, 'data');

      isLoading = false;
      update();
      return attendencetable;
    } catch (e) {
      isLoading = false;
      update();
    }
    return [];
  }

  Future<dynamic> getattendeceprsnttable() async {
    try {
      String url = 'http://117.217.126.127:44166/api/Employee/GetEmpAttendSumm_EmpInfo';
      var jsonbodyObj = {"loginId": loginId, "empId": empId, "monthYr": selectedMonthYear!.value};

      var empmonthyrtable = await apiController.getDynamicData(url, tokenNo, jsonbodyObj);
      attpresenttable = apiController.parseJson_Flag_attprsnt(empmonthyrtable, 'data');
      isLoading = false;
      update();
      return attpresenttable;
    } catch (e) {
      isLoading = false;
      update();
    }
    return [];
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

  List<DataRow> fixedColRowBuilderattprsnt() {
    var topdata = attpresenttable.asMap().entries.map((attData1) {
      AttPresentTable team = attData1.value;
      return DataRow(
        cells: [
          DataCell(Text(team.toTP.toString())),
          DataCell(Text(team.toTA.toString())),
        ],
      );
    }).toList();
    return topdata;
  }

  List<DataRow> scrollableColRowBuilderattprsnt() {
    var att = attpresenttable
        .map((team) => DataRow(
              cells: [
                DataCell(Text(team.toTDAYS.toString())),
                DataCell(Text(team.p.toString())),
                DataCell(Text(team.a.toString())),
                DataCell(Text(team.wo.toString())),
                DataCell(Text(team.co.toString())),
                DataCell(Text(team.pl.toString())),
                DataCell(Text(team.sl.toString())),
                DataCell(Text(team.cl.toString())),
                DataCell(Text(team.ho.toString())),
                DataCell(Text(team.ml.toString())),
                DataCell(Text(team.ch.toString())),
                DataCell(Text(team.lCEGMIN.toString())),
                DataCell(Text(team.lCEGCNT.toString())),
                DataCell(Text(team.nOTHRS.toString())),
                DataCell(Text(team.cOTHRS.toString())),
                DataCell(Text(team.ttLOTHRS.toString())),
                DataCell(Text(team.dutYHRS.toString())),
                DataCell(Text(team.dutYST.toString())),
              ],
            ))
        .toList();
    return att;
  }

  List<DataRow> fixedColRowBuilderattndence() {
    return attendencetable.asMap().entries.map((attData) {
      int index = attData.key;
      Attendencetable team = attData.value;
      return DataRow(
        cells: [
          DataCell(Text((index + 1).toString())),
          DataCell(Text(team.atTDATE.toString())),
        ],
      );
    }).toList();
  }

  List<DataRow> scrollableColRowBuilderattndence() {
    var att = attendencetable
        .map((team) => DataRow(
              cells: [
                        DataCell(CustomWidthCell(width: 100, child: Expanded(flex: 2,
                          child: Text(team.iN.toString())))),
                        DataCell(CustomWidthCell(width: 100, child: Expanded(child: Text(team.out.toString())))),
                        DataCell(CustomWidthCell(width: 150, child: Expanded(child: Text(team.punch.toString())))),
                        DataCell(CustomWidthCell(width: 100, child: Expanded(child: Text(team.shift.toString())))),
                        DataCell(CustomWidthCell(width: 50, child: Expanded(child: Text(team.lv.toString())))),
                        DataCell(CustomWidthCell(width: 50, child: Expanded(child: Text(team.st.toString())))),
                        DataCell(CustomWidthCell(width: 50, child: Expanded(child: Text(team.oTENTMIN.toString())))),
                        DataCell(CustomWidthCell(width: 50, child: Expanded(child: Text(team.oTMIN.toString())))),
                        DataCell(CustomWidthCell(width: 50, child: Expanded(child: Text(team.lc.toString())))),
                        DataCell(CustomWidthCell(width: 50, child: Expanded(child: Text(team.eg.toString())))),
                        DataCell(CustomWidthCell(width: 50, child: Expanded(child: Text(team.lCEGMIN.toString())))),
                      ],
                    ))
                .toList();
        //         DataCell(CustomWidthCell(width: 100, child: Text(team.iN.toString()))),
        //         DataCell(CustomWidthCell(width: 100, child: Text(team.out.toString()))),
        //         DataCell(CustomWidthCell(width: 150, child: Text(team.punch.toString()))),
        //         DataCell(CustomWidthCell(width: 100, child: Text(team.shift.toString()))),
        //         DataCell(CustomWidthCell(width: 50, child: Text(team.lv.toString()))),
        //         DataCell(CustomWidthCell(width: 50, child: Text(team.st.toString()))),
        //         DataCell(CustomWidthCell(width: 50, child: Text(team.oTENTMIN.toString()))),
        //         DataCell(CustomWidthCell(width: 50, child: Text(team.oTMIN.toString()))),
        //         DataCell(CustomWidthCell(width: 50, child: Text(team.lc.toString()))),
        //         DataCell(CustomWidthCell(width: 50, child: Text(team.eg.toString()))),
        //         DataCell(CustomWidthCell(width: 50, child: Text(team.lCEGMIN.toString()))),
        //         // DataCell(Text(team.iN.toString())),
        //         // DataCell(Text(team.out.toString())),
        //         // DataCell(Text(team.punch.toString())),
        //         // DataCell(Text(team.shift.toString())),
        //         // DataCell(Text(team.lv.toString())),
        //         // DataCell(Text(team.st.toString())),
        //         // DataCell(Text(team.oTENTMIN.toString())),
        //         // DataCell(Text(team.oTMIN.toString())),
        //         // DataCell(Text(team.lc.toString())),
        //         // DataCell(Text(team.eg.toString())),
        //         // DataCell(Text(team.lCEGMIN.toString())),
        //       ],
        //     ))
        // .toList();
    return att;
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
