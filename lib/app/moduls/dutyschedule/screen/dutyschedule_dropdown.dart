import 'package:emp_app/app/core/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class DutyscheduleDropdown extends StatefulWidget {
  const DutyscheduleDropdown({Key? key}) : super(key: key);

  @override
  DutyscheduleDropdownState createState() => DutyscheduleDropdownState();
}

class DutyscheduleDropdownState extends State<DutyscheduleDropdown> {
  String? selectedValue;
  List<String> dropdownItems = ['Option 1', 'Option 2', 'Option 3'];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        hint: Text('Select'),
        value: selectedValue,
        items: dropdownItems.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            selectedValue = value;
          });
        },
        buttonStyleData: ButtonStyleData( // Button style data
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          width: 200, // Dynamic width set kiya
          decoration: BoxDecoration(
            color: Color.fromARGB(199, 255, 255, 255),
            border: Border.all(color: Colors.grey), // Border add kiya
            borderRadius: BorderRadius.circular(8), // Border radius add kiya
          ),
        ),
      ),
    );
  }
}
