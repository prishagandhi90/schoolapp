import 'package:emp_app/app/app_custom_widget/common_text.dart';
import 'package:emp_app/app/app_custom_widget/custom_apptextform_field.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/custom_color.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/medication_sheet/controller/medicationsheet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OperationListView extends StatelessWidget {
  const OperationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MedicationsheetController>(builder: (controller) {
      return Container(
        decoration: BoxDecoration(color: AppColor.white, borderRadius: BorderRadius.circular(10)),
        height: getDynamicHeight(size: 0.395),
        child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getDynamicHeight(size: 0.015),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    AppText(
                      text: 'Select Surgery',
                      fontSize: Sizes.px16,
                      fontWeight: FontWeight.w600,
                      fontColor: AppColor.black,
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     Get.back();
                    //   },
                    //   child: AppText(
                    //     text: controller.selectedOperationId.isEmpty
                    //         ? 'Close'
                    //         : 'Done',
                    //     fontSize: Sizes.px16,
                    //     fontWeight: FontWeight.w600,
                    //     fontColor: ConstColor.buttonColor,
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                AppTextField(
                  hintText: 'Enter surgery name',
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  onChanged: (text) {
                    controller.searchOperationName(text.trim());
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: controller.searchLeaveNameListData != null
                      ? controller.searchLeaveNameListData!.isEmpty
                          ? Center(
                              child: AppText(
                                text: "No data found",
                                fontSize: Sizes.px16,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.only(bottom: Sizes.crossLength * 0.020),
                              itemCount: controller.searchLeaveNameListData!.length,
                              itemBuilder: (item, index) {
                                return GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (controller.selectedOperationId
                                        .contains(controller.searchLeaveNameListData![index].value.toString())) {
                                      controller.selectedOperationId.remove(controller.searchLeaveNameListData![index].value.toString());
                                      controller.selectedleaveList.remove(controller.searchLeaveNameListData![index]);
                                    } else {
                                      controller.selectedOperationId.add(controller.searchLeaveNameListData![index].value!.toString());
                                      controller.selectedleaveList.add(controller.searchLeaveNameListData![index]);
                                    }
                                    controller.update();
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: AppText(text: controller.searchLeaveNameListData![index].name ?? ''),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          controller.selectedOperationId
                                                  .contains(controller.searchLeaveNameListData![index].value.toString())
                                              ? GestureDetector(
                                                  onTap: () {
                                                    FocusScope.of(context).unfocus();
                                                    controller.selectedOperationId
                                                        .remove(controller.searchLeaveNameListData![index].value.toString());
                                                    controller.selectedleaveList.remove(controller.searchLeaveNameListData![index]);
                                                    controller.update();
                                                  },
                                                  child: Icon(
                                                    Icons.cancel_outlined,
                                                    color: ConstColor.buttonColor,
                                                  ))
                                              : const SizedBox()
                                        ],
                                      ),
                                      index == controller.searchLeaveNameListData!.length - 1
                                          ? const SizedBox()
                                          : const SizedBox(
                                              height: 15,
                                            ),
                                      index == controller.searchLeaveNameListData!.length - 1
                                          ? const SizedBox()
                                          : const Divider(
                                              thickness: 1,
                                              height: 1,
                                              color: ConstColor.greyACACAC,
                                            )
                                    ],
                                  ),
                                );
                              })
                      : controller.leaveNameListData.isEmpty
                          ? Center(
                              child: AppText(
                                text: "No data found for selected surgeon",
                                fontSize: Sizes.px16,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.only(bottom: Sizes.crossLength * 0.020),
                              itemCount: controller.leaveNameListData.length,
                              itemBuilder: (item, index) {
                                return GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (controller.selectedOperationId.contains(controller.leaveNameListData[index].value.toString())) {
                                      controller.selectedOperationId.remove(controller.leaveNameListData[index].value.toString());
                                      controller.selectedleaveList.remove(controller.leaveNameListData[index]);
                                    } else {
                                      controller.selectedOperationId.add(controller.leaveNameListData[index].value!.toString());
                                      controller.selectedleaveList.add(controller.leaveNameListData[index]);
                                    }
                                    controller.update();
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: AppText(text: controller.leaveNameListData[index].name ?? ''),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          controller.selectedOperationId.contains(controller.leaveNameListData[index].value.toString())
                                              ? GestureDetector(
                                                  onTap: () {
                                                    FocusScope.of(context).unfocus();
                                                    controller.selectedOperationId
                                                        .remove(controller.leaveNameListData[index].value.toString());
                                                    controller.selectedleaveList.remove(controller.leaveNameListData[index]);
                                                    controller.update();
                                                  },
                                                  child: const Icon(
                                                    Icons.cancel_outlined,
                                                    color: ConstColor.buttonColor,
                                                  ))
                                              : const SizedBox()
                                        ],
                                      ),
                                      index == controller.leaveNameListData.length - 1
                                          ? const SizedBox()
                                          : const SizedBox(
                                              height: 15,
                                            ),
                                      index == controller.leaveNameListData.length - 1
                                          ? const SizedBox()
                                          : const Divider(
                                              thickness: 1,
                                              height: 1,
                                              color: ConstColor.greyACACAC,
                                            )
                                    ],
                                  ),
                                );
                              }),
                ),
              ],
            )),
      );
    });
  }
}
