import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:flutter/material.dart';

import 'package:emp_app/app/core/util/app_color.dart';

class CustomDatePicker extends StatelessWidget {
  final TextEditingController dateController;
  final String hintText;
  final Function? onDateSelected;
  final TextStyle? style;
  final InputDecoration? decoration;

  const CustomDatePicker({
    Key? key,
    required this.dateController,
    required this.hintText,
    this.onDateSelected,
    this.style,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: dateController,
      style: style,
      decoration: decoration ??
          InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.black),
              borderRadius: BorderRadius.circular(0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.black),
              borderRadius: BorderRadius.circular(0),
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              // fontSize: 14,
              fontSize: getDynamicHeight(size: 0.016),
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                await onDateSelected!();
                FocusScope.of(context).unfocus();
              },
            ),
          ),
      onTap: () {
        FocusScope.of(context).unfocus(); // Close keyboard when tapping on the TextFormField
      },
    );
  }
}
