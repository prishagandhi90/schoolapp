import 'package:emp_app/app/app_custom_widget/custom_dropdown1.dart';
import 'package:emp_app/app/app_custom_widget/custom_timepicker.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:emp_app/app/moduls/leave/model/leavedelayreason_model.dart';
import 'package:emp_app/app/moduls/overtime/controller/overtime_controller.dart';
import 'package:emp_app/app/app_custom_widget/custom_datepicker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtScreen extends StatelessWidget {
  const OtScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(OvertimeController());
    var leaveController = Get.put(LeaveController());
    return GetBuilder<OvertimeController>(
      builder: (controller) {
        return Scaffold(
            backgroundColor: AppColor.white,
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: CustomDatePicker(
                        hintText: "From",
                        controllerValue: TextEditingController(
                          text: controller.selectedFromDate != null ? controller.dateFormat.format(controller.selectedFromDate!) : '',
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            controller.oTMinutes = 0;
                            controller.selectedFromDate = pickedDate;
                            controller.onDateTimeTap();
                            controller.update();
                          }
                        },
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomTimepicker(
                          hinttext: "--:--",
                          controllerValue: TextEditingController(
                            text: controller.formatTimeOfDay(controller.selectedFromTime),
                          ),
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: controller.selectedFromTime ?? TimeOfDay.now(),
                                initialEntryMode: TimePickerEntryMode.input);

                            if (pickedTime != null) {
                              controller.oTMinutes = 0;
                              controller.selectedFromTime = pickedTime;
                              controller.onDateTimeTap();
                              controller.update();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        Expanded(
                            child: CustomDatePicker(
                          hintText: "To",
                          controllerValue: TextEditingController(
                            text: controller.selectedToDate != null ? controller.dateFormat.format(controller.selectedToDate!) : '',
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              controller.oTMinutes = 0;
                              controller.selectedToDate = pickedDate;
                              controller.onDateTimeTap();
                              controller.update();
                            }
                          },
                        )),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CustomTimepicker(
                            hinttext: "--:--",
                            controllerValue: TextEditingController(
                              text: controller.formatTimeOfDay(controller.selectedToTime),
                            ),
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: controller.selectedToTime ?? TimeOfDay.now(),
                                  initialEntryMode: TimePickerEntryMode.input);

                              if (pickedTime != null) {
                                controller.oTMinutes = 0;
                                controller.selectedToTime = pickedTime;
                                controller.onDateTimeTap();
                                controller.update();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: controller.oTMinutes.toString(),
                    ),
                    decoration: InputDecoration(
                      hintText: "Min",
                      helperStyle: TextStyle(color: AppColor.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.black),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.black),
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
                  CustomDropdown1(
                    text: 'Late Reason',
                    width: double.infinity,
                    items: leaveController.leavedelayreason
                        .map((LeaveDelayReason item) => DropdownMenuItem<Map<String, String>>(
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
            ));
      },
    );
  }
}
