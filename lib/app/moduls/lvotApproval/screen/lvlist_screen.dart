import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/moduls/lvotApproval/controller/lvotapproval_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class LvList extends StatelessWidget {
  const LvList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LvotapprovalController()); // Initialize controller
    return GetBuilder<LvotapprovalController>(
      builder: (controller) {
        return Scaffold(
          body: controller.filteredList.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await await controller.fetchLeaveOTList(controller.selectedRole, controller.selectedLeaveType);
                        },
                        child: Scrollbar(
                          thickness: 4,
                          thumbVisibility: false,
                          radius: Radius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 45),
                            child: ListView.builder(
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
                                            backgroundColor: AppColor.lightwhite,
                                            foregroundColor: Colors.black,
                                            icon: Icons.check,
                                          ),
                                          SlidableAction(
                                            onPressed: (_) {
                                              controller.showRejectDialog(context, index);
                                            },
                                            backgroundColor: AppColor.lightred,
                                            foregroundColor: Colors.black,
                                            icon: Icons.close,
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          color: isSelected ? AppColor.lightred.withOpacity(0.3) : AppColor.lightblue,
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
                                              Container(
                                                width: 50,
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  leaveItem.leaveDays.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
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
                                                        style: const TextStyle(
                                                          fontSize: 17,
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
                                                              const Text(
                                                                "From",
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 4),
                                                              Text(
                                                                leaveItem.fromDate.toString(),
                                                                style: const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors.black54,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(width: 16),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              const Text(
                                                                "To",
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 4),
                                                              Text(
                                                                leaveItem.toDate.toString(),
                                                                style: const TextStyle(
                                                                  fontSize: 14,
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
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Displaying selected items at the end
                  ],
                )
              : const Padding(
                  padding: EdgeInsets.all(15),
                  child: Center(
                    child: Text(
                      "No data available",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
        );
      },
    );
  }
}



// import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
// import 'package:emp_app/app/core/util/app_color.dart';
// import 'package:emp_app/app/moduls/lvotApproval/controller/lvotapproval_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';

// class LvList extends StatelessWidget {
//   const LvList({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Get.put(LvotapprovalController()); // Initialize controller
//     return GetBuilder<LvotapprovalController>(
//       builder: (controller) {
//         return Scaffold(
//           body: controller.isLoader.value
//               ? const Center(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(vertical: 100),
//                     child: ProgressWithIcon(),
//                   ),
//                 )
//               : controller.filteredList.isNotEmpty
//                   ? Column(
//                       children: [
//                         Expanded(
//                           child: Scrollbar(
//                             thickness: 4,
//                             thumbVisibility: false,
//                             radius: Radius.circular(10),
//                             child: ListView.builder(
//                               itemCount: controller.filteredList.length,
//                               itemBuilder: (context, index) {
//                                 final leaveItem = controller.filteredList[index];
//                                 return Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Slidable(
//                                     key: ValueKey(leaveItem.employeeCodeName),
//                                     endActionPane: ActionPane(
//                                       motion: const DrawerMotion(),
//                                       children: [
//                                         SlidableAction(
//                                           onPressed: (_) {
//                                             controller.showApproveDialog(context, index);
//                                           },
//                                           backgroundColor: AppColor.lightwhite,
//                                           foregroundColor: Colors.black,
//                                           icon: Icons.check,
//                                           // label: 'Approve',
//                                         ),
//                                         SlidableAction(
//                                           onPressed: (_) {
//                                             controller.showRejectDialog(context, index);
//                                           },
//                                           backgroundColor: AppColor.lightred,
//                                           foregroundColor: Colors.black,
//                                           icon: Icons.close,
//                                           // label: 'Reject',
//                                         ),
//                                       ],
//                                     ),
//                                     child: Container(
//                                       width: double.infinity,
//                                       padding: const EdgeInsets.all(12.0),
//                                       decoration: BoxDecoration(
//                                         color: AppColor.lightblue,
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       child: IntrinsicHeight(
//                                         child: Row(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Container(
//                                               width: 50, // Fixed width for consistent alignment
//                                               alignment: Alignment.topLeft,
//                                               child: Text(
//                                                 leaveItem.leaveDays.toString(),
//                                                 style: const TextStyle(
//                                                   fontSize: 20,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ),
//                                             // Vertical Divider
//                                             Container(
//                                               width: 2, // Thickness of the divider
//                                               color: AppColor.grey,
//                                             ),
//                                             Expanded(
//                                               child: Padding(
//                                                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                                                 child: Column(
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       leaveItem.employeeCodeName.toString(),
//                                                       style: const TextStyle(
//                                                         fontSize: 17,
//                                                         fontWeight: FontWeight.bold,
//                                                       ),
//                                                       softWrap: true,
//                                                       maxLines: 2,
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                     const SizedBox(height: 10),
//                                                     Row(
//                                                       children: [
//                                                         // From Date
//                                                         Column(
//                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                           children: [
//                                                             const Text(
//                                                               "From",
//                                                               style: TextStyle(
//                                                                 fontWeight: FontWeight.bold,
//                                                                 fontSize: 14,
//                                                               ),
//                                                             ),
//                                                             const SizedBox(height: 4),
//                                                             Text(
//                                                               leaveItem.fromDate.toString(),
//                                                               style: const TextStyle(
//                                                                 fontSize: 14,
//                                                                 color: Colors.black54,
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         const SizedBox(width: 16),
//                                                         // To Date
//                                                         Column(
//                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                           children: [
//                                                             const Text(
//                                                               "To",
//                                                               style: TextStyle(
//                                                                 fontWeight: FontWeight.bold,
//                                                                 fontSize: 14,
//                                                               ),
//                                                             ),
//                                                             const SizedBox(height: 4),
//                                                             Text(
//                                                               leaveItem.toDate.toString(),
//                                                               style: const TextStyle(
//                                                                 fontSize: 14,
//                                                                 color: Colors.black54,
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                             GestureDetector(
//                                               onTap: () async {
//                                                 await controller.lvlistbottomsheet(context, index);
//                                                 controller.update();
//                                               },
//                                               child: Image.asset(
//                                                 'assets/image/bottomsheet.png',
//                                                 width: 50,
//                                                 height: 50,
//                                                 alignment: Alignment.topRight,
//                                               ),
//                                             ),
//                                             // IconButton(
//                                             //   icon: const Icon(Icons.more_vert),
//                                             //   onPressed: () {
//                                             //     controller.lvlistbottomsheet(context, index);
//                                             //   },
//                                             // ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         )
//                       ],
//                     )
//                   : const Padding(
//                       padding: EdgeInsets.all(15),
//                       child: Center(
//                         child: Text(
//                           "No data available",
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ),
//                     ),
//         );
//       },
//     );
//   }
// }
