import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/moduls/overtime/controller/overtime_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DatetimePicker extends StatelessWidget {
  const DatetimePicker({super.key, this.text, this.text1});
  final String? text;
  final String? text1;

  @override
  Widget build(BuildContext context) {
    Get.put(OvertimeController());
    return GetBuilder<OvertimeController>(
      builder: (controller) {
        return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
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
                      hintText:
                          text, //controller.selectedDate != null ? DateFormat('dd/MM/yyyy').format(controller.selectedDate!) : 'From',
                      suffixIcon: Icon(Icons.calendar_today), // Add suffixIcon here
                    ),
                    onTap: () => controller.selectDate(context),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
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
                      hintText: text1,
                      suffixIcon: Icon(Icons.timer_outlined), // Add suffixIcon here
                    ),
                    onTap: controller.selectedDate != null
                        ? () => controller.selectTime(context)
                        : null, // Time picker is disabled until a date is selected
                  ),
                ),
              ],
            ));
      },
    );
  }
}
