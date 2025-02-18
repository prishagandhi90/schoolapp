import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/lvotApproval/controller/lvotapproval_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class OtlistScreen extends GetView<LvotapprovalController> {
  const OtlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LvotapprovalController());
    return GetBuilder<LvotapprovalController>(
      builder: (controller) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: controller.filteredList.isNotEmpty
                    ? Column(
                        children: [
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                await controller.fetchLeaveOTList(controller.selectedRole, controller.selectedLeaveType);
                              },
                              child: Scrollbar(
                                thickness: 4, //According to your choice
                                thumbVisibility: false, //
                                radius: Radius.circular(10),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 45),
                                  child: SlidableAutoCloseBehavior(
                                    child: ListView.builder(
                                      itemCount: controller.filteredList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        final leaveItem = controller.filteredList[index];
                                        final isSelected = controller.selectedItems.contains(leaveItem);

                                        // Divider color logic
                                        final showPurpleDivider = leaveItem.lateReasonName != null && leaveItem.lateReasonName!.isNotEmpty;
                                        final showRedDivider = leaveItem.inchargeAction == "Rejected";

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
                                                    // label: 'Approve',
                                                  ),
                                                  SlidableAction(
                                                    onPressed: (_) {
                                                      controller.reasonnameController.clear();
                                                      controller.reasonvalueController.clear();
                                                      // controller.fetchOTReason();
                                                      controller.showRejectDialog(context, index);
                                                      // controller.update();
                                                    },
                                                    backgroundColor: AppColor.lightred,
                                                    foregroundColor: Colors.black,
                                                    icon: Icons.close,
                                                    // label: 'Reject',
                                                  ),
                                                  // SlidableAction(
                                                  //   onPressed: (_) async {
                                                  //     if (controller.selectedRole.toLowerCase() == "incharge") {
                                                  //       controller.noteController.text =
                                                  //           controller.filteredList[index].inchargeNote.toString();
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
                                                      const SizedBox(width: 8), // Space after divider
                                                      // Checkbox logic
                                                      if (controller.isSelectionMode.value)
                                                        Checkbox(
                                                          value: isSelected,
                                                          onChanged: (value) async {
                                                            await controller.toggleSelection(index, value!);
                                                          },
                                                        ),
                                                      Container(
                                                        width: 50, // Fixed width for consistent alignment
                                                        alignment: Alignment.topLeft,
                                                        child: Text(
                                                          leaveItem.otHours.toString(),
                                                          style: TextStyle(
                                                            // fontSize: 20,
                                                            fontSize: getDynamicHeight(size: 0.022),
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      // Vertical Divider
                                                      Container(
                                                        width: 2, // Thickness of the divider
                                                        color: AppColor.grey,
                                                      ),
                                                      // Text(
                                                      //   leaveItem.otHours.toString(),
                                                      //   style: const TextStyle(
                                                      //     fontSize: 20,
                                                      //     fontWeight: FontWeight.bold,
                                                      //   ),
                                                      // ),
                                                      // Padding(
                                                      //   padding: const EdgeInsets.symmetric(horizontal: 20),
                                                      //   child: VerticalDivider(
                                                      //     thickness: 2,
                                                      //     color: AppColor.grey, // Divider color
                                                      //   ),
                                                      // ),
                                                      // // Divider and Name
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
                                                                  fontSize: getDynamicHeight(size: 0.019),
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                                softWrap: true,
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                              SizedBox(height: 10),
                                                              Row(
                                                                children: [
                                                                  // From Date
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
                                                                      SizedBox(height: 4),
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
                                                                  SizedBox(width: 16),
                                                                  // To Date
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
                                                                      SizedBox(height: 4),
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
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          await controller.otlistbottomsheet(context, index);
                                                        },
                                                        child: Image.asset(
                                                          'assets/image/bottomsheet.png',
                                                          width: 50,
                                                          height: 50,
                                                          alignment: Alignment.topRight,
                                                        ),
                                                      ),
                                                      // IconButton(
                                                      //   icon: Icon(Icons.more_vert),
                                                      //   onPressed: () {
                                                      //     controller.otlistbottomsheet(context, index);
                                                      //   },
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
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
                            "No data available",
                            style: AppStyle.fontfamilyplus,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
