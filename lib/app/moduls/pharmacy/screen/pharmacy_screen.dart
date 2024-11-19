import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/moduls/pharmacy/controller/pharmacy_controller.dart';
import 'package:emp_app/app/moduls/pharmacy/screen/presviewer_screen.dart';
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
              onPressed: () {
                Get.snackbar(
                  AppString.comingsoon,
                  '',
                  colorText: AppColor.white,
                  backgroundColor: AppColor.black,
                  duration: const Duration(seconds: 1),
                );
              },
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
            padding: const EdgeInsets.symmetric(vertical: 35),
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
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.lightblue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Prescription Viewer',
                          style: AppStyle.plus17w600.copyWith(fontSize: 19),
                        ),
                      ),
                      // Image Section
                      SizedBox(
                        width: 150,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: -40, // To show half the image outside the container
                              child: Image.asset(
                                'assets/image/medicine.png', // Replace with your image path
                                height: 100,
                                width: 100,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}
