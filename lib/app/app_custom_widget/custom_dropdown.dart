// ignore_for_file: must_be_immutable

import 'package:emp_app/app/core/service/common_methods.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CustomDropDown extends StatefulWidget {
  CustomDropDown({super.key, this.selValue, required this.onPressed});
  final Function(String) onPressed;
  String? selValue = "";

  @override
  State<CustomDropDown> createState() => CustomDropDownState();
}

class CustomDropDownState extends State<CustomDropDown> {
  String? selectedValue;
  List<String> years = getLastTwoYears();
  // List<String> years = ['2023', '2024'];
  // String selValue = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Text(
            AppString.select,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),
          ),
          // decoration: InputDecoration(
          //               labelText: "label Text",
          //               labelStyle: TextStyle(
          //                   color: true
          //                       ? Colors.black54
          //                       : Theme.of(context).disabledColor),
          //               contentPadding: EdgeInsets.all(16),
          //               focusedBorder: OutlineInputBorder(
          //                 borderSide:
          //                     BorderSide(color: Theme.of(context).primaryColor),
          //               ),
          //               border: new OutlineInputBorder(
          //                   borderSide: new BorderSide()),
          //             ),
          items: years
              .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 13, //16
                        fontFamily: CommonFontStyle.plusJakartaSans,
                      ),
                    ),
                  ))
              .toList(),
          // value: controller.selectedYear.value.isNotEmpty ? controller.selectedYear.value : null,
          value: widget.selValue == null || widget.selValue!.isNotEmpty ? widget.selValue : null,
          // onChanged: (String? value) {
          //   if (value != null) {
          //     controller.selectedYear.value = value;
          //     int yearIndex = controller.years.indexOf(value);
          //     controller.upd_YearSelIndex(yearIndex);
          //   }
          // },
          onChanged: (String? value) {
            widget.onPressed(value!);
            setState(() {
              widget.selValue = value;
            });
          },
          buttonStyleData: ButtonStyleData(
            height: 50,
            width: 140,
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.black),
              color: AppColor.white,
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
        ),
      ),
    );
  }
}
