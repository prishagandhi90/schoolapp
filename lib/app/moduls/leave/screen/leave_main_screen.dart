import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:emp_app/app/moduls/leave/screen/leave_screen.dart';
import 'package:emp_app/app/moduls/leave/screen/leave_view_screen.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

final GlobalKey<ScaffoldState> _scaffoldKeyLeave = GlobalKey<ScaffoldState>();

class LeaveMainScreen extends GetView<LeaveController> {
  LeaveMainScreen({super.key});

  // Define a GlobalKey for the scaffold

  @override
  Widget build(BuildContext context) {
    // Get.put(LeaveController());
    final LeaveController controller = Get.put(LeaveController()); // Always create a new instance
    controller.currentTabIndex.value = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scaffoldKeyLeave.currentState?.isEndDrawerOpen ?? false) {
        Navigator.pop(context);
      }
    });

    // return GetBuilder<LeaveController>(builder: (controller) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          backgroundColor: AppColor.white,
          key: _scaffoldKeyLeave,
          endDrawer: Drawer(
              child: controller.isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 100),
                        child: ProgressWithIcon(),
                      ),
                    )
                  : controller.leaveHeaderList.isNotEmpty
                      ? ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 10),
                              child: Container(
                                // height: MediaQuery.of(context).size.height * 0.12,
                                decoration: BoxDecoration(
                                    color: AppColor.lightblue1,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),
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
                                          color: AppColor.primaryColor),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(AppString.department, style: AppStyle.w50018)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                              controller.leaveentryList.isNotEmpty
                                                  ? controller.leaveHeaderList[0].department.toString()
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
                                                controller.leaveHeaderList.isNotEmpty
                                                    ? controller.leaveHeaderList[0].deptInc.toString()
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
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
                                          color: AppColor.primaryColor),
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
                                              controller.leaveHeaderList.isNotEmpty
                                                  ? controller.leaveHeaderList[0].deptHOD.toString()
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
                                    color: AppColor.lightblue1,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),
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
                                          color: AppColor.primaryColor),
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
                                              controller.leaveHeaderList.isNotEmpty
                                                  ? controller.leaveHeaderList[0].subDept.toString()
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
                                    color: AppColor.lightblue1,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                    )),
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
                                          color: AppColor.primaryColor),
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
                                              controller.leaveHeaderList.isNotEmpty
                                                  ? controller.leaveHeaderList[0].subDeptInc.toString()
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
                            )
                          ],
                        )
                      : Padding(
                          padding: EdgeInsets.all(15),
                          child: Center(child: Text(AppString.nodataavailable)),
                        )),
          appBar: AppBar(
            backgroundColor: AppColor.white,
            title: Text(AppString.leave, style: AppStyle.primaryplusw700),
            centerTitle: true,
            actions: [
              Builder(builder: (context) {
                return IconButton(
                  onPressed: () async {
                    // Scaffold.of(context).openEndDrawer();
                    // await Future.delayed(Duration(milliseconds: 50));
                    _scaffoldKeyLeave.currentState?.openEndDrawer();
                    if (controller.leaveHeaderList.isEmpty) await controller.fetchHeaderList("LV");
                  },
                  icon: SvgPicture.asset(AppImage.drawersvg, height: 15, width: 15),
                );
              })
            ],
            leading: IconButton(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final bottomBarController = Get.find<BottomBarController>();
                    bottomBarController.persistentController.value.index = 0; // Set index to Payroll tab
                    bottomBarController.currentIndex.value = 0;
                    hideBottomBar.value = false;
                    Get.back();
                  });
                },
                icon: const Icon(Icons.arrow_back)),
          ),
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
                    dividerColor: AppColor.trasparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    onTap: (value) async {
                      if (controller.leaveHeaderList.isEmpty) {
                        await controller.fetchHeaderList("LV");
                      }
                      await controller.changeTab(value);
                    },
                    controller: controller.tabController_Leave,
                    labelStyle: TextStyle(fontFamily: CommonFontStyle.plusJakartaSans),
                    indicator: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColor.primaryColor),
                    tabs: const [Tab(text: 'Leave'), Tab(text: 'View')],
                    physics: NeverScrollableScrollPhysics(),
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: controller.tabController_Leave,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    LeaveScreen(),
                    LeaveViewScreen(),
                  ],
                ),
              ),
            ],
          )),
    );
    // });
  }
}
