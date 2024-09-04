import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
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
                controller: controller.leaveScrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    controller.isLoading.value
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 100),
                              child: ProgressWithIcon(),
                            ),
                          )
                        : controller.leaveentryList.isNotEmpty
                            ? Column(
                                children: [
                                  // Define the DataTable only once
                                  SizedBox(
                                    height: constraints.maxHeight * 0.5, // Half height of the screen
                                    child: SingleChildScrollView(
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
                                                '', // Use this column for the icon or any action
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
                                                      leavebottomsheet(context, index);
                                                    },
                                                    child: const Icon(Icons.arrow_drop_down_circle),
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
                              )
                            : Padding(
                                padding: const EdgeInsets.all(15),
                                child: Center(
                                  child: Text(
                                    AppString.noleavedata,
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

  Future<void> leavebottomsheet(BuildContext context, int index) async {
    showModalBottomSheet(
      backgroundColor: AppColor.white,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      context: Get.context!,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.90,
        width: Get.width,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: GetBuilder<LeaveController>(
          builder: (controller) {
            return controller.leaveentryList.isNotEmpty
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
                              child: Divider(height: 20, color: AppColor.originalgrey, thickness: 5),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.close),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: AppColor.primaryColor),
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                          // height: 100,
                                          width: MediaQuery.of(context).size.height * 0.4,
                                          alignment: Alignment.center,
                                          child: Text('Name', style: AppStyle.w50018)),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                          // height: 100,
                                          width: MediaQuery.of(context).size.height * 0.4,
                                          alignment: Alignment.center,
                                          child: Text('Reason', style: AppStyle.w50018)),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      width: MediaQuery.of(context).size.height * 0.5,
                                      alignment: Alignment.center,
                                      child: controller.leaveentryList.length > 0
                                          ? Text(
                                              controller.leaveentryList[index].leaveFullName.toString(),
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
                                      child: controller.leaveentryList.length > 0
                                          ? Text(
                                              controller.leaveentryList[index].reason.toString(),
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
                        Container(
                          // decoration: BoxDecoration(color: AppColor.lightblue1, borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: double.infinity,
                                height: 45,
                                decoration: BoxDecoration(color: AppColor.primaryColor),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Employee Notes',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500, //20
                                          fontFamily: CommonFontStyle.plusJakartaSans,
                                        ),
                                      )),
                                ),
                              ),
                              controller.leaveentryList.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          controller.leaveentryList[0].note.toString(),
                                          style: AppStyle.fontfamilyplus,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Align(alignment: Alignment.centerLeft, child: Text('--:--', style: AppStyle.plus16w600)),
                                    ),
                            ],
                          ),
                        ),
                        Container(
                          // decoration: BoxDecoration(color: AppColor.lightblue1, borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: double.infinity,
                                height: 45,
                                decoration: BoxDecoration(color: AppColor.primaryColor),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'In-Charge Notes',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500, //20
                                          fontFamily: CommonFontStyle.plusJakartaSans,
                                        ),
                                      )),
                                ),
                              ),
                              controller.leaveentryList.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          controller.leaveentryList[0].inchargeNote.toString(),
                                          style: AppStyle.fontfamilyplus,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Align(alignment: Alignment.centerLeft, child: Text('--:--', style: AppStyle.plus16w600)),
                                    ),
                            ],
                          ),
                        ),
                        Container(
                          // decoration: BoxDecoration(color: AppColor.lightblue1, borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: double.infinity,
                                height: 45,
                                decoration: BoxDecoration(color: AppColor.primaryColor),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'In-Charge Reject Reason',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500, //20
                                          fontFamily: CommonFontStyle.plusJakartaSans,
                                        ),
                                      )),
                                ),
                              ),
                              controller.leaveentryList.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          controller.leaveentryList[0].inchargeReason.toString(),
                                          style: AppStyle.fontfamilyplus,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Align(alignment: Alignment.centerLeft, child: Text('--:--', style: AppStyle.plus16w600)),
                                    ),
                            ],
                          ),
                        ),
                        Container(
                          // decoration: BoxDecoration(color: AppColor.lightblue1, borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: double.infinity,
                                height: 45,
                                decoration: BoxDecoration(color: AppColor.primaryColor),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'HOD Reject Reason',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500, //20
                                          fontFamily: CommonFontStyle.plusJakartaSans,
                                        ),
                                      )),
                                ),
                              ),
                              controller.leaveentryList.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          controller.leaveentryList[0].hodReason.toString(),
                                          style: AppStyle.fontfamilyplus,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Align(alignment: Alignment.centerLeft, child: Text('--:--', style: AppStyle.plus16w600)),
                                    ),
                            ],
                          ),
                        ),
                        Container(
                          // decoration: BoxDecoration(color: AppColor.lightblue1, borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: double.infinity,
                                height: 45,
                                decoration: BoxDecoration(color: AppColor.primaryColor),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'HOD Notes',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500, //20
                                          fontFamily: CommonFontStyle.plusJakartaSans,
                                        ),
                                      )),
                                ),
                              ),
                              controller.leaveentryList.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          controller.leaveentryList[0].hoDNote.toString(),
                                          style: AppStyle.fontfamilyplus,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Align(alignment: Alignment.centerLeft, child: Text('--:--', style: AppStyle.plus16w600)),
                                    ),
                            ],
                          ),
                        ),
                        Container(
                          // decoration: BoxDecoration(color: AppColor.lightblue1, borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: double.infinity,
                                height: 45,
                                decoration: BoxDecoration(color: AppColor.primaryColor),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'HR Notes',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500, //20
                                          fontFamily: CommonFontStyle.plusJakartaSans,
                                        ),
                                      )),
                                ),
                              ),
                              controller.leaveentryList.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          controller.leaveentryList[0].hrNote.toString(),
                                          style: AppStyle.fontfamilyplus,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Align(alignment: Alignment.centerLeft, child: Text('--:--', style: AppStyle.plus16w600)),
                                    ),
                            ],
                          ),
                        ),
                        Container(
                          // decoration: BoxDecoration(color: AppColor.lightblue1, borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: double.infinity,
                                height: 45,
                                decoration: BoxDecoration(color: AppColor.primaryColor),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'HR Reject Reason',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500, //20
                                          fontFamily: CommonFontStyle.plusJakartaSans,
                                        ),
                                      )),
                                ),
                              ),
                              controller.leaveentryList.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          controller.leaveentryList[0].hrReason.toString(),
                                          style: AppStyle.fontfamilyplus,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Align(alignment: Alignment.centerLeft, child: Text('--:--', style: AppStyle.plus16w600)),
                                    ),
                            ],
                          ),
                        ),
                        Container(
                          // decoration: BoxDecoration(color: AppColor.lightblue1, borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: double.infinity,
                                height: 45,
                                decoration: BoxDecoration(color: AppColor.primaryColor),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Late Reason',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500, //20
                                          fontFamily: CommonFontStyle.plusJakartaSans,
                                        ),
                                      )),
                                ),
                              ),
                              controller.leaveentryList.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          controller.leaveentryList[0].lateReasonName.toString(),
                                          style: AppStyle.fontfamilyplus,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Align(alignment: Alignment.centerLeft, child: Text('--:--', style: AppStyle.plus16w600)),
                                    ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          // height: MediaQuery.of(context).size.height*0.2,
                          decoration: BoxDecoration(color: AppColor.primaryColor),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Emp Entry D/T ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500, //20
                                        fontFamily: CommonFontStyle.plusJakartaSans,
                                      ),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Dept InC D/T ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500, //20
                                        fontFamily: CommonFontStyle.plusJakartaSans,
                                      ),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Dept HOD D/T ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500, //20
                                        fontFamily: CommonFontStyle.plusJakartaSans,
                                      ),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Dept HR D/T ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500, //20
                                        fontFamily: CommonFontStyle.plusJakartaSans,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        // Column(
                        //   mainAxisSize: MainAxisSize.min,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Container(
                        //       padding: const EdgeInsets.all(10),
                        //       width: double.infinity,
                        //       height: MediaQuery.of(context).size.height,
                        //       decoration: BoxDecoration(color: AppColor.primaryColor),
                        //       child: Padding(
                        //         padding: const EdgeInsets.symmetric(horizontal: 15),
                        //         child: Align(
                        //             alignment: Alignment.centerLeft,
                        //             child: Text(
                        //               'Employee Notes',
                        //               style: TextStyle(
                        //                 fontSize: 18,
                        //                 fontWeight: FontWeight.w500, //20
                        //                 fontFamily: CommonFontStyle.plusJakartaSans,
                        //               ),
                        //             )),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(15),
                    child: Center(child: Text(AppString.noleavedata)),
                  );
          },
        ),
      ),
    );
  }
}
