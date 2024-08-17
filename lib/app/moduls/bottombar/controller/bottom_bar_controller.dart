import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/attendence/screen/attendance_screen.dart';
import 'package:emp_app/app/moduls/leave/screen/leavedemo.dart';
import 'package:emp_app/app/moduls/overtime/screens/overtime_screen.dart';
import 'package:emp_app/app/moduls/dashboard/screen/dashboard1_screen.dart';
import 'package:emp_app/app/moduls/payroll/screen/payroll_screen.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomBarController extends GetxController with WidgetsBindingObserver {
  PersistentTabController? persistentController = PersistentTabController(initialIndex: 2);
  @override
  void onInit() {
    super.onInit();
    // persistentController = PersistentTabController(initialIndex: 2);
    hideBottomBar.value = false;
    update();
  }

  List<Widget> buildScreens() {
    return [
      const PayrollScreen(),
      AttendanceScreen(fromDashboard: true),
      const Dashboard1Screen(),
      Leavedemo(),
      OvertimeScreen(),
    ];
  }

  void onItemTapped(int index, BuildContext context) {
    // if (persistentController!.index != index) {
    // Pop all previous screens in the current tab stack
    // Get.until((route) => route.isFirst);
    // while (Navigator.canPop(context)) {
    //   Navigator.pop(context);
    // }
    // hideBottomBar.value = false;
    // Get.offAll(buildScreens1()[index]);
    // Change the tab
    // persistentController!.index = index;
    update();
    // }
  }

  List<PersistentBottomNavBarItem> navBarsItems(BuildContext? ctx) {
    return [
      PersistentBottomNavBarItem(
        title: AppString.home,
        icon: Image.asset(AppImage.home, color: AppColor.primaryColor),
        inactiveIcon: Image.asset(AppImage.home, color: AppColor.black),
        activeColorPrimary: AppColor.primaryColor,
      ),
      PersistentBottomNavBarItem(
        title: AppString.attendence,
        icon: Image.asset(AppImage.attendence, color: AppColor.primaryColor),
        inactiveIcon: Image.asset(AppImage.attendence, color: AppColor.black),
        activeColorPrimary: AppColor.primaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset(AppImage.dashboard, color: AppColor.primaryColor),
        inactiveIcon: Image.asset(AppImage.dashboard, color: AppColor.black),
        title: AppString.dashboard,
        activeColorPrimary: AppColor.primaryColor,
      ),
      PersistentBottomNavBarItem(
        title: AppString.leave,
        icon: Image.asset(AppImage.leave, color: AppColor.primaryColor),
        inactiveIcon: Image.asset(AppImage.leave),
        activeColorPrimary: AppColor.primaryColor,
      ),
      PersistentBottomNavBarItem(
        title: AppString.overtime,
        icon: Image.asset(AppImage.overtime, color: AppColor.primaryColor),
        inactiveIcon: Image.asset(AppImage.overtime, color: AppColor.black),
        activeColorPrimary: AppColor.primaryColor,
      ),
    ];
  }

  // Future<bool> onWillPop(BuildContext context) async {
  //   if (Navigator.of(context).canPop()) {
  //     // If there's anything to pop on the current stack, pop it.
  //     Navigator.of(context).pop();
  //     return Future.value(false);
  //   } else if (persistentController!.index != 2) {
  //     // If not on the dashboard, navigate back to the dashboard
  //     persistentController!.jumpToTab(2);
  //     return Future.value(false);
  //   } else {
  //     // Handle exit from the app
  //     if (lastBackPressed == null ||
  //         DateTime.now().difference(lastBackPressed!) > Duration(seconds: 2)) {
  //       lastBackPressed = DateTime.now();
  //       Get.snackbar("Press Back Again", "to exit the app",
  //           snackPosition: SnackPosition.BOTTOM);
  //       return Future.value(false);
  //     }
  //     return Future.value(true); // Exit the app
  //   }
  // }
}
