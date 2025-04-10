// ignore_for_file: deprecated_member_use

import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/bottombar/screen/bottom_bar_screen.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/moduls/pharmacy/controller/pharmacy_controller.dart';
import 'package:emp_app/app/moduls/pharmacy/screen/presdetails_screen.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class PresviewerScreen extends StatelessWidget {
  PresviewerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PharmacyController());
    return GetBuilder<PharmacyController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(
            backgroundColor: AppColor.white,
            automaticallyImplyLeading: false,
            title: Text(
              AppString.prescriptionviewer,
              style: AppStyle.primaryplusw700,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.white, // Set your default color here
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                // WidgetsBinding.instance.addPostFrameCallback((_) {
                final bottomBarController = Get.find<BottomBarController>();
                bottomBarController.isPharmacyHome.value = true;
                bottomBarController.persistentController.value.index = 0; // Set index to Payroll tab
                bottomBarController.currentIndex.value = 0;
                hideBottomBar.value = false;
                // Get.back();
                Get.offAll(() => BottomBarView());
                // });
              },
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Get.snackbar(
                      AppString.comingsoon,
                      '',
                      colorText: AppColor.white,
                      backgroundColor: AppColor.black,
                      duration: const Duration(seconds: 1),
                    );
                  },
                  icon: Image.asset(
                    AppImage.notification,
                    width: getDynamicHeight(size: 0.022),
                  ))
            ],
            centerTitle: true,
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(getDynamicHeight(size: 0.012)),
                child: Row(
                  children: [
                    // Search Bar (60%)
                    Expanded(
                      flex: 7,
                      child: WillPopScope(
                        onWillPop: () async {
                          // Unfocus the TextFormField and dismiss the keyboard
                          FocusScope.of(context).unfocus();
                          return true; // Allow navigation to go back
                        },
                        child: TextFormField(
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
                                      controller.fetchpresViewer(isLoader: false);
                                    },
                                    child: const Icon(Icons.cancel_outlined))
                                : const SizedBox(),
                            prefixIcon: Icon(Icons.search, color: AppColor.lightgrey1),
                            hintText: AppString.searchpatient,
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
                            controller.filterSearchResults(value);
                            // controller.searchController.clear();
                          },
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                            // Future.delayed(const Duration(milliseconds: 300));
                            controller.showShortButton = true;
                            controller.update();
                          },
                          onFieldSubmitted: (v) {
                            if (controller.searchController.text.trim().isNotEmpty) {
                              controller.fetchpresViewer(
                                searchPrefix: controller.searchController.text.trim(),
                                isLoader: false,
                              );
                              controller.searchController.clear();
                            }
                            Future.delayed(const Duration(milliseconds: 800));
                            controller.showShortButton = true;
                            controller.update();
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: getDynamicHeight(size: 0.010)), // Space between items
                    Expanded(
                      flex: 1.5.toInt(),
                      child: Container(
                        height: MediaQuery.of(context).size.width > 600
                            ? getDynamicHeight(size: 0.030) * 1.2 // iPad pe 20% zyada
                            : MediaQuery.of(context).size.width < 360
                                ? getDynamicHeight(size: 0.090) // Small Screen pe zyada height
                                : getDynamicHeight(size: 0.050), // Normal Screen
                        // height: getDynamicHeight(size: 0.052), // Adjust height as needed
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.black),
                          borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.012)),
                        ),
                        child: Center(
                            child: GestureDetector(
                                onTap: () {
                                  controller.sortBy();
                                },
                                child: Image.asset(
                                  AppImage.filter,
                                ))),
                      ),
                    ),
                    SizedBox(width: getDynamicHeight(size: 0.010)), // Space between items
                    Expanded(
                      flex: 1.5.toInt(),
                      child: Container(
                        // height: 50, // Adjust height as needed
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.black),
                          borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.012)),
                        ),
                        child: Center(
                          child: IconButton(
                            icon: Icon(Icons.filter_alt, color: AppColor.black, size: getDynamicHeight(size: 0.027)),
                            onPressed: () async {
                              controller.callFilterAPi = false;
                              controller.tempWardList = List.unmodifiable(controller.selectedWardList);
                              controller.tempFloorsList = List.unmodifiable((controller.selectedFloorList));
                              controller.tempBedList = List.unmodifiable(controller.selectedBedList);

                              await controller.pharmacyFiltterBottomSheet();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              controller.isLoading
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: getDynamicHeight(size: 0.102)),
                      child: Center(child: ProgressWithIcon()),
                    )
                  : Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // double ConstraintsHeight = constraints.maxHeight; // Ensure scrolling
                          return Scrollbar(
                            thickness: getDynamicHeight(size: 0.007), //According to your choice
                            thumbVisibility: false, //
                            radius: Radius.circular(getDynamicHeight(size: 0.012)),
                            child: RefreshIndicator(
                              onRefresh: () async {
                                await controller.fetchpresViewer();
                              },
                              child: SizedBox(
                                // height: ConstraintsHeight - 80.0,
                                child: controller.filterpresviewerList.isEmpty
                                    ? Center(
                                        child: Text(
                                          "No data found",
                                          style: TextStyle(
                                            // fontSize: 18,
                                            fontSize: getDynamicHeight(size: 0.020),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: controller.filterpresviewerList.length,
                                        // controller: scrollController,
                                        // controller: controller.pharmacyviewScrollController,
                                        physics: AlwaysScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.all(getDynamicHeight(size: 0.010)),
                                            child: GestureDetector(
                                              onTap: () async {
                                                if (controller.isPresMedicineNavigating.value) return;
                                                controller.isPresMedicineNavigating.value = true;

                                                if (controller.empModuleScreenRightsTable.isNotEmpty) {
                                                  if (controller.empModuleScreenRightsTable[0].rightsYN == "N") {
                                                    controller.isPresViewerNavigating.value = false;
                                                    Get.snackbar(
                                                      "You don't have access to this screen",
                                                      '',
                                                      colorText: AppColor.white,
                                                      backgroundColor: AppColor.black,
                                                      duration: const Duration(seconds: 1),
                                                    );
                                                    return;
                                                  }
                                                }

                                                controller.SelectedIndex = index;
                                                controller.fetchpresDetailList(controller.filterpresviewerList[index].mstId.toString());

                                                // final bottomBarController = Get.put(BottomBarController());
                                                // bottomBarController.currentIndex.value = -1;
                                                // hideBottomBar.value = false;
                                                controller.showScrollDownArrow.value = false;
                                                controller.showScrollUpArrow.value = false;
                                                PersistentNavBarNavigator.pushNewScreen(
                                                  context,
                                                  screen: PresdetailsScreen(),
                                                  withNavBar: false,
                                                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                                ).then((value) async {
                                                  controller.searchController.clear();
                                                  await controller.fetchpresViewer();
                                                  final bottomBarController = Get.put(BottomBarController());
                                                  // bottomBarController.currentIndex.value = -1;
                                                  // hideBottomBar.value = true;
                                                  bottomBarController.persistentController.value.index = 0;
                                                  bottomBarController.currentIndex.value = 0;
                                                  bottomBarController.isPharmacyHome.value = true;
                                                  hideBottomBar.value = true;
                                                  controller.isPresMedicineNavigating.value = false;

                                                  // var dashboardController = Get.put(DashboardController());
                                                  // await dashboardController.getDashboardDataUsingToken();
                                                });
                                                controller.isPresMedicineNavigating.value = false;
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(vertical: getDynamicHeight(size: 0.012), horizontal: getDynamicHeight(size: 0.012)),
                                                decoration: BoxDecoration(
                                                  // color: controller.filterpresviewerList[index].printStatus.toString().toLowerCase() ==
                                                  //         "printed"
                                                  color: controller.filterpresviewerList[index].rxStatus.toString().toLowerCase() == "working"
                                                      ? AppColor.lightyellow
                                                      : AppColor.lightblue,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        // Left side: Index
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.007)), // Space between index and right side
                                                          child: Text(
                                                            "${index + 1}", // Dynamic index
                                                            style: AppStyle.w50018.copyWith(
                                                              // fontSize: 17,
                                                              fontSize: getDynamicHeight(size: 0.019),
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                        // Right side: Text and Container
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.end, // Align text and container to the right
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              // Text
                                                              Text(
                                                                controller.filterpresviewerList[index].org.toString(), // Add your custom text
                                                                style: TextStyle(
                                                                  // fontSize: 16,
                                                                  fontSize: getDynamicHeight(size: 0.018),
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                              const SizedBox(width: 20), // Minimal space between text and container
                                                              // Container
                                                              Container(
                                                                // height: 35, // Small container size
                                                                height: getDynamicHeight(size: 0.037),
                                                                margin: EdgeInsets.only(bottom: getDynamicHeight(size: 0.007)), // Adjust positioning if needed
                                                                decoration: BoxDecoration(
                                                                  color: Colors.grey[200],
                                                                  borderRadius: BorderRadius.circular(8),
                                                                ),
                                                                child: IconButton(
                                                                  icon: Icon(
                                                                    Icons.shopping_cart,
                                                                    // size: 18,
                                                                    size: getDynamicHeight(size: 0.020),
                                                                  ),
                                                                  onPressed: () async {
                                                                    try {
                                                                      if (controller.isPresMedicineNavigating.value) return;
                                                                      controller.isPresMedicineNavigating.value = true;
                                                                      if (controller.empModuleScreenRightsTable.isNotEmpty) {
                                                                        if (controller.empModuleScreenRightsTable[0].rightsYN == "N") {
                                                                          controller.isPresViewerNavigating.value = false;
                                                                          Get.snackbar(
                                                                            "You don't have access to this screen",
                                                                            '',
                                                                            colorText: AppColor.white,
                                                                            backgroundColor: AppColor.black,
                                                                            duration: const Duration(seconds: 1),
                                                                          );
                                                                          return;
                                                                        }
                                                                      }
                                                                      controller.isPresMedicineNavigating.value = true;
                                                                      controller.SelectedIndex = index;

                                                                      controller.fetchpresDetailList(
                                                                        controller.filterpresviewerList[index].mstId.toString(),
                                                                      );
                                                                      controller.showScrollDownArrow.value = false;
                                                                      controller.showScrollUpArrow.value = false;
                                                                      controller.isPresMedicineNavigating.value = false;
                                                                      PersistentNavBarNavigator.pushNewScreen(
                                                                        context,
                                                                        screen: PresdetailsScreen(),
                                                                        withNavBar: false,
                                                                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                                                      ).then((value) async {
                                                                        final bottomBarController = Get.put(BottomBarController());
                                                                        bottomBarController.persistentController.value.index = 0;
                                                                        bottomBarController.currentIndex.value = 0;
                                                                        bottomBarController.isPharmacyHome.value = true;
                                                                        hideBottomBar.value = true;
                                                                        var dashboardController = Get.put(DashboardController());
                                                                        await dashboardController.getDashboardDataUsingToken();
                                                                        controller.isPresMedicineNavigating.value = false;
                                                                      });
                                                                      controller.isPresMedicineNavigating.value = false;
                                                                    } catch (e) {
                                                                      print("Error in navigation: $e");
                                                                      Get.snackbar("Error", "$e");
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.006)),
                                                      child: Text(
                                                        controller.filterpresviewerList[index].patientName.toString(),
                                                        style: AppStyle.w50018.copyWith(
                                                          // fontSize: 17,
                                                          fontSize: getDynamicHeight(size: 0.019),
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text.rich(
                                                                  TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                          text: AppString.rxview, // Heading
                                                                          style: AppStyle.plusbold16.copyWith(
                                                                            // fontSize: 16,
                                                                            fontSize: getDynamicHeight(size: 0.018),
                                                                          )),
                                                                      TextSpan(
                                                                          text: controller.filterpresviewerList[index].printStatus.toString(), // Data
                                                                          style: AppStyle.w50018.copyWith(
                                                                            // fontSize: 16,
                                                                            fontSize: getDynamicHeight(size: 0.018),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(height: getDynamicHeight(size: 0.007)), // Space between IPD and MOP
                                                                Text.rich(
                                                                  TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                          text: AppString.lastuser, // Heading
                                                                          style: AppStyle.plusbold16.copyWith(
                                                                            // fontSize: 16,
                                                                            fontSize: getDynamicHeight(size: 0.018),
                                                                          )),
                                                                      TextSpan(
                                                                          text: controller.filterpresviewerList[index].lastUser.toString(), // Data
                                                                          style: AppStyle.w50018.copyWith(
                                                                            // fontSize: 16,
                                                                            fontSize: getDynamicHeight(size: 0.018),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(height: getDynamicHeight(size: 0.007)), // Space between IPD and MOP
                                                                Text.rich(
                                                                  TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                          text: AppString.ipdNo, // Heading
                                                                          style: AppStyle.plusbold16.copyWith(
                                                                            // fontSize: 16,
                                                                            fontSize: getDynamicHeight(size: 0.018),
                                                                          )),
                                                                      TextSpan(
                                                                          text: controller.filterpresviewerList[index].ipd.toString(), // Data
                                                                          style: AppStyle.w50018.copyWith(
                                                                            // fontSize: 16,
                                                                            fontSize: getDynamicHeight(size: 0.018),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                horizontal: getDynamicHeight(size: 0.011),
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text.rich(
                                                                    TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                            text: AppString.priority, // Heading
                                                                            style: AppStyle.plusbold16.copyWith(
                                                                              // fontSize: 16,
                                                                              fontSize: getDynamicHeight(size: 0.018),
                                                                            )),
                                                                        TextSpan(
                                                                            text: controller.filterpresviewerList[index].priority.toString(), // Data
                                                                            style: AppStyle.w50018.copyWith(
                                                                              // fontSize: 16,
                                                                              fontSize: getDynamicHeight(size: 0.018),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: getDynamicHeight(size: 0.005)), // Space between Bed and Intercom
                                                                  Text.rich(
                                                                    TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                            text: AppString.rxStatus, // Heading
                                                                            style: AppStyle.plusbold16.copyWith(
                                                                              // fontSize: 16,
                                                                              fontSize: getDynamicHeight(size: 0.016),
                                                                            )),
                                                                        TextSpan(
                                                                            text: controller.filterpresviewerList[index].rxStatus.toString(), // Data
                                                                            style: AppStyle.w50018.copyWith(
                                                                              // fontSize: 16,
                                                                              fontSize: getDynamicHeight(size: 0.016),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: getDynamicHeight(size: 0.005)), // Space between Bed and Intercom
                                                                  Text.rich(
                                                                    TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                            text: AppString.tokenNo, // Heading
                                                                            style: AppStyle.plusbold16.copyWith(
                                                                              // fontSize: 16,
                                                                              fontSize: getDynamicHeight(size: 0.018),
                                                                            )),
                                                                        TextSpan(
                                                                            text: controller.filterpresviewerList[index].tokenNo.toString(), // Data
                                                                            style: AppStyle.w50018.copyWith(
                                                                              // fontSize: 20,
                                                                              fontSize: getDynamicHeight(size: 0.022),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
