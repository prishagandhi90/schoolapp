import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/moduls/overtime/controller/overtime_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTimepicker extends StatelessWidget {
  final String hinttext;
  final TextEditingController controllerValue;
  final Function()? onTap;
  const CustomTimepicker({super.key, required this.hinttext, required this.controllerValue, this.onTap});

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
          onTap: onTap,
          controller: controllerValue,
        );
      },
    );
  }
}
