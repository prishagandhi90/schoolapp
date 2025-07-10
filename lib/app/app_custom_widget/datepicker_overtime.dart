import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/moduls/PAYROLL_MAIN/overtime/controller/overtime_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDatePicker extends StatelessWidget {
  final String hintText;
  final Function()? onTap;
  final TextEditingController controllerValue;

  CustomDatePicker({required this.hintText, required this.controllerValue, this.onTap});

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
            hintStyle: TextStyle(color: AppColor.black),
            suffixIcon: IconButton(icon: Icon(Icons.calendar_today), onPressed: onTap),
          ),
          controller: controllerValue,
        );
      },
    );
  }
}
