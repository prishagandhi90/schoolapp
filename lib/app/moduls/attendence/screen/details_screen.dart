import 'package:emp_app/app/app_custom_widget/custom_botttom_sheet.dart';
import 'package:emp_app/app/app_custom_widget/custom_list_Scrollable.dart';
import 'package:emp_app/app/app_custom_widget/custom_month_picker.dart';
import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/app_custom_widget/emp_att_dtl_extra_data.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/moduls/attendence/controller/attendence_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsScreen extends StatelessWidget {
  DetailsScreen({super.key});
  final AttendenceController attendenceController = Get.put(AttendenceController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendenceController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
            body: SingleChildScrollView(
          child: Column(
            children: [
              MonthSelectionScreen(
                selectedMonthIndex: controller.MonthSel_selIndex.value,
                onPressed: (index) {
                  controller.upd_MonthSelIndex(index);
                  attendenceController.showHideMsg();
                },
              ),
              const SizedBox(height: 20),
              controller.isLoading1.value
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 100),
                      child: Center(child: ProgressWithIcon()),
                    )
                  : Row(children: [
                      (controller.attendencetable.isNotEmpty)
                          ? Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                  child: DataTable(
                                      columnSpacing: Get.width * 0.06,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            const Color.fromRGBO(119, 229, 17, 0.37).withOpacity(0.2),
                                            const Color.fromRGBO(7, 164, 178, 0.582).withOpacity(0.2),
                                          ],
                                        ),
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Text(
                                            'DATE',
                                            style: TextStyle(
                                              fontFamily: CommonFontStyle.plusJakartaSans,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                            label: Text(
                                          'IN',
                                          style: TextStyle(
                                            fontFamily: CommonFontStyle.plusJakartaSans,
                                          ),
                                        )),
                                        DataColumn(
                                            label: Text(
                                          'OUT',
                                          style: TextStyle(
                                            fontFamily: CommonFontStyle.plusJakartaSans,
                                          ),
                                        )),
                                        DataColumn(
                                            label: Text(
                                          'LC/EG \nMIN',
                                          style: TextStyle(
                                            fontFamily: CommonFontStyle.plusJakartaSans,
                                          ),
                                        )),
                                        DataColumn(
                                            label: Text(
                                          '',
                                          style: TextStyle(
                                            fontFamily: CommonFontStyle.plusJakartaSans,
                                          ),
                                        )),
                                      ],
                                      rows: List.generate(
                                          controller.attendencetable.length,
                                          (index) => DataRow(cells: [
                                                DataCell(
                                                  Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                      color: const Color.fromARGB(255, 199, 199, 199),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          controller.attendencetable[index].atTDATE.toString(),
                                                          style: TextStyle(
                                                            fontFamily: CommonFontStyle.plusJakartaSans,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                DataCell(Text(
                                                  controller.attendencetable[index].iN.toString(),
                                                  style: TextStyle(
                                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                                  ),
                                                )),
                                                DataCell(Text(
                                                  controller.attendencetable[index].out.toString(),
                                                  style: TextStyle(
                                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                                  ),
                                                )),
                                                DataCell(Text(
                                                  controller.attendencetable[index].lCEGMIN.toString(),
                                                  style: TextStyle(
                                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                                  ),
                                                )),
                                                DataCell(IconButton(
                                                  icon: const Icon(Icons.arrow_drop_down_circle),
                                                  onPressed: () {
                                                    detailbottomsheet(context, index);
                                                    //   // controller.detailbottomsheet(context);
                                                    //   // Get.to(
                                                    //   // EmpAttDtlExtraData(
                                                    //   //   punch: controller.attendencetable[index].punch!,
                                                    //   //   shift: controller.attendencetable[index].shift!,
                                                    //   //   lv: controller.attendencetable[index].lv!,
                                                    //   //   st: controller.attendencetable[index].st!,
                                                    //   //   oTENTMIN: controller.attendencetable[index].oTENTMIN!,
                                                    //   //   oTMIN: controller.attendencetable[index].oTMIN!,
                                                    //   //   lc: controller.attendencetable[index].lc!,
                                                    //   //   eg: controller.attendencetable[index].eg!,
                                                    //   // ),
                                                    //   // );
                                                  },
                                                )),
                                              ]))),
                                ),
                            ),
                          )
                          : Padding(
                              padding: EdgeInsets.all(15),
                              child: Center(child: Text('No attendance data available',
                                        style: TextStyle(
                                          fontFamily: CommonFontStyle.plusJakartaSans,
                                        ),)),
                            )
                      // if (attendenceController.scrollableColRowBuilderattprsnt().isNotEmpty)
                      //   ScrollableColumnWidget(
                      //     columns: const [
                      //       DataColumn(label: Text('TTL \nDAYS')),
                      //       DataColumn(label: Text('PRSNT')),
                      //       DataColumn(label: Text('AB')),
                      //       DataColumn(label: Text('WO')),
                      //       // DataColumn(label: Text('CO')),
                      //       // DataColumn(label: Text('PL')),
                      //       // DataColumn(label: Text('SL')),
                      //       // DataColumn(label: Text('CL')),
                      //       // DataColumn(label: Text('HO')),
                      //       // DataColumn(label: Text('ML')),
                      //       // DataColumn(label: Text('CH')),
                      //       // DataColumn(label: Text('LC/EG \nMIN')),
                      //       // DataColumn(label: Text('LC/EG \nCNT')),
                      //       // DataColumn(label: Text('N TO \nHRS')),
                      //       // DataColumn(label: Text('C TO \nHRS')),
                      //       // DataColumn(label: Text('TTL OF \nHRS')),
                      //       // DataColumn(label: Text('DUTY \nHRS')),
                      //       // DataColumn(label: Text('DUTY \nST')),
                      //     ],
                      //     rowBuilder: attendenceController.scrollableColRowBuilderattprsnt,
                      //     headingRowColor: const WidgetStatePropertyAll(Color.fromARGB(255, 182, 235, 214)),
                      //   ),
                    ]),
            ],
          ),
        ));
      },
    );
  }

  Future<void> detailbottomsheet(BuildContext context, int index) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      constraints: const BoxConstraints(maxWidth: 380),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: const BorderSide(color: Colors.black),
      ),
      builder: (context) {
        return attendenceController.attpresenttable.isNotEmpty
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(139, 194, 218, 221),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  const Color.fromRGBO(119, 229, 17, 0.37).withOpacity(0.2),
                                  const Color.fromRGBO(7, 164, 178, 0.582).withOpacity(0.2),
                                ],
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'PUNCH',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                  )),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(split_go_leftRight(attendenceController.attendencetable[index].punch.toString(), 'left')),
                              Text(split_go_leftRight(attendenceController.attendencetable[index].punch.toString(), 'right')),
                            ],
                          )
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(211, 240, 243, 0.58),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            // width: double.infinity,
                            // height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  const Color.fromRGBO(119, 229, 17, 0.37).withOpacity(0.2),
                                  const Color.fromRGBO(7, 164, 178, 0.582).withOpacity(0.2),
                                ],
                              ),
                            ),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Container(
                                      // height: 100,
                                      width: MediaQuery.of(context).size.height * 0.5,
                                      alignment: Alignment.center,
                                      child: const Text('SHIFT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                      // height: 100,
                                      width: MediaQuery.of(context).size.height * 0.25,
                                      alignment: Alignment.center,
                                      child: const Text('ST', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                      // height: 100,
                                      width: MediaQuery.of(context).size.height * 0.25,
                                      alignment: Alignment.center,
                                      child: const Text('LV', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
                                ),
                                // Flexible(
                                //   flex: 3,
                                //   child: Text('SHIFT', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                                // ),
                                // Flexible(
                                //   flex: 1,
                                //   child: Padding(
                                //       padding: EdgeInsets.symmetric(horizontal: 4.0),
                                //       child: Text('ST', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500))),
                                // ),
                                // Flexible(
                                //   flex: 1,
                                //   child: Padding(
                                //       padding: EdgeInsets.symmetric(horizontal: 4.0),
                                //       child: Text('LV', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500))),
                                // ),
                                // Text('ST', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                                // Text('LV', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                flex: 3,
                                child: Container(
                                    // height: 100,
                                    width: MediaQuery.of(context).size.height * 0.5,
                                    alignment: Alignment.center,
                                    child: Text(attendenceController.attendencetable[index].shift.toString())),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                    // height: 100,
                                    width: MediaQuery.of(context).size.height * 0.25,
                                    alignment: Alignment.center,
                                    child: Text(attendenceController.attendencetable[index].st.toString())),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                    // height: 100,
                                    width: MediaQuery.of(context).size.height * 0.25,
                                    alignment: Alignment.center,
                                    child: Text(attendenceController.attendencetable[index].lv.toString())),
                              ),
                              // Text(attendenceController.attendencetable[index].shift.toString()),
                              // Text(attendenceController.attendencetable[index].st.toString()),
                              // Text(attendenceController.attendencetable[index].lv.toString()),
                            ],
                          )
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(211, 240, 243, 0.58),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            // width: double.infinity,
                            // height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  const Color.fromRGBO(119, 229, 17, 0.37).withOpacity(0.2),
                                  const Color.fromRGBO(7, 164, 178, 0.582).withOpacity(0.2),
                                ],
                              ),
                            ),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                      // height: 100,
                                      width: MediaQuery.of(context).size.height * 0.5,
                                      alignment: Alignment.center,
                                      child: const Text('LC', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                      // height: 100,
                                      width: MediaQuery.of(context).size.height * 0.5,
                                      alignment: Alignment.center,
                                      child: const Text('EG', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
                                ),

                                // Flexible(
                                //   flex: 3,
                                //   child: Text('SHIFT', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                                // ),
                                // Flexible(
                                //   flex: 1,
                                //   child: Padding(
                                //       padding: EdgeInsets.symmetric(horizontal: 4.0),
                                //       child: Text('ST', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500))),
                                // ),
                                // Flexible(
                                //   flex: 1,
                                //   child: Padding(
                                //       padding: EdgeInsets.symmetric(horizontal: 4.0),
                                //       child: Text('LV', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500))),
                                // ),
                                // Text('ST', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                                // Text('LV', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Container(
                                    // height: 100,
                                    width: MediaQuery.of(context).size.height * 0.5,
                                    alignment: Alignment.center,
                                    child: Text(attendenceController.attendencetable[index].lc.toString())),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                    // height: 100,
                                    width: MediaQuery.of(context).size.height * 0.5,
                                    alignment: Alignment.center,
                                    child: Text(attendenceController.attendencetable[index].eg.toString())),
                              ),

                              // Text(attendenceController.attendencetable[index].shift.toString()),
                              // Text(attendenceController.attendencetable[index].st.toString()),
                              // Text(attendenceController.attendencetable[index].lv.toString()),
                            ],
                          )
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(211, 240, 243, 0.58),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            // width: double.infinity,
                            // height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  const Color.fromRGBO(119, 229, 17, 0.37).withOpacity(0.2),
                                  const Color.fromRGBO(7, 164, 178, 0.582).withOpacity(0.2),
                                ],
                              ),
                            ),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                      // height: 100,
                                      width: MediaQuery.of(context).size.height * 0.5,
                                      alignment: Alignment.center,
                                      child: const Text('OT ENT MIN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                      // height: 100,
                                      width: MediaQuery.of(context).size.height * 0.5,
                                      alignment: Alignment.center,
                                      child: const Text('OT MIN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
                                ),

                                // Flexible(
                                //   flex: 3,
                                //   child: Text('SHIFT', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                                // ),
                                // Flexible(
                                //   flex: 1,
                                //   child: Padding(
                                //       padding: EdgeInsets.symmetric(horizontal: 4.0),
                                //       child: Text('ST', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500))),
                                // ),
                                // Flexible(
                                //   flex: 1,
                                //   child: Padding(
                                //       padding: EdgeInsets.symmetric(horizontal: 4.0),
                                //       child: Text('LV', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500))),
                                // ),
                                // Text('ST', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                                // Text('LV', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Container(
                                    // height: 100,
                                    width: MediaQuery.of(context).size.height * 0.5,
                                    alignment: Alignment.center,
                                    child: Text(attendenceController.attendencetable[index].oTENTMIN.toString())),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                    // height: 100,
                                    width: MediaQuery.of(context).size.height * 0.5,
                                    alignment: Alignment.center,
                                    child: Text(attendenceController.attendencetable[index].oTMIN.toString())),
                              ),

                              // Text(attendenceController.attendencetable[index].shift.toString()),
                              // Text(attendenceController.attendencetable[index].st.toString()),
                              // Text(attendenceController.attendencetable[index].lv.toString()),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            : const Padding(
                padding: EdgeInsets.all(15),
                child: Center(child: Text('No attendance data available')),
              );
      },
    );
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
