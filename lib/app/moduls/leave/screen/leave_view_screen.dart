import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
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
                    const SizedBox(height: 20),
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
                                    padding: const EdgeInsets.all(10),
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
                                            columnSpacing: 35,
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
      padding: EdgeInsets.all(8),
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

  // Widget buildCell(Widget child) {
  //   return Container(
  //     padding: EdgeInsets.all(8),
  //     child: child,
  //   );
  // }
  Widget buildCell(Widget child, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8),
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
          maxChildSize: 1,
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
                                                child: Text(AppString.name, style: AppStyle.w50018)),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                                // height: 100,
                                                width: MediaQuery.of(context).size.height * 0.4,
                                                alignment: Alignment.center,
                                                child: Text(AppString.reason, style: AppStyle.w50018)),
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
                                              AppString.employeeNotes,
                                              style: AppStyle.w50018,
                                            )),
                                      ),
                                    ),
                                    controller.leaveentryList.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                controller.leaveentryList[index].note.toString(),
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
                                            alignment: Alignment.centerLeft, child: Text(AppString.inChargeNotes, style: AppStyle.w50018)),
                                      ),
                                    ),
                                    controller.leaveentryList.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                controller.leaveentryList[index].inchargeNote.toString(),
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
                                            child: Text(AppString.inchargerejectreason, style: AppStyle.w50018)),
                                      ),
                                    ),
                                    controller.leaveentryList.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                controller.leaveentryList[index].inchargeReason.toString(),
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
                                            child: Text(AppString.hodRejectReason, style: AppStyle.w50018)),
                                      ),
                                    ),
                                    controller.leaveentryList.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                controller.leaveentryList[index].hodReason.toString(),
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
                                        child:
                                            Align(alignment: Alignment.centerLeft, child: Text(AppString.hodNotes, style: AppStyle.w50018)),
                                      ),
                                    ),
                                    controller.leaveentryList.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                controller.leaveentryList[index].hoDNote.toString(),
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
                                        child:
                                            Align(alignment: Alignment.centerLeft, child: Text(AppString.hrnotes, style: AppStyle.w50018)),
                                      ),
                                    ),
                                    controller.leaveentryList.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                controller.leaveentryList[index].hrNote.toString(),
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
                                            alignment: Alignment.centerLeft, child: Text(AppString.hrRejectReason, style: AppStyle.w50018)),
                                      ),
                                    ),
                                    controller.leaveentryList.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                controller.leaveentryList[index].hrReason.toString(),
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
                                            alignment: Alignment.centerLeft, child: Text(AppString.lateReason, style: AppStyle.w50018)),
                                      ),
                                    ),
                                    controller.leaveentryList.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                controller.leaveentryList[index].lateReasonName.toString(),
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
                                            'Emp Entry D/T : ${controller.leaveentryList[index].enterDate}',
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
                                            'Dept InC D/T : ${controller.leaveentryList[index].inchargeDate}',
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
                                            'Dept HOD D/T : ${controller.leaveentryList[index].hodDate}',
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
                                            'Dept HR D/T : ${controller.leaveentryList[index].hrDate} ',
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
}
