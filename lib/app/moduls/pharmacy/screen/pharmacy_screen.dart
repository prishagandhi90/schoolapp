import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/moduls/pharmacy/controller/pharmacy_controller.dart';
import 'package:emp_app/app/moduls/pharmacy/screen/presviewer_screen.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class PharmacyScreen extends StatelessWidget {
  const PharmacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PharmacyController());
    return GetBuilder<PharmacyController>(
      init: PharmacyController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.white,
          onDrawerChanged: (isOpened) {
            // var bottomBarController = Get.put(BottomBarController());
            hideBottomBar.value = isOpened;
            if (isOpened) {
              controller.filterSearchpharmaResults(''); // Reset the filter
              controller.textEditingController.clear();
            }
          },
          drawer: Drawer(
              backgroundColor: AppColor.white,
              child: ListView(
                children: [
                  const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      focusNode: controller.focusNode,
                      cursorColor: AppColor.grey,
                      controller: controller.textEditingController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.lightgrey1, width: 1.0),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: AppColor.lightgrey1,
                          ),
                        ),
                        prefixIcon: Icon(Icons.search, color: AppColor.lightgrey1),
                        suffixIcon: controller.hasFocus
                            ? IconButton(
                                icon: Icon(
                                  Icons.cancel_outlined,
                                  color: Color.fromARGB(255, 192, 191, 191),
                                ),
                                onPressed: () {
                                  controller.textEditingController.clear();
                                  controller.filterSearchpharmaResults('');
                                },
                              )
                            : null,
                        hintText: AppString.search,
                        hintStyle: TextStyle(
                          color: AppColor.lightgrey1,
                          fontFamily: CommonFontStyle.plusJakartaSans,
                        ),
                        filled: true,
                        focusColor: AppColor.originalgrey,
                        fillColor: AppColor.white,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                      onChanged: (value) {
                        controller.filterSearchpharmaResults(value);
                      },
                    ),
                  ),
                  GetBuilder<PharmacyController>(
                    builder: (controller) {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        shrinkWrap: true,
                        itemCount: controller.filteredList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              if (controller.isPresViewerNavigating.value) return;
                              controller.isPresViewerNavigating.value = true;

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

                              Navigator.pop(context);
                              // var bottomBarController = Get.put(BottomBarController());
                              // bottomBarController.isPharmacyHome.value = true;
                              hideBottomBar.value = true;

                              // controller.payrolListOnClk(index, context);
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: PresviewerScreen(),
                                withNavBar: false,
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              ).then((value) async {
                                final bottomBarController = Get.put(BottomBarController());
                                bottomBarController.currentIndex.value = -1;
                                bottomBarController.persistentController.value.index = 0;
                                bottomBarController.currentIndex.value = 0;
                                bottomBarController.isPharmacyHome.value = true;
                                hideBottomBar.value = false;
                                var dashboardController = Get.put(DashboardController());
                                await dashboardController.getDashboardDataUsingToken();
                              });
                              controller.isPresViewerNavigating.value = false;
                            },
                            child: SizedBox(
                              height: 40,
                              child: ListTile(
                                leading: Image.asset(
                                  controller.filteredList[index]['image'],
                                  height: 25,
                                  width: 25,
                                  color: AppColor.primaryColor,
                                ),
                                title: Text(
                                  controller.filteredList[index]['label'],
                                  style: TextStyle(
                                    // fontSize: 16.0,
                                    fontSize: getDynamicHeight(size: 0.018),
                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                  ),
                                ),
                                trailing: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      // controller.payrolListOnClk(index, context);
                                      hideBottomBar.value = true;
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: PresviewerScreen(),
                                        withNavBar: false,
                                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                      ).then((value) async {
                                        final bottomBarController = Get.put(BottomBarController());
                                        bottomBarController.currentIndex.value = -1;

                                        bottomBarController.persistentController.value.index = 0;
                                        bottomBarController.currentIndex.value = 0;
                                        bottomBarController.isPharmacyHome.value = true;
                                        hideBottomBar.value = false;
                                        var dashboardController = Get.put(DashboardController());
                                        await dashboardController.getDashboardDataUsingToken();
                                      });
                                    },
                                    icon: const Icon(Icons.arrow_forward_ios)),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                ],
              )),
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              AppString.pharmacy,
              style: TextStyle(
                color: AppColor.primaryColor,
                fontWeight: FontWeight.w700,
                fontFamily: CommonFontStyle.plusJakartaSans,
              ),
            ),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Image.asset(
                    AppImage.drawer,
                    width: 20,
                    color: AppColor.black,
                  ),
                );
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
                padding: const EdgeInsets.symmetric(vertical: 35),
                child: GestureDetector(
                    // onTap: () => Get.to(PresviewerScreen()),
                    onTap: () {
                      // // Get.delete<MispunchController>();
                      // final presviewerScreen = Get.put(PresviewerScreen());
                      // presviewerScreen.resetData();
                      // presviewerScreen.update();
                      // // Get.put(MispunchScreen());
                      if (controller.isPresViewerNavigating.value) return;
                      controller.isPresViewerNavigating.value = true;

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
                      hideBottomBar.value = true;
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: PresviewerScreen(),
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      ).then((value) async {
                        final bottomBarController = Get.put(BottomBarController());
                        bottomBarController.currentIndex.value = -1;
                        bottomBarController.persistentController.value.index = 0;
                        bottomBarController.currentIndex.value = 0;
                        bottomBarController.isPharmacyHome.value = true;
                        hideBottomBar.value = false;
                        var dashboardController = Get.put(DashboardController());
                        await dashboardController.getDashboardDataUsingToken();
                      });
                      controller.isPresViewerNavigating.value = false;
                    },
                    child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColor.lightblue,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Title Section
                            Flexible(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20, // 4% of screen width
                                ),
                                child: Text(
                                  AppString.prescriptionviewer,
                                  style: AppStyle.plus17w600.copyWith(
                                    // fontSize: 19, // 4.5% of screen width
                                    fontSize: getDynamicHeight(size: 0.021),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            // Image Section
                            Flexible(
                              flex: 1,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.height * 0.150,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      top: -40, // 4% of screen height
                                      right: 30,
                                      child: Image.asset(
                                        AppImage.medicine,
                                        height: 100, // 10% of screen height
                                        width: 100, // 20% of screen width
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ))),
              )
            ],
          ),
        );
      },
    );
  }
}
