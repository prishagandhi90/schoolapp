import 'package:emp_app/app/app_custom_widget/custom_month_picker.dart';
import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/moduls/attendence/controller/attendence_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final AttendenceController attendenceController = Get.put(AttendenceController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      attendenceController.setCurrentMonthYear("DetailScreen");
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendenceController>(
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColor.white,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                controller: controller.attendanceScrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MonthSelectionScreen(
                      selectedMonthIndex: controller.MonthSel_selIndex.value,
                      scrollController: controller.monthScrollControllerDetail,
                      onPressed: (index) {
                        controller.upd_MonthSelIndex(index);
                        controller.showHideMsg();
                      },
                    ),
                    const SizedBox(height: 20),
                    controller.isLoading1.value
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 100),
                              child: ProgressWithIcon(),
                            ),
                          )
                        : controller.attendenceDetailTable.length > 0
                            ? SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: constraints.maxWidth,
                                  ),
                                  child: DataTable(
                                    headingRowColor: WidgetStateColor.resolveWith(
                                      (states) => const Color.fromARGB(255, 94, 157, 168),
                                    ),
                                    columnSpacing: constraints.maxWidth * 0.05,
                                    columns: [
                                      DataColumn(
                                        label: Text(
                                          AppString.date,
                                          style: AppStyle.fontfamilyplus,
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          AppString.iN,
                                          style: AppStyle.fontfamilyplus,
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          AppString.out,
                                          style: AppStyle.fontfamilyplus,
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          AppString.lcegmin,
                                          style: AppStyle.fontfamilyplus,
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          '',
                                          style: AppStyle.fontfamilyplus,
                                        ),
                                      ),
                                    ],
                                    rows: List.generate(
                                      controller.attendenceDetailTable.length,
                                      (index) => DataRow(
                                        cells: [
                                          DataCell(
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: AppColor.lightgrey,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  controller.attendenceDetailTable[index].atTDATE.toString(),
                                                  style: AppStyle.fontfamilyplus,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(Text(
                                            controller.attendenceDetailTable[index].iN.toString(),
                                            style: AppStyle.fontfamilyplus,
                                          )),
                                          DataCell(Text(
                                            controller.attendenceDetailTable[index].out.toString(),
                                            style: AppStyle.fontfamilyplus,
                                          )),
                                          DataCell(Text(
                                            controller.attendenceDetailTable[index].lCEGMIN.toString(),
                                            style: AppStyle.fontfamilyplus,
                                          )),
                                          DataCell(
                                            GestureDetector(
                                              onTap: () {
                                                detailbottomsheet(context, index);
                                              },
                                              child: const Icon(Icons.arrow_drop_down_circle),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(15),
                                child: Center(
                                  child: Text(
                                    AppString.noattendencedata,
                                    style: AppStyle.fontfamilyplus,
                                  ),
                                ),
                              ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> detailbottomsheet(BuildContext context, int index) async {
    showModalBottomSheet(
        backgroundColor: AppColor.white,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        // context: context,
        context: Get.context!,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.95,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: AppColor.black),
        ),
        builder: (context) {
          return GetBuilder<AttendenceController>(
            builder: (controller) {
              return controller.attendenceDetailTable.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const SizedBox(width: 30),
                              const Spacer(),
                              Container(
                                width: 90,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                                child: Divider(height: 20, color: AppColor.originalgrey, thickness: 5),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(Icons.cancel),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                              color: AppColor.lightblue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  width: double.infinity,
                                  height: 45,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColor.primaryColor),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          AppString.punch,
                                          style: AppStyle.w50018,
                                        )),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    controller.attendenceDetailTable.length > 0
                                        ? Text(
                                            split_go_leftRight(controller.attendenceDetailTable[index].punch.toString(), 'left'),
                                          )
                                        : Text('--:-- ', style: AppStyle.plus16w600),
                                    controller.attendenceDetailTable.length > 0
                                        ? Text(
                                            split_go_leftRight(controller.attendenceDetailTable[index].punch.toString(), 'right'),
                                          )
                                        : Text('--:-- ', style: AppStyle.plus16w600),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                              color: AppColor.lightblue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColor.primaryColor),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: Container(
                                            width: MediaQuery.of(context).size.height * 0.5,
                                            alignment: Alignment.center,
                                            child: Text(AppString.shift, style: AppStyle.w50018)),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                            width: MediaQuery.of(context).size.height * 0.25,
                                            alignment: Alignment.center,
                                            child: Text(AppString.st, style: AppStyle.w50018)),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                            width: MediaQuery.of(context).size.height * 0.25,
                                            alignment: Alignment.center,
                                            child: Text(AppString.lv, style: AppStyle.w50018)),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Container(
                                        // height: 100,
                                        width: MediaQuery.of(context).size.height * 0.5,
                                        alignment: Alignment.center,
                                        child: controller.attendenceDetailTable.length > 0
                                            ? Text(
                                                controller.attendenceDetailTable[index].shift.toString(),
                                              )
                                            : Text('--:-- ', style: AppStyle.plus16w600),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        // height: 100,
                                        width: MediaQuery.of(context).size.height * 0.25,
                                        alignment: Alignment.center,
                                        child: controller.attendenceDetailTable.length > 0
                                            ? Text(
                                                controller.attendenceDetailTable[index].st.toString(),
                                              )
                                            : Text('--:-- ', style: AppStyle.plus16w600),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        // height: 100,
                                        width: MediaQuery.of(context).size.height * 0.25,
                                        alignment: Alignment.center,
                                        child: controller.attendenceDetailTable.length > 0
                                            ? Text(
                                                controller.attendenceDetailTable[index].lv.toString(),
                                              )
                                            : Text('--:-- ', style: AppStyle.plus16w600),
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
                              color: AppColor.lightblue,
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
                                            child: Text(AppString.lc, style: AppStyle.w50018)),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                            // height: 100,
                                            width: MediaQuery.of(context).size.height * 0.5,
                                            alignment: Alignment.center,
                                            child: Text(AppString.eg, style: AppStyle.w50018)),
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
                                        child: controller.attendenceDetailTable.length > 0
                                            ? Text(
                                                controller.attendenceDetailTable[index].lc.toString(),
                                              )
                                            : Text('--:-- ', style: AppStyle.plus16w600),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        // height: 100,
                                        width: MediaQuery.of(context).size.height * 0.5,
                                        alignment: Alignment.center,
                                        child: controller.attendenceDetailTable.length > 0
                                            ? Text(
                                                controller.attendenceDetailTable[index].eg.toString(),
                                              )
                                            : Text('--:-- ', style: AppStyle.plus16w600),
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
                              color: AppColor.lightblue,
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
                                            child: Text(AppString.otentmin, style: AppStyle.w50018)),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                            // height: 100,
                                            width: MediaQuery.of(context).size.height * 0.5,
                                            alignment: Alignment.center,
                                            child: Text(AppString.otmin, style: AppStyle.w50018)),
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
                                        child: controller.attendenceDetailTable.length > 0
                                            ? Text(
                                                controller.attendenceDetailTable[index].oTENTMIN.toString(),
                                              )
                                            : Text('--:-- ', style: AppStyle.plus16w600),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        // height: 100,
                                        width: MediaQuery.of(context).size.height * 0.5,
                                        alignment: Alignment.center,
                                        child: controller.attendenceDetailTable.length > 0
                                            ? Text(
                                                controller.attendenceDetailTable[index].oTMIN.toString(),
                                              )
                                            : Text('--:-- ', style: AppStyle.plus16w600),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.all(15),
                      child: Center(child: Text(AppString.noattendencedata)),
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
