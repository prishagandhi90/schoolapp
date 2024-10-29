import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/moduls/leave/model/dropdownlist_custom.dart';
import 'package:emp_app/app/app_custom_widget/custom_date_picker.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:emp_app/app/moduls/leave/model/leaveReliverName_model.dart';
import 'package:emp_app/app/moduls/leave/model/leavedelayreason_model.dart';
import 'package:emp_app/app/moduls/leave/model/leavenames_model.dart';
import 'package:emp_app/app/moduls/leave/model/leavereason_model.dart';
import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/moduls/leave/screen/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveScreen extends GetView<LeaveController> {
  LeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LeaveController());

    return GetBuilder<LeaveController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          controller: controller.leaveScrollController,
          child: Column(
            children: [
              // CustomDatePicker(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomDatePicker(
                        dateController: controller.fromDateController,
                        hintText: AppString.from,
                        onDateSelected: () async => await controller.selectFromDate(context),
                      ),
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Expanded(
                      child: CustomDatePicker(
                        dateController: controller.toDateController,
                        hintText: AppString.to,
                        onDateSelected: () async => await controller.selectToDate(context),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: CustomDropdown(
                        text: AppString.name,
                        controller: controller.leaveNameController,
                        onChanged: (value) async {
                          await controller.LeaveNameChangeMethod(value);
                          // controller.leaveNameController.text = value?['text'] ?? '';
                          // Update the leftleavedays and days fields if needed
                          if (value != null) {
                            await controller.getLeftLeaves(); // Call this to update leftleavedays
                          }
                        },
                        items: controller.leavename
                            .map((LeaveNamesTable item) => DropdownMenuItem<Map<String, String>>(
                                  value: {
                                    'value': item.value ?? '',
                                    'text': item.name ?? '',
                                  },
                                  child: Text(
                                    item.name ?? '',
                                    style: AppStyle.black.copyWith(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        width: double.infinity,
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 50,
                        child: CustomTextFormField(
                          readOnly: true,
                          controller: controller.leftLeaveDaysController,
                          style: TextStyle(color: AppColor.white),
                          decoration: InputDecoration(
                              hintText: controller.leftleavedays.value != '' ? 'Left ' : 'Left',
                              hintStyle: TextStyle(color: AppColor.white, fontSize: 15),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColor.red),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColor.red),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              fillColor: AppColor.red,
                              filled: true),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      flex: 3,
                      child: CustomDropdown(
                        text: AppString.days,
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
                                    style: AppStyle.black.copyWith(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: CustomDropdown(
                  text: AppString.reason,
                  controller: controller.reasonController,
                  onChanged: (value) async {
                    controller.update();
                  },
                  onMenuStateChange: (isOpen) async {
                    // Bottom navigation bar ko hide/show karna
                    if (isOpen) {
                      controller.hideBottomNavBar();
                    } else {
                      controller.showBottomNavBar();
                    }
                  },
                  width: double.infinity,
                  items: controller.leavereason
                      .map((LeaveReasonTable item) => DropdownMenuItem<Map<String, String>>(
                            value: {
                              'value': item.name ?? '', // Use the value as the item value
                              'text': item.name ?? '', // Display the name in the dropdown
                            },
                            child: Text(
                              item.name ?? '', // Display the name in the dropdown
                              style: AppStyle.black.copyWith(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomTextFormField(
                  hint: AppString.note,
                  hintStyle: AppStyle.black.copyWith(fontSize: 14),
                  minLines: 3,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: controller.noteController,
                  focusNode: controller.notesFocusNode,
                  scrollPhysics: BouncingScrollPhysics(),
                  onChanged: (value) {
                    print('Password changed: $value');
                  },
                  // onFieldSubmitted: (value) {
                  //   // Move focus to the next field
                  //   // FocusScope.of(context).requestFocus(passwordFocusNode);
                  // },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppString.notesisrequired;
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: CustomDropdown(
                  text: AppString.relieverName,
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
                              style: AppStyle.black.copyWith(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomDropdown(
                  text: AppString.lateReason,
                  controller: controller.delayreasonNameController,
                  onChanged: (value) async {
                    await controller.DelayReasonChangeMethod(value);
                    controller.update();
                  },
                  width: double.infinity,
                  items: controller.leavedelayreason
                      .map((LeaveDelayReason item) => DropdownMenuItem<Map<String, String>>(
                            value: {
                              'value': item.id ?? '', // Use the value as the item value
                              'text': item.name ?? '', // Display the name in the dropdown
                            },
                            child: Text(
                              item.name ?? '', // Display the name in the dropdown
                              style: AppStyle.black.copyWith(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                ),
              ),
              SizedBox(height: 30),
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
                    AppString.save,
                    style: AppStyle.black.copyWith(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      // );
    });
  }
}
