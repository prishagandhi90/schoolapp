// ignore_for_file: must_be_immutable

import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/app_image.dart';
import 'package:schoolapp/app/core/util/app_string.dart';
import 'package:schoolapp/app/core/util/app_style.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:schoolapp/app/modules/IPD/dietician_checklist/controller/dietchecklist_controller.dart';
import 'package:schoolapp/app/modules/dashboard/controller/dashboard_controller.dart';
import 'package:schoolapp/app/modules/notification/screen/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class DieticianChecklistScreen extends StatelessWidget {
  DieticianChecklistScreen({Key? key}) : super(key: key);
  final dashboardController = Get.isRegistered<DashboardController>() ? Get.find<DashboardController>() : Get.put(DashboardController());
  @override
  Widget build(BuildContext context) {
    Get.put(DietchecklistController());
    return GetBuilder<DietchecklistController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(
            title: Text(AppString.dietchecklist, style: AppStyle.primaryplusw700),
            centerTitle: true,
            backgroundColor: AppColor.white,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: getDynamicHeight(size: 0.013)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Filter icon
                    GestureDetector(
                      onTap: () {
                        // controller.showSortFilterBottomSheet(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: getDynamicHeight(size: 0.010)), // 👈 Minimal spacing between icons
                        child: IconButton(
                            onPressed: () {
                              controller.dietFiltterBottomSheet();
                            },
                            icon: Icon(
                              Icons.filter_alt,
                              color: AppColor.black,
                              size: getDynamicHeight(size: 0.024),
                            )),
                      ),
                    ),
                    // Notification icon with badge
                    GestureDetector(
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: NotificationScreen(),
                          withNavBar: false,
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        ).then((value) async {});
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Image.asset(
                            AppImage.notification,
                            width: getDynamicHeight(size: 0.022),
                          ),
                          if (dashboardController.notificationCount != "0")
                            Positioned(
                              right: -2,
                              top: -6,
                              child: Container(
                                padding: EdgeInsets.all(getDynamicHeight(size: 0.004)),
                                decoration: BoxDecoration(
                                  color: AppColor.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  dashboardController.notificationCount,
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: getDynamicHeight(size: 0.010),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(getDynamicHeight(size: 0.008)),
            child: Column(
              children: [
                TextFormField(
                  cursorColor: AppColor.black,
                  controller: controller.searchController,
                  focusNode: controller.searchFocusNode,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(getDynamicHeight(size: 0.012)),
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
                    suffixIcon: controller.searchController.text.trim().isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              // FocusScope.of(context).unfocus();
                              controller.searchFocusNode.unfocus();
                              controller.searchController.clear();
                              controller.fetchDieticianList();
                            },
                            child: const Icon(Icons.cancel_outlined))
                        : const SizedBox(),
                    prefixIcon: Icon(Icons.search, color: AppColor.lightgrey1),
                    hintText: AppString.search,
                    hintStyle: AppStyle.plusgrey,
                    filled: true,
                    fillColor: AppColor.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(getDynamicHeight(size: 0.027))),
                    ),
                  ),
                  onTap: () {
                    controller.update();
                  },
                  onChanged: (value) {
                    controller.filterSearchResults(value);
                  },
                  onTapOutside: (event) {
                    // FocusScope.of(context).unfocus();
                    Future.delayed(const Duration(milliseconds: 300));
                    controller.update();
                    controller.searchFocusNode.unfocus();
                  },
                  onFieldSubmitted: (v) {
                    if (controller.searchController.text.trim().isNotEmpty) {
                      controller.fetchDieticianList(
                        searchPrefix: controller.searchController.text.trim(),
                      );
                      controller.searchController.clear();
                    }
                    Future.delayed(const Duration(milliseconds: 800));
                    controller.update();
                  },
                ),
                SizedBox(height: getDynamicHeight(size: 0.005)),

                /// 🟦 Room Type Tabs
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔵 Static ALL tab from API
                    if (controller.allTabs.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(
                          right: getDynamicHeight(size: 0.008),
                          top: getDynamicHeight(size: 0.006),
                        ),
                        child: _buildTabWithBadge(
                          label: controller.allTabs.first.shortWardName ?? '',
                          count: controller.allTabs.first.wardCount ?? 0,
                          isSelected: controller.selectedTabLabel == controller.allTabs.first.shortWardName,
                          onTap: () {
                            controller.isBottomFilterApplied = false; // ✅ tab use = no filter
                            controller.updateSelectedTab(controller.allTabs.first.shortWardName.toString());
                          },
                        ),
                      ),
                    // 🔵 Scrollable other tabs
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: controller.otherTabs.map((tab) {
                            return Padding(
                              padding: EdgeInsets.only(
                                right: getDynamicHeight(size: 0.008),
                                top: getDynamicHeight(size: 0.006),
                              ), // 👈 Added top padding here
                              child: _buildTabWithBadge(
                                  label: tab.shortWardName ?? '',
                                  count: tab.wardCount ?? 0,
                                  isSelected: controller.selectedTabLabel == tab.shortWardName,
                                  onTap: () {
                                    controller.isBottomFilterApplied = false; // ✅ tab use = no filter
                                    tab.wardCount! > 0 ? controller.updateSelectedTab(tab.shortWardName.toString()) : null;
                                  }),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: getDynamicHeight(size: 0.009)),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            if (controller.isBottomFilterApplied) {
                              // ✅ Agar filter laga ho to yeh hamesha chale
                              if (controller.allTabs.isNotEmpty) {
                                controller.updateSelectedTab(controller.allTabs.first.shortWardName ?? '');
                              }
                              await controller.fetchDieticianList();
                            } else {
                              // ✅ Agar tab select ho to uske hisaab se refresh
                              await controller.fetchDieticianList(isTabFilter: true);
                            }
                          },
                          child: ListView.builder(
                            controller: controller.dieticianScrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(vertical: getDynamicHeight(size: 0.002)),
                            itemCount: controller.filterdieticianList.length,
                            itemBuilder: (context, index) {
                              return _buildPatientCard(index, context, controller);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabWithBadge({
    required String label,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: getDynamicHeight(size: 0.016),
              vertical: getDynamicHeight(size: 0.010),
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColor.teal : AppColor.white,
              border: Border.all(color: AppColor.teal),
              borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.015)),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColor.white : AppColor.teal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              padding: EdgeInsets.all(getDynamicHeight(size: 0.006)),
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                count.toString(),
                style: AppStyle.white.copyWith(
                  fontSize: getDynamicHeight(size: 0.0098),
                  fontWeight: FontWeight.bold,
                ),
                // style: const TextStyle(
                //   color: Colors.white,
                //   fontSize: 10,
                //   fontWeight: FontWeight.bold,
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(int index, BuildContext context, DietchecklistController controller) {
    bool isRecordUnsaved = (controller.filterdieticianList[index].diagnosis.toString().isEmpty ||
            controller.filterdieticianList[index].diagnosis.toString().toLowerCase() == "null") &&
        (controller.filterdieticianList[index].username.toString().isEmpty ||
            controller.filterdieticianList[index].username.toString().toLowerCase() == "null") &&
        (controller.filterdieticianList[index].dietPlan.toString().isEmpty ||
            controller.filterdieticianList[index].dietPlan.toString().toLowerCase() == "null") &&
        (controller.filterdieticianList[index].relFoodRemark.toString().isEmpty ||
            controller.filterdieticianList[index].relFoodRemark.toString().toLowerCase() == "null") &&
        (controller.filterdieticianList[index].remark.toString().isEmpty ||
            controller.filterdieticianList[index].remark.toString().toLowerCase() == "null");
    return GestureDetector(
      onTap: () {
        // FocusScope.of(context).unfocus();
        controller.showDietDialog(context, index);
        controller.searchFocusNode.unfocus();
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              getDynamicHeight(size: 0.0098),
            ),
            side: BorderSide(
              color: isRecordUnsaved ? const Color.fromARGB(255, 243, 231, 122) : AppColor.primaryColor,
            )),
        margin: EdgeInsets.symmetric(
          vertical: getDynamicHeight(size: 0.0078),
          horizontal: getDynamicHeight(size: 0.0039),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔷 Header
            Container(
              decoration: BoxDecoration(
                color: isRecordUnsaved ? AppColor.yellow : AppColor.primaryColor,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                  getDynamicHeight(size: 0.0098),
                )),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: getDynamicHeight(size: 0.0118),
                vertical: getDynamicHeight(size: 0.0058),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(controller.filterdieticianList[index].bedNo.toString(),
                      style: TextStyle(
                        color: AppColor.white,
                      )),
                  Text(
                    controller.filterdieticianList[index].ipdNo.toString(),
                    style: TextStyle(color: AppColor.white),
                  ),
                  Text(
                    "${controller.filterdieticianList[index].wardName.toString()} - Floor ${controller.filterdieticianList[index].floorNo.toString()}",
                    style: TextStyle(color: AppColor.white),
                  ),
                ],
              ),
            ),

            /// 🔽 Body
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getDynamicHeight(size: 0.0118),
                vertical: getDynamicHeight(size: 0.0078),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🟦 Patient Name + Menu icon (Same Line)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          controller.filterdieticianList[index].patientName.toString(),
                          style: AppStyle.black.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryColor,
                          ),
                          // style: TextStyle(
                          //   fontSize: Sizes.px15,
                          //   fontWeight: FontWeight.bold,
                          //   color: AppColor.primaryColor,
                          // ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => controller.dieticianBottomSheet(index),
                        child: Icon(
                          Icons.menu,
                          size: getDynamicHeight(size: 0.0195),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getDynamicHeight(size: 0.0078)),

                  /// 🟨 Row 1: Dr Name + Diet
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Dr Name
                      Expanded(
                        child: Text(
                          controller.filterdieticianList[index].doctor.toString(),
                          style: AppStyle.black,
                          // style: TextStyle(
                          //   fontSize: getDynamicHeight(size: 0.015),
                          //   fontWeight: FontWeight.w600,
                          // ),
                        ),
                      ),
                      SizedBox(width: getDynamicHeight(size: 0.0078)),

                      /// Diet
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: AppString.diet,
                            style: AppStyle.plusbold16.copyWith(
                              fontSize: getDynamicHeight(size: 0.014),
                            ),
                            children: [
                              TextSpan(
                                text: controller.filterdieticianList[index].dietPlan.toString(),
                                style: AppStyle.w50018.copyWith(
                                  fontSize: getDynamicHeight(size: 0.014),
                                  color: AppColor.originalgrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getDynamicHeight(size: 0.0059)),

                  /// 🟨 Row 2: DOA + Diagnosis
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// DOA
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: AppString.doa,
                            style: AppStyle.plusbold16.copyWith(
                              fontSize: getDynamicHeight(size: 0.014),
                            ),
                            children: [
                              TextSpan(
                                text: DateFormat('dd-MM-yy').format(
                                  DateTime.parse(controller.filterdieticianList[index].doa.toString()),
                                ),
                                style: AppStyle.w50018.copyWith(
                                  fontSize: getDynamicHeight(size: 0.014),
                                  color: AppColor.originalgrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: getDynamicHeight(size: 0.0078)),

                      /// Diagnosis
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: 'Diagnosis: ',
                            style: AppStyle.plusbold16.copyWith(
                              fontSize: getDynamicHeight(size: 0.014),
                            ),
                            children: [
                              TextSpan(
                                text: controller.filterdieticianList[index].diagnosis.toString(),
                                style: AppStyle.w50018.copyWith(
                                  fontSize: getDynamicHeight(size: 0.014),
                                  color: AppColor.originalgrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getDynamicHeight(size: 0.0059)),

                  /// 🟨 Remarks (Last line)
                  Text.rich(
                    TextSpan(
                      text: 'Remark: ',
                      style: AppStyle.plusbold16.copyWith(
                        fontSize: getDynamicHeight(size: 0.014),
                      ),
                      children: [
                        TextSpan(
                          text: controller.filterdieticianList[index].remark.toString(),
                          style: AppStyle.w50018.copyWith(
                            fontSize: getDynamicHeight(size: 0.014),
                            color: AppColor.originalgrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
