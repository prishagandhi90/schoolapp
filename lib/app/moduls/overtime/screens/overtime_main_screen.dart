// ignore_for_file: must_be_immutable

import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/dashboard/screen/custom_drawer.dart';
import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:emp_app/app/moduls/overtime/controller/overtime_controller.dart';
import 'package:emp_app/app/moduls/overtime/screens/overtime_screen.dart';
import 'package:emp_app/app/moduls/overtime/screens/overtime_view_screen.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

final GlobalKey<ScaffoldState> _scaffoldKeyOT = GlobalKey<ScaffoldState>();

class OvertimeMainScreen extends GetView<OvertimeController> {
  OvertimeMainScreen({super.key});
  // var scaffoldKey = GlobalKey<ScaffoldState>();
  // final leaveController = Get.put(LeaveController());

  @override
  Widget build(BuildContext context) {
    Get.put(OvertimeController());
    final LeaveController leaveController = Get.put(LeaveController()); // Always create a new instance
    leaveController.currentTabIndex.value = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scaffoldKeyOT.currentState?.isEndDrawerOpen ?? false) {
        Navigator.pop(context);
      }
    });

    return GetBuilder<OvertimeController>(builder: (controller) {
      return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
            backgroundColor: AppColor.white,
            key: _scaffoldKeyOT,
            endDrawer: Drawer(
                child: controller.isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 100),
                          child: ProgressWithIcon(),
                        ),
                      )
                    : controller.otHeaderList.isNotEmpty
                        ? ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20, left: 10),
                                child: Container(
                                  // height: MediaQuery.of(context).size.height * 0.12,
                                  decoration: BoxDecoration(
                                      color: AppColor.lightblue1, borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        width: double.infinity,
                                        height: 45,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20)), color: AppColor.primaryColor),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: Align(
                                              alignment: Alignment.centerLeft, child: Text(AppString.department, style: AppStyle.w50018)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                                controller.otHeaderList.isNotEmpty
                                                    ? controller.otHeaderList[0].department.toString()
                                                    : '--:--',
                                                style: AppStyle.plus500.copyWith(fontSize: MediaQuery.of(context).size.width * 0.04)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20, left: 10),
                                child: IntrinsicHeight(
                                  child: Container(
                                    // height: MediaQuery.of(context).size.height * 0.12, // Pehli ek specific height set kari
                                    constraints: BoxConstraints(
                                      maxHeight: MediaQuery.of(context).size.height * 0.30,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColor.lightblue1,
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          width: double.infinity,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
                                            color: AppColor.primaryColor,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 15),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(AppString.departmentincharge,
                                                  style: AppStyle.plus500.copyWith(
                                                    fontSize: MediaQuery.of(context).size.width * 0.04,
                                                  )),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                  controller.otHeaderList.isNotEmpty
                                                      ? controller.otHeaderList[0].deptInc.toString()
                                                      : '--:--',
                                                  style: AppStyle.plus500.copyWith(
                                                    fontSize: MediaQuery.of(context).size.width * 0.04,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20, left: 10),
                                child: Container(
                                  // height: MediaQuery.of(context).size.height * 0.12,
                                  decoration: BoxDecoration(
                                    color: AppColor.lightblue1,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        width: double.infinity,
                                        height: 45,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20)), color: AppColor.primaryColor),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(AppString.departmentHOD,
                                                  style: AppStyle.plus500.copyWith(
                                                    fontSize: MediaQuery.of(context).size.width * 0.04,
                                                  ))),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                                controller.otHeaderList.isNotEmpty
                                                    ? controller.otHeaderList[0].deptHOD.toString()
                                                    : '--:--',
                                                style: AppStyle.plus500.copyWith(
                                                  fontSize: MediaQuery.of(context).size.width * 0.04,
                                                )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20, left: 10),
                                child: Container(
                                  // height: MediaQuery.of(context).size.height * 0.12,
                                  decoration: BoxDecoration(
                                      color: AppColor.lightblue1, borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        width: double.infinity,
                                        height: 45,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20)), color: AppColor.primaryColor),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(AppString.subdepartment, style: AppStyle.w50018)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                                controller.otHeaderList.isNotEmpty
                                                    ? controller.otHeaderList[0].subDept.toString()
                                                    : '--:--',
                                                style: AppStyle.plus500.copyWith(fontSize: MediaQuery.of(context).size.width * 0.04)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20, left: 10),
                                child: Container(
                                  // height: MediaQuery.of(context).size.height * 0.12,
                                  decoration: BoxDecoration(
                                      color: AppColor.lightblue1, borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        width: double.infinity,
                                        height: 45,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20)), color: AppColor.primaryColor),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(AppString.subdepartmentincharge, style: AppStyle.w50018)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                                controller.otHeaderList.isNotEmpty
                                                    ? controller.otHeaderList[0].subDeptInc.toString()
                                                    : '--:--',
                                                style: AppStyle.plus500.copyWith(fontSize: MediaQuery.of(context).size.width * 0.04)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        : Padding(
                            padding: EdgeInsets.all(15),
                            child: Center(child: Text(AppString.nodataavailable)),
                          )),
            appBar: AppBar(
              backgroundColor: AppColor.white,
              title: Text(AppString.overtime, style: AppStyle.primaryplusw700),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final bottomBarController = Get.find<BottomBarController>();
                    bottomBarController.persistentController.value.index = 0; // Set index to Payroll tab
                    bottomBarController.currentIndex.value = 0;
                    hideBottomBar.value = false;
                    Get.back();
                  });
                },
              ),
              actions: [
                Builder(builder: (context) {
                  return IconButton(
                    onPressed: () async {
                      Scaffold.of(context).openEndDrawer();
                      if (controller.otHeaderList.isEmpty) {
                        await controller.fetchHeaderList("OT");
                      }
                    },
                    icon: SvgPicture.asset(AppImage.drawersvg, height: 15, width: 15),
                  );
                })
              ],
            ),
            onDrawerChanged: (isop) {
              hideBottomBar.value = isop;
            },
            drawer: CustomDrawer(),
            body: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.lightblue,
                    ),
                    child: TabBar(
                      labelColor: AppColor.white,
                      unselectedLabelColor: AppColor.black,
                      dividerColor: AppColor.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      onTap: (value) async {
                        if (controller.otHeaderList.isEmpty) {
                          await controller.fetchHeaderList("OT");
                        }
                        hideBottomBar.value = false;
                        await controller.changeTab(value);
                      },
                      controller: controller.tabController_OT,
                      labelStyle: TextStyle(fontFamily: CommonFontStyle.plusJakartaSans),
                      indicator: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColor.primaryColor),
                      tabs: const [Tab(text: 'OT'), Tab(text: 'View')],
                      physics: NeverScrollableScrollPhysics(),
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: controller.tabController_OT,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      OtScreen(),
                      OvertimeViewScreen(),
                    ],
                  ),
                ),
              ],
            )),
      );
    });
  }
}
