// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
// import 'package:emp_app/app/core/util/sizer_constant.dart';
// import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';

// class BottomBarView extends GetView<BottomBarController> {
//   const BottomBarView({super.key, required this.context1});

//   final BuildContext context1;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PersistentTabView(
//         context,
//         controller: controller.persistentController,
//         handleAndroidBackButtonPress: true,
//         backgroundColor: Colors.white,
//         navBarHeight: kBottomNavigationBarHeight,
//         // decoration: NavBarDecoration(
//         //   borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
//         //   colorBehindNavBar: Colors.transparent,
//         //   boxShadow: [
//         //     BoxShadow(
//         //       color: Colors.grey.withOpacity(0.1),
//         //       spreadRadius: 3.0,
//         //     ),
//         //   ],
//         // ),
//         // animationSettings: const NavBarAnimationSettings(
//         //   navBarItemAnimation: ItemAnimationSettings(
//         //     duration: Duration(milliseconds: 200),
//         //     curve: Curves.ease,
//         //   ),
//         //   screenTransitionAnimation: ScreenTransitionAnimationSettings(
//         //     animateTabTransition: false,
//         //     curve: Curves.ease,
//         //     duration: Duration(milliseconds: 100),
//         //   ),
//         // ),
//         screens: controller.buildScreens(),
//         items: controller.items(context),
//         navBarStyle: NavBarStyle.style8,
//         stateManagement: false,
//         resizeToAvoidBottomInset: true,
//         // bottomScreenMargin: Sizes.crossLength * 0.020,
//         onItemSelected: (value) {
//           controller.onItemTapped(value);
//         },
//       ),
//     );
//   }
// }
