import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/moduls/lvotApproval/controller/lvotapproval_controller.dart';
import 'package:emp_app/app/moduls/lvotApproval/screen/lvlist_screen.dart';
import 'package:emp_app/app/moduls/lvotApproval/screen/otlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LvotapprovalScreen extends StatelessWidget {
  const LvotapprovalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LvotapprovalController());
    return GetBuilder<LvotapprovalController>(builder: (controller) {
      return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
            appBar: AppBar(
              title: Text('LV/OT Approval'),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildContainer('In-Charge'),
                      buildContainer('HOD'),
                      buildContainer('HR'),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          width: MediaQuery.of(context).size.width * 0.45,
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
                                // if (controller.leaveHeaderList.isEmpty) {
                                //   await controller.fetchHeaderList("LV");
                                // }
                                // hideBottomBar.value = false;
                                // await controller.changeTab(value);
                              },
                              // controller: controller.tabController_Leave,
                              labelStyle: TextStyle(fontFamily: CommonFontStyle.plusJakartaSans),
                              indicator: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColor.primaryColor),
                              tabs: const [Tab(text: 'LT'), Tab(text: 'OT')],
                              physics: NeverScrollableScrollPhysics(),
                            ),
                          ),
                        ),
                        Icon(Icons.search),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      // controller: controller.tabController_Leave,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        LvList(),
                        OtlistScreen(),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      );
    });
  }
}

Widget buildContainer(String text) {
  return Container(
    height: 50,
    width: 120,
    decoration: BoxDecoration(
      color: AppColor.lightwhite,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
