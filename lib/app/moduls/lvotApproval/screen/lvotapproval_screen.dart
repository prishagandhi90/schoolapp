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
            title: const Text('LV/OT Approval'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        // await controller.changeTab(controller.selectedLeaveType == 'LV' ? 0 : 1);
                        // await controller.fetchLeaveOTList("InCharge", controller.selectedLeaveType);
                        // await controller.changeTab(0);
                        await controller.fetchLeaveOTList("InCharge", 'LV');
                      },
                      child: buildContainer(
                        text: 'InCharge',
                        isSelected: controller.selectedRole == 'InCharge',
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        // await controller.changeTab(controller.selectedLeaveType == 'LV' ? 0 : 1);
                        // await controller.fetchLeaveOTList('HOD', controller.selectedLeaveType);
                        // await controller.changeTab(0);
                        await controller.fetchLeaveOTList('HOD', 'LV');
                      },
                      child: buildContainer(
                        text: 'HOD',
                        isSelected: controller.selectedRole == 'HOD',
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        // await controller.changeTab(controller.selectedLeaveType == 'LV' ? 0 : 1);
                        // await controller.fetchLeaveOTList('HR', controller.selectedLeaveType);
                        // await controller.changeTab(0);
                        await controller.fetchLeaveOTList('HR', 'LV');
                      },
                      child: buildContainer(
                        text: 'HR',
                        isSelected: controller.selectedRole == 'HR',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Dynamic TabBar & Search Bar
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Conditionally show TabBar
                      if (!controller.isSearchActive)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Container(
                            // padding: const EdgeInsets.all(4),
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
                  ),
                ),
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

  Widget buildContainer({required String text, required bool isSelected}) {
    return Container(
      height: 50,
      width: 120,
      decoration: BoxDecoration(
        color: isSelected ? AppColor.lightblue : AppColor.lightwhite,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}


// class LvotapprovalScreen extends StatelessWidget {
//   const LvotapprovalScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Get.put(LvotapprovalController());
//     return GetBuilder<LvotapprovalController>(builder: (controller) {
//       return DefaultTabController(
//         length: 2,
//         initialIndex: 0,
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('LV/OT Approval'),
//             centerTitle: true,
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     GestureDetector(
//                       onTap: () async {
//                         // await controller.selectRole('InCharge');
//                         await controller.fetchLeaveOTList("InCharge", 'LV');
//                       },
//                       child: buildContainer(
//                         text: 'InCharge',
//                         isSelected: controller.selectedRole == 'InCharge',
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () async {
//                         // await controller.selectRole('HOD');
//                         await controller.fetchLeaveOTList('HOD', 'LV');
//                       },
//                       child: buildContainer(
//                         text: 'HOD',
//                         isSelected: controller.selectedRole == 'HOD',
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () async {
//                         // await controller.selectRole('HR');
//                         await controller.fetchLeaveOTList('HR', 'LV');
//                       },
//                       child: buildContainer(
//                         text: 'HR',
//                         isSelected: controller.selectedRole == 'HR',
//                       ),
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         width: MediaQuery.of(context).size.width * 0.45,
//                         child: Container(
//                           padding: const EdgeInsets.all(4),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: AppColor.lightblue,
//                           ),
//                           child: TabBar(
//                             controller: controller.tabController_Lv,
//                             labelColor: AppColor.white,
//                             unselectedLabelColor: AppColor.black,
//                             dividerColor: AppColor.trasparent,
//                             indicatorSize: TabBarIndicatorSize.tab,
//                             onTap: (value) async {
//                               // await controller.fetchLeaveOTList(controller.selectedRole, value == 0 ? 'LV' : 'OT');
//                               await controller.updateFilteredList(controller.selectedRole, value == 0 ? 'LV' : 'OT');
//                             },
//                             labelStyle: TextStyle(fontFamily: CommonFontStyle.plusJakartaSans),
//                             indicator: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: AppColor.primaryColor,
//                             ),
//                             tabs: const [Tab(text: 'LV'), Tab(text: 'OT')],
//                             physics: const NeverScrollableScrollPhysics(),
//                           ),
//                         ),
//                       ),
//                       const Icon(Icons.search),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: TabBarView(
//                     physics: const NeverScrollableScrollPhysics(),
//                     children: [
//                       LvList(),
//                       OtlistScreen(),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }

//   Widget buildContainer({required String text, required bool isSelected}) {
//     return Container(
//       height: 50,
//       width: 120,
//       decoration: BoxDecoration(
//         color: isSelected ? AppColor.primaryColor : AppColor.lightwhite, // Change color based on selection
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Center(
//         child: Text(
//           text,
//           style: TextStyle(
//             color: isSelected ? AppColor.white : Colors.black, // Change text color
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }
