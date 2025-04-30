import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/admitted%20patient/screen/ipd_dashboard_screen.dart';
import 'package:emp_app/app/moduls/attendence/controller/attendence_controller.dart';
import 'package:emp_app/app/moduls/attendence/screen/attendance_screen.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:emp_app/app/moduls/leave/screen/leave_main_screen.dart';
import 'package:emp_app/app/moduls/dashboard/screen/dashboard1_screen.dart';
import 'package:emp_app/app/moduls/overtime/screens/overtime_main_screen.dart';
import 'package:emp_app/app/moduls/payroll/screen/payroll_screen.dart';
import 'package:emp_app/app/moduls/pharmacy/screen/pharmacy_screen.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomBarController extends GetxController {
  RxInt currentIndex = (2).obs;
  Rx<PersistentTabController> persistentController = PersistentTabController(initialIndex: 2).obs;
  RxBool isPharmacyHome = false.obs;
  RxBool isIPDHome = false.obs;
  RxBool isPayrollHome = false.obs;
  RxBool isDashboardHome = false.obs;

  @override
  void onInit() {
    super.onInit();
    // persistentController = PersistentTabController(initialIndex: 2);
    hideBottomBar.value = false;
    // update();
  }

  List<Widget> buildScreens() {
    return [
      Obx(() {
        if (isPharmacyHome.value) {
          return PharmacyScreen();
        } else if (isIPDHome.value) {
          return IpdDashboardScreen();
        } else if (isPayrollHome.value) {
          return PayrollScreen();
        } else {
          return Dashboard1Screen(); // Default screen if none of the conditions are met
        }
      }),
      AttendanceScreen(),
      Dashboard1Screen(),
      LeaveMainScreen(),
      OvertimeMainScreen(),
    ];
  }

  onItemTapped(int index, bool showPharmacy, BuildContext context, bool showAdPatient) async {
    currentIndex.value = index;
    hideBottomBar.value = false;
    isPharmacyHome.value = showPharmacy;
    // isAdmittedPatient.value = showAdPatient;

    if (index == 1) {
      final attendanceController = Get.put(AttendenceController());
      await attendanceController.resetData();
    }

    if (index == 3 || index == 4) {
      final leaveController = Get.put(LeaveController());
      await leaveController.resetForm();
    }

    if (index == 0) {
      // Navigate to PayrollScreen
      // Ensure MispunchScreen is popped before navigating to PayrollScreen
      Get.until((route) => route.isFirst); // This pops all routes until the first one (PayrollScreen)S
      persistentController.value.index = 0;
      return; // This sets PayrollScreen tab
    } else if (index == 2) {
      persistentController.value.index = index;

      isPharmacyHome.value = false;
      isIPDHome.value = false;
      isPayrollHome.value = false;
      return;
    }
    {
      // Navigate to other screens
      persistentController.value.index = index;
    }
    update();
  }

  void resetAndInitialize() {
    currentIndex.value = 2;
    isPharmacyHome.value = false;
    isIPDHome.value = false;
    isPayrollHome.value = false;
    persistentController.value = PersistentTabController(initialIndex: 2);
    hideBottomBar.value = false;
    // update();
  }

  void resetAndInitializeToScreen(int index) {
    currentIndex.value = index;
    //deliberately commented below to eliminate onItemtapped in dashboardscreen to go to payroll screen
    // persistentController.value = PersistentTabController(initialIndex: index);
    persistentController.value.index = index;
    hideBottomBar.value = false;
    if (index == 2) {
      isPharmacyHome.value = false;
      isIPDHome.value = false;
      isPayrollHome.value = false;
    }
    // update();
  }

  void resetAndInitialize_new(int index) {
    currentIndex.value = index;
    persistentController.value = PersistentTabController(initialIndex: index);
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
              Image.asset(
                AppImage.home,
                color: currentIndex.value != -1 ? AppColor.primaryColor : AppColor.black,
                height: getDynamicHeight(size: 0.032),
                width: getDynamicHeight(size: 0.032),
              ),
              SizedBox(height: getDynamicHeight(size: 0.006)),
              Text(
                AppString.home,
                style: TextStyle(
                  color: currentIndex.value != -1 ? AppColor.primaryColor : AppColor.black,
                  // fontSize: 12,
                  fontSize: getDynamicHeight(size: 0.014),
                ),
              ),
            ],
          ),
        ),
        inactiveIcon: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImage.home,
                  color: AppColor.black, height: getDynamicHeight(size: 0.034), width: getDynamicHeight(size: 0.034)),
              SizedBox(height: getDynamicHeight(size: 0.006)),
              Text(
                AppString.home,
                style: TextStyle(
                  color: AppColor.black,
                  // fontSize: 12,
                  fontSize: getDynamicHeight(size: 0.014),
                ),
              ),
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
              Image.asset(
                AppImage.attendance,
                color: currentIndex.value != -1 ? AppColor.primaryColor : AppColor.black,
                height: getDynamicHeight(size: 0.032),
                width: getDynamicHeight(size: 0.032),
              ),
              SizedBox(height: getDynamicHeight(size: 0.006)),
              Text(
                AppString.attendance,
                style: TextStyle(
                  color: currentIndex.value != -1 ? AppColor.primaryColor : AppColor.black,
                  // fontSize: 12,
                  fontSize: getDynamicHeight(size: 0.014),
                ),
              ),
            ],
          ),
        ),
        inactiveIcon: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImage.attendance,
                color: AppColor.black,
                height: getDynamicHeight(size: 0.034),
                width: getDynamicHeight(size: 0.034),
              ),
              SizedBox(height: getDynamicHeight(size: 0.006)),
              Text(
                AppString.attendance,
                style: TextStyle(
                  color: AppColor.black,
                  // fontSize: 12,
                  fontSize: getDynamicHeight(
                    size: 0.014,
                  ),
                ),
              ),
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
              Image.asset(
                AppImage.dashboard,
                color: currentIndex.value != -1 ? AppColor.primaryColor : AppColor.black,
                height: getDynamicHeight(size: 0.032),
                width: getDynamicHeight(size: 0.032),
              ),
              SizedBox(height: getDynamicHeight(size: 0.006)),
              Text(AppString.dashboard,
                  style: TextStyle(
                    color: currentIndex.value != -1 ? AppColor.primaryColor : AppColor.black,
                    // fontSize: 12,
                    fontSize: getDynamicHeight(size: 0.014),
                  )),
            ],
          ),
        ),
        inactiveIcon: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImage.dashboard,
                color: AppColor.black,
                height: getDynamicHeight(size: 0.032),
                width: getDynamicHeight(size: 0.032),
              ),
              SizedBox(height: getDynamicHeight(size: 0.006)),
              Text(AppString.dashboard,
                  style: TextStyle(
                    color: AppColor.black,
                    // fontSize: 12,
                    fontSize: getDynamicHeight(size: 0.014),
                  )),
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
              Image.asset(
                AppImage.leave,
                color: currentIndex.value != -1 ? AppColor.primaryColor : AppColor.black,
                height: getDynamicHeight(size: 0.032),
                width: getDynamicHeight(size: 0.032),
              ),
              SizedBox(height: getDynamicHeight(size: 0.006)),
              Text(AppString.leave,
                  style: TextStyle(
                    color: currentIndex.value != -1 ? AppColor.primaryColor : AppColor.black,
                    // fontSize: 12,
                    fontSize: getDynamicHeight(size: 0.014),
                  )),
            ],
          ),
        ),
        inactiveIcon: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImage.leave,
                color: AppColor.black,
                height: getDynamicHeight(size: 0.032),
                width: getDynamicHeight(size: 0.032),
              ),
              SizedBox(height: getDynamicHeight(size: 0.006)),
              Text(AppString.leave,
                  style: TextStyle(
                    color: AppColor.black,
                    // fontSize: 12,
                    fontSize: getDynamicHeight(size: 0.014),
                  )),
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
              Image.asset(
                AppImage.overtime,
                color: currentIndex.value != -1 ? AppColor.primaryColor : AppColor.black,
                height: getDynamicHeight(size: 0.032),
                width: getDynamicHeight(size: 0.032),
              ),
              SizedBox(height: getDynamicHeight(size: 0.006)),
              Text(AppString.overtime,
                  style: TextStyle(
                    color: currentIndex.value != -1 ? AppColor.primaryColor : AppColor.black,
                    // fontSize: 12,
                    fontSize: getDynamicHeight(size: 0.014),
                  )),
            ],
          ),
        ),
        inactiveIcon: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImage.overtime,
                color: AppColor.black,
                height: getDynamicHeight(size: 0.032),
                width: getDynamicHeight(size: 0.032),
              ),
              SizedBox(height: getDynamicHeight(size: 0.006)),
              Text(AppString.overtime,
                  style: TextStyle(
                    color: AppColor.black,
                    // fontSize: 12,
                    fontSize: getDynamicHeight(size: 0.014),
                  )),
            ],
          ),
        ),
        activeColorPrimary: AppColor.primaryColor,
        inactiveColorPrimary: AppColor.black,
      ),
    ];
  }
}
