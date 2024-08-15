import 'package:emp_app/app/app_custom_widget/custom_containerview.dart';
import 'package:emp_app/app/app_custom_widget/custom_month_picker.dart';
import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/moduls/attendence/controller/attendence_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final AttendenceController attendenceController =
      Get.put(AttendenceController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      attendenceController.setCurrentMonthYear("SummaryScreen");
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AttendenceController());
    return GetBuilder<AttendenceController>(builder: (controller) {
      return SingleChildScrollView(
        controller: controller.attendanceScrollController,
        child: Column(
          children: [
            MonthSelectionScreen(
              selectedMonthIndex: controller.MonthSel_selIndex.value,
              scrollController: controller.monthScrollControllerSummary,
              onPressed: (index) {
                attendenceController.upd_MonthSelIndex(index);
                attendenceController.showHideMsg();
              },
            ),
            controller.isLoading1.value
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 100),
                    child: Center(child: ProgressWithIcon()),
                  )
                : controller.attSummaryModelTable.data!.isNotEmpty
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: AppColor.lightblue,
                                border:
                                    Border.all(color: AppColor.primaryColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CustomContainerview(
                                          text: 'TOT P',
                                          text1: controller.attSummaryModelTable
                                              .data![0].toTP
                                              .toString()),
                                      CustomContainerview(
                                          text: 'TOT A',
                                          text1: controller.attSummaryModelTable
                                              .data![0].toTA
                                              .toString()),
                                      CustomContainerview(
                                          text: 'TOT DAYS',
                                          text1: controller.attSummaryModelTable
                                              .data![0].toTDAYS
                                              .toString()),
                                      CustomContainerview(
                                          text: 'P',
                                          text1: controller
                                              .attSummaryModelTable.data![0].p
                                              .toString()),
                                      CustomContainerview(
                                          text: 'A',
                                          text1: controller
                                              .attSummaryModelTable.data![0].a
                                              .toString()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: AppColor.lightblue,
                                border:
                                    Border.all(color: AppColor.primaryColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CustomContainerview(
                                            text: 'PL',
                                            text1: controller
                                                .attSummaryModelTable
                                                .data![0]
                                                .pl
                                                .toString()),
                                        CustomContainerview(
                                            text: 'HO',
                                            text1: controller
                                                .attSummaryModelTable
                                                .data![0]
                                                .ho
                                                .toString()),
                                        CustomContainerview(
                                            text: 'SL',
                                            text1: controller
                                                .attSummaryModelTable
                                                .data![0]
                                                .sl
                                                .toString()),
                                        CustomContainerview(
                                            text: 'CL',
                                            text1: controller
                                                .attSummaryModelTable
                                                .data![0]
                                                .cl
                                                .toString()),
                                        CustomContainerview(
                                            text: 'ML',
                                            text1: controller
                                                .attSummaryModelTable
                                                .data![0]
                                                .ml
                                                .toString())
                                      ]),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: AppColor.lightblue,
                                border:
                                    Border.all(color: AppColor.primaryColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CustomContainerview(
                                            text: 'LC/EG CNT',
                                            text1: controller
                                                .attSummaryModelTable
                                                .data![0]
                                                .lCEGCNT
                                                .toString()),
                                        CustomContainerview(
                                            text: 'LC/EG MIN',
                                            text1: controller
                                                .attSummaryModelTable
                                                .data![0]
                                                .lCEGMIN
                                                .toString()),
                                        CustomContainerview(
                                            text: 'WO',
                                            text1: controller
                                                .attSummaryModelTable
                                                .data![0]
                                                .wo
                                                .toString()),
                                        CustomContainerview(
                                            text: 'CO',
                                            text1: controller
                                                .attSummaryModelTable
                                                .data![0]
                                                .co
                                                .toString()),
                                      ]),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: AppColor.lightblue,
                                border:
                                    Border.all(color: AppColor.primaryColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CustomContainerview(
                                          text: 'OT HRS',
                                          text1: controller.attSummaryModelTable
                                              .data![0].cOTHRS
                                              .toString()),
                                      CustomContainerview(
                                          text: 'DUTY HRS',
                                          text1: controller.attSummaryModelTable
                                              .data![0].dutYHRS
                                              .toString()),
                                      CustomContainerview(
                                          text: 'DUTY ST',
                                          text1: controller.attSummaryModelTable
                                              .data![0].dutYST
                                              .toString()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    : const Padding(
                        padding: EdgeInsets.all(15),
                        child:
                            Center(child: Text('No attendance data available')),
                      )
          ],
        ),
      );
    });
  }
}
