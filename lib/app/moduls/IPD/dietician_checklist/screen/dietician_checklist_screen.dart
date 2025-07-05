// ignore_for_file: must_be_immutable

import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/IPD/admitted%20patient/controller/adpatient_controller.dart';
import 'package:emp_app/app/moduls/IPD/dietician_checklist/controller/dietchecklist_controller.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/moduls/notification/screen/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class DieticianChecklistScreen extends StatelessWidget {
  DieticianChecklistScreen({Key? key}) : super(key: key);
  final dashboardController = Get.isRegistered<DashboardController>() ? Get.find<DashboardController>() : Get.put(DashboardController());
  final AdPatientController adPatientController = Get.put(AdPatientController());
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
                        child: Icon(
                          Icons.filter_alt,
                          color: AppColor.black,
                          size: getDynamicHeight(size: 0.024),
                        ),
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
                              // controller.fetchDeptwisePatientList(isLoader: false);
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
                    // controller.filterSearchResults(value);
                  },
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                    Future.delayed(const Duration(milliseconds: 300));
                    controller.update();
                  },
                  onFieldSubmitted: (v) {
                    if (controller.searchController.text.trim().isNotEmpty) {
                      // controller.fetchDeptwisePatientList(
                      //   searchPrefix: controller.searchController.text.trim(),
                      //   isLoader: false,
                      // );
                      controller.searchController.clear();
                    }
                    Future.delayed(const Duration(milliseconds: 800));
                    controller.update();
                  },
                ),
                SizedBox(height: getDynamicHeight(size: 0.010)),

                /// 🟦 Room Type Tabs
                Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Fixed "ALL" tab
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildTabWithBadge(
                            label: 'ALL',
                            count: 33,
                            isSelected: controller.selectedTabLabel == 'ALL',
                            onTap: () {
                              controller.updateSelectedTab('ALL');
                            },
                          ),
                        ),
                        // Scrollable other tabs
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: tabs.map((tab) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: _buildTabWithBadge(
                                    label: tab['label'],
                                    count: tab['count'],
                                    isSelected: controller.selectedTabLabel == tab['label'],
                                    onTap: () {
                                      controller.updateSelectedTab(tab['label']);
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    )),
                Expanded(
                  child: ListView.builder(
                    controller: controller.adPatientScrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(5),
                    itemCount: adPatientController.filterpatientsData.length,
                    itemBuilder: (context, index) {
                      return _buildPatientCard(index, context, adPatientController);
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

  List<Map<String, dynamic>> tabs = [
    {'label': 'Economy AC', 'count': 9},
    {'label': 'Deluxe', 'count': 8},
    {'label': 'MICU', 'count': 6},
    {'label': 'NICU', 'count': 4},
    // Add more if needed
  ];

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

  Widget _buildPatientCard(int index, BuildContext context, AdPatientController controller) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.filterpatientsData[index].bedNo.toString(),
                  style: TextStyle(color: AppColor.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  controller.filterpatientsData[index].ipdNo.toString(),
                  style: TextStyle(color: AppColor.white),
                ),
                Text(
                  controller.filterpatientsData[index].floor.toString(),
                  style: TextStyle(color: AppColor.white),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(getDynamicHeight(size: 0.010)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 Patient Name + Menu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        controller.filterpatientsData[index].patientName ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Sizes.px16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.menu),
                    ),
                  ],
                ),

                SizedBox(height: getDynamicHeight(size: 0.006)),

                /// 🔹 Doctor Name & Diet
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        controller.filterpatientsData[index].floor ?? '',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Diet: ${controller.filterpatientsData[index].floor ?? ''}",
                        style: TextStyle(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: getDynamicHeight(size: 0.006)),

                /// 🔹 DOA & Diagnosis
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "DOA: ${controller.filterpatientsData[index].doa ?? ''}",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Diagnosis: ${controller.filterpatientsData[index].bedNo ?? ''}",
                        style: TextStyle(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: getDynamicHeight(size: 0.006)),

                /// 🔹 Remarks
                Text(
                  "Remarks: ${controller.filterpatientsData[index].bedNo ?? ''}",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
