// ignore_for_file: must_be_immutable

import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:emp_app/app/moduls/leave/screen/leave_screen.dart';
import 'package:emp_app/app/moduls/leave/screen/leave_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LeaveMainScreen extends GetView<LeaveController> {
  LeaveMainScreen({this.fromDashboard = false, super.key});
  final bool fromDashboard;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Get.put(LeaveController());
    // controller.setActiveScreen("LeaveMainScreen");
    return GetBuilder<LeaveController>(builder: (controller) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
            backgroundColor: Colors.white,
            key: scaffoldKey,
            endDrawer: Drawer(
                child: controller.isLoading.value
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 100),
                          child: ProgressWithIcon(),
                        ),
                      )
                    : controller.leaveentryList.isNotEmpty
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
                                              child: Text(
                                                'Department',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500, //20
                                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                                ),
                                              )),
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
                                                  ? controller.leaveentryList[0].department.toString()
                                                  : '--:--',
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.width * 0.04,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: CommonFontStyle.plusJakartaSans,
                                              ),
                                            ),
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
                                              child: Text(
                                                'Department In-charge',
                                                style: TextStyle(
                                                  // fontSize: 18,
                                                  fontSize: MediaQuery.of(context).size.width * 0.05,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                                ),
                                              ),
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
                                                controller.leaveentryList.isNotEmpty
                                                    ? controller.leaveentryList[0].deptInc.toString()
                                                    : '--:--',
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width * 0.04,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                                ),
                                              ),
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
                                              child: Text(
                                                'Department HOD',
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width * 0.05,
                                                  fontWeight: FontWeight.w500, //20
                                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                                ),
                                              )),
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
                                                  ? controller.leaveentryList[0].deptHOD.toString()
                                                  : '--:--',
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.width * 0.04,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: CommonFontStyle.plusJakartaSans,
                                              ),
                                            ),
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
                                              child: Text(
                                                'Sub Department',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500, //20
                                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                                ),
                                              )),
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
                                                  ? controller.leaveentryList[0].subDept.toString()
                                                  : '--:--',
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.width * 0.04,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: CommonFontStyle.plusJakartaSans,
                                              ),
                                            ),
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
                                              child: Text(
                                                'Sub Department In-Charge',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500, //20
                                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                                ),
                                              )),
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
                                                  ? controller.leaveentryList[0].subDeptInc.toString()
                                                  : '--:--',
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.width * 0.04,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: CommonFontStyle.plusJakartaSans,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        : const Padding(
                            padding: EdgeInsets.all(15),
                            child: Center(child: Text('No data available')),
                          )),
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                'Leave',
                style: TextStyle(
                    color: const Color.fromARGB(255, 94, 157, 168),
                    fontWeight: FontWeight.w700,
                    fontFamily: CommonFontStyle.plusJakartaSans),
              ),
              centerTitle: true,
              actions: [
                Builder(builder: (context) {
                  return IconButton(
                    onPressed: () async {
                      Scaffold.of(context).openEndDrawer();
                      if (controller.leaveentryList.isEmpty) await controller.fetchLeaveEntryList("LV");
                    },
                    icon: SvgPicture.asset('assets/image/svg/drawer.svg', height: 15, width: 15),
                  );
                })
              ],
              leading: IconButton(
                  onPressed: () {
                    // controller.dispose();
                    // Get.delete<LeaveController>();
                    Navigator.pop(context);
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
                      color: const Color.fromARGB(255, 223, 239, 241),
                    ),
                    child: TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: AppColor.black,
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      onTap: (value) async {
                        if (value == 1 && controller.leaveentryList.isEmpty) {
                          await controller.fetchLeaveEntryList("LV");
                        }
                      },
                      labelStyle: TextStyle(fontFamily: CommonFontStyle.plusJakartaSans),
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10), color: const Color.fromARGB(255, 94, 157, 168)),
                      tabs: const [Tab(text: 'Leave'), Tab(text: 'View')],
                      physics: NeverScrollableScrollPhysics(),
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
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
    });
  }
}
