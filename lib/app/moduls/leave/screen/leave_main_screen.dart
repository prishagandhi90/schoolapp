// ignore_for_file: must_be_immutable

import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:emp_app/app/moduls/leave/screen/leave_screen.dart';
import 'package:emp_app/app/moduls/leave/screen/view_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveMainScreen extends GetView<LeaveController> {
  LeaveMainScreen({super.key});
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Get.put(LeaveController());
    return GetBuilder<LeaveController>(builder: (controller) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
            backgroundColor: Colors.white,
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                'Leave',
                style: TextStyle(
                    color: const Color.fromARGB(255, 94, 157, 168), fontWeight: FontWeight.w700, fontFamily: CommonFontStyle.plusJakartaSans),
              ),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
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
                      labelStyle: TextStyle(fontFamily: CommonFontStyle.plusJakartaSans),
                      indicator: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color.fromARGB(255, 94, 157, 168)),
                      tabs: const [Tab(text: 'Leave'), Tab(text: 'View')],
                    ),
                  ),
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      LeaveScreen(),
                      ViewScreen(),
                    ],
                  ),
                ),
              ],
            )),
      );
    });
  }
}
