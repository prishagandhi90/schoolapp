// ignore_for_file: must_be_immutable

import 'package:emp_app/app/app_custom_widget/common_methods.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class DropDownAttendance extends StatefulWidget {
  DropDownAttendance({super.key, this.selValue, required this.onPressed});
  final Function(String) onPressed;
  String? selValue;

  @override
  State<DropDownAttendance> createState() => CustomDropDownState();
}

class CustomDropDownState extends State<DropDownAttendance> {
  String? selectedValue;
  List<String> years = getLastTwoYears();

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selValue; // Initialize local selectedValue
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   setState(() {
  //     selectedValue = widget.selValue;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          key: UniqueKey(),
          isExpanded: true,
          hint: Text(
            AppString.select,
            style: TextStyle(
              // fontSize: 14,
              fontSize: getDynamicHeight(size: 0.016),
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),
          ),
          items: years
              .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        // fontSize: 13, //16
                        fontSize: getDynamicHeight(size: 0.015),
                        fontFamily: CommonFontStyle.plusJakartaSans,
                      ),
                    ),
                  ))
              .toList(),
          value: widget
              .selValue, //selectedValue, //widget.selValue == null || widget.selValue!.isNotEmpty ? widget.selValue : null,
          onChanged: (String? value) {
            setState(() {
              widget.selValue = value;
              selectedValue = value;
            });
            widget.onPressed(value!);
          },
          buttonStyleData: ButtonStyleData(
            height: getDynamicHeight(size: 0.052), //50,
            width: getDynamicHeight(size: 0.122), //120,
            padding: EdgeInsets.only(
              left: getDynamicHeight(size: 0.016), //14,
              right: getDynamicHeight(size: 0.016), //14,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.black),
              color: AppColor.white,
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          menuItemStyleData: MenuItemStyleData(
            height: getDynamicHeight(size: 0.042), //40,
          ),
        ),
      ),
    );
  }
}
