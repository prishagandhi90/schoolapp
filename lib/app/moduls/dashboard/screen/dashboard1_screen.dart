import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/dashboard/screen/custom_drawer.dart';
import 'package:emp_app/app/app_custom_widget/custom_gridview.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
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
            // var bottomBarController = Get.put(BottomBarController());
            hideBottomBar.value = isop;
            // bottomBarController.update();
          },
          drawer: CustomDrawer(),
          appBar: AppBar(
            backgroundColor: AppColor.white,            
            title: Text(
              AppString.venushospital,
              style: TextStyle(
                color: AppColor.primaryColor,
                fontWeight: FontWeight.w700,
                fontFamily: CommonFontStyle.plusJakartaSans,
              ),
            ),
            excludeHeaderSemantics: false,
            leading: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Image.asset(
                    AppImage.drawer,
                    width: getDynamicHeight(size: 0.022),
                    color: AppColor.black,
                  ),
                );
              },
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    // Get.to(NotificationScreen());
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
                    width: getDynamicHeight(size: 0.022),
                  ))
            ],
          ),
          body: controller.isLoading.value
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: getDynamicHeight(size: 0.102)), //100),
                  child: Center(child: ProgressWithIcon()),
                )
              : const CustomGridview(),
        ),
      );
    });
  }
}
