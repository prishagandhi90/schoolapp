// ignore_for_file: must_be_immutable

import 'package:emp_app/app/app_custom_widget/common_text.dart';
import 'package:emp_app/app/moduls/dashboard/screen/custom_drawer.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/overtime/controller/overtime_controller.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OvertimeScreen extends GetView<OvertimeController> {
  OvertimeScreen({super.key});
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Get.put(OvertimeController());
    return GetBuilder<OvertimeController>(builder: (controller) {
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: AppText(
            text: 'Contact',
            fontSize: Sizes.px22,
            fontColor: AppColor.teal,
            fontWeight: FontWeight.w800,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 2,
          excludeHeaderSemantics: false,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.grey,
          leading: IconButton(
              icon: Image.asset(
                'assets/image/drawer.png',
                width: 20,
                color: AppColor.black,
              ),
              onPressed: () => scaffoldKey.currentState!.openDrawer()),
        ),
        backgroundColor: Colors.white,
        onDrawerChanged: (isop) {
          // var bottomBarController = Get.put(BottomBarController());
          final bottomBarController = Get.isRegistered<BottomBarController>()
              ? Get.find<BottomBarController>() // If already registered, find it
              : Get.put(BottomBarController());
          hideBottomBar.value = isop;
          bottomBarController.update();
        },
        drawer: CustomDrawer(),
        body: const Center(
          child: Text(
            'Coming Soon...',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    });
  }
}
