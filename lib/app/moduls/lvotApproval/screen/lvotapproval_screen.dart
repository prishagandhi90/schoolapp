// ignore_for_file: deprecated_member_use

import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/lvotApproval/controller/lvotapproval_controller.dart';
import 'package:emp_app/app/moduls/lvotApproval/screen/lvlist_screen.dart';
import 'package:emp_app/app/moduls/lvotApproval/screen/otlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
        child: WillPopScope(
          onWillPop: () async {
            // Agar selection mode ON hai to exit kare bina bas selection hataye
            if (controller.isSelectionMode.value) {
              await controller.exitSelectionMode();
              return false; // Screen se exit nahi karega
            }
            return true; // Normal back navigation
          },
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
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () async {
                  if (controller.isSelectionMode.value) {
                    await controller.exitSelectionMode(); // Selection mode se exit karega
                  } else {
                    controller.searchController.clear(); // Search text clear karna
                    controller.activateSearch(false); // Search mode deactivate karna
                    controller.update(); // UI ko refresh karna
                    Navigator.pop(context); // Normal back navigation
                  }
                },
              ),
              centerTitle: true,
            ),
            body: controller.isLoader.value
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 100),
                      child: ProgressWithIcon(),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        controller.isSelectionMode.value
                            ? Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 25),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${controller.selectedItems.length}",
                                                style: TextStyle(
                                                  color: AppColor.black,
                                                  fontWeight: FontWeight.bold,
                                                  // fontSize: 18,
                                                  fontSize: getDynamicHeight(size: 0.020),
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                "selected",
                                                style: TextStyle(
                                                  color: AppColor.black,
                                                  fontWeight: FontWeight.bold,
                                                  // fontSize: 18,
                                                  fontSize: getDynamicHeight(size: 0.020),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                await controller.exitSelectionMode();
                                              },
                                              style: ElevatedButton.styleFrom(backgroundColor: AppColor.lightblue),
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(color: AppColor.black),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
                                        await controller.clearSearch();
                                        await controller.activateSearch(false);
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
                                        await controller.clearSearch();
                                        await controller.activateSearch(false);
                                        controller.HODYN_c.value
                                            ? await controller.fetchLeaveOTList('HOD', controller.selectedLeaveType)
                                            : null;
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
                                        await controller.clearSearch();
                                        await controller.activateSearch(false);
                                        controller.HRYN_c.value
                                            ? await controller.fetchLeaveOTList('HR', controller.selectedLeaveType)
                                            : null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                        const SizedBox(height: 10),
                        Obx(() {
                          // Check if selection mode is active
                          return controller.isSelectionMode.value
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Checkbox(
                                          value: controller.isAllSelected.value,
                                          onChanged: (value) async {
                                            await controller.clearSearch();
                                            controller.isAllSelected.value = value!;

                                            await controller.toggleSelectAll(value);
                                          },
                                        ),
                                        Text(
                                          controller.isAllSelected.value ? "Unselect All" : "Select All",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        bool hasRejectedLeave = controller.selectedItems.any((item) =>
                                            item.typeValue == controller.selectedLeaveType &&
                                            item.inchargeAction?.toLowerCase() == 'rejected');

                                        if (hasRejectedLeave) {
                                          controller.showByPassApproveDialog(context);
                                          return;
                                        }
                                        controller.showApproveAllDialog(context);

                                        // controller.exitSelectionMode(); // Exit selection mode
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
                                        onPressed: () async {
                                          final slidable = Slidable.of(context);
                                          if (slidable != null && slidable.actionPaneType.value != ActionPaneType.none) {
                                            slidable.close(); // Close Slidable if it's open
                                            await Future.delayed(Duration(milliseconds: 300)); // Smooth transition
                                          }
                                          await controller.activateSearch(true);
                                        },
                                      ),
                                    if (controller.isSearchActive)
                                      Expanded(
                                        child: Container(
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            // color: Colors.grey[200],
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                    controller: controller.searchController,
                                                    decoration: InputDecoration(
                                                      hintText: "Search...",
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: AppColor.lightgrey1, width: 1.0),
                                                        borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.012)),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.012)),
                                                        borderSide: BorderSide(
                                                          color: AppColor.black,
                                                        ),
                                                      ),
                                                      prefixIcon: Icon(Icons.search, color: AppColor.lightgrey1),
                                                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                                      hintStyle: AppStyle.plusgrey,
                                                      filled: true,
                                                      fillColor: AppColor.white,
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(getDynamicHeight(size: 0.027))),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      controller.showShortButton = false;
                                                      controller.update();
                                                    },
                                                    onChanged: (value) {
                                                      controller.filterSearchResults(value, controller.selectedLeaveType);
                                                    },
                                                    onTapOutside: (event) {
                                                      FocusScope.of(context).unfocus();
                                                      // Future.delayed(const Duration(milliseconds: 300));
                                                      controller.showShortButton = true;
                                                      controller.update();
                                                    },
                                                    onFieldSubmitted: (v) {
                                                      if (controller.searchController.text.trim().isNotEmpty) {
                                                        controller.fetchLeaveOTList(controller.selectedRole, controller.selectedLeaveType);
                                                        controller.searchController.clear();
                                                      }
                                                      Future.delayed(const Duration(milliseconds: 800));
                                                      controller.showShortButton = true;
                                                      controller.update();
                                                    }),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.cancel),
                                                onPressed: () async {
                                                  await controller.clearSearch();
                                                  await controller.activateSearch(false);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                        }),
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
              // fontSize: 16,
              fontSize: getDynamicHeight(size: 0.018),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
