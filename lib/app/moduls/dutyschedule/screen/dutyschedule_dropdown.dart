import 'package:flutter/material.dart';

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
    return DropdownButton<String>(
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
    );
  }
}
