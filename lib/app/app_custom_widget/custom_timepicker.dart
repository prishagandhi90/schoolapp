import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/moduls/overtime/controller/overtime_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTimepicker extends StatelessWidget {
  final String hinttext;
  const CustomTimepicker({super.key, required this.hinttext});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OvertimeController>(
      builder: (controller) {
        return TextField(
          readOnly: true,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.black),
              borderRadius: BorderRadius.circular(0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.black),
              borderRadius: BorderRadius.circular(0),
            ),
            hintText: hinttext,
            suffixIcon: Icon(Icons.access_time),
          ),
          onTap: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: controller.selectedTime ?? TimeOfDay.now(),
              initialEntryMode: TimePickerEntryMode.input
            );

            if (pickedTime != null) {
              controller.selectedTime = pickedTime;
              controller.update();
            }
          },
          controller: TextEditingController(
            text: controller.formatTimeOfDay(controller.selectedTime),
          ),
        );
      },
    );
  }
}
