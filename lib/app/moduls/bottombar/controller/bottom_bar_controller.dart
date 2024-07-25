import 'package:emp_app/app/moduls/attendence/screen/attendance_screen.dart';
import 'package:emp_app/app/moduls/dashboard/screen/dashboard1_screen.dart';
import 'package:emp_app/app/moduls/payroll/screen/payroll_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomBarController extends GetxController {
  final count = 0.obs;
  final Rx<int> selectedIndex = 2.obs;
  PersistentTabController? persistentController = PersistentTabController(initialIndex: 2);
  @override
  void onInit() {
    persistentController = PersistentTabController(initialIndex: 0);
    super.onInit();
  }

  @override
  void onClose() {
    persistentController!.dispose();
    super.onClose();
  }

  // Widget buildBottomNavigationBar(BuildContext context) {
  //   return PersistentTabView(
  //     context,
  //     controller: persistentController,
  //     screens: buildScreens(),
  //     items: navBarsItems(),
  //     // navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0 ? 0.0 : kBottomNavigationBarHeight,
  //     backgroundColor: Colors.white,
  //     handleAndroidBackButtonPress: true,
  //     resizeToAvoidBottomInset: true,
  //     stateManagement: true,
  //     // hideNavigationBarWhenKeyboardShows: true,
  //     decoration: NavBarDecoration(
  //       boxShadow: [
  //         BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 10.0),
  //       ],
  //     ),
  //     animationSettings: const NavBarAnimationSettings(
  //       navBarItemAnimation: ItemAnimationSettings(
  //         duration: Duration(milliseconds: 200),
  //         curve: Curves.ease,
  //       ),
  //       screenTransitionAnimation: ScreenTransitionAnimationSettings(
  //         animateTabTransition: true,
  //         curve: Curves.ease,
  //         duration: Duration(milliseconds: 100),
  //       ),
  //     ),
  //     navBarStyle: NavBarStyle.style15,
  //   );
  // }

  List<Widget> buildScreens() {
    return [
      const PayrollScreen(),
      const AttendanceScreen(),
      Dashboard1Screen(),
      const PayrollScreen(),
      const AttendanceScreen(),
    ];
  }

  Widget get currentScreen => buildScreens()[selectedIndex.value];

  // List<PersistentBottomNavBarItem> navBarsItems() {
  //   return [
  //     PersistentBottomNavBarItem(
  //       title: "Home",
  //       icon: Image.asset('assets/image/home.png'),
  //       inactiveIcon: Image.asset('assets/image/home.png'),
  //       activeColorPrimary: const Color.fromARGB(255, 94, 157, 168),
  //     ),
  //     PersistentBottomNavBarItem(
  //       title: "Attendence",
  //       icon: Image.asset('assets/image/attendence.png'),
  //       inactiveIcon: Image.asset('assets/image/attendence.png'),
  //       activeColorPrimary: const Color.fromARGB(255, 94, 157, 168),
  //     ),
  //     PersistentBottomNavBarItem(
  //       icon: Image.asset('assets/image/dashboard.png',),
  //       title: "Dashboard",
  //       activeColorPrimary: Colors.white,
  //       inactiveColorPrimary: Colors.grey,
  //     ),
  //     PersistentBottomNavBarItem(
  //       title: "Leave",
  //       icon: Image.asset('assets/image/leave.png'),
  //       inactiveIcon: Image.asset('assets/image/leave.png'),
  //       activeColorPrimary: const Color.fromARGB(255, 94, 157, 168),
  //     ),
  //     PersistentBottomNavBarItem(
  //       title: "Over Time",
  //       icon: Image.asset('assets/image/overtime.png'),
  //       inactiveIcon: Image.asset('assets/image/overtime.png'),
  //       activeColorPrimary: const Color.fromARGB(255, 94, 157, 168),
  //     ),
  //   ];
  // }
  List<NavigationDestination> navBarsItems() {
    return [
      NavigationDestination(
        icon: Image.asset('assets/image/home.png', width: 20.0),
        label: "Home",
      ),
      NavigationDestination(
        icon: Image.asset('assets/image/attendence.png', width: 20.0),
        label: "Attendence",
      ),
      NavigationDestination(
          icon: Image.asset(
            'assets/image/dashboard.png',
            width: 20.0,
            color: Colors.black,
          ),
          label: "Dashboard"),
      NavigationDestination(
        icon: Image.asset('assets/image/leave.png', width: 20.0),
        label: "Leave",
      ),
      NavigationDestination(
        icon: Image.asset('assets/image/overtime.png', width: 20.0),
        label: "Over Time",
      )
    ];
  }
}

// class BottomNavigationController extends GetxController {
//   late PersistentTabController controller;

//   @override
//   void onInit() {
//     controller = PersistentTabController(initialIndex: 0);
//     super.onInit();
//   }

//   @override
//   void onClose() {}
// }
  // @override
  // void onInit() async {
  //   super.onInit();
  //   update();
  // }

  // List<Widget> buildScreens() {
  //   return [
  //     const PayrollScreen(),
  //     const AttendanceScreen(),
  //     Dashboard1Screen(),
  //     const PayrollScreen(),
  //     const AttendanceScreen(),
  //   ];
  // }

  // List<PersistentBottomNavBarItem> items(BuildContext? ctx) {
  //   return [
  //     PersistentBottomNavBarItem(
  //       title: "Home",
  //       icon: Image.asset(
  //         'assets/image/home.png',
  //         color: const Color.fromARGB(255, 94, 157, 168),
  //       ),
  //       inactiveIcon: Image.asset(
  //         'assets/image/home.png',
  //         height: Sizes.crossLength * 0.050,
  //         color: Colors.black,
  //       ),
  //       activeColorPrimary: const Color.fromARGB(255, 94, 157, 168),
  //       textStyle: TextStyle(
  //         fontSize: Sizes.px12,
  //         fontWeight: FontWeight.w600,
  //       ),
  //     ),
  //     PersistentBottomNavBarItem(
  //       title: "Attendence",
  //       textStyle: TextStyle(fontSize: Sizes.px12, fontWeight: FontWeight.w600),
  //       icon: Image.asset(
  //         'assets/image/attendence.png',
  //       ),
  //       inactiveIcon: Image.asset(
  //         'assets/image/home.png',
  //         color: Colors.black,
  //       ),
  //       activeColorPrimary: Color.fromARGB(255, 94, 157, 168),
  //     ),
  //     PersistentBottomNavBarItem(
  //       icon: Image.asset('assets/image/dashboard.png'),
  //       title: "",
  //       activeColorPrimary: Colors.blueAccent,
  //       inactiveColorPrimary: Colors.grey,
  //       // activeColorSecondary: _getSecondaryItemColorForSpecificStyles(),
  //     ),
  //     PersistentBottomNavBarItem(
  //       title: "Leave",
  //       textStyle: TextStyle(
  //         fontSize: Sizes.px12,
  //         fontWeight: FontWeight.w600,
  //       ),
  //       icon: Image.asset(
  //         'assets/image/leave.png',
  //       ),
  //       inactiveIcon: Image.asset(
  //         'assets/image/leave.png',
  //         color: Colors.black,
  //       ),
  //       activeColorPrimary: Color.fromARGB(255, 94, 157, 168),
  //     ),
  //     PersistentBottomNavBarItem(
  //       title: "Over Time",
  //       textStyle: TextStyle(
  //         fontSize: Sizes.px12,
  //         fontWeight: FontWeight.w600,
  //       ),
  //       icon: Image.asset(
  //         'assets/image/overtime.png',
  //       ),
  //       inactiveIcon: Image.asset(
  //         'assets/image/overtime.png',
  //         color: Colors.black,
  //       ),
  //       activeColorPrimary: Color.fromARGB(255, 94, 157, 168),
  //     ),
  //   ];
  // }

  // void onItemTapped(int index) {
  //   print("=====index---$index");
  //   persistentController!.jumpToTab(index);
  //   update();
  // }

