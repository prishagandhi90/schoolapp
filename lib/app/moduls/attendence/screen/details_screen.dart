import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/app_custom_widget/monthpick.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/attendence/controller/attendence_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsScreen extends GetView<AttendenceController> {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AttendenceController());
    return GetBuilder<AttendenceController>(
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColor.white,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // MonthPicker widget jo month select karne ke liye use hota hai
                  MonthPicker(
                    controller: controller,
                    scrollController: controller.monthScrollControllerDetail,
                  ),
                  SizedBox(height: getDynamicHeight(size: 0.020)), //10),
                  Expanded(
                    child: controller.isLoader.value
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: getDynamicHeight(size: 0.10)),
                              child: ProgressWithIcon(), // Loading indicator jab data load ho raha ho
                            ),
                          )
                        : controller.attendenceDetailTable.isNotEmpty
                            ? SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: constraints.maxWidth,
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        color: AppColor.primaryColor,
                                        child: Row(
                                          children: [
                                            buildHeaderCell(AppString.date, constraints.maxWidth * 0.2),
                                            buildHeaderCell(AppString.iN, constraints.maxWidth * 0.2),
                                            buildHeaderCell(AppString.out, constraints.maxWidth * 0.2),
                                            buildHeaderCell(AppString.lcegmin, constraints.maxWidth * 0.2),
                                            buildHeaderCell('', constraints.maxWidth * 0.2),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: RefreshIndicator(
                                          onRefresh: () async {
                                            await await controller.getattendeceinfotable(); // Refresh karne par data fetch karna
                                          },
                                          child: SingleChildScrollView(
                                            controller: controller.attendanceScrollController,
                                            physics: const AlwaysScrollableScrollPhysics(),
                                            child: Table(
                                              columnWidths: {
                                                0: FixedColumnWidth(constraints.maxWidth * 0.15),
                                                1: FixedColumnWidth(constraints.maxWidth * 0.22),
                                                2: FixedColumnWidth(constraints.maxWidth * 0.22),
                                                3: FixedColumnWidth(constraints.maxWidth * 0.2),
                                                4: FixedColumnWidth(constraints.maxWidth * 0.2),
                                              },
                                              // Table ke rows generate karna
                                              children: List.generate(
                                                controller.attendenceDetailTable.length,
                                                (index) => TableRow(
                                                  children: [
                                                    buildCell(
                                                      Container(
                                                        height: getDynamicHeight(size: 0.042), //40,
                                                        width: getDynamicHeight(size: 0.032), //30, // Width ko kam kiya gaya hai
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
                                                    buildCell(
                                                      Text(
                                                        controller.attendenceDetailTable[index].iN.toString(),
                                                        style: AppStyle.fontfamilyplus.copyWith(
                                                          color: controller.attendenceDetailTable[index].redYNINTM == 'Y'
                                                              ? AppColor.red
                                                              : AppColor.black,
                                                        ),
                                                      ),
                                                    ),
                                                    buildCell(
                                                      Text(
                                                        controller.attendenceDetailTable[index].out.toString(),
                                                        style: AppStyle.fontfamilyplus.copyWith(
                                                          color: controller.attendenceDetailTable[index].redYNOUTTM == 'Y'
                                                              ? AppColor.red
                                                              : AppColor.black, // redYNOUTTM se color set kiya
                                                        ),
                                                      ),
                                                    ),
                                                    buildCell(
                                                      Text(
                                                        controller.attendenceDetailTable[index].lCEGMIN.toString(),
                                                        textAlign: TextAlign.center,
                                                        style: AppStyle.fontfamilyplus.copyWith(
                                                          color: controller.attendenceDetailTable[index].redYNLCEGMIN == 'Y'
                                                              ? AppColor.red
                                                              : AppColor.black, // redYNLCEGMIN se color set kiya
                                                        ),
                                                      ),
                                                    ),
                                                    buildCell(
                                                      GestureDetector(
                                                        onTap: () {
                                                          detailbottomsheet(context, index);
                                                        },
                                                        child: const Icon(
                                                            Icons.arrow_drop_down_circle), // Arrow icon to open details bottom sheet
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            // Agar attendance data empty ho
                            : Padding(
                                padding: EdgeInsets.all(getDynamicHeight(size: 0.017)), //15,
                                child: Center(
                                  child: Text(
                                    AppString.noattendencedata,
                                    style: AppStyle.fontfamilyplus,
                                  ),
                                ),
                              ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget buildHeaderCell(String text, double width) {
    return Container(
      width: width,
      padding: EdgeInsets.all(getDynamicHeight(size: 0.010)), //8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppStyle.fontfamilyplus.copyWith(
          color: AppColor.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildCell(Widget child) {
    return Container(
      padding: EdgeInsets.all(getDynamicHeight(size: 0.010)), //8),
      child: child,
    );
  }

  Future<void> detailbottomsheet(BuildContext context, int index) async {
    showModalBottomSheet(
        backgroundColor: AppColor.white,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        context: Get.context!,
        constraints: BoxConstraints(
          maxWidth: getDynamicHeight(size: 0.9),
          //  MediaQuery.of(context).size.width * 0.95,
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
                          SizedBox(height: getDynamicHeight(size: 0.010)), //10),
                          Row(
                            children: [
                              SizedBox(width: getDynamicHeight(size: 0.032)), //30),
                              const Spacer(),
                              Container(
                                width: getDynamicHeight(size: 0.092), //90,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                                child: Divider(height: getDynamicHeight(size: 0.020), color: AppColor.originalgrey, thickness: 5),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(Icons.close),
                              ),
                              SizedBox(
                                width: getDynamicHeight(size: 0.032), //30,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            // height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                              color: AppColor.lightblue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  width: double.infinity,
                                  height: getDynamicHeight(size: 0.045), //40,
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      controller.attendenceDetailTable.length > 0
                                          ? Text(
                                              controller.attendenceDetailTable[index].punch.toString(),
                                              style: AppStyle.fontfamilyplus,
                                            )
                                          : Text('--:-- ', style: AppStyle.plus16w600),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                          // Shift, ST, LV Section
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
                                                style: AppStyle.fontfamilyplus,
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
                                                style: AppStyle.fontfamilyplus,
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
                                                style: AppStyle.fontfamilyplus,
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
                          // LC, EG Section
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
                                                style: AppStyle.fontfamilyplus,
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
                                                style: AppStyle.fontfamilyplus,
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
                          // OTENTMIN and OTMIN Section
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
                                                style: AppStyle.fontfamilyplus,
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
                                                style: AppStyle.fontfamilyplus,
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
}
