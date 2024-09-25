// ignore_for_file: must_be_immutable

import 'package:emp_app/app/app_custom_widget/common_text.dart';
import 'package:emp_app/app/moduls/dashboard/screen/custom_drawer.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Leavedemo extends GetView<LeaveController> {
  Leavedemo({super.key});
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Get.put(LeaveController());
    return GetBuilder<LeaveController>(builder: (controller) {
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: AppText(
            text: AppString.contact,
            fontSize: Sizes.px22,
            fontColor: AppColor.teal,
            fontWeight: FontWeight.w800,
          ),
          centerTitle: true,
          backgroundColor: AppColor.white,
          elevation: 2,
          excludeHeaderSemantics: false,
          surfaceTintColor: AppColor.white,
          shadowColor: AppColor.originalgrey,
          leading: IconButton(
              icon: Image.asset(
                AppImage.drawer,
                width: 20,
                color: AppColor.black,
              ),
              onPressed: () => scaffoldKey.currentState!.openDrawer()),
        ),
        backgroundColor: AppColor.white,
        onDrawerChanged: (isop) {
          var bottomBarController = Get.put(BottomBarController());
          hideBottomBar.value = isop;
          bottomBarController.update();
        },
        drawer: CustomDrawer(),
        body: Center(
          child: Text(
            AppString.comingsoon,
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    });
  }
}
