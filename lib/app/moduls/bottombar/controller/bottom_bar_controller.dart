import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/attendence/controller/attendence_controller.dart';
import 'package:emp_app/app/moduls/attendence/screen/attendance_screen.dart';
import 'package:emp_app/app/moduls/leave/screen/leave_main_screen.dart';
import 'package:emp_app/app/moduls/overtime/screens/overtime_main_screen.dart';
import 'package:emp_app/app/moduls/dashboard/screen/dashboard1_screen.dart';
import 'package:emp_app/app/moduls/payroll/screen/payroll_screen.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomBarController extends GetxController {
  RxInt currentIndex = (-1).obs;
  PersistentTabController? persistentController = PersistentTabController(initialIndex: 2);
  // final AttendanceScreen attendanceScreen = AttendanceScreen(fromDashboard: true);
  final attendanceScreen = Get.isRegistered<AttendanceScreen>()
      ? Get.find<AttendanceScreen>() // If already registered, find it
      : Get.put(AttendanceScreen());
  @override
  void onInit() {
    super.onInit();
    // persistentController = PersistentTabController(initialIndex: 2);
    hideBottomBar.value = false;

    update();
  }

  @override
  void dispose() {
    persistentController?.dispose();
    super.dispose();
  }

  List<Widget> buildScreens() {
    return [
      PayrollScreen(),
      attendanceScreen,
      // AttendanceScreen(fromDashboard: true),
      // GetBuilder<AttendenceController>(
      //   init: AttendenceController(),
      //   builder: (controller) => AttendanceScreen(fromDashboard: true),
      // ),
      const Dashboard1Screen(),
      LeaveMainScreen(),
      OvertimeMainScreen(fromDashboard: true),
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
    if (index == 1 && persistentController!.index == 1) {
      // Already on AttendanceScreen, do not change anything
      return;
    }

    // Update the persistent controller index
    persistentController!.index = index;
    update();
  }

  // List<PersistentBottomNavBarItem> navBarsItems(BuildContext? ctx) {
  //   return [
  //     _buildNavBarItem(0, AppImage.home, AppString.home),
  //     _buildNavBarItem(1, AppImage.attendence, AppString.attendence),
  //     _buildNavBarItem(2, AppImage.dashboard, AppString.dashboard),
  //     _buildNavBarItem(3, AppImage.leave, AppString.leave),
  //     _buildNavBarItem(4, AppImage.overtime, AppString.overtime),
  //   ];
  // }

  // PersistentBottomNavBarItem _buildNavBarItem(int index, String iconPath, String title) {
  //   return PersistentBottomNavBarItem(
  //     icon: Container(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Image.asset(iconPath,
  //               color: currentIndex.value == index && currentIndex.value != -1 ? AppColor.primaryColor : AppColor.black,
  //               height: 32,
  //               width: 32),
  //           SizedBox(height: 4),
  //           Text(
  //             title,
  //             style: TextStyle(
  //                 color: currentIndex.value == index && currentIndex.value != -1 ? AppColor.primaryColor : AppColor.black, fontSize: 12),
  //           ),
  //         ],
  //       ),
  //     ),
  //     activeColorPrimary: AppColor.primaryColor,
  //     inactiveColorPrimary: AppColor.black,
  //   );
  // }

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
        onPressed: (index) {
          if (index != 0) {
            // Add your functionality here
          }
        },
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
