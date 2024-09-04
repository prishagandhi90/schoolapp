import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/moduls/overtime/controller/overtime_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDatePicker extends StatelessWidget {
  final String hintText;
  final Function()? onTap;

  CustomDatePicker({required this.hintText, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OvertimeController>(
      builder: (controller) {
        return TextFormField(
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
            hintText: hintText,
            suffixIcon: Icon(Icons.calendar_today),
          ),
          onTap: onTap,
          controller: TextEditingController(
            text: controller.selectedDate != null ? controller.dateFormat.format(controller.selectedDate!) : '',
          ),
        );
      },
    );
  }
}
