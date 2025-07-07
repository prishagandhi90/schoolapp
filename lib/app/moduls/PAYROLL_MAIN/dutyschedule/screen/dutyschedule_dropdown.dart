// ignore_for_file: must_be_immutable

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/moduls/PAYROLL_MAIN/dutyschedule/controller/dutyschedule_controller.dart';
import 'package:emp_app/app/moduls/PAYROLL_MAIN/dutyschedule/model/dropdown_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DutyscheduleDropdown extends StatefulWidget {
  @override
  State<DutyscheduleDropdown> createState() => DutyscheduleDropdownState();
}

class DutyscheduleDropdownState extends State<DutyscheduleDropdown> {
  sheduledrpdwnlst? selectedItem;

  final DutyscheduleController controller = Get.put(DutyscheduleController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DutyscheduleController>(
      builder: (controller) {
        return DropdownButtonHideUnderline(
          child: DropdownButton2<sheduledrpdwnlst>(
            hint: Text('Select'),
            value: selectedItem,
            items: controller.Sheduledrpdwnlst.map((sheduledrpdwnlst item) {
              return DropdownMenuItem<sheduledrpdwnlst>(
                value: item,
                child: Container(
                  // color: isCurrentWeek ? Colors.yellow : Colors.transparent,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    item.name ?? '',
                    style: TextStyle(
                      color: item == controller.CurrentWeekItem ? AppColor.primaryColor : Colors.black, // Custom color
                      fontWeight: item == controller.CurrentWeekItem ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ), // Display the item name
              );
            }).toList(),
            onChanged: (sheduledrpdwnlst? value) {
              setState(() {
                selectedItem = value;
              });
              print("Selected item: ${selectedItem?.name}");
            },
            buttonStyleData: ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                color: Color.fromARGB(199, 255, 255, 255),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      },
    );
  }
}
