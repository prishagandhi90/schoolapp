import 'package:emp_app/app/app_custom_widget/custom_dropdown1.dart';
import 'package:emp_app/app/app_custom_widget/custom_timepicker.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/moduls/leave/model/leavedelayreason_model.dart';
import 'package:emp_app/app/moduls/overtime/controller/overtime_controller.dart';
import 'package:emp_app/app/app_custom_widget/custom_datepicker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtScreen extends StatelessWidget {
  const OtScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            controller.selectedDate = pickedDate;
                            controller.update();
                          }
                        },
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomTimepicker(hinttext: "--:--"),
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
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              controller.selectedDate = pickedDate;
                              controller.update();
                            }
                          },
                        )),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CustomTimepicker(hinttext: "--:--"),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    readOnly: true,
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
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 16),
                  //   child: CustomDropdown1(
                  //     text: 'Late Reason',
                  //     width: double.infinity,
                  //     items: leaveController.leavedelayreason
                  //         .map((LeaveDelayReason item) => DropdownMenuItem<String>(
                  //               value: item.name, // Use the value as the item value
                  //               child: Text(
                  //                 item.name ?? '', // Display the name in the dropdown
                  //                 style: const TextStyle(
                  //                   fontSize: 14,
                  //                   fontWeight: FontWeight.bold,
                  //                   color: Colors.black,
                  //                 ),
                  //                 overflow: TextOverflow.ellipsis,
                  //               ),
                  //             ))
                  //         .toList(),
                  //   ),
                  // ),
                ],
              ),
            ));
      },
    );
  }
}
