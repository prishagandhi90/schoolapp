import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/attendence/screen/attendance_screen.dart';
import 'package:emp_app/app/moduls/leave/screen/leavedemo.dart';
import 'package:emp_app/app/moduls/overtime/screens/overtimedemo.dart';
import 'package:emp_app/app/moduls/dashboard/screen/dashboard1_screen.dart';
import 'package:emp_app/app/moduls/payroll/screen/payroll_screen.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomBarController extends GetxController {
  PersistentTabController? persistentController = PersistentTabController(initialIndex: 2);
  @override
  void onInit() {
    super.onInit();
    persistentController = PersistentTabController(initialIndex: 2);
    hideBottomBar.value = false;
    update();
  }

  List<Widget> buildScreens() {
    return [
      const PayrollScreen(),
      // AttendanceScreen(fromDashboard: true),
      const AttendanceScreen(fromDashboard: true),
      const Dashboard1Screen(),
      Leavedemo(),
      OvertimeScreen(),
    ];
  }

  // Future<bool> onWillPop() async {
  //   if (persistentController!.index != 2) {
  //     persistentController!.jumpToTab(2); // Dashboard tab par le aaye
  //     return false; // Back navigation prevent kare
  //   } else {
  //     return true; // Allow default back navigation to previous screens
  //   }
  // }
// Future<bool> onWillPop(BuildContext context) async {
//   if (persistentController!.index == 2) {
//     // If on Dashboard
//     if (Navigator.of(context).canPop()) {
//       // If there's anything to pop on the Dashboard stack
//       Navigator.of(context).pop();
//       return false; // Prevent default back navigation
//     } else {
//       // No more screens to pop, exit app
//       return true; // Exit the app
//     }
//   } else {
//     // If on any other tab, go to Dashboard
//     persistentController!.jumpToTab(2); // Jump to Dashboard tab
//     return false; // Prevent default back navigation
//   }
// }

  void onItemTapped(int index, BuildContext context) {
    update();
  }

  List<PersistentBottomNavBarItem> navBarsItems(BuildContext? ctx) {
    return [
      PersistentBottomNavBarItem(
        icon: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImage.home, color: AppColor.primaryColor, height: 32, width: 32),
              SizedBox(height: 4),
              Text(AppString.home, style: TextStyle(color: AppColor.primaryColor, fontSize: 12)),
            ],
          ),
        ),
        inactiveIcon: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImage.home, color: AppColor.black, height: 32, width: 32),
              SizedBox(height: 4),
              Text(AppString.home, style: TextStyle(color: AppColor.black, fontSize: 12)),
            ],
          ),
        ),
        activeColorPrimary: AppColor.primaryColor,
        inactiveColorPrimary: AppColor.black,
      ),
      PersistentBottomNavBarItem(
        icon: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImage.attendence, color: AppColor.primaryColor, height: 32, width: 32),
              SizedBox(height: 4),
              Text(AppString.attendence, style: TextStyle(color: AppColor.primaryColor, fontSize: 12)),
            ],
          ),
        ),
        inactiveIcon: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImage.attendence, color: AppColor.black, height: 32, width: 32),
              SizedBox(height: 4),
              Text(AppString.attendence, style: TextStyle(color: AppColor.black, fontSize: 12)),
            ],
          ),
        ),
        activeColorPrimary: AppColor.primaryColor,
        inactiveColorPrimary: AppColor.black,
      ),
      PersistentBottomNavBarItem(
        icon: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImage.dashboard, color: AppColor.primaryColor, height: 32, width: 32),
              SizedBox(height: 4),
              Text(AppString.dashboard, style: TextStyle(color: AppColor.primaryColor, fontSize: 12)),
            ],
          ),
        ),
        inactiveIcon: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImage.dashboard, color: AppColor.black, height: 32, width: 32),
              SizedBox(height: 4),
              Text(AppString.dashboard, style: TextStyle(color: AppColor.black, fontSize: 12)),
            ],
          ),
        ),
        activeColorPrimary: AppColor.primaryColor,
        inactiveColorPrimary: AppColor.black,
      ),
      PersistentBottomNavBarItem(
        icon: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImage.leave, color: AppColor.primaryColor, height: 32, width: 32),
              SizedBox(height: 4),
              Text(AppString.leave, style: TextStyle(color: AppColor.primaryColor, fontSize: 12)),
            ],
          ),
        ),
        inactiveIcon: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImage.leave, color: AppColor.black, height: 32, width: 32),
              SizedBox(height: 4),
              Text(AppString.leave, style: TextStyle(color: AppColor.black, fontSize: 12)),
            ],
          ),
        ),
        activeColorPrimary: AppColor.primaryColor,
        inactiveColorPrimary: AppColor.black,
      ),
      PersistentBottomNavBarItem(
        icon: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImage.overtime, color: AppColor.primaryColor, height: 32, width: 32),
              SizedBox(height: 4),
              Text(AppString.overtime, style: TextStyle(color: AppColor.primaryColor, fontSize: 12)),
            ],
          ),
        ),
        inactiveIcon: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImage.overtime, color: AppColor.black, height: 32, width: 32),
              SizedBox(height: 4),
              Text(AppString.overtime, style: TextStyle(color: AppColor.black, fontSize: 12)),
            ],
          ),
        ),
        activeColorPrimary: AppColor.primaryColor,
        inactiveColorPrimary: AppColor.black,
      ),
    ];
  }
}
