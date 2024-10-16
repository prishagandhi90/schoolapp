import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdown extends StatelessWidget {
  final String text; // Label for the dropdown
  final TextEditingController controller; // To manage the selected value
  final Function(Map<String, String>?) onChanged; // Custom onChanged callback for Map<String, String>
  final List<DropdownMenuItem<Map<String, String>>> items; // List of items with Map<String, String>
  final double width; // To set width dynamically
  final InputDecoration? decoration; // Custom decoration if needed

  CustomDropdown({
    required this.text,
    required this.controller,
    required this.onChanged,
    required this.items,
    this.width = double.infinity,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: DropdownButtonFormField<Map<String, String>>(
        decoration: decoration ??
            InputDecoration(
              labelText: text,
              border: OutlineInputBorder(),
            ),
        value: items.firstWhereOrNull((item) => item.value!['text'] == controller.text)?.value,
        items: items,
        onChanged: (value) {
          if (value != null) {
            controller.text = value['text'] ?? ''; // Update the TextEditingController with selected text
          }
          onChanged(value); // Call the custom onChanged method passed from parent
        },
      ),
    );
  }
}
