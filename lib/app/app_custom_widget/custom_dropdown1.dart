import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomDropdown1 extends StatefulWidget {
  CustomDropdown1({
    super.key,
    required this.text,
    this.items,
    required this.width,
    this.controller,
    // this.textController,
    this.onChanged,
  });

  final double width;
  final String text;
  Function(Map<String, String>?)? onChanged;
  // List<DropdownMenuItem<String>>? items;
  List<DropdownMenuItem<Map<String, String>>>? items; // Use Map for both value and text
  final TextEditingController? controller; // Declare controller
  // final TextEditingController? textController; // For storing text

  @override
  State<CustomDropdown1> createState() => _CustomDropdown1State();
}

class _CustomDropdown1State extends State<CustomDropdown1> {
  // String? selectedValue;
  Map<String, String>? selectedItem;
  final LeaveController leaveController = Get.put(LeaveController());

  @override
  void initState() {
    super.initState();
    // widget.controller!.text = selectedValue ?? '';
    if (widget.controller != null) {
      widget.controller!.text = selectedItem?['value'] ?? ''; // Set initial value
    }
    // if (widget.textController != null) {
    //   widget.textController!.text = selectedItem?['text'] ?? ''; // Set initial text
    // }
  }

  @override
  Widget build(BuildContext context) {
    // if (selectedValue != null && !widget.items!.any((item) => item.value == selectedValue)) {
    //   selectedValue = null;
    // }
    return SingleChildScrollView(
      controller: leaveController.leaveScrollController,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<Map<String, String>>(
          isExpanded: true,
          hint: Row(
            children: [
              Expanded(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColor.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: widget.items,
          // value: selectedValue,
          // value: selectedItem,
          value: widget.items?.any((item) => item.value == selectedItem) == true ? selectedItem : null,
          onChanged: (value) {
            setState(() {
              selectedItem = value; // Update selectedItem

              if (widget.controller != null) {
                widget.controller!.text = value?['value'] ?? ''; // Update value controller
              }
              // if (widget.textController != null) {
              //   widget.textController!.text = value?['text'] ?? ''; // Update text controller
              // }

              if (widget.onChanged != null) {
                widget.onChanged!(value); // Call the custom onChanged callback
              }
            });
          },
          buttonStyleData: ButtonStyleData(
            height: 50,
            width: widget.width,
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              border: Border.all(color: AppColor.black),
            ),
          ),
          iconStyleData: IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down,
            ),
            iconSize: 14,
            iconEnabledColor: AppColor.black,
            iconDisabledColor: AppColor.black,
          ),
        ),
      ),
    );
  }
}
