import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
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
              title: Text(
                AppString.prescriptionviewer,
                style: TextStyle(
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: CommonFontStyle.plusJakartaSans,
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
                      width: 20,
                    ))
              ],
              centerTitle: true,
            ),
            body: Column(children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    // Search Bar (60%)
                    Expanded(
                      flex: 7,
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
                          hintStyle: TextStyle(
                            color: AppColor.lightgrey1,
                            fontFamily: CommonFontStyle.plusJakartaSans,
                          ),
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
                          }
                          Future.delayed(const Duration(milliseconds: 800));
                          controller.showShortButton = true;
                          controller.update();
                        },
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
                                  'assets/image/Vector.png',
                                ))

                            // IconButton(
                            //   icon: Icon(Icons.sort, color: AppColor.black),
                            //   onPressed: () {
                            //     controller.sortBy();
                            //   },
                            // ),
                            ),
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
                      child: Scrollbar(
                        // controller: controller.pharmacyScrollController,
                        thickness: 5, //According to your choice
                        thumbVisibility: false, //
                        radius: Radius.circular(10),
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
                                    controller.SelectedIndex = index;
                                    await controller.fetchpresDetailList(controller.filterpresviewerList[index].mstId.toString());

                                    final bottomBarController = Get.put(BottomBarController());
                                    bottomBarController.currentIndex.value = -1;
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: PresdetailsScreen(),
                                      withNavBar: true,
                                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                    ).then((value) async {
                                      // final bottomBarController = Get.find<BottomBarController>();
                                      bottomBarController.persistentController.value.index = 0;
                                      bottomBarController.currentIndex.value = 0;
                                      bottomBarController.isPharmacyHome.value = true;
                                      hideBottomBar.value = false;
                                      var dashboardController = Get.put(DashboardController());
                                      await dashboardController.getDashboardDataUsingToken();
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: AppColor.lightblue,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 6,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  controller.filterpresviewerList[index].patientName.toString(),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                height: 35, // Small container size
                                                margin: const EdgeInsets.only(bottom: 5), // Moves container a bit left and down
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: IconButton(
                                                  icon: Icon(Icons.shopping_cart, size: 18),
                                                  onPressed: () async {
                                                    controller.SelectedIndex = index;
                                                    await controller
                                                        .fetchpresDetailList(controller.filterpresviewerList[index].mstId.toString());

                                                    final bottomBarController = Get.put(BottomBarController());
                                                    bottomBarController.currentIndex.value = -1;
                                                    PersistentNavBarNavigator.pushNewScreen(
                                                      context,
                                                      screen: PresdetailsScreen(),
                                                      withNavBar: true,
                                                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                                    ).then((value) async {
                                                      // final bottomBarController = Get.find<BottomBarController>();
                                                      bottomBarController.persistentController.value.index = 0;
                                                      bottomBarController.currentIndex.value = 0;
                                                      bottomBarController.isPharmacyHome.value = true;
                                                      hideBottomBar.value = false;
                                                      var dashboardController = Get.put(DashboardController());
                                                      await dashboardController.getDashboardDataUsingToken();
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'Print St: ', // Heading
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold, // Bold style for heading
                                                        fontFamily: CommonFontStyle.plusJakartaSans,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: controller.filterpresviewerList[index].printStatus.toString(), // Data
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500, // Normal weight for data
                                                        fontFamily: CommonFontStyle.plusJakartaSans,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Priority: ', // Heading
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold, // Bold style for heading
                                                            fontFamily: CommonFontStyle.plusJakartaSans,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: controller.filterpresviewerList[index].priority.toString(), // Data
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500, // Normal weight for data
                                                            fontFamily: CommonFontStyle.plusJakartaSans,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'Last User: ', // Heading
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold, // Bold style for heading
                                                        fontFamily: CommonFontStyle.plusJakartaSans,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: controller.filterpresviewerList[index].lastUser.toString(), // Data
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500, // Normal weight for data
                                                        fontFamily: CommonFontStyle.plusJakartaSans,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'IPD No: ', // Heading
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold, // Bold style for heading
                                                        fontFamily: CommonFontStyle.plusJakartaSans,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: controller.filterpresviewerList[index].ipd.toString(), // Data
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500, // Normal weight for data
                                                        fontFamily: CommonFontStyle.plusJakartaSans,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'RX Status: ', // Heading
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold, // Bold style for heading
                                                            fontFamily: CommonFontStyle.plusJakartaSans,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: controller.filterpresviewerList[index].rxStatus.toString(), // Data
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500, // Normal weight for data
                                                            fontFamily: CommonFontStyle.plusJakartaSans,
                                                          ),
                                                        ),
                                                      ],
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
                                ),
                              );
                            }),
                      ),
                    )
            ]));
      },
    );
  }
}
