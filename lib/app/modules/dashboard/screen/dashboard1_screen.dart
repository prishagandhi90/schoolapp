import 'package:schoolapp/app/app_custom_widget/custom_progressloader.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:schoolapp/app/modules/dashboard/screen/custom_drawer.dart';
import 'package:schoolapp/app/app_custom_widget/custom_gridview.dart';
import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/app_font_name.dart';
import 'package:schoolapp/app/core/util/app_image.dart';
import 'package:schoolapp/app/core/util/app_string.dart';
import 'package:schoolapp/app/modules/dashboard/controller/dashboard_controller.dart';
import 'package:schoolapp/app/modules/notification/controller/notification_controller.dart';
import 'package:schoolapp/app/modules/notification/screen/notification_screen.dart';
import 'package:schoolapp/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class Dashboard1Screen extends GetView<DashboardController> {
  Dashboard1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DashboardController());
    return GetBuilder<DashboardController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColor.white,
          onDrawerChanged: (isop) {
            hideBottomBar.value = isop;
          },
          drawer: CustomDrawer(), // Drawer open ya close hone par bottom nav bar chhupana/show karna
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
              Padding(
                padding: EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    final notificationController = Get.put(NotificationController());
                    // Agar notifications list khali hai to fetch karo
                    if (notificationController.filternotificationlist.isEmpty) {
                      notificationController.fetchNotificationList();
                    }
                    // NotificationScreen par navigate karna (PersistentNavBar ke sath)
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: NotificationScreen(),
                      withNavBar: false,
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    ).then((value) async {
                      await notificationController.clearFilters();
                      await controller.getDashboardDataUsingToken();
                    });
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset(
                        AppImage.notification,
                        width: getDynamicHeight(size: 0.022),
                      ),
                      // Notification badge dikha rahe hain agar count > 0 ho
                      if (controller.notificationCount != "0") // 👈 Condition lagayi
                        Positioned(
                          right: -2,
                          top: -6,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColor.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              controller.notificationCount,
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
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
