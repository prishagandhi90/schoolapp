import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/moduls/attendence/screen/attendance_screen.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:emp_app/app/moduls/leave/screen/leave_main_screen.dart';
import 'package:emp_app/app/moduls/mispunch/screen/mispunch_screen.dart';
import 'package:emp_app/app/moduls/overtime/controller/overtime_controller.dart';
import 'package:emp_app/app/moduls/overtime/screens/overtime_main_screen.dart';
import 'package:emp_app/app/moduls/payroll/controller/payroll_controller.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class PayrollScreen extends GetView<PayrollController> {
  PayrollScreen({super.key});
  final attendanceScreen = Get.isRegistered<AttendanceScreen>()
      ? Get.find<AttendanceScreen>() // If already registered, find it
      : Get.put(AttendanceScreen());

  @override
  Widget build(BuildContext context) {
    // Get.put(PayrollController());
    // final PayrollController controller = Get.find<PayrollController>();
    final PayrollController controller = Get.isRegistered<PayrollController>()
        ? Get.find<PayrollController>() // If already registered, find it
        : Get.put(PayrollController());
    // return GetBuilder<PayrollController>(
    //   init: PayrollController(),
    //   builder: (controller) {
    return Obx(
      () => Scaffold(
        onDrawerChanged: (isop) {
          // var bottomBarController = Get.put(BottomBarController());
          final bottomBarController = Get.isRegistered<BottomBarController>()
              ? Get.find<BottomBarController>() // If already registered, find it
              : Get.put(BottomBarController());
          hideBottomBar.value = isop;
          bottomBarController.update();
        },
        drawer: Drawer(
            backgroundColor: AppColor.white,
            child: ListView(
              children: [
                const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    focusNode: controller.focusNode,
                    cursorColor: AppColor.grey,
                    controller: controller.textEditingController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.lightgrey1, width: 1.0),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
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
                ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  shrinkWrap: true,
                  itemCount: controller.filteredList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        controller.payrolListOnClk(index, context);
                      },
                      child: SizedBox(
                        height: 40,
                        child: ListTile(
                          leading: Image.asset(
                            controller.filteredList[index]['image'],
                            height: 25,
                            width: 25,
                            color: AppColor.primaryColor,
                          ),
                          title: Text(
                            controller.filteredList[index]['label'],
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: CommonFontStyle.plusJakartaSans,
                            ),
                          ),
                          trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios)),
                        ),
                      ),
                    );
                  },
                )
              ],
            )),
        appBar: AppBar(
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
                  width: 20,
                  color: AppColor.black,
                ),
              );
            },
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Image.asset(
                  AppImage.notification,
                  width: 20,
                ))
          ],
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: controller.isLoading.value
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 100),
                    child: Center(child: ProgressWithIcon()),
                  )
                : Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(20),
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
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(AppString.todaysoverview, style: AppStyle.blackplus16),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(controller.formattedDate, style: AppStyle.plus17w600),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppColor.originalgrey,
                                          blurRadius: 2.0, // soften the shadow
                                          spreadRadius: 1.0, //extend the shadow
                                          offset: Offset(3.0, 3.0))
                                    ],
                                    color: AppColor.white,
                                    borderRadius: BorderRadius.circular(20),
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
                                                      fontSize: 10, //12
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
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    final dashboardController = Get.isRegistered<DashboardController>()
                                        ? Get.find<DashboardController>() // If already registered, find it
                                        : Get.put(DashboardController());
                                    final bottomBarController = Get.isRegistered<BottomBarController>()
                                        ? Get.find<BottomBarController>() // If already registered, find it
                                        : Get.put(BottomBarController());

                                    // bool isCurrentScreenAttendance =
                                    //     ModalRoute.of(context)?.settings.name == AttendanceScreen.routeName;

                                    if (bottomBarController.persistentController!.index != 1) {
                                      // Get.off(() => AttendanceScreen(fromDashboard: true))?.then((value) {
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        // screen: AttendanceScreen(
                                        //   fromDashboard: true,
                                        // ),
                                        screen: attendanceScreen,
                                        withNavBar: true,
                                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                      ).then((value) {
                                        // bool isCurrentScreenAttendance = Navigator.of(context).canPop() &&
                                        //     ModalRoute.of(context)!.settings.name == AttendanceScreen.routeName;

                                        // if (!isCurrentScreenAttendance) {
                                        //   while (Navigator.canPop(context)) {
                                        //     Navigator.pop(context);
                                        //   }
                                        // }

                                        hideBottomBar.value = false;
                                        dashboardController.getDashboardDataUsingToken();
                                      });
                                      // });
                                    }
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
                                    child: Image.asset(
                                      AppImage.attendence,
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                ),
                                Text(AppString.attendence, style: AppStyle.plus12),
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.symmetric(horizontal: 7)),
                          Expanded(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // var dashboardController = Get.put(DashboardController());
                                    final dashboardController = Get.isRegistered<DashboardController>()
                                        ? Get.find<DashboardController>() // If already registered, find it
                                        : Get.put(DashboardController());
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: const MispunchScreen(),
                                      withNavBar: true,
                                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                    ).then((value) async {
                                      hideBottomBar.value = false;
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
                                    child: Image.asset(
                                      AppImage.mispunch,
                                      // height: 35, //50
                                      // width: 35, //50
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                ),
                                Text(AppString.mispunchinfo, style: AppStyle.plus12),
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.symmetric(horizontal: 7)),
                          Expanded(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    var dashboardController = Get.put(DashboardController());
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: LeaveMainScreen(),
                                      withNavBar: true,
                                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                    ).then((value) async {
                                      Get.delete<LeaveController>();
                                      hideBottomBar.value = false;
                                      await dashboardController.getDashboardDataUsingToken();
                                    });
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * 0.06, //0.07
                                    width: MediaQuery.of(context).size.width * 0.14, //0.17
                                    margin: const EdgeInsets.only(top: 15),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColor.primaryColor,
                                        ),
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Image.asset(
                                      AppImage.leave,
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                ),
                                Text(AppString.leaveentry, style: AppStyle.plus12),
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.symmetric(horizontal: 7)),
                          Expanded(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    var dashboardController = Get.put(DashboardController());
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: OvertimeMainScreen(),
                                      withNavBar: true,
                                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                    ).then((value) async {
                                      // Get.delete<LeaveController>();
                                      Get.delete<OvertimeController>();
                                      hideBottomBar.value = false;
                                      await dashboardController.getDashboardDataUsingToken();
                                    });
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
                                    child: Image.asset(
                                      AppImage.overtime,
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                ),
                                Text(AppString.overtime, style: AppStyle.plus12),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
    //   },
    // );
  }
}
