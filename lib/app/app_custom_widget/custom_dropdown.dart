// ignore_for_file: deprecated_member_use

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdown extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final Function(Map<String, String>?) onChanged;
  final List<DropdownMenuItem<Map<String, String>>> items;
  final double width;
  final InputDecoration? decoration;
  final Function(bool)? onMenuStateChange;
  final ButtonStyleData? buttonStyleData;
  final DropdownSearchData<Map<String, String>>? dropdownSearchData;

  /// ✅ New field added
  final bool enabled;

  CustomDropdown({
    required this.text,
    required this.controller,
    required this.onChanged,
    required this.items,
    this.width = double.infinity,
    this.decoration,
    this.onMenuStateChange,
    this.buttonStyleData,
    this.dropdownSearchData,
    this.enabled = true, // ✅ default true
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<Map<String, String>>(
          key: UniqueKey(),
          isExpanded: true,
          hint: Text(
            text,
            style: TextStyle(
              fontSize: getDynamicHeight(size: 0.016),
              color: enabled ? AppColor.black : AppColor.black.withOpacity(0.4), // faded if disabled
              fontFamily: CommonFontStyle.plusJakartaSans,
            ),
          ),
          items: enabled ? items : [], // ✅ disable item selection
          value: items
              .firstWhereOrNull(
                (item) => item.value?['text'] == controller.text,
              )
              ?.value,
          onChanged: enabled
              ? (value) {
                  if (value != null) {
                    controller.text = value['text'] ?? '';
                    onChanged(value);
                  }
                }
              : null, // ✅ disable interaction
          buttonStyleData: buttonStyleData,
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
          dropdownSearchData: dropdownSearchData,
          dropdownStyleData: DropdownStyleData(
            useSafeArea: false,
            useRootNavigator: true,
            maxHeight: screenHeight * 0.4,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(0),
              color: Colors.white,
            ),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(8),
              thickness: WidgetStateProperty.all(6),
              thumbVisibility: WidgetStateProperty.all(true),
              thumbColor: WidgetStateProperty.all(AppColor.black.withOpacity(0.5)),
            ),
            offset: const Offset(0, -4),
          ),
          onMenuStateChange: (isOpen) {
            if (isOpen) {
              print("Dropdown is open");
            } else {
              print("Dropdown is closed");
            }
          },
        ),
      ),
    );
  }
}
