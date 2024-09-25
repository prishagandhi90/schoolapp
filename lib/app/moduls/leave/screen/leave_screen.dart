import 'package:emp_app/app/moduls/leave/model/dropdownlist_custom.dart';
import 'package:emp_app/app/moduls/leave/screen/custom_date_picker.dart';
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
    // Get.find<LeaveController>();
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
                            flex: 3,
                            child: CustomDropdown1(
                              text: 'Name',
                              controller: controller.leaveNameController,
                              onChanged: (value) async {
                                await controller.LeaveNameChangeMethod(value);
                              },
                              items: controller.leavename
                                  .map((LeaveNamesTable item) => DropdownMenuItem<Map<String, String>>(
                                        value: {
                                          'value': item.value ?? '',
                                          'text': item.name ?? '',
                                        },
                                        child: Text(
                                          item.name ?? '',
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
                          SizedBox(width: 5),
                          Obx(
                            () => Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 48,
                                child: TextField(
                                  readOnly: true,
                                  controller: TextEditingController(text: controller.leftleavedays.value),
                                  style: TextStyle(color: AppColor.white),
                                  decoration: InputDecoration(
                                      hintText: controller.leftleavedays.value != '' ? 'Left ' : '',
                                      hintStyle: TextStyle(color: AppColor.white, fontSize: 15),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppColor.red),
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppColor.red),
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      fillColor: Colors.red,
                                      filled: true),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Obx(
                            () => Expanded(
                              flex: 2,
                              child: CustomDropdown1(
                                text: 'Days',
                                controller: controller.daysController,
                                onChanged: (value) async {
                                  await controller.LeaveDaysOnChange(value);
                                },
                                items: controller.dropdownItems123
                                    .map((DropdownlstTable item) => DropdownMenuItem<Map<String, String>>(
                                          value: {
                                            'value': item.value ?? '',
                                            'text': item.name ?? '',
                                          },
                                          child: Text(
                                            item.name ?? '',
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
                          )
                        ],
                      ),
                    ),
                    Obx(
                      () => Padding(
                        padding: const EdgeInsets.all(16),
                        child: CustomDropdown1(
                          text: 'Reason',
                          controller: controller.reasonController,
                          width: double.infinity,
                          items: controller.leavereason
                              .map((LeaveReasonTable item) => DropdownMenuItem<Map<String, String>>(
                                    value: {
                                      'value': item.name ?? '', // Use the value as the item value
                                      'text': item.name ?? '', // Display the name in the dropdown
                                    },
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        minLines: 3,
                        maxLines: 10,
                        controller: controller.noteController,
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
                        // onTap: () {
                        //   // Make sure it does not lose focus unnecessarily
                        //   FocusScope.of(context).requestFocus(FocusNode());
                        // },
                        // onChanged: (value) {
                        //   // Update the note field without clearing other fields
                        //   controller.noteController.text = value;
                        //   controller.noteController.selection = TextSelection.fromPosition(
                        //     TextPosition(offset: controller.noteController.text.length),
                        //   );
                        // },
                      ),
                    ),
                    Obx(
                      () => Padding(
                        padding: const EdgeInsets.all(16),
                        child: CustomDropdown1(
                          text: 'Reliever Name',
                          controller: controller.relieverNameController,
                          width: double.infinity,
                          onChanged: (value) async {
                            await controller.RelieverNameChangeMethod(value);
                          },
                          items: controller.leaverelivername
                              .map((LeaveReliverName item) => DropdownMenuItem<Map<String, String>>(
                                    value: {
                                      'value': item.id ?? '', // Use the value as the item value
                                      'text': item.name ?? '', // Display the name in the dropdown
                                    },
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
                    ),
                    Obx(
                      () => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CustomDropdown1(
                          text: 'Late Reason',
                          controller: controller.delayreasonNameController,
                          width: double.infinity,
                          items: controller.leavedelayreason
                              .map((LeaveDelayReason item) => DropdownMenuItem<Map<String, String>>(
                                    value: {
                                      'value': item.id ?? '', // Use the value as the item value
                                      'text': item.name ?? '', // Display the name in the dropdown
                                    },
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
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.13,
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: ElevatedButton(
                        onPressed: () async {
                          await controller.saveLeaveEntryList("LV");
                        },
                        // onPressed: controller.isLoading.value
                        //     ? null
                        //     : () async {
                        //         await controller.saveLeaveEntryList("LV");
                        //       },
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
