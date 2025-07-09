// ignore_for_file: must_be_immutable

import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/IPD/dietician_checklist/controller/dietchecklist_controller.dart';
import 'package:emp_app/app/moduls/IPD/dietician_checklist/model/dieticianfilterwardnm_model.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/moduls/notification/screen/notification_screen.dart';
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
                padding: EdgeInsets.only(right: 13),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Filter icon
                    GestureDetector(
                      onTap: () {
                        // controller.showSortFilterBottomSheet(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 10), // 👈 Minimal spacing between icons
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
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  dashboardController.notificationCount,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  cursorColor: AppColor.black,
                  controller: controller.searchController,
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
                              FocusScope.of(context).unfocus();
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
                    FocusScope.of(context).unfocus();
                    Future.delayed(const Duration(milliseconds: 300));
                    controller.update();
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
                SizedBox(height: getDynamicHeight(size: 0.010)),

                /// 🟦 Room Type Tabs
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔵 Static ALL tab from API
                      if (controller.allTabs.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildTabWithBadge(
                            label: controller.allTabs.first.shortWardName ?? '',
                            count: controller.allTabs.first.wardCount ?? 0,
                            isSelected: controller.selectedTabLabel == controller.allTabs.first.shortWardName,
                            onTap: () {
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
                                padding: const EdgeInsets.only(right: 8),
                                child: _buildTabWithBadge(
                                  label: tab.shortWardName ?? '',
                                  count: tab.wardCount ?? 0,
                                  isSelected: controller.selectedTabLabel == tab.shortWardName,
                                  onTap: () => tab.wardCount! > 0 ? controller.updateSelectedTab(tab.shortWardName.toString()) : null,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: controller.dieticianScrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: getDynamicHeight(size: 0.009)),
                    itemCount: controller.filterdieticianList.length,
                    itemBuilder: (context, index) {
                      return _buildPatientCard(index, context, controller);
                    },
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColor.teal : Colors.white,
              border: Border.all(color: AppColor.teal),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColor.teal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.teal,
                shape: BoxShape.circle,
              ),
              child: Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(int index, BuildContext context, DietchecklistController controller) {
    bool isRecordUnsaved =
        (controller.filterdieticianList[index].diagnosis.toString().isEmpty || controller.filterdieticianList[index].diagnosis.toString().toLowerCase() == "null") &&
            (controller.filterdieticianList[index].username.toString().isEmpty || controller.filterdieticianList[index].username.toString().toLowerCase() == "null") &&
            (controller.filterdieticianList[index].dietPlan.toString().isEmpty || controller.filterdieticianList[index].dietPlan.toString().toLowerCase() == "null") &&
            (controller.filterdieticianList[index].relFoodRemark.toString().isEmpty ||
                controller.filterdieticianList[index].relFoodRemark.toString().toLowerCase() == "null") &&
            (controller.filterdieticianList[index].remark.toString().isEmpty || controller.filterdieticianList[index].remark.toString().toLowerCase() == "null");
    return GestureDetector(
      onTap: () {
        controller.showDietDialog(context, index);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔷 Header
            Container(
              decoration: BoxDecoration(
                color: isRecordUnsaved ? AppColor.yellow : AppColor.primaryColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(controller.filterdieticianList[index].bedNo.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                      )),
                  Text(controller.filterdieticianList[index].ipdNo.toString(), style: const TextStyle(color: Colors.white)),
                  Text(
                    "${controller.filterdieticianList[index].wardName.toString()} - Floor ${controller.filterdieticianList[index].floorNo.toString()}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            /// 🔽 Body
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                          style: TextStyle(
                            fontSize: Sizes.px15,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => controller.dieticianBottomSheet(index),
                        child: const Icon(Icons.menu, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  /// 🟨 Row 1: Dr Name + Diet
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Dr Name
                      Expanded(
                        child: Text(
                          controller.filterdieticianList[index].doctor.toString(),
                          style: TextStyle(
                            fontSize: getDynamicHeight(size: 0.015),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      /// Diet
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: 'Diet: ',
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
                  const SizedBox(height: 6),

                  /// 🟨 Row 2: DOA + Diagnosis
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// DOA
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: 'DOA: ',
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
                      const SizedBox(width: 8),

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
                  const SizedBox(height: 6),

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
