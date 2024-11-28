import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdown extends StatelessWidget {
  final String text; // Label for the dropdown
  final TextEditingController controller; // To manage the selected value
  final Function(Map<String, String>?) onChanged; // Custom onChanged callback for Map<String, String>
  final List<DropdownMenuItem<Map<String, String>>> items; // List of items with Map<String, String>
  final double width; // To set width dynamically
  final InputDecoration? decoration; // Custom decoration if needed
  final Function(bool)? onMenuStateChange; // Menu state change callback
  final ButtonStyleData? buttonStyleData;

  CustomDropdown(
      {required this.text,
      required this.controller,
      required this.onChanged,
      required this.items,
      this.width = double.infinity,
      this.decoration,
      this.onMenuStateChange,
      this.buttonStyleData});

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
              fontSize: 14,
              color: AppColor.black,
            ),
          ),
          items: items,
          value: items
              .firstWhereOrNull(
                (item) => item.value?['text'] == controller.text,
              )
              ?.value, // Get selected value from the controller
          onChanged: (value) {
            FocusScope.of(context).unfocus();
            if (value != null) {
              controller.text = value['text'] ?? ''; // Update the controller with selected value
              onChanged(value); // Call the custom onChanged method
              print("Selected value: ${value['text']}"); // Debugging line to check selected value
            }
          },
          buttonStyleData: buttonStyleData,
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: screenHeight * 0.5, // Set dropdown max height to 50% of screen
            // padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            scrollbarTheme: ScrollbarThemeData(
              thumbVisibility: MaterialStateProperty.all(true),
            ),
          ),
          onMenuStateChange: (isOpen) {
            // Null check before invoking
            if (onMenuStateChange != null) {
              print("Dropdown Menu State Changed: $isOpen");
              onMenuStateChange!(isOpen); // Call only if it's not null
            }
          },
        ),
      ),
    );
  }
}
