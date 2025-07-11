// ignore_for_file: deprecated_member_use

import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/app_image.dart';
import 'package:schoolapp/app/core/util/app_string.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/lvotApproval/controller/lvotapproval_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class LvList extends StatelessWidget {
  LvList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final LvotapprovalController controller = Get.put(LvotapprovalController());
    return GetBuilder<LvotapprovalController>(
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            // Agar selection mode ON hai to exit kare bina bas selection hataye
            if (controller.isSelectionMode.value) {
              await controller.exitSelectionMode();
              return false; // Screen se exit nahi karega
            }
            return true; // Normal back navigation
          },
          child: Scaffold(
            body: controller.filteredList.isNotEmpty
                ? Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await controller.fetchLeaveOTList(controller.selectedRole, controller.selectedLeaveType);
                          },
                          child: Scrollbar(
                            thickness: getDynamicHeight(size: 0.005),
                            thumbVisibility: false,
                            radius: Radius.circular((getDynamicHeight(size: 0.012))),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: getDynamicHeight(size: 0.05)),
                              child: SlidableAutoCloseBehavior(
                                child: Builder(builder: (context) {
                                  return ListView.builder(
                                    controller: controller.lvappScrollController,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: controller.filteredList.length,
                                    itemBuilder: (context, index) {
                                      final leaveItem = controller.filteredList[index];
                                      final isSelected = controller.selectedItems.contains(leaveItem);

                                      // Divider color logic
                                      final showPurpleDivider = leaveItem.lateReasonName != null && leaveItem.lateReasonName!.isNotEmpty;
                                      final showRedDivider = leaveItem.inchargeAction?.toLowerCase() == "rejected";

                                      return GestureDetector(
                                        onLongPress: () async {
                                          if (controller.selectedRole == "HOD")
                                            await controller.enterSelectionMode(index);
                                          else
                                            await controller.exitSelectionMode();
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(getDynamicHeight(size: 0.01)),
                                          child: Slidable(
                                            key: ValueKey(leaveItem.employeeCodeName),
                                            endActionPane: ActionPane(
                                              motion: const DrawerMotion(),
                                              children: [
                                                SlidableAction(
                                                  onPressed: (_) {
                                                    controller.showApproveDialog(context, index);
                                                  },
                                                  backgroundColor: AppColor.lightgreen,
                                                  foregroundColor: AppColor.black,
                                                  icon: Icons.check,
                                                ),
                                                SlidableAction(
                                                  onPressed: (_) async {
                                                    controller.reasonnameController.clear();
                                                    controller.reasonvalueController.clear();
                                                    // controller.fetchOTReason();
                                                    controller.showRejectDialog(context, index);
                                                  },
                                                  backgroundColor: AppColor.lightred,
                                                  foregroundColor: AppColor.black,
                                                  icon: Icons.close,
                                                ),
                                                CustomSlidableAction(
                                                  onPressed: (_) async {
                                                    if (controller.selectedRole.toLowerCase() == "incharge") {
                                                      controller.noteController.text = controller.filteredList[index].inchargeNote.toString();
                                                    } else if (controller.selectedRole == "HOD") {
                                                      controller.noteController.text = controller.filteredList[index].hoDNote.toString();
                                                    } else if (controller.selectedRole == "HR") {
                                                      controller.noteController.text = controller.filteredList[index].hrNote.toString();
                                                    }
                                                    controller.showNoteDialog(context, index);
                                                  },
                                                  backgroundColor: AppColor.lightblue,
                                                  child: Image.asset(
                                                    AppImage.note,
                                                    width: getDynamicHeight(size: 0.03),
                                                    height: getDynamicHeight(size: 0.03),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            child: Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: getDynamicHeight(size: 0.006),
                                                vertical: getDynamicHeight(size: 0.006),
                                              ),
                                              decoration: BoxDecoration(
                                                color: isSelected ? AppColor.darkgery.withOpacity(0.3) : AppColor.lightblue,
                                                borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.015)),
                                              ),
                                              child: IntrinsicHeight(
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    // Add left divider with dynamic color
                                                    if (showPurpleDivider)
                                                      Container(
                                                        width: getDynamicHeight(size: 0.006),
                                                        height: double.infinity,
                                                        color: AppColor.purple,
                                                      ),
                                                    const SizedBox(width: 3),
                                                    if (showRedDivider)
                                                      Container(
                                                        width: getDynamicHeight(size: 0.006),
                                                        height: double.infinity,
                                                        color: AppColor.red,
                                                      ),
                                                    // const SizedBox(width: 8),
                                                    // Checkbox logic
                                                    if (controller.isSelectionMode.value)
                                                      Checkbox(
                                                        value: isSelected,
                                                        onChanged: (value) async {
                                                          await controller.toggleSelection(index, value!);
                                                        },
                                                      ),
                                                    // Main Leave Information
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Top & Bottom alignment maintain
                                                      children: [
                                                        // ✅ Top-Left Aligned Leave Days
                                                        Container(
                                                          width: getDynamicHeight(size: 0.06), //50,
                                                          alignment: Alignment.topLeft,
                                                          child: Text(
                                                            leaveItem.leaveDays.toString(),
                                                            style: TextStyle(
                                                              fontSize: getDynamicHeight(size: 0.022),
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),

                                                        // ✅ Bottom-Left Aligned Leave Days
                                                        Container(
                                                          width: getDynamicHeight(size: 0.06), //50,
                                                          alignment: Alignment.bottomLeft,
                                                          child: Text(
                                                            leaveItem.leaveShortName.toString(),
                                                            style: TextStyle(
                                                              fontSize: getDynamicHeight(size: 0.019),
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      width: 2,
                                                      color: AppColor.grey,
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.012)),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              leaveItem.employeeCodeName.toString(),
                                                              style: TextStyle(
                                                                // fontSize: 17,
                                                                fontSize: getDynamicHeight(size: 0.018),
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                              softWrap: true,
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                            SizedBox(height: getDynamicHeight(size: 0.012)),
                                                            Row(
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      AppString.from,
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        // fontSize: 14,
                                                                        fontSize: getDynamicHeight(size: 0.016),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(height: 4),
                                                                    Text(
                                                                      leaveItem.fromDate.toString(),
                                                                      style: TextStyle(
                                                                        // fontSize: 14,
                                                                        fontSize: getDynamicHeight(size: 0.016),
                                                                        color: AppColor.black,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(width: 16),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      AppString.to,
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        // fontSize: 14,
                                                                        fontSize: getDynamicHeight(size: 0.016),
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: getDynamicHeight(size: 0.004)),
                                                                    Text(
                                                                      leaveItem.toDate.toString(),
                                                                      style: TextStyle(
                                                                        // fontSize: 14,
                                                                        fontSize: getDynamicHeight(size: 0.016),
                                                                        color: AppColor.black,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    // Bottom Sheet Button
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await controller.lvlistbottomsheet(context, index);
                                                        controller.update();
                                                      },
                                                      child: Image.asset(
                                                        AppImage.bottomsheet,
                                                        width: getDynamicHeight(size: 0.02), //50,
                                                        height: getDynamicHeight(size: 0.02), //50,
                                                        alignment: Alignment.topRight,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Displaying selected items at the end
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        AppString.nodataavailable,
                        style: TextStyle(
                          // fontSize: 16,
                          fontSize: getDynamicHeight(size: 0.018),
                        ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
