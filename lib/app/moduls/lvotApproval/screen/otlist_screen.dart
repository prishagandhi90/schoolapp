import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/moduls/lvotApproval/controller/lvotapproval_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class OtlistScreen extends StatelessWidget {
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
                child: controller.isLoader.value
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 100),
                          child: ProgressWithIcon(),
                        ),
                      )
                    : controller.filteredList.isNotEmpty
                        ? Column(
                            children: [
                              Expanded(
                                child: Scrollbar(
                                  thickness: 4, //According to your choice
                                  thumbVisibility: false, //
                                  radius: Radius.circular(10),
                                  child: ListView.builder(
                                    itemCount: controller.filteredList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      final leaveItem = controller.filteredList[index];
                                      return Center(
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
                                                  // label: 'Approve',
                                                ),
                                                SlidableAction(
                                                  onPressed: (_) {
                                                    controller.showRejectDialog(context, index);
                                                  },
                                                  backgroundColor: AppColor.lightred,
                                                  foregroundColor: Colors.black,
                                                  icon: Icons.close,
                                                  // label: 'Reject',
                                                ),
                                              ],
                                            ),
                                            child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(12.0),
                                              decoration: BoxDecoration(
                                                color: AppColor.lightblue, // Background color
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: IntrinsicHeight(
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 50, // Fixed width for consistent alignment
                                                      alignment: Alignment.topLeft,
                                                      child: Text(
                                                        leaveItem.otHours.toString(),
                                                        style: const TextStyle(
                                                          fontSize: 20,
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
                                                                fontSize: 17,
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
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 4),
                                                                    Text(
                                                                      leaveItem.fromDate.toString(),
                                                                      style: TextStyle(
                                                                        fontSize: 14,
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
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 4),
                                                                    Text(
                                                                      leaveItem.toDate.toString(),
                                                                      style: TextStyle(
                                                                        fontSize: 14,
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
                                                      onTap: () {
                                                        controller.otlistbottomsheet(context, index);
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
