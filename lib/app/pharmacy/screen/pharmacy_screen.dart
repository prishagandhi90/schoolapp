import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/pharmacy/controller/pharmacy_controller.dart';
import 'package:emp_app/app/pharmacy/screen/presviewer_screen.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class PharmacyScreen extends StatelessWidget {
  const PharmacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PharmacyController());
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          AppString.pharmacy,
          style: TextStyle(
            color: AppColor.primaryColor,
            fontWeight: FontWeight.w700,
            fontFamily: CommonFontStyle.plusJakartaSans,
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Image.asset(
                AppImage.drawer,
                width: 20,
                color: AppColor.black,
              ),
            );
          },
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Image.asset(
                AppImage.notification,
                width: 20,
              ))
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: GestureDetector(
              // onTap: () => Get.to(PresviewerScreen()),
              onTap: () {
                final bottomBarController = Get.put(BottomBarController());
                bottomBarController.currentIndex.value = -1;

                // // Get.delete<MispunchController>();
                // final presviewerScreen = Get.put(PresviewerScreen());
                // presviewerScreen.resetData();
                // presviewerScreen.update();
                // // Get.put(MispunchScreen());
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: PresviewerScreen(),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                ).then((value) async {
                  // final bottomBarController = Get.find<BottomBarController>();
                  bottomBarController.persistentController.value.index = 0;
                  bottomBarController.currentIndex.value = 0;
                  bottomBarController.isPharmacyHome.value = true;
                  hideBottomBar.value = false;
                  var dashboardController = Get.put(DashboardController());
                  await dashboardController.getDashboardDataUsingToken();
                });
              },
              child: Container(
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(color: AppColor.lightblue),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    'Prescription Viewer',
                    style: AppStyle.plus17w600,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
