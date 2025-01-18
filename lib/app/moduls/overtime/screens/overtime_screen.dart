import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emp_app/app/app_custom_widget/custom_date_picker.dart';
import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/app_custom_widget/custom_timepicker.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:emp_app/app/moduls/leave/model/leavedelayreason_model.dart';
import 'package:emp_app/app/moduls/leave/screen/widget/custom_textformfield.dart';
import 'package:emp_app/app/moduls/overtime/controller/overtime_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtScreen extends GetView<OvertimeController> {
  const OtScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(OvertimeController());

    double screenHeight = MediaQuery.of(context).size.height;
    double availableHeight = screenHeight - 70.0; // 70.0 is the height of BottomNavigationBar

    // var leaveController = Get.put(LeaveController());
    final leaveController = Get.find<LeaveController>();
    return GetBuilder<OvertimeController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.white,
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  controller: controller.overtimeScrollController,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: availableHeight,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomDatePicker(
                                dateController: controller.fromDateController,
                                hintText: AppString.from,
                                onDateSelected: () async => await controller.selectDate(context, controller.fromDateController),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: CustomTimepicker(
                                hinttext: "--:--",
                                controllerValue: controller.fromTimeController,
                                onTap: () async {
                                  await controller.selectTime(context, controller.fromTimeController);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomDatePicker(
                                dateController: controller.toDateController,
                                hintText: AppString.to,
                                onDateSelected: () async => await controller.selectDate(context, controller.toDateController),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: CustomTimepicker(
                                hinttext: "--:--",
                                controllerValue: controller.toTimeController,
                                onTap: () async {
                                  await controller.selectTime(context, controller.toTimeController);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        CustomTextFormField(
                          readOnly: true,
                          controller: controller.otMinutesController,
                          hint: AppString.min,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            // fontWeight: FontWeight.bold,
                            color: AppColor.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: CustomTextFormField(
                            hint: AppString.note,
                            hintStyle: TextStyle(
                              fontSize: 14,
                              // fontWeight: FontWeight.bold,
                              color: AppColor.black,
                            ),
                            minLines: 3,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            controller: controller.noteController,
                            focusNode: controller.notesFocusNode,
                            scrollPhysics: BouncingScrollPhysics(),
                            onChanged: (value) {
                              print('Password changed: $value');
                            },
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onFieldSubmitted: (value) {
                              // Move focus to the next field
                              // FocusScope.of(context).requestFocus(passwordFocusNode);
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
                        CustomDropdown(
                          text: AppString.lateReason,
                          controller: controller.delayreasonName_OT_Controller,
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
                          items: leaveController.leavedelayreason
                              .map((LeaveDelayReason item) => DropdownMenuItem<Map<String, String>>(
                                    value: {
                                      'value': item.id ?? '', // Use the value as the item value
                                      'text': item.name ?? '', // Display the name in the dropdown
                                    },
                                    child: Text(
                                      item.name ?? '', // Display the name in the dropdown
                                      style: TextStyle(
                                        fontSize: 14,
                                        // fontWeight: FontWeight.bold,
                                        color: AppColor.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.13,
                          width: MediaQuery.of(context).size.width * 0.40,
                          child: ElevatedButton(
                            onPressed: controller.isSaveBtnLoading
                                ? null
                                : () async {
                                    await controller.saveLeaveEntryList("OT");
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
                                    style: AppStyle.black.copyWith(fontSize: 20),
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
          ),
        );
      },
    );
  }
}
