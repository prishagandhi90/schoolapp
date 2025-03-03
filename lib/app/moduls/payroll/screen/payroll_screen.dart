import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/attendence/controller/attendence_controller.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/moduls/dutyschedule/controller/dutyschedule_controller.dart';
import 'package:emp_app/app/moduls/dutyschedule/screen/dutyschedule_screen.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:emp_app/app/moduls/lvotApproval/controller/lvotapproval_controller.dart';
import 'package:emp_app/app/moduls/lvotApproval/screen/lvotapproval_screen.dart';
import 'package:emp_app/app/moduls/mispunch/controller/mispunch_controller.dart';
import 'package:emp_app/app/moduls/mispunch/screen/mispunch_screen.dart';
import 'package:emp_app/app/moduls/payroll/controller/payroll_controller.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class PayrollScreen extends GetView<PayrollController> {
  PayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PayrollController());

    double screenHeight = MediaQuery.of(context).size.height;
    double availableHeight = screenHeight - 85.0; // 70.0 is the height of BottomNavigationBar

    return GetBuilder<PayrollController>(
        init: PayrollController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColor.white,
            onDrawerChanged: (isOpened) {
              // var bottomBarController = Get.put(BottomBarController());
              hideBottomBar.value = isOpened;
              // bottomBarController.update();
              if (isOpened) {
                controller.filterSearchResults(''); // Reset the filter
                controller.textEditingController.clear();
              }
            },
            drawer: Drawer(
                backgroundColor: AppColor.white,
                child: ListView(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(vertical: getDynamicHeight(size: 0.022))), //20)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.012)), //10),
                      child: TextFormField(
                        focusNode: controller.focusNode,
                        cursorColor: AppColor.grey,
                        controller: controller.textEditingController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.lightgrey1, width: 1.0),
                            borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.027)), //25),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.027)), //25.0),
                            borderSide: BorderSide(
                              color: AppColor.lightgrey1,
                            ),
                          ),
                          prefixIcon: Icon(Icons.search, color: AppColor.lightgrey1),
                          suffixIcon: controller.hasFocus
                              ? IconButton(
                                  icon: Icon(
                                    Icons.cancel_outlined,
                                    color: Color.fromARGB(255, 192, 191, 191),
                                  ),
                                  onPressed: () {
                                    controller.textEditingController.clear();
                                    controller.filterSearchResults('');
                                  },
                                )
                              : null,
                          hintText: AppString.search,
                          hintStyle: TextStyle(
                            color: AppColor.lightgrey1,
                            fontFamily: CommonFontStyle.plusJakartaSans,
                          ),
                          filled: true,
                          focusColor: AppColor.originalgrey,
                          fillColor: AppColor.white,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                        ),
                        onChanged: (value) {
                          controller.filterSearchResults(value);
                        },
                      ),
                    ),
                    GetBuilder<PayrollController>(
                      builder: (controller) {
                        return ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: getDynamicHeight(size: 0.032)), //30),
                          shrinkWrap: true,
                          itemCount: controller.filteredList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                controller.payrolListOnClk(index, context);
                              },
                              child: SizedBox(
                                height: getDynamicHeight(size: 0.042), //40,
                                child: ListTile(
                                  leading: Image.asset(
                                    controller.filteredList[index]['image'],
                                    height: getDynamicHeight(size: 0.027), //25,
                                    width: getDynamicHeight(size: 0.027), //25,
                                    color: AppColor.primaryColor,
                                  ),
                                  title: Text(
                                    controller.filteredList[index]['label'],
                                    style: TextStyle(
                                      // fontSize: 16.0,
                                      fontSize: getDynamicHeight(size: 0.018),
                                      fontFamily: CommonFontStyle.plusJakartaSans,
                                    ),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        controller.payrolListOnClk(index, context);
                                      },
                                      icon: const Icon(Icons.arrow_forward_ios)),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    )
                  ],
                )),
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                AppString.payroll,
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
                      width: getDynamicHeight(size: 0.022), //20,
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
                      width: getDynamicHeight(size: 0.022), //20,
                    ))
              ],
              centerTitle: true,
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                // Check if content height exceeds available height
                bool isScrollable = constraints.maxHeight > availableHeight;

                return Padding(
                  padding: EdgeInsets.all(getDynamicHeight(size: 0.017)), //15),
                  child: SingleChildScrollView(
                    controller: isScrollable ? controller.payrollScrollController : null,
                    physics:
                        isScrollable ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: availableHeight,
                      ),
                      child: controller.isLoading.value
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: getDynamicHeight(size: 0.102)), //100),
                              child: Center(child: ProgressWithIcon()),
                            )
                          : Column(
                              children: [
                                Container(
                                    padding: EdgeInsets.all(getDynamicHeight(size: 0.022)), //20),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      gradient: LinearGradient(
                                        begin: Alignment.centerRight,
                                        end: Alignment.centerLeft,
                                        colors: [
                                          const Color.fromARGB(192, 198, 238, 243).withOpacity(0.3),
                                          const Color.fromARGB(162, 94, 157, 168).withOpacity(0.4),
                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.012)), //10),
                                          child: Text(AppString.todaysoverview, style: AppStyle.blackplus16),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.012)), //10),
                                          child: Text(controller.formattedDate, style: AppStyle.plus17w600),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(getDynamicHeight(size: 0.012)), //10),
                                          child: Container(
                                            padding: EdgeInsets.all(getDynamicHeight(size: 0.022)), //20),
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    color: AppColor.originalgrey,
                                                    blurRadius: 2.0, // soften the shadow
                                                    spreadRadius: 1.0, //extend the shadow
                                                    offset: Offset(3.0, 3.0))
                                              ],
                                              color: AppColor.white,
                                              borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.022)), //20),
                                              border: Border.all(color: AppColor.primaryColor),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(AppString.clockin, style: AppStyle.plus16),
                                                    if (controller.empSummDashboardTable.isNotEmpty)
                                                      Text(
                                                        controller.empSummDashboardTable[0].inPunchTime.toString(),
                                                        style: AppStyle.plus16w600,
                                                      )
                                                    else
                                                      Text('--:-- ', style: AppStyle.plus16w600),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                      decoration: BoxDecoration(
                                                          color: AppColor.lightblue2,
                                                          border: Border.all(color: AppColor.primaryColor),
                                                          borderRadius: BorderRadius.circular(20)),
                                                      child: controller.empSummDashboardTable.isNotEmpty &&
                                                              controller.empSummDashboardTable[0].inPunchTime
                                                                  .toString()
                                                                  .isNotEmpty
                                                          ? Text(
                                                              'Done at ${controller.empSummDashboardTable[0].inPunchTime}',
                                                              style: TextStyle(
                                                                // fontSize: 10, //12
                                                                fontSize: getDynamicHeight(size: 0.012),
                                                                fontFamily: CommonFontStyle.plusJakartaSans,
                                                              ),
                                                            )
                                                          : Text(AppString.notyet),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text(AppString.clockout, style: AppStyle.plus16),
                                                    if (controller.empSummDashboardTable.isNotEmpty)
                                                      Text(
                                                        controller.empSummDashboardTable[0].outPunchTime.toString(),
                                                        style: AppStyle.plus16w600,
                                                      )
                                                    else
                                                      Text('--:-- ', style: AppStyle.plus16w600),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                      decoration: BoxDecoration(
                                                          color: AppColor.lightblue2,
                                                          border: Border.all(color: AppColor.primaryColor),
                                                          borderRadius: BorderRadius.circular(20)),
                                                      child: controller.empSummDashboardTable.isNotEmpty &&
                                                              controller.empSummDashboardTable[0].outPunchTime
                                                                  .toString()
                                                                  .isNotEmpty
                                                          ? Text(
                                                              'Done at ${controller.empSummDashboardTable[0].outPunchTime}',
                                                              style: AppStyle.plus10,
                                                            )
                                                          : Text(AppString.notyet),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: AppColor.white,
                                                borderRadius: BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: AppColor.originalgrey,
                                                      blurRadius: 2.0, // soften the shadow
                                                      spreadRadius: 1.0, //extend the shadow
                                                      offset: Offset(3.0, 3.0))
                                                ],
                                                border: Border.all(color: AppColor.primaryColor),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(AppString.lcEgmin, style: AppStyle.plus14w500),
                                                    if (controller.empSummDashboardTable.isNotEmpty)
                                                      Text(controller.empSummDashboardTable[0].totLCEGMin.toString(),
                                                          style: AppStyle.plus16w600)
                                                    else
                                                      Text('-- ', style: AppStyle.plus16w600),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: AppColor.white,
                                              borderRadius: BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: AppColor.originalgrey,
                                                    blurRadius: 2.0, // soften the shadow
                                                    spreadRadius: 1.0, //extend the shadow
                                                    offset: Offset(3.0, 3.0))
                                              ],
                                              border: Border.all(color: AppColor.primaryColor),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(AppString.lcegcnt, style: AppStyle.plus14w500),
                                                  if (controller.empSummDashboardTable.isNotEmpty)
                                                    Text(
                                                      controller.empSummDashboardTable[0].cnt.toString(),
                                                      style: AppStyle.plus16w600,
                                                    )
                                                  else
                                                    Text('--', style: AppStyle.plus16w600),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              if (controller.empModuleScreenRightsTable.isNotEmpty) {
                                                if (controller.empModuleScreenRightsTable[0].rightsYN == "N") {
                                                  Get.snackbar(
                                                    "You don't have access to this screen",
                                                    '',
                                                    colorText: AppColor.white,
                                                    backgroundColor: AppColor.black,
                                                    duration: const Duration(seconds: 1),
                                                  );
                                                  return;
                                                }
                                              }
                                              final bottomBarController = Get.put(BottomBarController());
                                              final attendanceController = Get.put(AttendenceController());
                                              await attendanceController.resetData();
                                              if (bottomBarController.persistentController.value.index != 1) {
                                                bottomBarController.currentIndex.value = 1;
                                                bottomBarController.persistentController.value.index = 1;
                                              }
                                              bottomBarController.update();
                                            }, //Get.to(const AttendanceScreen()),
                                            child: Container(
                                              height: MediaQuery.of(context).size.height * 0.06, //0.07
                                              width: MediaQuery.of(context).size.width * 0.14, //0.17
                                              margin: const EdgeInsets.only(
                                                top: 15,
                                                left: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: AppColor.primaryColor,
                                                  ),
                                                  borderRadius: BorderRadius.circular(10)),
                                              child: controller.screens.isNotEmpty
                                                  ? Image.asset(
                                                      controller.getImage(controller.screens[0].screenName.toString()),
                                                      color: AppColor.primaryColor,
                                                    )
                                                  : SizedBox(),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            controller.screens.isNotEmpty
                                                ? controller.screens[0].screenName.toString()
                                                : "", // Empty string instead of SizedBox()
                                            style: AppStyle.plus12,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.symmetric(horizontal: 7)),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (controller.empModuleScreenRightsTable.isNotEmpty) {
                                              if (controller.empModuleScreenRightsTable[1].rightsYN == "N") {
                                                Get.snackbar(
                                                  "You don't have access to this screen",
                                                  '',
                                                  colorText: AppColor.white,
                                                  backgroundColor: AppColor.black,
                                                  duration: const Duration(seconds: 1),
                                                );
                                                return;
                                              }
                                            }

                                            final bottomBarController = Get.put(BottomBarController());
                                            bottomBarController.currentIndex.value = -1;

                                            // Get.delete<MispunchController>();
                                            final mispunchController = Get.put(MispunchController());
                                            mispunchController.resetData();
                                            mispunchController.update();
                                            // Get.put(MispunchScreen());
                                            PersistentNavBarNavigator.pushNewScreen(
                                              context,
                                              screen: const MispunchScreen(),
                                              withNavBar: true,
                                              pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                            ).then((value) async {
                                              // final bottomBarController = Get.find<BottomBarController>();
                                              bottomBarController.persistentController.value.index = 0;
                                              bottomBarController.currentIndex.value = 0;
                                              hideBottomBar.value = false;
                                              var dashboardController = Get.put(DashboardController());
                                              await dashboardController.getDashboardDataUsingToken();
                                            });
                                          }, //Get.to(MispunchScreen()),
                                          child: Container(
                                            height: MediaQuery.of(context).size.height * 0.06, //0.07
                                            width: MediaQuery.of(context).size.width * 0.14, //0.17
                                            margin: const EdgeInsets.only(top: 15),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: AppColor.primaryColor,
                                                ),
                                                borderRadius: BorderRadius.circular(10)),
                                            child: controller.screens.isNotEmpty
                                                ? Image.asset(
                                                    controller.getImage(controller.screens[1].screenName.toString()),
                                                    color: AppColor.primaryColor,
                                                  )
                                                : SizedBox(),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        // Text(AppString.mispunchinfo, style: AppStyle.plus12),
                                        Text(
                                          controller.screens.isNotEmpty
                                              ? controller.screens[1].screenName.toString()
                                              : "", // Empty string instead of SizedBox()
                                          style: AppStyle.plus12,
                                        ),
                                      ],
                                    )),
                                    const Padding(padding: EdgeInsets.symmetric(horizontal: 7)),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              if (controller.empModuleScreenRightsTable.isNotEmpty) {
                                                if (controller.empModuleScreenRightsTable[2].rightsYN == "N") {
                                                  Get.snackbar(
                                                    "You don't have access to this screen",
                                                    '',
                                                    colorText: AppColor.white,
                                                    backgroundColor: AppColor.black,
                                                    duration: const Duration(seconds: 1),
                                                  );
                                                  return;
                                                }
                                              }

                                              final bottomBarController = Get.put(BottomBarController());
                                              // final attendanceController = Get.put(AttendenceController());
                                              // await attendanceController.resetData();
                                              final leaveController = Get.put(LeaveController());
                                              await leaveController.resetForm();
                                              if (bottomBarController.persistentController.value.index != 3) {
                                                bottomBarController.currentIndex.value = 3;
                                                bottomBarController.persistentController.value.index = 3;
                                              }
                                              bottomBarController.update();

                                              // var dashboardController = Get.put(DashboardController());

                                              // var bottomBarController = Get.find<BottomBarController>();
                                              // bottomBarController.currentIndex.value = 3;
                                              // bottomBarController.persistentController.value.jumpToTab(3);
                                              // bottomBarController.update();

                                              // PersistentNavBarNavigator.pushNewScreen(
                                              //   context,
                                              //   screen: LeaveMainScreen(),
                                              //   withNavBar: true,
                                              //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                              // ).then((value) async {
                                              //   // if (Get.isRegistered<LeaveController>()) {
                                              //   //   Get.delete<LeaveController>();
                                              //   // }
                                              //   hideBottomBar.value = false;
                                              //   bottomBarController.update();
                                              //   await dashboardController.getDashboardDataUsingToken();
                                              // });
                                            },
                                            // onTap: () => Get.snackbar(
                                            //   AppString.comingsoon,
                                            //   '',
                                            //   colorText: AppColor.white,
                                            //   backgroundColor: AppColor.black,
                                            //   duration: const Duration(seconds: 1),
                                            // ),
                                            child: Container(
                                              height: MediaQuery.of(context).size.height * 0.06, //0.07
                                              width: MediaQuery.of(context).size.width * 0.14, //0.17
                                              margin: const EdgeInsets.only(top: 15),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: AppColor.primaryColor,
                                                  ),
                                                  borderRadius: BorderRadius.circular(10)),
                                              child: controller.screens.isNotEmpty
                                                  ? Image.asset(
                                                      controller.getImage(controller.screens[2].screenName.toString()),
                                                      color: AppColor.primaryColor,
                                                    )
                                                  : SizedBox(),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          // Text(AppString.leaveentry, style: AppStyle.plus12),
                                          Text(
                                            controller.screens.isNotEmpty
                                                ? controller.screens[2].screenName.toString()
                                                : "", // Empty string instead of SizedBox()
                                            style: AppStyle.plus12,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.symmetric(horizontal: 7)),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              if (controller.empModuleScreenRightsTable.isNotEmpty) {
                                                if (controller.empModuleScreenRightsTable[3].rightsYN == "N") {
                                                  Get.snackbar(
                                                    "You don't have access to this screen",
                                                    '',
                                                    colorText: AppColor.white,
                                                    backgroundColor: AppColor.black,
                                                    duration: const Duration(seconds: 1),
                                                  );
                                                  return;
                                                }
                                              }

                                              final bottomBarController = Get.put(BottomBarController());
                                              final leaveController = Get.put(LeaveController());
                                              await leaveController.resetForm();
                                              if (bottomBarController.persistentController.value.index != 4) {
                                                bottomBarController.currentIndex.value = 4;
                                                bottomBarController.persistentController.value.index = 4;
                                              }
                                              bottomBarController.update();
                                              // var dashboardController = Get.put(DashboardController());
                                              // PersistentNavBarNavigator.pushNewScreen(
                                              //   context,
                                              //   screen: OvertimeMainScreen(),
                                              //   withNavBar: true,
                                              //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                              // ).then((value) async {
                                              //   // Get.delete<LeaveController>();
                                              //   Get.delete<OvertimeController>();
                                              //   hideBottomBar.value = false;
                                              //   await dashboardController.getDashboardDataUsingToken();
                                              // });
                                            },
                                            // onTap: () => Get.snackbar(
                                            //   AppString.comingsoon,
                                            //   '',
                                            //   colorText: AppColor.white,
                                            //   backgroundColor: AppColor.black,
                                            //   duration: const Duration(seconds: 1),
                                            // ),
                                            child: Container(
                                              height: MediaQuery.of(context).size.height * 0.06, //0.07
                                              width: MediaQuery.of(context).size.width * 0.14, //0.17
                                              margin: const EdgeInsets.only(top: 15),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: AppColor.primaryColor,
                                                  ),
                                                  borderRadius: BorderRadius.circular(10)),
                                              child: controller.screens.isNotEmpty
                                                  ? Image.asset(
                                                      controller.getImage(controller.screens[3].screenName.toString()),
                                                      color: AppColor.primaryColor,
                                                    )
                                                  : SizedBox(),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          // Text(AppString.overtime, style: AppStyle.plus12),
                                          Text(
                                            controller.screens.isNotEmpty
                                                ? controller.screens[3].screenName.toString()
                                                : "", // Empty string instead of SizedBox()
                                            style: AppStyle.plus12,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  color: AppColor.transparent,
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                if (controller.isDutyScheduleNavigating.value) return;
                                                controller.isDutyScheduleNavigating.value = true;

                                                if (controller.empModuleScreenRightsTable.isNotEmpty) {
                                                  if (controller.empModuleScreenRightsTable[4].rightsYN == "N") {
                                                    Get.snackbar(
                                                      "You don't have access to this screen",
                                                      '',
                                                      colorText: AppColor.white,
                                                      backgroundColor: AppColor.black,
                                                      duration: const Duration(seconds: 1),
                                                    );
                                                    return;
                                                  }
                                                }

                                                final bottomBarController = Get.put(BottomBarController());
                                                bottomBarController.currentIndex.value = -1;

                                                DutyscheduleController dc = Get.put(DutyscheduleController());
                                                dc.fetchdutyScheduledrpdwn();

                                                PersistentNavBarNavigator.pushNewScreen(
                                                  context,
                                                  screen: const DutyscheduleScreen(),
                                                  withNavBar: true,
                                                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                                ).then((value) async {
                                                  bottomBarController.persistentController.value.index = 0;
                                                  bottomBarController.currentIndex.value = 0;
                                                  hideBottomBar.value = false;
                                                  var dashboardController = Get.put(DashboardController());
                                                  await dashboardController.getDashboardDataUsingToken();
                                                });
                                                controller.isDutyScheduleNavigating.value = false;
                                              },
                                              child: Container(
                                                height: MediaQuery.of(context).size.width * 0.13, // Dynamic height
                                                width: MediaQuery.of(context).size.width * 0.14, // Dynamic width
                                                margin: const EdgeInsets.only(
                                                  top: 15,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: AppColor.primaryColor,
                                                  ),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: controller.screens.isNotEmpty
                                                    ? Image.asset(
                                                        controller
                                                            .getImage(controller.screens[4].screenName.toString()),
                                                        color: AppColor.primaryColor,
                                                      )
                                                    : SizedBox(),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            // Text(AppString.dutyschedule, style: AppStyle.plus12),
                                            Text(
                                              controller.screens.isNotEmpty
                                                  ? controller.screens[4].screenName.toString()
                                                  : "", // Empty string instead of SizedBox()
                                              style: AppStyle.plus12, overflow: TextOverflow.ellipsis, maxLines: 2,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),

                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                if (controller.isLVOTApprovalNavigating.value) return;
                                                controller.isLVOTApprovalNavigating.value = true;

                                                if (controller.empModuleScreenRightsTable.isNotEmpty) {
                                                  if (controller.empModuleScreenRightsTable[5].rightsYN == "N") {
                                                    controller.isLVOTApprovalNavigating.value = false;
                                                    Get.snackbar(
                                                      "You don't have access to this screen",
                                                      '',
                                                      colorText: AppColor.white,
                                                      backgroundColor: AppColor.black,
                                                      duration: const Duration(seconds: 1),
                                                    );
                                                    return;
                                                  }
                                                }

                                                final bottomBarController = Get.put(BottomBarController());
                                                bottomBarController.currentIndex.value = -1;

                                                PersistentNavBarNavigator.pushNewScreen(
                                                  context,
                                                  screen: const LvotapprovalScreen(),
                                                  withNavBar: true,
                                                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                                ).then((value) async {
                                                  final lvotapprovalController = Get.put(LvotapprovalController());
                                                  if (lvotapprovalController.isSelectionMode.value == true) {
                                                    await lvotapprovalController.exitSelectionMode();
                                                    return false;
                                                  }
                                                  bottomBarController.persistentController.value.index = 0;
                                                  bottomBarController.currentIndex.value = 0;
                                                  hideBottomBar.value = false;
                                                  var dashboardController = Get.put(DashboardController());
                                                  await dashboardController.getDashboardDataUsingToken();
                                                });

                                                final lvotapprovalController = Get.put(LvotapprovalController());
                                                await lvotapprovalController.resetForm();
                                                await lvotapprovalController.fetchLeaveOTList("", "LV");
                                                controller.isLVOTApprovalNavigating.value = false;
                                              },
                                              child: Container(
                                                height: MediaQuery.of(context).size.width * 0.13, // Dynamic height
                                                width: MediaQuery.of(context).size.width * 0.14, // Dynamic width
                                                margin: const EdgeInsets.only(top: 15),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: AppColor.primaryColor,
                                                  ),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: controller.screens.isNotEmpty
                                                    ? Image.asset(
                                                        controller
                                                            .getImage(controller.screens[5].screenName.toString()),
                                                        color: AppColor.primaryColor,
                                                      )
                                                    : SizedBox(),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              controller.screens.isNotEmpty
                                                  ? controller.screens[5].screenName.toString()
                                                  : "",
                                              style: AppStyle.plus12,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),

                                      Expanded(child: SizedBox()), // Empty space
                                      Expanded(child: SizedBox()), // Empty space
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
