import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/leave/controller/leave_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDatePicker extends StatelessWidget {
  CustomDatePicker({super.key});

  final LeaveController leaveController = Get.put(LeaveController());
  // final LeaveController leaveController = Get.find<LeaveController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              // readOnly: true,
              controller: leaveController.fromDateController,
              // controller: TextEditingController(text: leaveController.fromDate.value),
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
                  onPressed: () async {
                    await leaveController.selectFromDate(context);
                    FocusScope.of(context).unfocus();
                  },
                  // onPressed: () => leaveController.selectFromDate(context),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              // readOnly: true,
              controller: leaveController.toDateController,
              // controller: TextEditingController(text: leaveController.toDate.value),
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
                  onPressed: () async {
                    await leaveController.selectToDate(context);
                    FocusScope.of(context).unfocus();
                  },
                  // onPressed: () => leaveController.selectToDate(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
