import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDatePicker extends StatelessWidget {
  CustomDatePicker({super.key});

  final LeaveController leaveController = Get.put(LeaveController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              readOnly: true,
              controller: leaveController.fromDateController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.black),
                  borderRadius: BorderRadius.circular(0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.black),
                  borderRadius: BorderRadius.circular(0),
                ),
                hintText: 'From',
                hintStyle: TextStyle(color: AppColor.black),
                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(0), borderSide: const BorderSide(color: Colors.black)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    leaveController.selectDate(context, leaveController.fromDateController);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              readOnly: true,
              controller: leaveController.toDateController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.black),
                  borderRadius: BorderRadius.circular(0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.black),
                  borderRadius: BorderRadius.circular(0),
                ),
                hintText: 'To',
                hintStyle: TextStyle(color: AppColor.black),
                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(0), borderSide: const BorderSide(color: Colors.black)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    leaveController.selectDate(context, leaveController.toDateController);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
