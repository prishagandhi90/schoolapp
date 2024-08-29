import 'package:emp_app/app/app_custom_widget/custom_date_picker.dart';
import 'package:emp_app/app/app_custom_widget/custom_dropdown1.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:emp_app/app/moduls/leave/model/leaveReliverName_model.dart';
import 'package:emp_app/app/moduls/leave/model/leavedelayreason_model.dart';
import 'package:emp_app/app/moduls/leave/model/leavenames_model.dart';
import 'package:emp_app/app/moduls/leave/model/leavereason_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveScreen extends StatelessWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LeaveController());
    return GetBuilder<LeaveController>(
      builder: (controller) {
        return Scaffold(
            backgroundColor: AppColor.white,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                controller: controller.leaveScrollController,
                child: Column(
                  children: [
                    CustomDatePicker(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CustomDropdown1(
                              text: 'Name',
                              items: controller.leavename
                                  .map((LeaveNamesTable item) => DropdownMenuItem<String>(
                                        value: item.value, // Use the value as the item value
                                        child: Text(
                                          item.name ?? '', // Display the name in the dropdown
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              width: double.infinity,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                              flex: 1,
                              child: Obx(
                                () => CustomDropdown1(
                                  text: 'Days',
                                  width: double.infinity,
                                  items: [
                                    DropdownMenuItem<String>(
                                      value: 'Select Option',
                                      child: Text(
                                        'Select Option',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (controller.days.value == '1') ...[
                                      DropdownMenuItem<String>(
                                        value: '0.5',
                                        child: Text(
                                          '0.5',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: '1',
                                        child: Text(
                                          '1',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ] else ...[
                                      DropdownMenuItem<String>(
                                        value: controller.days.value,
                                        child: Text(
                                          controller.days.value,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: CustomDropdown1(
                        text: 'Reason',
                        width: double.infinity,
                        items: controller.leavereason
                            .map((LeaveReasonTable item) => DropdownMenuItem<String>(
                                  value: item.name, // Use the value as the item value
                                  child: Text(
                                    item.name ?? '', // Display the name in the dropdown
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        minLines: 3,
                        maxLines: 10,
                        decoration: InputDecoration(
                            hintText: 'Notes...',
                            hintStyle: TextStyle(color: AppColor.black),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.black),
                              borderRadius: BorderRadius.circular(0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.black),
                              borderRadius: BorderRadius.circular(0),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: CustomDropdown1(
                        text: 'Reliever Name',
                        width: double.infinity,
                        items: controller.leaverelivername
                            .map((LeaveReliverName item) => DropdownMenuItem<String>(
                                  value: item.name, // Use the value as the item value
                                  child: Text(
                                    item.name ?? '', // Display the name in the dropdown
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomDropdown1(
                        text: 'Late Reason',
                        width: double.infinity,
                        items: controller.leavedelayreason
                            .map((LeaveDelayReason item) => DropdownMenuItem<String>(
                                  value: item.name, // Use the value as the item value
                                  child: Text(
                                    item.name ?? '', // Display the name in the dropdown
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.13,
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.lightgreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(color: AppColor.black, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
