import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/moduls/lvotApproval/controller/lvotapproval_controller.dart';
import 'package:emp_app/app/moduls/lvotApproval/screen/lvlist_screen.dart';
import 'package:emp_app/app/moduls/lvotApproval/screen/otlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LvotapprovalScreen extends StatelessWidget {
  const LvotapprovalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LvotapprovalController controller = Get.put(LvotapprovalController());
    controller.currentTabIndex.value = 0;
    return GetBuilder<LvotapprovalController>(builder: (controller) {
      return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'LV/OT Approval',
              style: TextStyle(
                color: AppColor.primaryColor,
                fontWeight: FontWeight.w700,
                fontFamily: CommonFontStyle.plusJakartaSans,
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                controller.isSelectionMode.value
                    ? Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.exitSelectionMode();
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: AppColor.lightblue),
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: AppColor.black),
                            ),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            // onTap: controller.InchargeYN_c.value
                            //     ? () async {
                            //         await controller.fetchLeaveOTList("InCharge", 'LV');
                            //       }
                            // : null,
                            child: buildContainer(
                              text: 'InCharge',
                              isSelected: controller.InchargeYN_c.value ? controller.selectedRole == 'InCharge' : false,
                              // isEnabled: controller.getRoleStatus('InCharge'), // Check API status
                              isEnabled: controller.InchargeYN_c.value,
                              onTap: () async {
                                controller.InchargeYN_c.value
                                    ? await controller.fetchLeaveOTList("InCharge", controller.selectedLeaveType)
                                    : null;
                              },
                            ),
                          ),
                          GestureDetector(
                            // onTap: controller.HODYN_c.value
                            //     ? () async {
                            //         await controller.fetchLeaveOTList("HOD", 'LV');
                            //       }
                            //     : null,
                            child: buildContainer(
                              text: 'HOD',
                              isSelected: controller.HODYN_c.value ? controller.selectedRole == 'HOD' : false,
                              // isEnabled: controller.getRoleStatus('HOD'), // Check API status
                              isEnabled: controller.HODYN_c.value,
                              onTap: () async {
                                controller.HODYN_c.value ? await controller.fetchLeaveOTList('HOD', controller.selectedLeaveType) : null;
                              },
                            ),
                          ),
                          GestureDetector(
                            // onTap: controller.HRYN_c.value
                            //     ? () async {
                            //         await controller.fetchLeaveOTList("HR", 'LV');
                            //       }
                            //     : null,
                            child: buildContainer(
                              text: 'HR',
                              isSelected: controller.HRYN_c.value ? controller.selectedRole == 'HR' : false,
                              // isEnabled: controller.getRoleStatus('HR'), // Check API status
                              isEnabled: controller.HRYN_c.value,
                              onTap: () async {
                                controller.HRYN_c.value ? await controller.fetchLeaveOTList('HR', controller.selectedLeaveType) : null;
                              },
                            ),
                          ),
                        ],
                      ),

                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Obx(() {
                    // Check if selection mode is active
                    return controller.isSelectionMode.value
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: controller.isAllSelected.value,
                                      onChanged: (value) {
                                        controller.toggleSelectAll(value!);
                                      },
                                    ),
                                    const Text(
                                      "Select All",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    controller.exitSelectionMode(); // Exit selection mode
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.lightgreen,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text("Approve"),
                                ),
                              ],
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Conditionally show TabBar
                              if (!controller.isSearchActive)
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  width: MediaQuery.of(context).size.width * 0.45,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColor.lightblue,
                                    ),
                                    child: TabBar(
                                      controller: controller.tabController_Lv,
                                      labelColor: AppColor.white,
                                      unselectedLabelColor: AppColor.black,
                                      dividerColor: AppColor.transparent,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      onTap: (value) async {
                                        await controller.updateFilteredList(
                                          controller.selectedRole,
                                          value == 0 ? 'LV' : 'OT',
                                        );
                                      },
                                      labelStyle: TextStyle(fontFamily: CommonFontStyle.plusJakartaSans),
                                      indicator: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColor.primaryColor,
                                      ),
                                      tabs: const [Tab(text: 'LV'), Tab(text: 'OT')],
                                      physics: const NeverScrollableScrollPhysics(),
                                    ),
                                  ),
                                ),
                              if (!controller.isSearchActive)
                                IconButton(
                                  icon: const Icon(Icons.search),
                                  onPressed: () {
                                    controller.activateSearch(true);
                                  },
                                ),
                              if (controller.isSearchActive)
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[200],
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: controller.searchController,
                                            decoration: const InputDecoration(
                                              hintText: "Search...",
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                            ),
                                            onChanged: (value) {
                                              controller.filterSearchResults(value, controller.selectedLeaveType);
                                            },
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.cancel),
                                          onPressed: () {
                                            controller.clearSearch();
                                            controller.activateSearch(false);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          );
                  }),
                ),
                // Dynamic TabBar & Search Bar
                // Padding(
                //   padding: const EdgeInsets.only(left: 8.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       // Conditionally show TabBar
                //       if (!controller.isSearchActive)
                //         Container(
                //           padding: const EdgeInsets.symmetric(vertical: 10),
                //           width: MediaQuery.of(context).size.width * 0.45,
                //           child: Container(
                //             // padding: const EdgeInsets.all(4),
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(10),
                //               color: AppColor.lightblue,
                //             ),
                //             child: TabBar(
                //               controller: controller.tabController_Lv,
                //               labelColor: AppColor.white,
                //               unselectedLabelColor: AppColor.black,
                //               dividerColor: AppColor.transparent,
                //               indicatorSize: TabBarIndicatorSize.tab,
                //               onTap: (value) async {
                //                 await controller.updateFilteredList(
                //                   controller.selectedRole,
                //                   value == 0 ? 'LV' : 'OT',
                //                 );
                //               },
                //               labelStyle: TextStyle(fontFamily: CommonFontStyle.plusJakartaSans),
                //               indicator: BoxDecoration(
                //                 borderRadius: BorderRadius.circular(10),
                //                 color: AppColor.primaryColor,
                //               ),
                //               tabs: const [Tab(text: 'LV'), Tab(text: 'OT')],
                //               physics: const NeverScrollableScrollPhysics(),
                //             ),
                //           ),
                //         ),

                //       if (!controller.isSearchActive)
                //         IconButton(
                //           icon: const Icon(Icons.search),
                //           onPressed: () {
                //             controller.activateSearch(true);
                //           },
                //         ),
                //       if (controller.isSearchActive)
                //         Expanded(
                //           child: Container(
                //             height: 50,
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(10),
                //               color: Colors.grey[200],
                //             ),
                //             child: Row(
                //               children: [
                //                 Expanded(
                //                   child: TextField(
                //                     controller: controller.searchController,
                //                     decoration: const InputDecoration(
                //                       hintText: "Search...",
                //                       border: InputBorder.none,
                //                       contentPadding: EdgeInsets.symmetric(horizontal: 16),
                //                     ),
                //                     onChanged: (value) {
                //                       controller.filterSearchResults(value, controller.selectedLeaveType);
                //                     },
                //                   ),
                //                 ),
                //                 IconButton(
                //                   icon: const Icon(Icons.cancel),
                //                   onPressed: () {
                //                     controller.clearSearch();
                //                     controller.activateSearch(false);
                //                   },
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                    controller: controller.tabController_Lv,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      LvList(),
                      OtlistScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildContainer({
    required String text,
    required bool isSelected,
    required bool isEnabled,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null, // Disable onTap if not enabled
      child: Container(
        height: 50,
        width: 120,
        decoration: BoxDecoration(
          color: isSelected ? (isEnabled ? AppColor.lightblue : AppColor.red) : AppColor.lightwhite,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isEnabled ? Colors.black : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
