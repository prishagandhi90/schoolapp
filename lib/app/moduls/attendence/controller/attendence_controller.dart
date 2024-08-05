import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/app_custom_widget/custom_month_picker.dart';
import 'package:emp_app/app/app_custom_widget/emp_att_dtl_extra_data.dart';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/mispunch/model/mispunchtable_model.dart';
import 'package:emp_app/app/moduls/attendence/model/attendencetable_model.dart';
import 'package:emp_app/app/moduls/attendence/model/attpresenttable_model.dart';
import 'package:emp_app/app/core/model/dropdown_G_model.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  final ScrollController attendanceScrollController = ScrollController();

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

    setCurrentMonthYear();
  }

  void setCurrentMonthYear() {
    DateTime now = DateTime.now();
    MonthSel_selIndex.value = now.month - 1;

    MonthSelectionScreen(
      selectedMonthIndex: MonthSel_selIndex.value,
      onPressed: (index) {
        upd_MonthSelIndex(index);
        showHideMsg();
      },
    );

    YearSel_selIndex = now.year.toString();

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

  void clearData() {
    MonthSel_selIndex.value = -1;
    YearSel_selIndex = "";
    attendencetable.clear();
    attpresenttable.clear();
    isLoading1.value = false;
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

  // Future<void> detailbottomsheet(BuildContext context, int index) async {
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     isDismissible: true,
  //     enableDrag: true,
  //     context: context,
  //     // context: Get.context!,
  //     constraints: const BoxConstraints(maxWidth: 380),
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(20.0),
  //       side: const BorderSide(color: Colors.black),
  //     ),
  //     builder: (context) {
  //       return attpresenttable.isNotEmpty
  //           ? Container(
  //               height: MediaQuery.of(context).size.height * 0.70,
  //               width: Get.width,
  //               decoration: const BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(25.0),
  //                   topRight: Radius.circular(25.0),
  //                 ),
  //               ),
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   children: [
  //                     Container(
  //                       height: MediaQuery.of(context).size.height * 0.15,
  //                       decoration: BoxDecoration(
  //                         color: const Color.fromARGB(255, 223, 239, 241),
  //                         borderRadius: BorderRadius.circular(20),
  //                       ),
  //                       child: Column(
  //                         children: [
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               const SizedBox(
  //                                 width: 30,
  //                               ),
  //                               //  Divider(
  //                               //   thickness: 20,
  //                               //   color: AppColor.black,
  //                               // ),
  //                               GestureDetector(
  //                                 onTap: () {
  //                                   Navigator.pop(context);
  //                                 },
  //                                 child: const Icon(Icons.cancel),
  //                               )
  //                             ],
  //                           ),
  //                           Container(
  //                             padding: const EdgeInsets.all(10),
  //                             width: double.infinity,
  //                             height: 45,
  //                             decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColor.primaryColor),
  //                             child: const Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 15),
  //                               child: Align(
  //                                   alignment: Alignment.center,
  //                                   child: Text(
  //                                     'PUNCH',
  //                                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  //                                   )),
  //                             ),
  //                           ),
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                             children: [
  //                               attendencetable.isNotEmpty
  //                                   ? Text(
  //                                       split_go_leftRight(attendencetable[index].punch.toString(), 'left'),
  //                                     )
  //                                   : Text('--:-- ',
  //                                       style: TextStyle(
  //                                         fontSize: 16, //25
  //                                         fontWeight: FontWeight.w600,
  //                                         fontFamily: CommonFontStyle.plusJakartaSans,
  //                                       )),
  //                               attendencetable.isNotEmpty
  //                                   ? Text(
  //                                       split_go_leftRight(attendencetable[index].punch.toString(), 'right'),
  //                                     )
  //                                   : Text('--:-- ',
  //                                       style: TextStyle(
  //                                         fontSize: 16, //25
  //                                         fontWeight: FontWeight.w600,
  //                                         fontFamily: CommonFontStyle.plusJakartaSans,
  //                                       )),
  //                               // if (attendenceController.attendencetable.isNotEmpty)
  //                               //   Text(
  //                               //     split_go_leftRight(attendenceController.attendencetable[index].punch.toString(), 'left'),
  //                               //   )
  //                               // else
  //                               //   Text('--:-- ',
  //                               //       style: TextStyle(
  //                               //         fontSize: 16, //25
  //                               //         fontWeight: FontWeight.w600,
  //                               //         fontFamily: CommonFontStyle.plusJakartaSans,
  //                               //       )),
  //                               // if (attendenceController.attendencetable.isNotEmpty)
  //                               //   Text(split_go_leftRight(attendenceController.attendencetable[index].punch.toString(), 'right'))
  //                               // else
  //                               //   Text('--:-- ',
  //                               //       style: TextStyle(
  //                               //         fontSize: 16, //25
  //                               //         fontWeight: FontWeight.w600,
  //                               //         fontFamily: CommonFontStyle.plusJakartaSans,
  //                               //       )),
  //                             ],
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                     const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
  //                     Container(
  //                       height: MediaQuery.of(context).size.height * 0.15,
  //                       decoration: BoxDecoration(
  //                         color: const Color.fromARGB(255, 223, 239, 241),
  //                         borderRadius: BorderRadius.circular(20),
  //                       ),
  //                       child: Column(
  //                         children: [
  //                           Container(
  //                             padding: const EdgeInsets.all(10),
  //                             decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColor.primaryColor),
  //                             child: Row(
  //                               // mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                               children: [
  //                                 Flexible(
  //                                   flex: 3,
  //                                   child: Container(
  //                                       width: MediaQuery.of(context).size.height * 0.5,
  //                                       alignment: Alignment.center,
  //                                       child: const Text('SHIFT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
  //                                 ),
  //                                 Flexible(
  //                                   flex: 1,
  //                                   child: Container(
  //                                       width: MediaQuery.of(context).size.height * 0.25,
  //                                       alignment: Alignment.center,
  //                                       child: const Text('ST', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
  //                                 ),
  //                                 Flexible(
  //                                   flex: 1,
  //                                   child: Container(
  //                                       width: MediaQuery.of(context).size.height * 0.25,
  //                                       alignment: Alignment.center,
  //                                       child: const Text('LV', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           Row(
  //                             // mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                             children: [
  //                               Flexible(
  //                                 flex: 3,
  //                                 child: Container(
  //                                   // height: 100,
  //                                   width: MediaQuery.of(context).size.height * 0.5,
  //                                   alignment: Alignment.center,
  //                                   child: attendencetable.isNotEmpty
  //                                       ? Text(
  //                                           attendencetable[index].shift.toString(),
  //                                         )
  //                                       : Text('--:-- ',
  //                                           style: TextStyle(
  //                                             fontSize: 16, //25
  //                                             fontWeight: FontWeight.w600,
  //                                             fontFamily: CommonFontStyle.plusJakartaSans,
  //                                           )),
  //                                 ),
  //                               ),
  //                               Flexible(
  //                                 flex: 1,
  //                                 child: Container(
  //                                   // height: 100,
  //                                   width: MediaQuery.of(context).size.height * 0.25,
  //                                   alignment: Alignment.center,
  //                                   child: attendencetable.isNotEmpty
  //                                       ? Text(
  //                                           attendencetable[index].st.toString(),
  //                                         )
  //                                       : Text('--:-- ',
  //                                           style: TextStyle(
  //                                             fontSize: 16, //25
  //                                             fontWeight: FontWeight.w600,
  //                                             fontFamily: CommonFontStyle.plusJakartaSans,
  //                                           )),
  //                                 ),
  //                               ),
  //                               Flexible(
  //                                 flex: 1,
  //                                 child: Container(
  //                                   // height: 100,
  //                                   width: MediaQuery.of(context).size.height * 0.25,
  //                                   alignment: Alignment.center,
  //                                   child: attendencetable.isNotEmpty
  //                                       ? Text(
  //                                           attendencetable[index].lv.toString(),
  //                                         )
  //                                       : Text('--:-- ',
  //                                           style: TextStyle(
  //                                             fontSize: 16, //25
  //                                             fontWeight: FontWeight.w600,
  //                                             fontFamily: CommonFontStyle.plusJakartaSans,
  //                                           )),
  //                                 ),
  //                               ),
  //                             ],
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                     const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
  //                     Container(
  //                       height: MediaQuery.of(context).size.height * 0.15,
  //                       decoration: BoxDecoration(
  //                         color: const Color.fromARGB(255, 223, 239, 241),
  //                         borderRadius: BorderRadius.circular(20),
  //                       ),
  //                       child: Column(
  //                         children: [
  //                           Container(
  //                             padding: const EdgeInsets.all(10),
  //                             // width: double.infinity,
  //                             // height: 45,
  //                             decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColor.primaryColor),
  //                             child: Row(
  //                               // mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                               children: [
  //                                 Flexible(
  //                                   flex: 1,
  //                                   child: Container(
  //                                       // height: 100,
  //                                       width: MediaQuery.of(context).size.height * 0.5,
  //                                       alignment: Alignment.center,
  //                                       child: const Text('LC', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
  //                                 ),
  //                                 Flexible(
  //                                   flex: 1,
  //                                   child: Container(
  //                                       // height: 100,
  //                                       width: MediaQuery.of(context).size.height * 0.5,
  //                                       alignment: Alignment.center,
  //                                       child: const Text('EG', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           Row(
  //                             // mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                             children: [
  //                               Flexible(
  //                                 flex: 1,
  //                                 child: Container(
  //                                   // height: 100,
  //                                   width: MediaQuery.of(context).size.height * 0.5,
  //                                   alignment: Alignment.center,
  //                                   child: attendencetable.isNotEmpty
  //                                       ? Text(
  //                                           attendencetable[index].lc.toString(),
  //                                         )
  //                                       : Text('--:-- ',
  //                                           style: TextStyle(
  //                                             fontSize: 16, //25
  //                                             fontWeight: FontWeight.w600,
  //                                             fontFamily: CommonFontStyle.plusJakartaSans,
  //                                           )),
  //                                 ),
  //                               ),
  //                               Flexible(
  //                                 flex: 1,
  //                                 child: Container(
  //                                   // height: 100,
  //                                   width: MediaQuery.of(context).size.height * 0.5,
  //                                   alignment: Alignment.center,
  //                                   child: attendencetable.isNotEmpty
  //                                       ? Text(
  //                                           attendencetable[index].eg.toString(),
  //                                         )
  //                                       : Text('--:-- ',
  //                                           style: TextStyle(
  //                                             fontSize: 16, //25
  //                                             fontWeight: FontWeight.w600,
  //                                             fontFamily: CommonFontStyle.plusJakartaSans,
  //                                           )),
  //                                 ),
  //                               ),
  //                             ],
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                     const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
  //                     Container(
  //                       height: MediaQuery.of(context).size.height * 0.15,
  //                       decoration: BoxDecoration(
  //                         color: const Color.fromARGB(255, 223, 239, 241),
  //                         borderRadius: BorderRadius.circular(20),
  //                       ),
  //                       child: Column(
  //                         children: [
  //                           Container(
  //                             padding: const EdgeInsets.all(10),
  //                             // width: double.infinity,
  //                             // height: 45,
  //                             decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColor.primaryColor),
  //                             child: Row(
  //                               // mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                               children: [
  //                                 Flexible(
  //                                   flex: 1,
  //                                   child: Container(
  //                                       // height: 100,
  //                                       width: MediaQuery.of(context).size.height * 0.5,
  //                                       alignment: Alignment.center,
  //                                       child: const Text('OT ENT MIN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
  //                                 ),
  //                                 Flexible(
  //                                   flex: 1,
  //                                   child: Container(
  //                                       // height: 100,
  //                                       width: MediaQuery.of(context).size.height * 0.5,
  //                                       alignment: Alignment.center,
  //                                       child: const Text('OT MIN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           Row(
  //                             // mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                             children: [
  //                               Flexible(
  //                                 flex: 1,
  //                                 child: Container(
  //                                   // height: 100,
  //                                   width: MediaQuery.of(context).size.height * 0.5,
  //                                   alignment: Alignment.center,
  //                                   child: attendencetable.isNotEmpty
  //                                       ? Text(
  //                                           attendencetable[index].oTENTMIN.toString(),
  //                                         )
  //                                       : Text('--:-- ',
  //                                           style: TextStyle(
  //                                             fontSize: 16, //25
  //                                             fontWeight: FontWeight.w600,
  //                                             fontFamily: CommonFontStyle.plusJakartaSans,
  //                                           )),
  //                                 ),
  //                               ),
  //                               Flexible(
  //                                 flex: 1,
  //                                 child: Container(
  //                                   // height: 100,
  //                                   width: MediaQuery.of(context).size.height * 0.5,
  //                                   alignment: Alignment.center,
  //                                   child: attendencetable.isNotEmpty
  //                                       ? Text(
  //                                           attendencetable[index].oTMIN.toString(),
  //                                         )
  //                                       : Text('--:-- ',
  //                                           style: TextStyle(
  //                                             fontSize: 16, //25
  //                                             fontWeight: FontWeight.w600,
  //                                             fontFamily: CommonFontStyle.plusJakartaSans,
  //                                           )),
  //                                 ),
  //                               ),

  //                               // Text(attendenceController.attendencetable[index].shift.toString()),
  //                               // Text(attendenceController.attendencetable[index].st.toString()),
  //                               // Text(attendenceController.attendencetable[index].lv.toString()),
  //                             ],
  //                           )
  //                         ],
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             )
  //           : const Padding(
  //               padding: EdgeInsets.all(15),
  //               child: Center(child: Text('No attendance data available')),
  //             );
  //     },
  //   );
  // }

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
