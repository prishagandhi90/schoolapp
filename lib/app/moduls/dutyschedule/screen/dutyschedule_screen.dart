import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/app_custom_widget/custom_stepper.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/moduls/dutyschedule/controller/dutyschedule_controller.dart';
import 'package:emp_app/app/moduls/dutyschedule/model/dropdown_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DutyscheduleScreen extends GetView<DutyscheduleController> {
  const DutyscheduleScreen({Key? key}) : super(key: key);

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
                'Duty Schedule',
                style: TextStyle(
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: CommonFontStyle.plusJakartaSans,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Image.asset(AppImage.notification, width: 20),
                )
              ],
              centerTitle: true,
            ),
            body: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: CustomDropdown(
                          text: controller.DutyDropdownNameController.text.isNotEmpty
                              ? controller.DutyDropdownNameController.text
                              : controller.getCurrentWeekDate(),
                          controller: controller.DutyDropdownNameController,
                          onChanged: (value) async {
                            await controller.DutyScheduleChangeMethod(value);
                          },
                          items: controller.Sheduledrpdwnlst.isNotEmpty // Check if the list is not empty
                              ? controller.Sheduledrpdwnlst
                                  //.where((item) => item.value != null && item.name != null) // Null check added
                                  .map((sheduledrpdwnlst item) => DropdownMenuItem<Map<String, String>>(
                                        value: {
                                          'value': item.value ?? '',
                                          'text': item.name ?? '',
                                        },
                                        child: Text(
                                          item.name ?? '',
                                          style: AppStyle.black.copyWith(fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )).toList()
                              : [], // Return an empty list if the original list is empty
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(199, 255, 255, 255),
                            border: Border.all(color: Colors.grey), // Border add kiya
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Sp Ward(1st Floor)',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                CustomStepper()
              ],
            ));
      },
    );
  }
}
