import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/attendence/controller/attendence_controller.dart';
import 'package:emp_app/app/moduls/attendence/screen/dropdown_attendance.dart';
import 'package:emp_app/app/moduls/attendence/screen/details_screen.dart';
import 'package:emp_app/app/moduls/attendence/screen/summary_screen.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceScreen extends StatelessWidget {
  AttendanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get.put(AttendenceController());
    final AttendenceController controller = Get.put(AttendenceController()); // Always create a new instance
    controller.currentTabIndex.value = 0;
    return GetBuilder<AttendenceController>(builder: (controller) {
      return Scaffold(
        body: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Scaffold(
            backgroundColor: AppColor.white,
            appBar: AppBar(
              backgroundColor: AppColor.white,
              title: Text(
                AppString.attendance,
                style: TextStyle(
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: CommonFontStyle.plusJakartaSans,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final bottomBarController = Get.find<BottomBarController>();
                    bottomBarController.persistentController.value.index = 0; // Set index to Payroll tab
                    bottomBarController.currentIndex.value = 0;
                    bottomBarController.isPayrollHome.value = true;
                    hideBottomBar.value = false;
                    Get.back();
                  });
                },
              ),
              // bottom: TabBar(
              //   controller: controller.tabController,
              // ),
              actions: [
                DropDownAttendance(
                  selValue: controller.YearSel_selIndex,
                  onPressed: (index) {
                    controller.upd_YearSelIndex(index);
                    controller.showHideMsg();
                  },
                )
              ],
            ),
            body: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: getDynamicHeight(size: 0.017)), //15),
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Container(
                    padding: EdgeInsets.all(getDynamicHeight(size: 0.005)), //4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.lightblue,
                    ),
                    child: TabBar(
                      onTap: (index) async {
                        hideBottomBar.value = false;
                        await controller.changeTab(index);
                      },
                      controller: controller.tabController,
                      physics: NeverScrollableScrollPhysics(),
                      labelColor: AppColor.white,
                      unselectedLabelColor: AppColor.black,
                      dividerColor: AppColor.transparent,
                      // dragStartBehavior: DragStartBehavior.start,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: TextStyle(fontFamily: CommonFontStyle.plusJakartaSans),
                      indicator: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color.fromARGB(255, 94, 157, 168)),
                      tabs: const [Tab(text: 'Summary'), Tab(text: 'Details')],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: controller.tabController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      SummaryScreen(),
                      DetailsScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      // });
    });
  }
}
