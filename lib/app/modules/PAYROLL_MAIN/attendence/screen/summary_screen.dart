import 'package:schoolapp/app/app_custom_widget/custom_containerview.dart';
import 'package:schoolapp/app/app_custom_widget/custom_progressloader.dart';
import 'package:schoolapp/app/app_custom_widget/monthpick.dart';
import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/app_string.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/attendence/controller/attendence_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SummaryScreen extends GetView<AttendenceController> {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AttendenceController());
    return GetBuilder<AttendenceController>(builder: (controller) {
      return SingleChildScrollView(
        controller: controller.attendanceScrollController,
        child: Column(
          children: [
            // Month Picker widget for month selection
            MonthPicker(
              controller: controller,
              scrollController: controller.monthScrollControllerSummary,
              // onPressed: (index) {
              //   controller.upd_MonthSelIndex(index);
              //   controller.showHideMsg();
              // },
            ),
            // Agar loader true hai toh loading spinner dikhayega
            controller.isLoader.value
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: getDynamicHeight(size: 0.102)), //100),
                    child: Center(child: ProgressWithIcon()),
                  )
                // Agar attendance data available hai
                : controller.attendenceSummaryTable.isNotEmpty
                    ? Column(
                        children: [
                          // First Row: Total Present, Absent, Total Days, P, A
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: AppColor.lightblue,
                                border: Border.all(color: AppColor.primaryColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CustomContainerview(text: 'TOT P', text1: controller.attendenceSummaryTable[0].toTP.toString()),
                                      CustomContainerview(text: 'TOT A', text1: controller.attendenceSummaryTable[0].toTA.toString()),
                                      CustomContainerview(text: 'TOT DAYS', text1: controller.attendenceSummaryTable[0].toTDAYS.toString()),
                                      CustomContainerview(text: 'P', text1: controller.attendenceSummaryTable[0].p.toString()),
                                      CustomContainerview(text: 'A', text1: controller.attendenceSummaryTable[0].a.toString()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Second Row: PL, HO, SL, CL, ML
                          Padding(
                            padding: EdgeInsets.all(getDynamicHeight(size: 0.017)), //15),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: getDynamicHeight(size: 0.017)), //15),
                              decoration: BoxDecoration(
                                color: AppColor.lightblue,
                                border: Border.all(color: AppColor.primaryColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                    CustomContainerview(text: 'PL', text1: controller.attendenceSummaryTable[0].pl.toString()),
                                    CustomContainerview(text: 'HO', text1: controller.attendenceSummaryTable[0].ho.toString()),
                                    CustomContainerview(text: 'SL', text1: controller.attendenceSummaryTable[0].sl.toString()),
                                    CustomContainerview(text: 'CL', text1: controller.attendenceSummaryTable[0].cl.toString()),
                                    CustomContainerview(text: 'ML', text1: controller.attendenceSummaryTable[0].ml.toString())
                                  ]),
                                ],
                              ),
                            ),
                          ),
                          // Third Row: LC/EG CNT, LC/EG MIN, WO, CO
                          Padding(
                            padding: EdgeInsets.all(getDynamicHeight(size: 0.015)), //15),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: getDynamicHeight(size: 0.017)), //15),
                              decoration: BoxDecoration(
                                color: AppColor.lightblue,
                                border: Border.all(color: AppColor.primaryColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                    CustomContainerview(text: 'LC/EG CNT', text1: controller.attendenceSummaryTable[0].lCEGCNT.toString()),
                                    CustomContainerview(text: 'LC/EG MIN', text1: controller.attendenceSummaryTable[0].lCEGMIN.toString()),
                                    CustomContainerview(text: 'WO', text1: controller.attendenceSummaryTable[0].wo.toString()),
                                    CustomContainerview(text: 'CO', text1: controller.attendenceSummaryTable[0].co.toString()),
                                  ]),
                                ],
                              ),
                            ),
                          ),
                          // Fourth Row: OT HRS, DUTY HRS, DUTY ST
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: AppColor.lightblue,
                                border: Border.all(color: AppColor.primaryColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CustomContainerview(text: 'OT HRS', text1: controller.attendenceSummaryTable[0].ttLOTHRS.toString()),
                                      CustomContainerview(text: 'DUTY HRS', text1: controller.attendenceSummaryTable[0].dutYHRS.toString()),
                                      CustomContainerview(text: 'DUTY ST', text1: controller.attendenceSummaryTable[0].dutYST.toString()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    // Agar data empty hai toh message show karega
                    : Padding(
                        padding: EdgeInsets.all(getDynamicHeight(size: 0.01)),
                        child: Center(child: Text(AppString.nodataavailable)),
                      ),
          ],
        ),
      );
    });
  }
}
