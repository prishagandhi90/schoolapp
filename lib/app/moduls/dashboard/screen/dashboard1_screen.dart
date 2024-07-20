import 'package:emp_app/app/app_custom_widget/custom_drawer.dart';
import 'package:emp_app/app/app_custom_widget/custom_gridview.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboard1Screen extends StatelessWidget {
  Dashboard1Screen({super.key});

  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: CustomDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('VENUS HOSPITAL', style: TextStyle(color: Color.fromARGB(255, 94, 157, 168), fontWeight: FontWeight.w700)),
          centerTitle: true,
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_active_outlined))],
        ),
        body: const CustomGridview(),
        // bottomNavigationBar: barController.buildBottomNavigationBar(context),
      ),
    );
  }
}
//   Widget buildBottomNavigationBar(BuildContext context) {
//     return GetBuilder<BottomNavigationController>(
//       init: BottomNavigationController(),
//       builder: (controller) => PersistentTabView(
//         context,
//         controller: controller.controller,
//         screens: buildScreens(),
//         items: navBarsItems(),
//         navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0 ? 0.0 : kBottomNavigationBarHeight,
//         backgroundColor: Colors.white,
//         handleAndroidBackButtonPress: true,
//         resizeToAvoidBottomInset: true,
//         stateManagement: true,
//         // hideNavigationBarWhenKeyboardShows: true,
//         decoration: NavBarDecoration(
//           boxShadow: [
//             BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 10.0),
//           ],
//         ),
//         animationSettings: const NavBarAnimationSettings(
//           navBarItemAnimation: ItemAnimationSettings(
//             duration: Duration(milliseconds: 200),
//             curve: Curves.ease,
//           ),
//           screenTransitionAnimation: ScreenTransitionAnimationSettings(
//             animateTabTransition: true,
//             curve: Curves.ease,
//             duration: Duration(milliseconds: 100),
//           ),
//         ),
//         navBarStyle: NavBarStyle.style15,
//       ),
//     );
//   }

//   List<Widget> buildScreens() {
//     return [
//       const PayrollScreen(),
//       const AttendanceScreen(),
//        MispunchScreen(),
//       const PayrollScreen(),
//       const AttendanceScreen(),
//     ];
//   }

//   List<PersistentBottomNavBarItem> navBarsItems() {
//     return [
//       PersistentBottomNavBarItem(
//         title: "Home",
//         icon: Image.asset(
//           'assets/image/home.png',
//           // color: const Color.fromARGB(255, 94, 157, 168),
//         ),
//         inactiveIcon: Image.asset(
//           'assets/image/home.png',
//           // height: Sizes.crossLength * 0.050,
//           // color: Colors.black,
//         ),
//         activeColorPrimary: const Color.fromARGB(255, 94, 157, 168),
//         // textStyle: TextStyle(
//         //   fontSize: Sizes.px12,
//         //   fontWeight: FontWeight.w600,
//         // ),
//       ),
//       PersistentBottomNavBarItem(
//         title: "Attendence",
//         // textStyle: TextStyle(fontSize: Sizes.px12, fontWeight: FontWeight.w600),
//         icon: Image.asset(
//           'assets/image/attendence.png',
//         ),
//         inactiveIcon: Image.asset(
//           'assets/image/attendence.png',
//           // color: Colors.black,
//         ),
//         activeColorPrimary: const Color.fromARGB(255, 94, 157, 168),
//       ),
//       PersistentBottomNavBarItem(
//         icon: Image.asset('assets/image/dashboard.png'),
//         title: "",
//         activeColorPrimary: Colors.blueAccent,
//         inactiveColorPrimary: Colors.grey,
//         // activeColorSecondary: _getSecondaryItemColorForSpecificStyles(),
//       ),
//       PersistentBottomNavBarItem(
//         title: "Leave",
//         icon: Image.asset(
//           'assets/image/leave.png',
//           // color: const Color.fromARGB(255, 94, 157, 168),
//         ),
//         inactiveIcon: Image.asset(
//           'assets/image/leave.png',
//           // height: Sizes.crossLength * 0.050,
//           // color: Colors.black,
//         ),
//         activeColorPrimary: const Color.fromARGB(255, 94, 157, 168),
//         // textStyle: TextStyle(
//         //   fontSize: Sizes.px12,
//         //   fontWeight: FontWeight.w600,
//         // ),
//       ),
//       PersistentBottomNavBarItem(
//         title: "Over Time",
//         icon: Image.asset(
//           'assets/image/overtime.png',
//           // color: const Color.fromARGB(255, 94, 157, 168),
//         ),
//         inactiveIcon: Image.asset(
//           'assets/image/overtime.png',
//           // height: Sizes.crossLength * 0.050,
//           // color: Colors.black,
//         ),
//         activeColorPrimary: const Color.fromARGB(255, 94, 157, 168),
//         // textStyle: TextStyle(
//         //   fontSize: Sizes.px12,
//         //   fontWeight: FontWeight.w600,
//       ),
//     ];
//   }
// }

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

// import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
// import 'package:emp_app/app/moduls/bottombar/screen/bottom_bar_screen.dart';
// import 'package:emp_app/app/app_custom_widget/custom_drawer.dart';
// import 'package:emp_app/app/app_custom_widget/custom_gridview.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class Dashboard1Screen extends StatelessWidget {
//   const Dashboard1Screen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       drawer: CustomDrawer(),
//       onDrawerChanged: (isOpened) {
//         var bottomBarController = Get.put(BottomBarController());
//         bottomBarController.update();
//       },
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text(
//           'VENUS HOSPITAL',
//           style: TextStyle(color: Color.fromARGB(255, 94, 157, 168), fontWeight: FontWeight.w700),
//         ),
//         centerTitle: true,
//         actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_active_outlined))],
//       ),
//       body: const CustomGridview(),
//       bottomNavigationBar: const BottomBarView(),
//     );
//   }
// }
