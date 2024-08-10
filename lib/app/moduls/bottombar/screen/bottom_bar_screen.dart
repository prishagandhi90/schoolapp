import 'dart:io';

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
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: PersistentTabView(
            padding: const EdgeInsets.only(bottom: 4, top: 0),
            context,
            confineToSafeArea: Platform.isAndroid ? true : false,
            controller: controller.persistentController,
            screens: controller.buildScreens(),
            items: controller.navBarsItems(),
            // navBarHeight: hideBottomBar.value ? 0 : Sizes.crossLength * 0.082,
            navBarHeight: hideBottomBar.value ? 0 : 70.0,
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            stateManagement: false,
            bottomScreenMargin: Sizes.crossLength * 0.020,
            // popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
            // isVisible: true,
            hideNavigationBarWhenKeyboardAppears: true,
            handleAndroidBackButtonPress: true,
            onItemSelected: (value) {
              controller.onItemTapped(value);
            },
            decoration: NavBarDecoration(
              colorBehindNavBar: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 3.0,
                ),
              ],
            ),
            animationSettings: const NavBarAnimationSettings(
              navBarItemAnimation: ItemAnimationSettings(
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: ScreenTransitionAnimationSettings(
                animateTabTransition: false,
                curve: Curves.ease,
                duration: Duration(milliseconds: 100),
              ),
            ),

            navBarStyle: NavBarStyle.style3,
          ),
        );
      },
    );
  }
}
