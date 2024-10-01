import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/attendence/controller/attendence_controller.dart';
import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/moduls/attendence/screen/details_screen.dart';
import 'package:emp_app/app/moduls/attendence/screen/summary_screen.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceScreen extends StatelessWidget {
  AttendanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get.put(AttendenceController());
    // final controller = Get.find<AttendenceController>();
    final AttendenceController controller = Get.isRegistered<AttendenceController>()
        ? Get.find<AttendenceController>() // If already registered, find it
        : Get.put(AttendenceController());

    // return GetBuilder<AttendenceController>(
    //   builder: (controller) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            AppString.attendence,
            style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.w700, fontFamily: CommonFontStyle.plusJakartaSans),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final bottomBarController = Get.find<BottomBarController>();
                bottomBarController.persistentController.value.index = 0; // Set index to Payroll tab
                bottomBarController.currentIndex.value = 0;
                Get.back();
              });
            },
          ),
          actions: [
            CustomDropDown(
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
              padding: const EdgeInsets.symmetric(vertical: 15),
              width: MediaQuery.of(context).size.width * 0.7,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColor.lightblue,
                ),
                child: TabBar(
                  physics: NeverScrollableScrollPhysics(),
                  labelColor: AppColor.white,
                  unselectedLabelColor: AppColor.black,
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: TextStyle(fontFamily: CommonFontStyle.plusJakartaSans),
                  indicator: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color.fromARGB(255, 94, 157, 168)),
                  tabs: const [Tab(text: 'Summary'), Tab(text: 'Details')],
                ),
              ),
            ),
            const Expanded(
              child: TabBarView(
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
    );
  }
}
