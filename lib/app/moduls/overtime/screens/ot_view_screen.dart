import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:emp_app/app/moduls/overtime/controller/overtime_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OTViewScreen extends StatelessWidget {
  const OTViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(OvertimeController());
    var leaveController = Get.put(LeaveController());
    return GetBuilder<OvertimeController>(
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColor.white,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
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
                        : leaveController.otentryList.isNotEmpty
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: constraints.maxHeight * 0.6, // Half screen height
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minWidth: constraints.maxWidth,
                                          ),
                                          child: DataTable(
                                            showCheckboxColumn: false,
                                            headingRowColor: WidgetStateColor.resolveWith(
                                              (states) => AppColor.primaryColor,
                                            ),
                                            columnSpacing: 20, // Adjust column spacing if needed
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
                                                  AppString.min,
                                                  style: AppStyle.fontfamilyplus,
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '', // Action column
                                                  style: AppStyle.fontfamilyplus,
                                                ),
                                              ),
                                            ],
                                            rows: List.generate(
                                              leaveController.otentryList.length,
                                              (index) => DataRow(
                                                onSelectChanged: (selected) {
                                                  if (selected!) {
                                                    leaveController.inchargeAction.value = leaveController.otentryList[index].inchargeAction ?? '' ;
                                                    leaveController.hodAction.value = leaveController.otentryList[index].hodAction ?? '' ;
                                                    leaveController.hrAction.value = leaveController.otentryList[index].hrAction ?? '' ;
                                                    leaveController.update();
                                                  } else {
                                                    leaveController.inchargeAction = ''.obs;
                                                    leaveController.hodAction = ''.obs;
                                                    leaveController.hrAction = ''.obs;
                                                    leaveController.update();
                                                  }
                                                },
                                                cells: [
                                                  DataCell(Text(
                                                    leaveController.otentryList[index].fromDate.toString(),
                                                    style: AppStyle.fontfamilyplus,
                                                  )),
                                                  DataCell(Text(
                                                    leaveController.otentryList[index].toDate.toString(),
                                                    style: AppStyle.fontfamilyplus,
                                                  )),
                                                  DataCell(Text(
                                                    leaveController.otentryList[index].overTimeMinutes.toString(),
                                                    style: AppStyle.fontfamilyplus,
                                                  )),
                                                  DataCell(
                                                    GestureDetector(
                                                      onTap: () {
                                                        oTbottomsheet(context, index);
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Status',
                                        style: AppStyle.plus17w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.35, // Adjust height accordingly
                                    child: SingleChildScrollView(
                                      controller: leaveController.leaveScrollController,
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
                                            columnSpacing: 35,
                                            columns: [
                                              DataColumn(
                                                label: Text(
                                                  'In-Charge',
                                                  style: AppStyle.fontfamilyplus,
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'HOD',
                                                  style: AppStyle.fontfamilyplus,
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'HR',
                                                  style: AppStyle.fontfamilyplus,
                                                ),
                                              ),
                                            ],
                                            rows: List.generate(
                                              1, // Adjust number of rows as needed
                                              (index) => DataRow(
                                                cells: [
                                                  DataCell(getStatusImage(leaveController.otentryList[0].inchargeAction.toString())),
                                                  DataCell(getStatusImage(leaveController.otentryList[0].hodAction.toString())),
                                                  DataCell(getStatusImage(leaveController.otentryList[0].hrAction.toString())),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
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

  Widget getStatusImage(String status) {
    switch (status) {
      case 'APPROVED':
        return Image.asset('assets/image/check-mark.png');
      case 'REJECTED':
        return Image.asset('assets/image/cross.png');
      case 'PENDING':
        return Image.asset('assets/image/hourglass.png');
      default:
        return SizedBox(); // If the status is invalid or unknown
    }
  }

  Future<void> oTbottomsheet(BuildContext context, int index) async {
    final leaveController = Get.put(LeaveController());
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
        child: GetBuilder<OvertimeController>(
          builder: (controller) {
            return leaveController.otentryList.isNotEmpty
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
                                        'Hours',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500, //20
                                          fontFamily: CommonFontStyle.plusJakartaSans,
                                        ),
                                      )),
                                ),
                              ),
                              leaveController.otentryList.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          leaveController.otentryList[0].otHours.toString(),
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
                                        'Employee Notes',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500, //20
                                          fontFamily: CommonFontStyle.plusJakartaSans,
                                        ),
                                      )),
                                ),
                              ),
                              leaveController.otentryList.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          leaveController.otentryList[0].note.toString(),
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
                              leaveController.otentryList.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          leaveController.otentryList[0].inchargeNote.toString(),
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
                              leaveController.otentryList.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          leaveController.otentryList[0].inchargeReason.toString(),
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
                              leaveController.otentryList.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          leaveController.otentryList[0].hodReason.toString(),
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
                              leaveController.otentryList.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          leaveController.otentryList[0].hoDNote.toString(),
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
                              leaveController.otentryList.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          leaveController.otentryList[0].hrNote.toString(),
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
                              leaveController.otentryList.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          leaveController.otentryList[0].hrReason.toString(),
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
                              leaveController.otentryList.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          leaveController.otentryList[0].lateReasonName.toString(),
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
                                      'Emp Entry D/T : ${leaveController.otentryList[0].enterDate}',
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
                                      'Dept InC D/T : ${leaveController.otentryList[0].inchargeDate}',
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
                                      'Dept HOD D/T : ${leaveController.otentryList[0].hodDate}',
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
                                      'Dept HR D/T : ${leaveController.otentryList[0].hrDate}',
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
