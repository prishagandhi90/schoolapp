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
            // FocusManager.instance.primaryFocus?.unfocus();
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

          // dropdownStyleData: DropdownStyleData(
          //   // maxHeight: screenHeight * 0.5, // Set dropdown max height to 50% of screen
          //   maxHeight: screenHeight - 100.0,
          //   // padding: const EdgeInsets.symmetric(horizontal: 14),
          //   padding: items.length * 40.0 > screenHeight - 70.0 // Each item's height approx. 40
          //       ? const EdgeInsets.only(bottom: 70.0) // Add padding if items exceed height
          //       : null,
          //   decoration: BoxDecoration(
          //     border: Border.all(color: Colors.black),
          //     borderRadius: BorderRadius.circular(0),
          //     color: Colors.white,
          //   ),
          //   scrollbarTheme: ScrollbarThemeData(
          //     thumbVisibility: WidgetStateProperty.all(true),
          //   ),
          // ),
          dropdownStyleData: DropdownStyleData(
            useSafeArea: false, // यह dropdown को safe area से बाहर जाने की अनुमति देगा
            useRootNavigator: true,
            maxHeight: screenHeight * 0.4, // स्क्रीन की ऊंचाई का 40% तक सीमित करें
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
            offset: const Offset(0, -4), // ड्रॉपडाउन को थोड़ा ऊपर शिफ्ट करें
          ),
          onMenuStateChange: (isOpen) {
            if (isOpen) {
              print("Dropdown is open");
              // FocusManager.instance.primaryFocus?.unfocus();
            } else {
              print("Dropdown is closed");
            }
          },
        ),
      ),
    );
  }
}
