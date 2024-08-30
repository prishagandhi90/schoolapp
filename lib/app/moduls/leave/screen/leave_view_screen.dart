import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveViewScreen extends StatelessWidget {
  const LeaveViewScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    Get.put(LeaveController());
    return GetBuilder<LeaveController>(
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColor.white,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    controller.isLoading.value
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 100),
                              child: ProgressWithIcon(),
                            ),
                          )
                        : controller.leaveentryList.length > 0
                            ? SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: constraints.maxWidth,
                                  ),
                                  child: DataTable(
                                    headingRowColor: WidgetStateColor.resolveWith(
                                      (states) => AppColor.primaryColor,
                                    ),
                                    columnSpacing: constraints.maxWidth * 0.05,
                                    columns: [
                                      DataColumn(
                                        label: Text(
                                          AppString.from,
                                          style: AppStyle.fontfamilyplus,
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          AppString.to,
                                          style: AppStyle.fontfamilyplus,
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          AppString.days,
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
                                      controller.leaveentryList.length,
                                      (index) => DataRow(
                                        cells: [
                                          DataCell(Text(
                                            controller.leaveentryList[index].fromDate.toString(),
                                            style: AppStyle.fontfamilyplus,
                                          )),
                                          DataCell(Text(
                                            controller.leaveentryList[index].toDate.toString(),
                                            style: AppStyle.fontfamilyplus,
                                          )),
                                          DataCell(Text(
                                            controller.leaveentryList[index].leaveDays.toString(),
                                            style: AppStyle.fontfamilyplus,
                                          )),
                                          DataCell(
                                            GestureDetector(
                                              onTap: () {
                                                // detailbottomsheet(context, index);
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

  Future<void> leavebottomsheet(BuildContext context) async {
    showModalBottomSheet(
      backgroundColor: AppColor.white,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      context: Get.context!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: AppColor.black),
      ),
      builder: (context) {
        return Container();
      },
    );
  }
}
