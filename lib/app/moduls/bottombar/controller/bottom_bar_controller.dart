import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/attendence/screen/attendance_screen.dart';
import 'package:emp_app/app/moduls/leave/screen/demo.dart';
import 'package:emp_app/app/moduls/leave/screen/leave_main_screen.dart';
import 'package:emp_app/app/moduls/dashboard/screen/dashboard1_screen.dart';
import 'package:emp_app/app/moduls/leave/screen/leavedemo.dart';
import 'package:emp_app/app/moduls/overtime/screens/overtime_main_screen.dart';
import 'package:emp_app/app/moduls/overtime/screens/overtimedemo.dart';
import 'package:emp_app/app/moduls/payroll/screen/payroll_screen.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomBarController extends GetxController {
  RxInt currentIndex = (2).obs;
  Rx<PersistentTabController> persistentController = PersistentTabController(initialIndex: 2).obs;

  @override
  void onInit() {
    super.onInit();
    // persistentController = PersistentTabController(initialIndex: 2);
    hideBottomBar.value = false;
    // update();
  }

  List<Widget> buildScreens() {
    return [
      PayrollScreen(),
      // attendanceScreen,
      AttendanceScreen(),
      const Dashboard1Screen(),
      // LeaveMainScreen(),
      Leavedemo(),
      // DemoScreen(),
      OvertimeScreen()
      // OvertimeMainScreen(fromDashboard: true),
    ];
  }

  // onItemTapped(int index, BuildContext context) async {
  //   // Get.delete<MispunchController>();
  //   hideBottomBar.value = false;
  //   persistentController.update((val) {
  //     val?.index = index;
  //   });
  //   currentIndex.value = index;

  //   if (index == 1) {
  //     final attendanceController = Get.put(AttendenceController());
  //     await attendanceController.resetData(); // Call resetData or any other method to reset the state
  //     // attendanceController.initialIndex.value = 0;
  //     // attendanceController.update();
  //   }
  //   update();
  // }

  onItemTapped(int index, BuildContext context) async {
    currentIndex.value = index;
    if (index == 0) {
      // Navigate to PayrollScreen
      // Ensure MispunchScreen is popped before navigating to PayrollScreen
      Get.until((route) => route.isFirst); // This pops all routes until the first one (PayrollScreen)
      persistentController.value.index = 0; // This sets PayrollScreen tab
    } else {
      // Navigate to other screens
      persistentController.value.index = index;
    }
    update();
  }

  void resetAndInitialize() {
    currentIndex.value = 2;
    persistentController.value = PersistentTabController(initialIndex: 2);
    hideBottomBar.value = false;
    // update();
  }

  List<PersistentBottomNavBarItem> navBarsItems(BuildContext? ctx) {
    return [
      PersistentBottomNavBarItem(
        icon: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImage.home, color: currentIndex.value != -1 ? AppColor.primaryColor : AppColor.black, height: 32, width: 32),
              SizedBox(height: 4),
              Text(AppString.home,
                  style: TextStyle(color: currentIndex.value != -1 ? AppColor.primaryColor : AppColor.black, fontSize: 12)),
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
        // onPressed: (index) {
        //   if (index != 0) {
        //     // Add your functionality here
        //   }
        // },
      ),
      PersistentBottomNavBarItem(
        icon: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImage.attendence,
                  color: currentIndex.value != -1 ? AppColor.primaryColor : AppColor.black, height: 32, width: 32),
              SizedBox(height: 4),
              Text(AppString.attendence,
                  style: TextStyle(color: currentIndex.value != -1 ? AppColor.primaryColor : AppColor.black, fontSize: 12)),
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
              Image.asset(AppImage.dashboard,
                  color: currentIndex.value != -1 ? AppColor.primaryColor : AppColor.black, height: 32, width: 32),
              SizedBox(height: 4),
              Text(AppString.dashboard,
                  style: TextStyle(color: currentIndex.value != -1 ? AppColor.primaryColor : AppColor.black, fontSize: 12)),
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
              Image.asset(AppImage.leave, color: currentIndex.value != -1 ? AppColor.primaryColor : AppColor.black, height: 32, width: 32),
              SizedBox(height: 4),
              Text(AppString.leave,
                  style: TextStyle(color: currentIndex.value != -1 ? AppColor.primaryColor : AppColor.black, fontSize: 12)),
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
              Image.asset(AppImage.overtime,
                  color: currentIndex.value != -1 ? AppColor.primaryColor : AppColor.black, height: 32, width: 32),
              SizedBox(height: 4),
              Text(AppString.overtime,
                  style: TextStyle(color: currentIndex.value != -1 ? AppColor.primaryColor : AppColor.black, fontSize: 12)),
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
