import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/moduls/attendence/screen/attendance_screen.dart';
import 'package:emp_app/app/moduls/leave/screen/leave_screen.dart';
import 'package:emp_app/app/moduls/overtime/screens/overtime_screen.dart';
import 'package:emp_app/app/moduls/dashboard/screen/dashboard1_screen.dart';
import 'package:emp_app/app/moduls/payroll/screen/payroll_screen.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomBarController extends GetxController {
  final count = 0.obs;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentTabController? persistentController = PersistentTabController(initialIndex: 2);
  @override
  void onInit() {
    super.onInit();
    hideBottomBar.value = false;
    update();
  }

  List<Widget> buildScreens() {
    return [
      const PayrollScreen(),
      AttendanceScreen(),
      const Dashboard1Screen(),
      const LeaveScreen(),
      const OvertimeScreen(),
    ];
  }

  void onItemTapped(int index) {
    update();
  }

  List<PersistentBottomNavBarItem> navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        title: "Home",
        icon: Image.asset('assets/image/home.png', color: AppColor.primaryColor),
        inactiveIcon: Image.asset('assets/image/home.png', color: AppColor.black),
        activeColorPrimary: const Color.fromARGB(255, 94, 157, 168),
      ),
      PersistentBottomNavBarItem(
        title: "Attendence",
        icon: Image.asset('assets/image/attendence.png', color: AppColor.primaryColor),
        inactiveIcon: Image.asset('assets/image/attendence.png', color: AppColor.black),
        activeColorPrimary: const Color.fromARGB(255, 94, 157, 168),
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset('assets/image/dashboard.png', color: AppColor.primaryColor),
        inactiveIcon: Image.asset('assets/image/dashboard.png', color: AppColor.black),
        title: "Dashboard",
        activeColorPrimary: AppColor.primaryColor,
      ),
      PersistentBottomNavBarItem(
        title: "Leave",
        icon: Image.asset('assets/image/leave.png', color: AppColor.primaryColor),
        inactiveIcon: Image.asset('assets/image/leave.png'),
        activeColorPrimary: const Color.fromARGB(255, 94, 157, 168),
      ),
      PersistentBottomNavBarItem(
        title: "Over Time",
        icon: Image.asset('assets/image/overtime.png', color: AppColor.primaryColor),
        inactiveIcon: Image.asset('assets/image/overtime.png', color: AppColor.black),
        activeColorPrimary: const Color.fromARGB(255, 94, 157, 168),
      ),
    ];
  }
}
