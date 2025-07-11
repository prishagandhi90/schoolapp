import 'package:schoolapp/app/core/common/common_methods.dart';
import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/app_image.dart';
import 'package:schoolapp/app/core/util/app_string.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:schoolapp/app/modules/IPD/admitted%20patient/screen/ipd_dashboard_screen.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/attendence/controller/attendence_controller.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/attendence/screen/attendance_screen.dart';
import 'package:schoolapp/app/modules/common/module.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/leave/controller/leave_controller.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/leave/screen/leave_main_screen.dart';
import 'package:schoolapp/app/modules/dashboard/screen/dashboard1_screen.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/overtime/screens/overtime_main_screen.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/payroll/screen/payroll_screen.dart';
import 'package:schoolapp/app/modules/pharmacy/screen/pharmacy_screen.dart';
import 'package:schoolapp/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomBarController extends GetxController {
  RxInt currentIndex = (2).obs; // Current selected index of bottom navigation
  Rx<PersistentTabController> persistentController = PersistentTabController(initialIndex: 2).obs;
  // Flags to determine which screen to load inside the first tab
  RxBool isPharmacyHome = false.obs;
  RxBool isIPDHome = false.obs;
  RxBool isPayrollHome = false.obs;
  RxBool isDashboardHome = false.obs;
  List<ModuleScreenRights> payrollModuleScreenRightsTable = [];

  @override
  void onInit() {
    super.onInit();
    loadPayrollScreens_Rights(); // Load Payroll screen rights when controller initializes
    // persistentController = PersistentTabController(initialIndex: 2);
    hideBottomBar.value = false;
    // update();
  }

  Future<void> loadPayrollScreens_Rights() async {
    payrollModuleScreenRightsTable = await CommonMethods.fetchModuleScreens("Payroll");
    update();
  }

  // Widget getHomeTab() {
  //   if (isPharmacyHome.value) return PharmacyScreen();
  //   if (isIPDHome.value) return IpdDashboardScreen();
  //   if (isPayrollHome.value) return PayrollScreen();
  //   return Dashboard1Screen();
  // }

  Widget getHomeTab() {
    if (isPharmacyHome.value) {
      print("➡️ Loading PharmacyScreen");
      return PharmacyScreen();
    }
    if (isIPDHome.value) {
      print("➡️ Loading IpdDashboardScreen");
      return IpdDashboardScreen();
    }
    if (isPayrollHome.value) {
      print("➡️ Loading PayrollScreen");
      return PayrollScreen();
    }
    print("➡️ Loading Default Dashboard1Screen");
    return Dashboard1Screen();
  }

  // List<Widget> buildScreens() {
  //   return [
  //     // First tab switches dynamically based on flags
  //     Navigator(
  //       key: Get.nestedKey(1),
  //       onGenerateRoute: (settings) {
  //         return MaterialPageRoute(
  //           builder: (_) => getHomeTab(), // isPharmacyHome/IPDHome check
  //           settings: RouteSettings(name: 'DynamicHome'),
  //         );
  //       },
  //     ),
  //     AttendanceScreen(),
  //     Dashboard1Screen(),
  //     LeaveMainScreen(),
  //     OvertimeMainScreen(),
  //   ];
  // }

  List<Widget> buildScreens() {
    return [
      // First tab switches dynamically based on flags
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

// Reset tab controller and flags to default (Dashboard)
  void resetAndInitialize() {
    currentIndex.value = 2;
    isPharmacyHome.value = false;
    isIPDHome.value = false;
    isPayrollHome.value = false;
    persistentController.value = PersistentTabController(initialIndex: 2);
    hideBottomBar.value = false;
    // update();
  }

  // Reset and navigate to a specific screen/tab by index
  void resetAndInitializeToScreen(int index) {
    currentIndex.value = index;
    persistentController.value.index = index;
    hideBottomBar.value = false;
    // Reset flags if Dashboard tab is selected
    if (index == 2) {
      isPharmacyHome.value = false;
      isIPDHome.value = false;
      isPayrollHome.value = false;
    }
    // update();
  }

  // Another reset method to force recreate controller with a different tab
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
              Image.asset(AppImage.home, color: AppColor.black, height: getDynamicHeight(size: 0.034), width: getDynamicHeight(size: 0.034)),
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
