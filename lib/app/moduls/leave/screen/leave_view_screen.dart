import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveViewScreen extends GetView<LeaveController> {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: getDynamicHeight(size: 0.02)),
                    controller.isLoading
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 100),
                              child: ProgressWithIcon(),
                            ),
                          )
                        : controller.leaveentryList.isNotEmpty
                            ? Column(
                                children: [
                                  // Sticky Header
                                  Container(
                                    color: AppColor.primaryColor,
                                    child: Row(
                                      children: [
                                        buildHeaderCell(AppString.from, constraints.maxWidth * 0.3),
                                        buildHeaderCell(AppString.to, constraints.maxWidth * 0.3),
                                        buildHeaderCell(AppString.days, constraints.maxWidth * 0.2),
                                        buildHeaderCell('', constraints.maxWidth * 0.2),
                                      ],
                                    ),
                                  ),
                                  // Scrollable Table Rows
                                  SizedBox(
                                    height: constraints.maxHeight * 0.5, // Set a fixed height for the table
                                    child: ListView.builder(
                                      itemCount: controller.leaveentryList.length,
                                      itemBuilder: (context, index) {
                                        final row = controller.leaveentryList[index];
                                        final isSelected = controller.selectedRowIndex == index; // Check if row is selected
                                        return GestureDetector(
                                          onTap: () {
                                            // Trigger API Call here
                                            // controller.callApiForRow(row);
                                            controller.inchargeAction.value = controller.leaveentryList[index].inchargeAction ?? '';
                                            controller.hodAction.value = controller.leaveentryList[index].hodAction ?? '';
                                            controller.hrAction.value = controller.leaveentryList[index].hrAction ?? '';
                                            controller.setSelectedRow(index);
                                            controller.update();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: isSelected ? AppColor.lightblue : AppColor.white,
                                              border: Border(
                                                bottom: BorderSide(color: AppColor.lightgrey, width: 0.5),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                buildCell(
                                                  Text(
                                                    row.fromDate.toString(),
                                                    style: AppStyle.fontfamilyplus,
                                                  ),
                                                  constraints.maxWidth * 0.3,
                                                ),
                                                buildCell(
                                                  Text(
                                                    row.toDate.toString(),
                                                    style: AppStyle.fontfamilyplus,
                                                  ),
                                                  constraints.maxWidth * 0.3,
                                                ),
                                                buildCell(
                                                  Text(
                                                    row.leaveDays.toString(),
                                                    style: AppStyle.fontfamilyplus,
                                                  ),
                                                  constraints.maxWidth * 0.2,
                                                ),
                                                buildCell(
                                                  GestureDetector(
                                                    onTap: () {
                                                      leavebottomsheet(context, index);
                                                    },
                                                    child: const Icon(Icons.arrow_drop_down_circle),
                                                  ),
                                                  constraints.maxWidth * 0.2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(getDynamicHeight(size: 0.008)),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        AppString.status,
                                        style: AppStyle.plus17w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.35, // Adjust height accordingly
                                    child: SingleChildScrollView(
                                      controller: controller.leaveScrollController,
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
                                            columnSpacing: getDynamicHeight(size: 0.035),
                                            columns: [
                                              DataColumn(
                                                label: Text(
                                                  AppString.inCharge,
                                                  style: AppStyle.fontfamilyplus.copyWith(
                                                    color: AppColor.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  AppString.hod,
                                                  style: AppStyle.fontfamilyplus.copyWith(
                                                    color: AppColor.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  AppString.hr,
                                                  style: AppStyle.fontfamilyplus.copyWith(
                                                    color: AppColor.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                            rows: List.generate(
                                              1, // Adjust number of rows as needed
                                              (index) => DataRow(
                                                cells: [
                                                  DataCell(getStatusImage(controller.inchargeAction.toString())),
                                                  DataCell(getStatusImage(controller.hodAction.toString())),
                                                  DataCell(getStatusImage(controller.hrAction.toString())),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Padding(
                                padding: EdgeInsets.all(getDynamicHeight(size: 0.01)),
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
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return Image.asset(AppImage.checkmark);
      case 'REJECTED':
        return Image.asset(AppImage.cross);
      case 'PENDING':
        return Image.asset(AppImage.hourglass);
      default:
        return SizedBox(); // If the status is invalid or unknown
    }
  }

  Widget buildHeaderCell(String text, double width) {
    return Container(
      width: width,
      height: getDynamicHeight(size: 0.045), // fixed height for consistency
      alignment: Alignment.center,
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

  Widget buildCell(Widget child, double width) {
    return Container(
      width: width,
      height: getDynamicHeight(size: 0.04), // same as header
      alignment: Alignment.center,
      // decoration: BoxDecoration(
      //   border: Border(
      //     right: BorderSide(color: AppColor.lightgrey, width: 0.5),
      //   ),
      // ),
      child: child,
    );
  }

  Future<void> leavebottomsheet(BuildContext context, int index) async {
    showModalBottomSheet(
      backgroundColor: AppColor.white,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      context: Get.context!,
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.0,
          maxChildSize: 0.95,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.90,
              width: Get.width,
              decoration: BoxDecoration(
                color: AppColor.white,
              ),
              child: GetBuilder<LeaveController>(
                builder: (controller) {
                  return controller.leaveentryList.isNotEmpty
                      ? SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            children: [
                              SizedBox(height: getDynamicHeight(size: 0.007)),
                              Row(
                                children: [
                                  SizedBox(width: getDynamicHeight(size: 0.02)), // ~30 dynamically
                                  const Spacer(),
                                  Container(
                                    width: getDynamicHeight(size: 0.06), // ~90 dynamically
                                    child: Divider(
                                      height: getDynamicHeight(size: 0.025), // ~20 dynamically
                                      color: AppColor.originalgrey,
                                      thickness: getDynamicHeight(size: 0.0065), // ~5 dynamically
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: getDynamicHeight(size: 0.025), // Icon size dynamic
                                    ),
                                  ),
                                  SizedBox(width: getDynamicHeight(size: 0.02)), // ~30 dynamically
                                ],
                              ),
                              SizedBox(height: getDynamicHeight(size: 0.007)), // was SizedBox(height: 10)
                              Container(
                                height: getDynamicHeight(size: 0.09), // was MediaQuery height * 0.12
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(getDynamicHeight(size: 0.007)), // was EdgeInsets.all(10)
                                      decoration: BoxDecoration(color: AppColor.primaryColor),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                              width: getDynamicHeight(size: 0.4), // was height * 0.4
                                              alignment: Alignment.center,
                                              child: Text(
                                                AppString.name,
                                                style: AppStyle.w50018.copyWith(
                                                  color: AppColor.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                              width: getDynamicHeight(size: 0.4), // was height * 0.4
                                              alignment: Alignment.center,
                                              child: Text(
                                                AppString.reason,
                                                style: AppStyle.w50018.copyWith(
                                                  color: AppColor.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            width: getDynamicHeight(size: 0.5), // was height * 0.5
                                            alignment: Alignment.center,
                                            child: controller.leaveentryList.isNotEmpty
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
                                            width: getDynamicHeight(size: 0.5), // was height * 0.5
                                            alignment: Alignment.center,
                                            child: controller.leaveentryList.isNotEmpty
                                                ? Text(
                                                    controller.leaveentryList[index].reason.toString(),
                                                    style: AppStyle.fontfamilyplus,
                                                  )
                                                : Text('--:-- ', style: AppStyle.plus16w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              _buildNoteSection(AppString.employeeNotes, controller.leaveentryList[index].note.toString()),
                              _buildNoteSection(AppString.inChargeNotes, controller.leaveentryList[index].inchargeNote.toString()),
                              _buildNoteSection(AppString.inchargerejectreason, controller.leaveentryList[index].inchargeReason.toString()),
                              _buildNoteSection(AppString.hodRejectReason, controller.leaveentryList[index].hodReason.toString()),
                              _buildNoteSection(AppString.hodNotes, controller.leaveentryList[index].hoDNote.toString()),
                              _buildNoteSection(AppString.hrnotes, controller.leaveentryList[index].hrNote.toString()),
                              _buildNoteSection(AppString.hrRejectReason, controller.leaveentryList[index].hrReason.toString()),
                              _buildNoteSection(AppString.lateReason, controller.leaveentryList[index].lateReasonName.toString()),
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
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'Emp Entry D/T : ',
                                            style: TextStyle(
                                              // fontSize: 18,
                                              fontSize: getDynamicHeight(size: 0.020),
                                              fontWeight: FontWeight.w700, // 20
                                              fontFamily: CommonFontStyle.plusJakartaSans,
                                              color: Colors.white60, // Main text color
                                            ),
                                            children: [
                                              TextSpan(
                                                text: controller.leaveentryList[index].enterDate,
                                                style: TextStyle(
                                                  // fontSize: 18,
                                                  fontSize: getDynamicHeight(size: 0.020),
                                                  fontWeight: FontWeight.w500, // Slightly lighter
                                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                                  color: Colors.white38, // Lighter color for right side text
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'Dept InC D/T : ',
                                          style: TextStyle(
                                            // fontSize: 18,
                                            fontSize: getDynamicHeight(size: 0.020),
                                            fontWeight: FontWeight.w700, // 20
                                            fontFamily: CommonFontStyle.plusJakartaSans,
                                            color: Colors.white60, // Main text color
                                          ),
                                          children: [
                                            TextSpan(
                                              text: controller.leaveentryList[index].inchargeDate,
                                              style: TextStyle(
                                                // fontSize: 18,
                                                fontSize: getDynamicHeight(size: 0.020),
                                                fontWeight: FontWeight.w500, // Slightly lighter
                                                fontFamily: CommonFontStyle.plusJakartaSans,
                                                color: Colors.white38, // Lighter color for right side text
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'Dept HOD D/T : ',
                                          style: TextStyle(
                                            // fontSize: 18,
                                            fontSize: getDynamicHeight(size: 0.020),
                                            fontWeight: FontWeight.w700, // 20
                                            fontFamily: CommonFontStyle.plusJakartaSans,
                                            color: Colors.white60, // Main text color
                                          ),
                                          children: [
                                            TextSpan(
                                              text: controller.leaveentryList[index].hodDate,
                                              style: TextStyle(
                                                // fontSize: 18,
                                                fontSize: getDynamicHeight(size: 0.020),
                                                fontWeight: FontWeight.w500, // Slightly lighter
                                                fontFamily: CommonFontStyle.plusJakartaSans,
                                                color: Colors.white38, // Lighter color for right side text
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'Dept HR D/T : ',
                                          style: TextStyle(
                                            // fontSize: 18,
                                            fontSize: getDynamicHeight(size: 0.020),
                                            fontWeight: FontWeight.w700, // 20
                                            fontFamily: CommonFontStyle.plusJakartaSans,
                                            color: Colors.white60, // Main text color
                                          ),
                                          children: [
                                            TextSpan(
                                              text: controller.leaveentryList[index].hrDate,
                                              style: TextStyle(
                                                // fontSize: 18,
                                                fontSize: getDynamicHeight(size: 0.020),
                                                fontWeight: FontWeight.w500, // Slightly lighter
                                                fontFamily: CommonFontStyle.plusJakartaSans,
                                                color: Colors.white38, // Lighter color for right side text
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.all(15),
                          child: Center(child: Text(AppString.noleavedata)),
                        );
                },
              ),
            );
          }),
    );
  }

  Widget _buildNoteSection(String title, String content) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(getDynamicHeight(size: 0.01)),
            width: double.infinity,
            height: getDynamicHeight(size: 0.045),
            color: AppColor.primaryColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.02)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: AppStyle.w50018.copyWith(color: AppColor.white),
                ),
              ),
            ),
          ),
          controller.leaveentryList.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getDynamicHeight(size: 0.015),
                    vertical: getDynamicHeight(size: 0.01),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      content,
                      style: content.isNotEmpty ? AppStyle.fontfamilyplus : AppStyle.plus16w600,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(alignment: Alignment.centerLeft, child: Text('--:--', style: AppStyle.plus16w600)),
                ),
        ],
      ),
    );
  }
}
