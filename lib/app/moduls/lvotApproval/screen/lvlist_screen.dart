import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/lvotApproval/controller/lvotapproval_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class LvList extends StatelessWidget {
  LvList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LvotapprovalController controller = Get.put(LvotapprovalController());
    return GetBuilder<LvotapprovalController>(
      builder: (controller) {
        return PopScope(
          onPopInvokedWithResult: (bool didPop, Object? result) async {
            await controller.exitSelectionMode();
            // This can be async and you can check your condition
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
                            thickness: 4,
                            thumbVisibility: false,
                            radius: Radius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 45),
                              child: SlidableAutoCloseBehavior(
                                child: Builder(builder: (context) {
                                  return ListView.builder(
                                    controller: controller.lvappScrollController,
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
                                          padding: const EdgeInsets.all(8.0),
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
                                                  foregroundColor: Colors.black,
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
                                                  foregroundColor: Colors.black,
                                                  icon: Icons.close,
                                                ),
                                                // SlidableAction(
                                                //   onPressed: (_) async {
                                                //     if (controller.selectedRole.toLowerCase() == "incharge") {
                                                //       controller.noteController.text = controller.filteredList[index].inchargeNote.toString();
                                                //     } else if (controller.selectedRole == "HOD") {
                                                //       controller.noteController.text = controller.filteredList[index].hoDNote.toString();
                                                //     } else if (controller.selectedRole == "HR") {
                                                //       controller.noteController.text = controller.filteredList[index].hrNote.toString();
                                                //     }

                                                //     controller.showNoteDialog(context, index);
                                                //   },
                                                //   backgroundColor: AppColor.lightblue,
                                                //   foregroundColor: Colors.black,
                                                //   icon: Icons.note,
                                                // ),
                                                CustomSlidableAction(
                                                  onPressed: (_) async {
                                                    if (controller.selectedRole.toLowerCase() == "incharge") {
                                                      controller.noteController.text =
                                                          controller.filteredList[index].inchargeNote.toString();
                                                    } else if (controller.selectedRole == "HOD") {
                                                      controller.noteController.text = controller.filteredList[index].hoDNote.toString();
                                                    } else if (controller.selectedRole == "HR") {
                                                      controller.noteController.text = controller.filteredList[index].hrNote.toString();
                                                    }
                                                    controller.showNoteDialog(context, index);
                                                  },
                                                  backgroundColor: AppColor.lightblue,
                                                  child: Image.asset(
                                                    'assets/image/notes.png',
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(12.0),
                                              decoration: BoxDecoration(
                                                color: isSelected ? AppColor.darkgery.withOpacity(0.3) : AppColor.lightblue,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: IntrinsicHeight(
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    // Add left divider with dynamic color
                                                    if (showPurpleDivider)
                                                      Container(
                                                        width: 5,
                                                        height: double.infinity,
                                                        color: Colors.purple,
                                                      ),
                                                    const SizedBox(width: 3),
                                                    if (showRedDivider)
                                                      Container(
                                                        width: 5,
                                                        height: double.infinity,
                                                        color: Colors.red,
                                                      ),
                                                    const SizedBox(width: 8),
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
                                                          width: 50,
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
                                                          width: 50,
                                                          alignment: Alignment.bottomLeft,
                                                          child: Text(
                                                            leaveItem.leaveShortName.toString(),
                                                            style: TextStyle(
                                                              fontSize: getDynamicHeight(size: 0.020),
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    // Container(
                                                    //   width: 50,
                                                    //   alignment: Alignment.topLeft,
                                                    //   child: Text(
                                                    //     leaveItem.leaveDays.toString(),
                                                    //     style: TextStyle(
                                                    //       // fontSize: 20,
                                                    //       fontSize: getDynamicHeight(size: 0.022),
                                                    //       fontWeight: FontWeight.bold,
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    Container(
                                                      width: 2,
                                                      color: AppColor.grey,
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              leaveItem.employeeCodeName.toString(),
                                                              style: TextStyle(
                                                                // fontSize: 17,
                                                                fontSize: getDynamicHeight(
                                                                  size: 0.019,
                                                                ),
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                              softWrap: true,
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                            const SizedBox(height: 10),
                                                            Row(
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      "From",
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
                                                                        color: Colors.black54,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(width: 16),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      "To",
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        // fontSize: 14,
                                                                        fontSize: getDynamicHeight(size: 0.016),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(height: 4),
                                                                    Text(
                                                                      leaveItem.toDate.toString(),
                                                                      style: TextStyle(
                                                                        // fontSize: 14,
                                                                        fontSize: getDynamicHeight(size: 0.016),
                                                                        color: Colors.black54,
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
                                                        'assets/image/bottomsheet.png',
                                                        width: 50,
                                                        height: 50,
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
                        "No data available",
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
