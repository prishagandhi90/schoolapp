import 'package:flutter/material.dart';

import 'package:emp_app/app/core/util/app_color.dart';

class CustomDatePicker extends StatelessWidget {
  final TextEditingController dateController;
  final String hintText;
  final Function onDateSelected;

  const CustomDatePicker({
    Key? key,
    required this.dateController,
    required this.hintText,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: dateController,
      decoration: InputDecoration(
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
          fontSize: 14,
          // fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            await onDateSelected();
            FocusScope.of(context).unfocus();
          },
        ),
      ),
    );
  }
}
