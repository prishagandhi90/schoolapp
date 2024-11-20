import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:emp_app/app/moduls/overtime/controller/overtime_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OvertimeViewScreen extends GetView<OvertimeController> {
  const OvertimeViewScreen({Key? key}) : super(key: key);

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
                    controller.isLoading
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 100),
                              child: ProgressWithIcon(),
                            ),
                          )
                        : controller.otentryList.isNotEmpty
                            ? Column(
                                children: [
                                  Container(
                                    color: AppColor.primaryColor,
                                    child: Row(
                                      children: [
                                        buildHeaderCell(AppString.from, constraints.maxWidth * 0.3),
                                        buildHeaderCell(AppString.to, constraints.maxWidth * 0.3),
                                        buildHeaderCell(AppString.min, constraints.maxWidth * 0.2),
                                        buildHeaderCell('', constraints.maxWidth * 0.2),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.5, // Half screen height
                                    child: ListView.builder(
                                      itemCount: controller.otentryList.length,
                                      itemBuilder: (context, index) {
                                        final row = controller.otentryList[index];
                                        final isSelected =
                                            controller.selectedRowIndex == index; // Check if row is selected

                                        return GestureDetector(
                                          onTap: () {
                                            controller.inchargeAction.value =
                                                controller.otentryList[index].inchargeAction ?? '';
                                            controller.hodAction.value = controller.otentryList[index].hodAction ?? '';
                                            controller.hrAction.value = controller.otentryList[index].hrAction ?? '';
                                            controller.setSelectedRow(index);
                                            controller.update();
                                            //   else {
                                            //   controller.inchargeAction = ''.obs;
                                            //   controller.hodAction = ''.obs;
                                            //   controller.hrAction = ''.obs;
                                            //   controller.update();
                                            // }
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
                                                    row.overTimeMinutes.toString(),
                                                    style: AppStyle.fontfamilyplus,
                                                  ),
                                                  constraints.maxWidth * 0.2,
                                                ),
                                                buildCell(
                                                  GestureDetector(
                                                    onTap: () {
                                                      oTbottomsheet(context, index);
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
                                  )
                                ],
                              )
                            : Padding(
                                padding: const EdgeInsets.all(10),
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

  Widget buildCell(Widget child, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8),
      child: child,
    );
  }

  Future<void> oTbottomsheet(BuildContext context, int index) async {
    final leaveController = Get.put(LeaveController());
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
              child: GetBuilder<OvertimeController>(
                builder: (controller) {
                  return controller.otentryList.isNotEmpty
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
                                              AppString.hours,
                                              style: AppStyle.w50018.copyWith(
                                                color: Colors.white, // Set text color to white
                                              ),
                                            )),
                                      ),
                                    ),
                                    controller.otentryList.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                controller.otentryList[index].otHours.toString(),
                                                style: AppStyle.fontfamilyplus,
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text('--:--', style: AppStyle.plus16w600)),
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
                                              AppString.employeeNotes,
                                              style: AppStyle.w50018.copyWith(
                                                color: Colors.white, // Set text color to white
                                              ),
                                            )),
                                      ),
                                    ),
                                    controller.otentryList.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                controller.otentryList[index].note.toString(),
                                                style: AppStyle.fontfamilyplus,
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text('--:--', style: AppStyle.plus16w600)),
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
                                              AppString.inChargeNotes,
                                              style: AppStyle.w50018.copyWith(
                                                color: Colors.white, // Set text color to white
                                              ),
                                            )),
                                      ),
                                    ),
                                    controller.otentryList.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                controller.otentryList[index].inchargeNote.toString(),
                                                style: AppStyle.fontfamilyplus,
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text('--:--', style: AppStyle.plus16w600)),
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
                                              AppString.inchargerejectreason,
                                              style: AppStyle.w50018.copyWith(
                                                color: Colors.white, // Set text color to white
                                              ),
                                            )),
                                      ),
                                    ),
                                    controller.otentryList.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                controller.otentryList[index].inchargeReason.toString(),
                                                style: AppStyle.fontfamilyplus,
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text('--:--', style: AppStyle.plus16w600)),
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
                                              AppString.hodRejectReason,
                                              style: AppStyle.w50018.copyWith(
                                                color: Colors.white, // Set text color to white
                                              ),
                                            )),
                                      ),
                                    ),
                                    controller.otentryList.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                controller.otentryList[index].hodReason.toString(),
                                                style: AppStyle.fontfamilyplus,
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text('--:--', style: AppStyle.plus16w600)),
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
                                              AppString.hodNotes,
                                              style: AppStyle.w50018.copyWith(
                                                color: Colors.white, // Set text color to white
                                              ),
                                            )),
                                      ),
                                    ),
                                    controller.otentryList.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                controller.otentryList[index].hoDNote.toString(),
                                                style: AppStyle.fontfamilyplus,
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text('--:--', style: AppStyle.plus16w600)),
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
                                              AppString.hrnotes,
                                              style: AppStyle.w50018.copyWith(
                                                color: Colors.white, // Set text color to white
                                              ),
                                            )),
                                      ),
                                    ),
                                    controller.otentryList.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                controller.otentryList[index].hrNote.toString(),
                                                style: AppStyle.fontfamilyplus,
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text('--:--', style: AppStyle.plus16w600)),
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
                                              AppString.hrRejectReason,
                                              style: AppStyle.w50018.copyWith(
                                                color: Colors.white, // Set text color to white
                                              ),
                                            )),
                                      ),
                                    ),
                                    controller.otentryList.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                controller.otentryList[index].hrReason.toString(),
                                                style: AppStyle.fontfamilyplus,
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text('--:--', style: AppStyle.plus16w600)),
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
                                              AppString.lateReason,
                                              style: AppStyle.w50018.copyWith(
                                                color: Colors.white, // Set text color to white
                                              ),
                                            )),
                                      ),
                                    ),
                                    controller.otentryList.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                controller.otentryList[index].lateReasonName.toString(),
                                                style: AppStyle.fontfamilyplus,
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text('--:--', style: AppStyle.plus16w600)),
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
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'Emp Entry D/T : ',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700, // 20
                                              fontFamily: CommonFontStyle.plusJakartaSans,
                                              color: Colors.white60, // Main text color
                                            ),
                                            children: [
                                              TextSpan(
                                                text: controller.otentryList[index].enterDate,
                                                style: TextStyle(
                                                  fontSize: 18,
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
                                          text: 'Dept Inc D/T : ',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700, // 20
                                            fontFamily: CommonFontStyle.plusJakartaSans,
                                            color: Colors.white60, // Main text color
                                          ),
                                          children: [
                                            TextSpan(
                                              text: controller.otentryList[index].inchargeDate,
                                              style: TextStyle(
                                                fontSize: 18,
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
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700, // 20
                                            fontFamily: CommonFontStyle.plusJakartaSans,
                                            color: Colors.white60, // Main text color
                                          ),
                                          children: [
                                            TextSpan(
                                              text: controller.otentryList[index].hodDate,
                                              style: TextStyle(
                                                fontSize: 18,
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
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700, // 20
                                            fontFamily: CommonFontStyle.plusJakartaSans,
                                            color: Colors.white60, // Main text color
                                          ),
                                          children: [
                                            TextSpan(
                                              text: controller.otentryList[index].hrDate,
                                              style: TextStyle(
                                                fontSize: 18,
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
            );
          }),
    );
  }
}
