// ignore_for_file: deprecated_member_use

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/leave/model/dropdownlist_custom.dart';
import 'package:emp_app/app/app_custom_widget/custom_date_picker.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:emp_app/app/moduls/leave/model/leaveReliverName_model.dart';
import 'package:emp_app/app/moduls/leave/model/leavedelayreason_model.dart';
import 'package:emp_app/app/moduls/leave/model/leavenames_model.dart';
import 'package:emp_app/app/moduls/leave/model/leavereason_model.dart';
import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/moduls/leave/screen/widget/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveScreen extends GetView<LeaveController> {
  LeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LeaveController());

    double screenHeight = MediaQuery.of(context).size.height;
    double availableHeight = screenHeight - 70.0; // 70.0 is the height of BottomNavigationBar

    return GetBuilder<LeaveController>(builder: (controller) {
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              // physics: AlwaysScrollableScrollPhysics(),
              controller: controller.leaveScrollController,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: availableHeight,
                ),
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
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal: 0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColor.black),
                                  borderRadius: BorderRadius.circular(0),
                                  color: AppColor.white,
                                ),
                              ),
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
                                          style: AppStyle.black.copyWith(
                                            // fontSize: 14,
                                            fontSize: getDynamicHeight(size: 0.016),
                                          ),
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
                                    hintStyle: TextStyle(
                                      color: AppColor.white,
                                      // fontSize: 15,
                                      fontSize: getDynamicHeight(size: 0.017),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.darkGreen),
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.darkGreen),
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    fillColor: AppColor.darkGreen,
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
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal: 0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColor.black),
                                  borderRadius: BorderRadius.circular(0),
                                  color: AppColor.white,
                                ),
                              ),
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
                                          style: AppStyle.black.copyWith(
                                            // fontSize: 14,
                                            fontSize: getDynamicHeight(size: 0.016),
                                          ),
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
                      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: CustomDropdown(
                        text: AppString.hdleaveperiod,
                        controller: controller.hdleaveperiodController,
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.black),
                            borderRadius: BorderRadius.circular(0),
                            color: AppColor.white,
                          ),
                        ),
                        onChanged: (value) {
                          if (value!['value'] != '--select--') {
                            controller.hdleaveperiodController.text = value['text']!;
                          } else {
                            // "--select--" choose hone par, previous value rakho
                            controller.hdleaveperiodController.text = controller.hdleaveperiodController.text;
                          }
                          controller.update();
                        },
                        width: double.infinity,
                        items: [
                          {'value': '', 'text': '--select--'}, // Empty value so that it doesn't save
                          {'value': 'First_Half', 'text': 'First_Half'},
                          {'value': 'Second_Half', 'text': 'Second_Half'},
                        ].map((Map<String, String> item) {
                          return DropdownMenuItem<Map<String, String>>(
                            value: item,
                            child: Text(
                              item['text'] ?? '',
                              style: AppStyle.black,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                    //   child: CustomDropdown(
                    //     text: AppString.hdleaveperiod,
                    //     controller: controller.hdleaveperiodController,
                    //     buttonStyleData: ButtonStyleData(
                    //       height: 50,
                    //       decoration: BoxDecoration(
                    //         border: Border.all(color: AppColor.black),
                    //         borderRadius: BorderRadius.circular(0),
                    //         color: AppColor.white,
                    //       ),
                    //     ),
                    //     onChanged: (value) {
                    //       controller.update();
                    //     },
                    //     width: double.infinity,
                    //     items: [
                    //       {'value': '--select--', 'text': '--select--'},
                    //       {'value': 'First_Half', 'text': 'First_Half'},
                    //       {'value': 'Second_Half', 'text': 'Second_Half'},
                    //     ].map((Map<String, String> item) {
                    //       return DropdownMenuItem<Map<String, String>>(
                    //         value: item,
                    //         child: Text(
                    //           item['text'] ?? '',
                    //           style: AppStyle.black,
                    //         ),
                    //       );
                    //     }).toList(),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: CustomDropdown(
                        text: AppString.reason,
                        controller: controller.reasonController,
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.black),
                            borderRadius: BorderRadius.circular(0),
                            color: AppColor.white,
                          ),
                        ),
                        onChanged: (value) async {
                          controller.update();
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
                                    style: AppStyle.black.copyWith(
                                      // fontSize: 14,
                                      fontSize: getDynamicHeight(size: 0.016),
                                    ),
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
                        hintStyle: AppStyle.black.copyWith(
                          // fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontSize: getDynamicHeight(size: 0.016),
                        ),
                        minLines: 3,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        controller: controller.noteController,
                        focusNode: controller.notesFocusNode,
                        scrollPhysics: BouncingScrollPhysics(),
                         enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.black, width: 1),
                              borderRadius: BorderRadius.circular(0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.black,width: 1),
                              borderRadius: BorderRadius.circular(0),
                            ),
                        onChanged: (value) {
                          print('Password changed: $value');
                        },
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        onFieldSubmitted: (value) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
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
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.black),
                            borderRadius: BorderRadius.circular(0),
                            color: AppColor.white,
                          ),
                        ),
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
                                    style: AppStyle.black.copyWith(
                                      // fontSize: 14,
                                      fontSize: getDynamicHeight(size: 0.016),
                                    ),
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
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.black),
                            borderRadius: BorderRadius.circular(0),
                            color: AppColor.white,
                          ),
                        ),
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
                                    style: AppStyle.black.copyWith(
                                      // fontSize: 14,
                                      fontSize: getDynamicHeight(size: 0.016),
                                    ),
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
                        onPressed: controller.isSaveBtnLoading
                            ? null
                            : () async {
                                await controller.saveLeaveEntryList("LV");
                                controller.update();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.lightgreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: controller.isSaveBtnLoading
                            ? const CircularProgressIndicator()
                            : Text(
                                AppString.save,
                                style: AppStyle.black.copyWith(
                                  // fontSize: 20,
                                  fontSize: getDynamicHeight(size: 0.022),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (controller.isNotesFieldFocused.value)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
        ],
      );
      // );
    });
  }
}
