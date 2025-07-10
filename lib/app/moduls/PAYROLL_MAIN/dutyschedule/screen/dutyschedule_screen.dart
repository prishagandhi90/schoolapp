import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:schoolapp/app/app_custom_widget/custom_dropdown.dart';
import 'package:schoolapp/app/app_custom_widget/custom_stepper.dart';
import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/app_font_name.dart';
import 'package:schoolapp/app/core/util/app_image.dart';
import 'package:schoolapp/app/core/util/app_string.dart';
import 'package:schoolapp/app/core/util/app_style.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:schoolapp/app/moduls/IPD/admitted%20patient/controller/adpatient_controller.dart';
import 'package:schoolapp/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:schoolapp/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:schoolapp/app/moduls/PAYROLL_MAIN/dutyschedule/controller/dutyschedule_controller.dart';
import 'package:schoolapp/app/moduls/PAYROLL_MAIN/dutyschedule/model/dropdown_model.dart';
import 'package:schoolapp/app/moduls/notification/screen/notification_screen.dart';
import 'package:schoolapp/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class DutyscheduleScreen extends GetView<DutyscheduleController> {
  DutyscheduleScreen({Key? key}) : super(key: key);
  final DashboardController dashboardController = Get.put(DashboardController());
  final AdPatientController adPatientController = Get.put(AdPatientController());

  @override
  Widget build(BuildContext context) {
    Get.put(DutyscheduleController());
    return GetBuilder<DutyscheduleController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(
            backgroundColor: AppColor.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              AppString.dutyschedule,
              style: TextStyle(
                color: AppColor.primaryColor,
                fontWeight: FontWeight.w700,
                fontFamily: CommonFontStyle.plusJakartaSans,
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: NotificationScreen(),
                      withNavBar: false,
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    ).then((value) async {
                      Get.back();
                      await adPatientController.fetchDeptwisePatientList();
                      // var dashboardController = Get.put(DashboardController());
                      await dashboardController.getDashboardDataUsingToken();
                      var bottomBarController = Get.find<BottomBarController>();
                      bottomBarController.currentIndex.value = 0;
                      bottomBarController.persistentController.value.index = 0;
                      bottomBarController.isIPDHome.value = true;
                      hideBottomBar.value = false;
                    });
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset(
                        AppImage.notification,
                        width: getDynamicHeight(size: 0.022),
                      ),
                      if (dashboardController.notificationCount != "0") // 👈 Condition lagayi
                        Positioned(
                          right: -2,
                          top: -6,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              dashboardController.notificationCount,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
            centerTitle: true,
          ),
          body: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5, // 60% width for the dropdown
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: CustomDropdown(
                        text: controller.DutyDropdownNameController.text.isNotEmpty
                            ? controller.DutyDropdownNameController.text
                            : controller.getCurrentWeekDate(),
                        controller: controller.DutyDropdownNameController,
                        buttonStyleData: ButtonStyleData(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(199, 255, 255, 255),
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) async {
                          await controller.DutyScheduleChangeMethod(value);
                        },
                        items: controller.Sheduledrpdwnlst.isNotEmpty
                            ? controller.Sheduledrpdwnlst.map(
                                (sheduledrpdwnlst item) => DropdownMenuItem<Map<String, String>>(
                                  value: {
                                    'value': item.value ?? '',
                                    'text': item.name ?? '',
                                  },
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      item.name ?? '',
                                      style: item.name != controller.CurrentWeekItem
                                          ? AppStyle.black.copyWith(
                                              // fontSize: 13,
                                              fontSize: getDynamicHeight(size: 0.015),
                                            )
                                          : TextStyle(
                                              // fontSize: 13,
                                              fontSize: getDynamicHeight(size: 0.015),
                                              color: item.name == controller.CurrentWeekItem ? AppColor.primaryColor : Colors.black, // Custom color
                                              // fontWeight: item.name == controller.CurrentWeekItem
                                              //     ? FontWeight.bold
                                              //     : FontWeight.normal,
                                            ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ).toList()
                            : [],
                        width: double.infinity,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5, // 40% width for the text field
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(199, 255, 255, 255),
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            controller.dutySchSftData.isNotEmpty && controller.dutySchSftData[0].dateColumnsValue != null
                                ? controller.dutySchSftData[0].subDepartment!
                                : "",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              CustomStepper(),
            ],
          ),
        );
      },
    );
  }
}
