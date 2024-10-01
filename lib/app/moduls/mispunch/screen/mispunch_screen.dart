import 'package:emp_app/app/app_custom_widget/monthpicker_mispunch.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/app_custom_widget/custom_containerview.dart';
import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/app_custom_widget/custom_month_picker.dart';
import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/mispunch/controller/mispunch_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MispunchScreen extends GetView<MispunchController> {
  const MispunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.put(MispunchController());
    final MispunchController controller = Get.isRegistered<MispunchController>()
        ? Get.find<MispunchController>() // If already registered, find it
        : Get.put(MispunchController());
    return GetBuilder<MispunchController>(
      builder: (controller) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
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
                    Navigator.pop(context);
                    // controller.clearData();
                  },
                  icon: const Icon(Icons.arrow_back)),
              // centerTitle: true,
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
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  MonthPicker_mispunch(
                    controller: controller,
                    scrollController: controller.monthScrollController_mispunch,
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
                                      decoration: BoxDecoration(
                                          color: AppColor.lightblue1, borderRadius: BorderRadius.circular(10)),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            width: double.infinity,
                                            height: 45,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10), color: AppColor.primaryColor),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15),
                                              child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    controller.mispunchTable[index].dt.toString(),
                                                    style: TextStyle(
                                                      fontSize: 20,
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
                                                      text: AppString.type,
                                                      text1: controller.mispunchTable[index].misPunch.toString()),
                                                  CustomContainerview(
                                                      text: AppString.punchtime,
                                                      text1: controller.mispunchTable[index].punchTime.toString()),
                                                  CustomContainerview(
                                                      text: AppString.shifttime,
                                                      text1: controller.mispunchTable[index].shiftTime.toString()),
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
          ),
        );
      },
    );
  }
}
