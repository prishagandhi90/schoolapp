import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/moduls/lvotApproval/controller/lvotapproval_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LvList extends StatelessWidget {
  const LvList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LvotapprovalController());
    return GetBuilder<LvotapprovalController>(
      builder: (controller) {
        return Scaffold(
          body: controller.leavelist.isEmpty
              ? Center(
                  child: Text(
                    "No data available.",
                    style: TextStyle(fontSize: 18, color: AppColor.grey),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.leavelist.length,
                        itemBuilder: (context, index) {
                          final leaveItem = controller.leavelist[index]; // Access item safely
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: AppColor.lightblue, // Background color
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Left number
                                    Text(
                                      leaveItem.leaveDays.toString(),
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Container(
                                        width: 2, // Divider width
                                        height: 80, // Divider height
                                        color: AppColor.grey, // Divider color
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:  [
                                          Text(
                                            leaveItem.employeeCodeName.toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
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
                                    // Icon
                                    IconButton(
                                      icon: Icon(Icons.more_vert),
                                      onPressed: () {
                                        controller.lvotlistbottomsheet(context, index);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
        );
      },
    );
  }
}
