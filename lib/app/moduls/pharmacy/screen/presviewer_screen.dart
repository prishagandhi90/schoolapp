// ignore_for_file: deprecated_member_use

import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
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
            title: Text(AppString.prescriptionviewer, style: AppStyle.primaryplusw700),
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
                    width: 20,
                  ))
            ],
            centerTitle: true,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
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
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.lightgrey1, width: 1.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
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
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                            ),
                          ),
                          onTap: () {
                            controller.showShortButton = false;
                            controller.update();
                          },
                          onChanged: (value) {
                            controller.filterSearchResults(value);
                            controller.searchController.clear();
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
                    const SizedBox(width: 8), // Space between items
                    Expanded(
                      flex: 1.5.toInt(),
                      child: Container(
                        height: 50, // Adjust height as needed
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.black),
                          borderRadius: BorderRadius.circular(10),
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
                    const SizedBox(width: 8), // Space between items
                    Expanded(
                      flex: 1.5.toInt(),
                      child: Container(
                        // height: 50, // Adjust height as needed
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: IconButton(
                            icon: Icon(Icons.filter_alt, color: AppColor.black, size: 25),
                            onPressed: () {
                              controller.callFilterAPi = false;
                              controller.tempWardList = List.unmodifiable(controller.selectedWardList);
                              controller.tempFloorsList = List.unmodifiable((controller.selectedFloorList));
                              controller.tempBedList = List.unmodifiable(controller.selectedBedList);

                              controller.pharmacyFiltterBottomSheet();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              controller.isLoading
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 100),
                      child: Center(child: ProgressWithIcon()),
                    )
                  : Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // double ConstraintsHeight = constraints.maxHeight; // Ensure scrolling
                          return Scrollbar(
                            thickness: 5, //According to your choice
                            thumbVisibility: false, //
                            radius: Radius.circular(10),
                            child: RefreshIndicator(
                              onRefresh: () async {
                                await await controller.fetchpresViewer();
                              },
                              child: SizedBox(
                                // height: ConstraintsHeight - 80.0,
                                child: ListView.builder(
                                    itemCount: controller.filterpresviewerList.length,
                                    controller: controller.pharmacyviewScrollController,
                                    shrinkWrap: true,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (controller.isPresMedicineNavigating.value) return;
                                            controller.isPresMedicineNavigating.value = true;

                                            controller.SelectedIndex = index;
                                            await controller.fetchpresDetailList(
                                                controller.filterpresviewerList[index].mstId.toString());

                                            // final bottomBarController = Get.put(BottomBarController());
                                            // bottomBarController.currentIndex.value = -1;
                                            // hideBottomBar.value = false;

                                            PersistentNavBarNavigator.pushNewScreen(
                                              context,
                                              screen: PresdetailsScreen(),
                                              withNavBar: false,
                                              pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                            ).then((value) async {
                                              final bottomBarController = Get.put(BottomBarController());
                                              // bottomBarController.currentIndex.value = -1;
                                              // hideBottomBar.value = true;
                                              bottomBarController.persistentController.value.index = 0;
                                              bottomBarController.currentIndex.value = 0;
                                              bottomBarController.isPharmacyHome.value = true;
                                              hideBottomBar.value = true;
                                              // var dashboardController = Get.put(DashboardController());
                                              // await dashboardController.getDashboardDataUsingToken();
                                            });
                                            controller.isPresMedicineNavigating.value = false;
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                            decoration: BoxDecoration(
                                              color: controller.filterpresviewerList[index].printStatus
                                                          .toString()
                                                          .toLowerCase() ==
                                                      "printed"
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
                                                      padding: const EdgeInsets.symmetric(
                                                          horizontal: 5), // Space between index and right side
                                                      child: Text(
                                                        "${index + 1}", // Dynamic index
                                                        style: AppStyle.w50018
                                                            .copyWith(fontSize: 17, fontWeight: FontWeight.w600),
                                                      ),
                                                    ),
                                                    // Right side: Text and Container
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .end, // Align text and container to the right
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          // Text
                                                          Text(
                                                            controller.filterpresviewerList[index].org
                                                                .toString(), // Add your custom text
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w500,
                                                                color: Colors.black),
                                                          ),
                                                          const SizedBox(
                                                              width: 20), // Minimal space between text and container
                                                          // Container
                                                          Container(
                                                            height: 35, // Small container size
                                                            margin: const EdgeInsets.only(
                                                                bottom: 5), // Adjust positioning if needed
                                                            decoration: BoxDecoration(
                                                              color: Colors.grey[200],
                                                              borderRadius: BorderRadius.circular(8),
                                                            ),
                                                            child: IconButton(
                                                              icon: Icon(Icons.shopping_cart, size: 18),
                                                              onPressed: () async {
                                                                try {
                                                                  controller.SelectedIndex = index;

                                                                  await controller.fetchpresDetailList(
                                                                    controller.filterpresviewerList[index].mstId
                                                                        .toString(),
                                                                  );

                                                                  PersistentNavBarNavigator.pushNewScreen(
                                                                    context,
                                                                    screen: PresdetailsScreen(),
                                                                    withNavBar: false,
                                                                    pageTransitionAnimation:
                                                                        PageTransitionAnimation.cupertino,
                                                                  ).then((value) async {
                                                                    final bottomBarController =
                                                                        Get.put(BottomBarController());
                                                                    bottomBarController
                                                                        .persistentController.value.index = 0;
                                                                    bottomBarController.currentIndex.value = 0;
                                                                    bottomBarController.isPharmacyHome.value = true;
                                                                    hideBottomBar.value = true;
                                                                    var dashboardController =
                                                                        Get.put(DashboardController());
                                                                    await dashboardController
                                                                        .getDashboardDataUsingToken();
                                                                  });
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
                                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                                  child: Text(
                                                    controller.filterpresviewerList[index].patientName.toString(),
                                                    style: AppStyle.w50018
                                                        .copyWith(fontSize: 17, fontWeight: FontWeight.w600),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 5),
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
                                                                      style: AppStyle.plusbold16),
                                                                  TextSpan(
                                                                      text: controller
                                                                          .filterpresviewerList[index].printStatus
                                                                          .toString(), // Data
                                                                      style: AppStyle.w50018.copyWith(fontSize: 16)),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(height: 5), // Space between IPD and MOP
                                                            Text.rich(
                                                              TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                      text: AppString.lastuser, // Heading
                                                                      style: AppStyle.plusbold16),
                                                                  TextSpan(
                                                                      text: controller
                                                                          .filterpresviewerList[index].lastUser
                                                                          .toString(), // Data
                                                                      style: AppStyle.w50018.copyWith(fontSize: 16)),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(height: 5), // Space between IPD and MOP
                                                            Text.rich(
                                                              TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                      text: AppString.ipdNo, // Heading
                                                                      style: AppStyle.plusbold16),
                                                                  TextSpan(
                                                                      text: controller.filterpresviewerList[index].ipd
                                                                          .toString(), // Data
                                                                      style: AppStyle.w50018.copyWith(fontSize: 16)),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 9),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text.rich(
                                                                TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                        text: AppString.priority, // Heading
                                                                        style: AppStyle.plusbold16),
                                                                    TextSpan(
                                                                        text: controller
                                                                            .filterpresviewerList[index].priority
                                                                            .toString(), // Data
                                                                        style: AppStyle.w50018.copyWith(fontSize: 16)),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(height: 5), // Space between Bed and Intercom
                                                              Text.rich(
                                                                TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                        text: AppString.rxStatus, // Heading
                                                                        style: AppStyle.plusbold16),
                                                                    TextSpan(
                                                                        text: controller
                                                                            .filterpresviewerList[index].rxStatus
                                                                            .toString(), // Data
                                                                        style: AppStyle.w50018.copyWith(fontSize: 16)),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(height: 5), // Space between Bed and Intercom
                                                              Text.rich(
                                                                TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                        text: AppString.tokenNo, // Heading
                                                                        style: AppStyle.plusbold16),
                                                                    TextSpan(
                                                                        text: controller
                                                                            .filterpresviewerList[index].tokenNo
                                                                            .toString(), // Data
                                                                        style: AppStyle.w50018.copyWith(fontSize: 20)),
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
