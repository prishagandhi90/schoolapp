import 'package:emp_app/app/app_custom_widget/custom_month_picker.dart';
import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/moduls/attendence/controller/attendence_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AttendenceController controller = Get.put(AttendenceController());

    return GetBuilder<AttendenceController>(
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            controller: controller.attendanceScrollController, // Assign the ScrollController here
            child: Column(
              children: [
                MonthSelectionScreen(
                  selectedMonthIndex: controller.MonthSel_selIndex.value,
                  onPressed: (index) {
                    controller.upd_MonthSelIndex(index);
                    controller.showHideMsg();
                  },
                ),
                const SizedBox(height: 20),
                controller.isLoading1.value
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 100),
                        child: Center(child: ProgressWithIcon()),
                      )
                    : Row(
                        children: [
                          (controller.attendencetable.isNotEmpty)
                              ? Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SingleChildScrollView(
                                      // controller: controller.attendanceScrollController, // Assign the ScrollController here
                                      child: DataTable(
                                        headingRowColor: MaterialStateColor.resolveWith(
                                          (states) => const Color.fromARGB(255, 94, 157, 168),
                                        ),
                                        columnSpacing: Get.width * 0.06,
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
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'OUT',
                                              style: TextStyle(
                                                fontFamily: CommonFontStyle.plusJakartaSans,
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'LC/EG \nMIN',
                                              style: TextStyle(
                                                fontFamily: CommonFontStyle.plusJakartaSans,
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              '',
                                              style: TextStyle(
                                                fontFamily: CommonFontStyle.plusJakartaSans,
                                              ),
                                            ),
                                          ),
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
                                                  DataCell(
                                                    GestureDetector(
                                                      onTap: () {
                                                        detailbottomsheet(context, index);
                                                      },
                                                      child: Container(
                                                        child: const Icon(Icons.arrow_drop_down_circle),
                                                      ),
                                                    ),
                                                  ),
                                                ])),
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Center(
                                    child: Text(
                                      'No attendance data available',
                                      style: TextStyle(
                                        fontFamily: CommonFontStyle.plusJakartaSans,
                                      ),
                                    ),
                                  ),
                                )
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> detailbottomsheet(BuildContext context, int index) async {
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        // context: context,
        context: Get.context!,
        constraints: const BoxConstraints(maxWidth: 380),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(color: Colors.black),
        ),
        builder: (context) {
          return GetBuilder<AttendenceController>(
            builder: (controller) {
              return controller.attpresenttable.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 223, 239, 241),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    //  Divider(
                                    //   thickness: 20,
                                    //   color: AppColor.black,
                                    // ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Icon(Icons.cancel),
                                    )
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  width: double.infinity,
                                  height: 45,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColor.primaryColor),
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
                                    controller.attendencetable.isNotEmpty
                                        ? Text(
                                            split_go_leftRight(controller.attendencetable[index].punch.toString(), 'left'),
                                          )
                                        : Text('--:-- ',
                                            style: TextStyle(
                                              fontSize: 16, //25
                                              fontWeight: FontWeight.w600,
                                              fontFamily: CommonFontStyle.plusJakartaSans,
                                            )),
                                    controller.attendencetable.isNotEmpty
                                        ? Text(
                                            split_go_leftRight(controller.attendencetable[index].punch.toString(), 'right'),
                                          )
                                        : Text('--:-- ',
                                            style: TextStyle(
                                              fontSize: 16, //25
                                              fontWeight: FontWeight.w600,
                                              fontFamily: CommonFontStyle.plusJakartaSans,
                                            )),
                                    // if (attendenceController.attendencetable.isNotEmpty)
                                    //   Text(
                                    //     split_go_leftRight(attendenceController.attendencetable[index].punch.toString(), 'left'),
                                    //   )
                                    // else
                                    //   Text('--:-- ',
                                    //       style: TextStyle(
                                    //         fontSize: 16, //25
                                    //         fontWeight: FontWeight.w600,
                                    //         fontFamily: CommonFontStyle.plusJakartaSans,
                                    //       )),
                                    // if (attendenceController.attendencetable.isNotEmpty)
                                    //   Text(split_go_leftRight(attendenceController.attendencetable[index].punch.toString(), 'right'))
                                    // else
                                    //   Text('--:-- ',
                                    //       style: TextStyle(
                                    //         fontSize: 16, //25
                                    //         fontWeight: FontWeight.w600,
                                    //         fontFamily: CommonFontStyle.plusJakartaSans,
                                    //       )),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 223, 239, 241),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColor.primaryColor),
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: Container(
                                            width: MediaQuery.of(context).size.height * 0.5,
                                            alignment: Alignment.center,
                                            child: const Text('SHIFT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                            width: MediaQuery.of(context).size.height * 0.25,
                                            alignment: Alignment.center,
                                            child: const Text('ST', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                            width: MediaQuery.of(context).size.height * 0.25,
                                            alignment: Alignment.center,
                                            child: const Text('LV', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
                                      ),
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
                                        child: controller.attendencetable.isNotEmpty
                                            ? Text(
                                                controller.attendencetable[index].shift.toString(),
                                              )
                                            : Text('--:-- ',
                                                style: TextStyle(
                                                  fontSize: 16, //25
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                                )),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        // height: 100,
                                        width: MediaQuery.of(context).size.height * 0.25,
                                        alignment: Alignment.center,
                                        child: controller.attendencetable.isNotEmpty
                                            ? Text(
                                                controller.attendencetable[index].st.toString(),
                                              )
                                            : Text('--:-- ',
                                                style: TextStyle(
                                                  fontSize: 16, //25
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                                )),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        // height: 100,
                                        width: MediaQuery.of(context).size.height * 0.25,
                                        alignment: Alignment.center,
                                        child: controller.attendencetable.isNotEmpty
                                            ? Text(
                                                controller.attendencetable[index].lv.toString(),
                                              )
                                            : Text('--:-- ',
                                                style: TextStyle(
                                                  fontSize: 16, //25
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                                )),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 223, 239, 241),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  // width: double.infinity,
                                  // height: 45,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColor.primaryColor),
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
                                        child: controller.attendencetable.isNotEmpty
                                            ? Text(
                                                controller.attendencetable[index].lc.toString(),
                                              )
                                            : Text('--:-- ',
                                                style: TextStyle(
                                                  fontSize: 16, //25
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                                )),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        // height: 100,
                                        width: MediaQuery.of(context).size.height * 0.5,
                                        alignment: Alignment.center,
                                        child: controller.attendencetable.isNotEmpty
                                            ? Text(
                                                controller.attendencetable[index].eg.toString(),
                                              )
                                            : Text('--:-- ',
                                                style: TextStyle(
                                                  fontSize: 16, //25
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                                )),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 223, 239, 241),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  // width: double.infinity,
                                  // height: 45,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColor.primaryColor),
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
                                        child: controller.attendencetable.isNotEmpty
                                            ? Text(
                                                controller.attendencetable[index].oTENTMIN.toString(),
                                              )
                                            : Text('--:-- ',
                                                style: TextStyle(
                                                  fontSize: 16, //25
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                                )),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        // height: 100,
                                        width: MediaQuery.of(context).size.height * 0.5,
                                        alignment: Alignment.center,
                                        child: controller.attendencetable.isNotEmpty
                                            ? Text(
                                                controller.attendencetable[index].oTMIN.toString(),
                                              )
                                            : Text('--:-- ',
                                                style: TextStyle(
                                                  fontSize: 16, //25
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                                )),
                                      ),
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
        });
  }

  String split_go_leftRight(String string1, String flag) {
    if (string1 == "") return '';

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
