// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomBarView extends GetView<BottomBarController> {
  const BottomBarView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BottomBarController());
    return GetBuilder<BottomBarController>(
      builder: (controller) {
        return Obx(
          () => Scaffold(
            resizeToAvoidBottomInset: false,
            body: PersistentTabView(
              padding: const EdgeInsets.only(bottom: 4, top: 0),
              context,
              confineToSafeArea: Platform.isAndroid ? true : false,
              controller: controller.persistentController,
              handleAndroidBackButtonPress: true,
              hideNavigationBarWhenKeyboardAppears: true,
              // popBehaviorOnSelectedNavBarItemPress: PopBehavior.none,
              backgroundColor: AppColor.white,
              navBarHeight: hideBottomBar.value ? 0 : 70.0,
              decoration: NavBarDecoration(
                colorBehindNavBar: AppColor.trasparent,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.originalgrey.withOpacity(0.1),
                    spreadRadius: 3.0,
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
              navBarStyle: NavBarStyle.style3,
              stateManagement: false,
              resizeToAvoidBottomInset: true,
              bottomScreenMargin: Sizes.crossLength * 0.020,
              // onItemSelected: (value) {
              //   controller.onItemTapped(value, context);
              // },
              onItemSelected: (index) => controller.onItemTapped(index, context),
              // popAllScreensOnTapOfSelectedTab: true,
            ),
          ),
        );
      },
    );
  }
}
