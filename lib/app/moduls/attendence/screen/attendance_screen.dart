import 'package:emp_app/app/app_custom_widget/custom_drawer.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/moduls/attendence/controller/attendence_controller.dart';
import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/moduls/attendence/screen/details_screen.dart';
import 'package:emp_app/app/moduls/attendence/screen/summary_screen.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class AttendanceScreen extends GetView<AttendenceController> {
class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key, this.fromDashboard = false});
  final bool fromDashboard;

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final AttendenceController attendenceController = Get.put(AttendenceController());
  var scaffoldKey1 = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendenceController>(
      builder: (controller) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            key: scaffoldKey1,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                'Attendance',
                style: TextStyle(
                    color: const Color.fromARGB(255, 94, 157, 168), fontWeight: FontWeight.w700, fontFamily: CommonFontStyle.plusJakartaSans),
              ),
              // centerTitle: true,
              leading: widget.fromDashboard
                  ? IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        scaffoldKey1.currentState!.openDrawer();
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
              actions: [
                CustomDropDown(
                  selValue: controller.YearSel_selIndex,
                  onPressed: (index) {
                    controller.upd_YearSelIndex(index);
                    attendenceController.showHideMsg();
                  },
                )
              ],
            ),
            onDrawerChanged: (isop) {
              var bottomBarController = Get.put(BottomBarController());
              hideBottomBar.value = isop;
              bottomBarController.update();
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
                      color: const Color.fromARGB(255, 223, 239, 241),
                    ),
                    child: TabBar(
                      labelColor: Colors.white,
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
      },
    );
  }
}
