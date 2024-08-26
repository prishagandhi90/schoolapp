import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/moduls/overtime/controller/overtime_controller.dart';
import 'package:emp_app/app/moduls/overtime/screens/datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OtScreen extends StatelessWidget {
  const OtScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OvertimeController>(
      builder: (controller) {
        return Scaffold(
            backgroundColor: AppColor.white,
            body: Column(
              children: [
                DatetimePicker(
                  text: controller.selectedDate != null ? DateFormat('dd/MM/yyyy').format(controller.selectedDate!) : 'From',
                  text1: controller.selectedTime != null ? controller.selectedTime!.format(context) : '--:--',
                ),
              ],
            ));
      },
    );
  }
}
