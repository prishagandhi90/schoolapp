// ignore_for_file: deprecated_member_use

import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/lvotApproval/controller/lvotapproval_controller.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomBarView extends GetView<BottomBarController> {
  BottomBarView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BottomBarController());
    return GetBuilder<BottomBarController>(
      builder: (controller) {
        return Obx(
          () => Scaffold(
            resizeToAvoidBottomInset: false,
            body: WillPopScope(
              onWillPop: () async {
                final lvotapprovalController = Get.put(LvotapprovalController());
                if (lvotapprovalController.isSelectionMode.value == true) {
                  await lvotapprovalController.exitSelectionMode();
                  return false;
                }
                if (controller.currentIndex.value == 0) {
                  hideBottomBar.value = false;
                  controller.resetAndInitializeToScreen(2);
                  return false;
                } else if (controller.currentIndex.value == 2) {
                  return false;
                }

                return true;
              },
              child: PersistentTabView(
                padding: EdgeInsets.only(bottom: getDynamicHeight(size: 0.006), top: 0),
                context,
                confineToSafeArea: kIsWeb ? false : true,
                controller: controller.persistentController.value,
                handleAndroidBackButtonPress: true,
                hideNavigationBarWhenKeyboardAppears: true,
                backgroundColor: AppColor.white,
                navBarHeight: hideBottomBar.value ? 0 : getDynamicHeight(size: 0.072),
                decoration: NavBarDecoration(
                  colorBehindNavBar: AppColor.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.originalgrey.withOpacity(0.1),
                      spreadRadius: getDynamicHeight(size: 0.005),
                    ),
                  ],
                ),
                animationSettings: const NavBarAnimationSettings(
                  screenTransitionAnimation: ScreenTransitionAnimationSettings(
                    animateTabTransition: false,
                    curve: Curves.ease,
                    duration: Duration(milliseconds: 100),
                  ),
                ),
                screens: controller.buildScreens(),
                items: controller.navBarsItems(context),
                navBarStyle: controller.currentIndex.value != -1 ? NavBarStyle.style6 : NavBarStyle.style8,
                stateManagement: true,
                resizeToAvoidBottomInset: true,
                bottomScreenMargin: getDynamicHeight(size: 0.020),
                onItemSelected: (index) async {
                  if (controller.payrollModuleScreenRightsTable.isNotEmpty &&
                      controller.isIPDHome.value == false &&
                      controller.isPharmacyHome.value == false &&
                      controller.isPayrollHome.value == false) {
                    if (controller.payrollModuleScreenRightsTable[0].rightsYN == "N" && index != 2) {
                      Get.snackbar(
                        AppString.youdonthaveaccesstothisscreen,
                        '',
                        colorText: AppColor.white,
                        backgroundColor: AppColor.black,
                        duration: const Duration(seconds: 1),
                      );
                      controller.currentIndex.value = 2;
                      controller.persistentController.value.index = 2;
                      controller.update();
                      return;
                    }
                  } else if ((controller.isIPDHome.value || controller.isPharmacyHome.value) && (index == 0 || index == 1 || index == 3 || index == 4)) {
                    controller.persistentController.value.index = 0;
                    controller.currentIndex.value = 0;
                    controller.update();
                    return;
                  }

                  await controller.onItemTapped(index, false, context, false);
                },
              ),
            ),
          ),
        );
        // );
      },
    );
  }
}
