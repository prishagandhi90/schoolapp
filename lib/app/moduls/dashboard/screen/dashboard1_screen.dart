import 'package:emp_app/app/app_custom_widget/custom_drawer.dart';
import 'package:emp_app/app/app_custom_widget/custom_gridview.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboard1Screen extends GetView<DashboardController> {
  const Dashboard1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DashboardController());
    return GetBuilder<DashboardController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColor.white,
          onDrawerChanged: (isop) {
            var bottomBarController = Get.put(BottomBarController());
            hideBottomBar.value = isop;
            bottomBarController.update();
          },
          drawer: CustomDrawer(),
          appBar: AppBar(
            backgroundColor: AppColor.white,
            title: Text(
              'Venus Hospital',
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
                    'assets/image/drawer.png',
                    width: 20,
                    color: AppColor.black,
                  ),
                );
              },
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    Get.snackbar(
                      'Coming Soon',
                      '',
                      colorText: Colors.white,
                      backgroundColor: Colors.black,
                      duration: const Duration(seconds: 1),
                    );
                  },
                  icon: Image.asset(
                    'assets/image/notification.png',
                    width: 20,
                  ))
            ],
          ),
          body: const CustomGridview(),
        ),
      );
    });
  }
}
