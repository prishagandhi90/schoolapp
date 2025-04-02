import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/mispunch/screen/monthpicker_mispunch.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/app_custom_widget/custom_containerview.dart';
import 'package:emp_app/app/moduls/attendence/screen/dropdown_attendance.dart';
import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/mispunch/controller/mispunch_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MispunchScreen extends GetView<MispunchController> {
  const MispunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MispunchController());

    return GetBuilder<MispunchController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(
            backgroundColor: AppColor.white,
            title: Text(
              AppString.mispunch,
              style: TextStyle(
                color: AppColor.primaryColor,
                fontWeight: FontWeight.w700,
                fontFamily: CommonFontStyle.plusJakartaSans,
              ),
            ),
            leading: IconButton(
                onPressed: () {
                  final bottomBarController = Get.put(BottomBarController());
                  bottomBarController.persistentController.value.index = 0; // Set index to Payroll tab
                  bottomBarController.isPayrollHome.value = true;
                  bottomBarController.currentIndex.value = 0;
                  Navigator.of(context).pop();

                  // WidgetsBinding.instance.addPostFrameCallback((_) {
                  // Get.back();
                  // });
                },
                icon: const Icon(Icons.arrow_back_ios)),
            // centerTitle: true,
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
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                MonthPicker_mispunch(
                  controller: controller,
                  scrollController_Mispunch: controller.monthScrollController_mispunch,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: controller.isLoading.value
                      ? const Center(child: ProgressWithIcon())
                      : controller.mispunchTable.isNotEmpty
                          ? ListView.builder(
                              itemCount: controller.mispunchTable.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * 0.23,
                                    decoration: BoxDecoration(color: AppColor.lightblue1, borderRadius: BorderRadius.circular(10)),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          width: double.infinity,
                                          height: 45,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColor.primaryColor),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 15),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  controller.mispunchTable[index].dt.toString(),
                                                  style: TextStyle(
                                                    // fontSize: 20,
                                                    fontSize: getDynamicHeight(size: 0.022),
                                                    fontWeight: FontWeight.w500, //20
                                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                                  ),
                                                )),
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                CustomContainerview(
                                                    text: AppString.type, text1: controller.mispunchTable[index].misPunch.toString()),
                                                CustomContainerview(
                                                    text: AppString.punchtime, text1: controller.mispunchTable[index].punchTime.toString()),
                                                CustomContainerview(
                                                    text: AppString.shifttime, text1: controller.mispunchTable[index].shiftTime.toString()),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : Padding(
                              padding: EdgeInsets.all(15),
                              child: Center(
                                child: Text(AppString.nomispunchinthismonth),
                              ),
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
