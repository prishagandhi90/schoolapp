// import 'package:emp_app/model/monthyear_model.dart';
// import 'package:flutter/material.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';

// // ignore: must_be_immutable
// class CustomDropDown extends StatelessWidget {
//   final List<DropdownMenuItem<MonthYear>>? items;
//   final MonthYear? selectedValue;
//   final Function? onChange;
//   const CustomDropDown({super.key, this.items, this.selectedValue, this.onChange});

//   // String? selectedValue;

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonHideUnderline(
//       child: DropdownButton2<MonthYear>(
//         isExpanded: true,
//         hint: Text(
//           'Select Mnth Yr',
//           style: TextStyle(
//             fontSize: 14,
//             color: Theme.of(context).hintColor,
//           ),
//         ),
//         items: items,
//         // items
//         //     .map((String item) => DropdownMenuItem<String>(
//         //           value: item,
//         //           child: Text(
//         //             item,
//         //             style: const TextStyle(
//         //               fontSize: 14,
//         //             ),
//         //           ),
//         //         ))
//         //     .toList(),
//         value: selectedValue,
//         onChanged: (MonthYear? value) {
//           onChange!(value);
//         },
//         buttonStyleData: ButtonStyleData(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           height: 40,
//           width: MediaQuery.of(context).size.width * 0.5,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(
//               color: Colors.black26,
//             ),
//           ),
//           // elevation: 2,
//         ),
//         menuItemStyleData: const MenuItemStyleData(height: 40),
//       ),
//     );
//   }
// }

import 'package:emp_app/model/dropdown_G_model.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CustomDropDown extends StatelessWidget {
  final Dropdown_Glbl? selectedValue;
  final Function? onChange;
  final List<DropdownMenuItem<Dropdown_Glbl>>? items;

  const CustomDropDown({
    super.key,
    this.selectedValue,
    this.onChange,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton2<Dropdown_Glbl>(
              isExpanded: true,
              hint: Text(
                'Select',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              value: selectedValue,
              items: items,
              onChanged: (Dropdown_Glbl? value) {
                onChange!(value);
              },
              buttonStyleData: ButtonStyleData(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 40,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black26,
                  ),
                ),
                // elevation: 2,
              ),
              menuItemStyleData: const MenuItemStyleData(height: 40),
            ),
          ),
        ],
      ),
    );
  }
}
