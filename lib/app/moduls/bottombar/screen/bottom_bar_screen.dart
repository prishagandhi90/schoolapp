import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomBarView extends GetView<BottomBarController> {
  BottomBarView({super.key});

  final BottomBarController barController = Get.put(BottomBarController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomBarController>(
      builder: (controller) {
        return Scaffold(
          // bottomNavigationBar: Obx(
          //   () => NavigationBar(
          //     backgroundColor: Colors.white,
          //     indicatorColor: const Color.fromARGB(255, 192, 191, 191),
          //     selectedIndex: controller.selectedIndex.value,
          //     overlayColor: const WidgetStatePropertyAll(Colors.black),
          //     surfaceTintColor: const Color.fromARGB(255, 214, 214, 213),
          //     height: 80,
          //     onDestinationSelected: (index) => controller.selectedIndex.value = index,
          //     destinations: controller.navBarsItems(),
          //   ),
          // ),
          // body: Obx(() {
          //   return controller.buildScreens()[controller.selectedIndex.value];
          // }),
          body: PersistentTabView(
            context,
            controller: controller.persistentController,
            screens: controller.buildScreens(),
            items: controller.navBarsItems(),
            // navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0 ? 0.0 : kBottomNavigationBarHeight,
            backgroundColor: Colors.white,
            handleAndroidBackButtonPress: true,
            resizeToAvoidBottomInset: true,
            stateManagement: true,
            // hideNavigationBarWhenKeyboardShows: true,
            decoration: const NavBarDecoration(
              // borderRadius: BorderRadius.circular(10.0),
              colorBehindNavBar: Colors.white,
            ),
            // decoration: NavBarDecoration(
            //   boxShadow: [
            //     BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 10.0),
            //   ],
            // ),
            animationSettings: const NavBarAnimationSettings(
              navBarItemAnimation: ItemAnimationSettings(
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: ScreenTransitionAnimationSettings(
                animateTabTransition: true,
                curve: Curves.ease,
                duration: Duration(milliseconds: 100),
              ),
            ),
            navBarStyle: NavBarStyle.style6,
          ),
        );
      },
    );
  }
}
