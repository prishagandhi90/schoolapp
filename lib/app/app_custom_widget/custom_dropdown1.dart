import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomDropdown1 extends StatefulWidget {
  CustomDropdown1({super.key, required this.text, this.items, required this.width});
  final double width;
  final String text;
  List<DropdownMenuItem<String>>? items;

  @override
  State<CustomDropdown1> createState() => _CustomDropdown1State();
}

class _CustomDropdown1State extends State<CustomDropdown1> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
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
        // items
        //     .map((String item) => DropdownMenuItem<String>(
        //           value: item,
        //           child: Text(
        //             item,
        //             style: const TextStyle(
        //               fontSize: 14,
        //               fontWeight: FontWeight.bold,
        //               color: Colors.black,
        //             ),
        //             overflow: TextOverflow.ellipsis,
        //           ),
        //         ))
        //     .toList(),
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
        },
        buttonStyleData: ButtonStyleData(
          height: 50,
          width: widget.width,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            border: Border.all(color: AppColor.black),
            // color: Colors.white,
          ),
        ),
        iconStyleData:  IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down,
          ),
          iconSize: 14,
          iconEnabledColor: AppColor.black,
          iconDisabledColor: AppColor.black,
        ),
      ),
    );
  }
}
