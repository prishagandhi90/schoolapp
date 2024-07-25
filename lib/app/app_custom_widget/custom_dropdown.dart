import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/moduls/attendence/controller/attendence_controller.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get/get.dart';

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({super.key, required this.onPressed});
  final Function(String) onPressed;

  @override
  State<CustomDropDown> createState() => CustomDropDownState();
}

class CustomDropDownState extends State<CustomDropDown> {
  String? selectedValue;
  List<String> years = ['2023', '2024'];
  String selValue = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: const Text(
            'Select',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          // decoration: InputDecoration(
          //               labelText: "label Text",
          //               labelStyle: TextStyle(
          //                   color: true
          //                       ? Colors.black54
          //                       : Theme.of(context).disabledColor),
          //               contentPadding: EdgeInsets.all(16),
          //               focusedBorder: OutlineInputBorder(
          //                 borderSide:
          //                     BorderSide(color: Theme.of(context).primaryColor),
          //               ),
          //               border: new OutlineInputBorder(
          //                   borderSide: new BorderSide()),
          //             ),
          items: years
              .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 13, //16
                        fontFamily: CommonFontStyle.plusJakartaSans,
                      ),
                    ),
                  ))
              .toList(),
          // value: controller.selectedYear.value.isNotEmpty ? controller.selectedYear.value : null,
          value: selValue.isNotEmpty ? selValue : null,
          // onChanged: (String? value) {
          //   if (value != null) {
          //     controller.selectedYear.value = value;
          //     int yearIndex = controller.years.indexOf(value);
          //     controller.upd_YearSelIndex(yearIndex);
          //   }
          // },
          onChanged: (String? value) {
            widget.onPressed(value!);
            setState(() {
              selValue = value;
            });
          },
          buttonStyleData: ButtonStyleData(
            height: 50,
            width: 140,
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
        ),
      ),
    );
  }
}

// import 'package:emp_app/app/core/model/dropdown_G_model.dart';
// import 'package:flutter/material.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';

// class CustomDropDown extends StatelessWidget {
//   final Dropdown_Glbl? selectedValue;
//   final Function? onChange;
//   final List<DropdownMenuItem<Dropdown_Glbl>>? items;

//   const CustomDropDown({
//     super.key,
//     this.selectedValue,
//     this.onChange,
//     this.items,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           DropdownButtonHideUnderline(
//             child: DropdownButton2<Dropdown_Glbl>(
//               isExpanded: true,
//               hint: Text(
//                 'Select',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Theme.of(context).hintColor,
//                 ),
//               ),
//               value: selectedValue,
//               items: items,
//               onChanged: (Dropdown_Glbl? value) {
//                 onChange!(value);
//               },
//               buttonStyleData: ButtonStyleData(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 height: 40,
//                 width: MediaQuery.of(context).size.width * 0.5,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(
//                     color: Colors.black26,
//                   ),
//                 ),
//                 // elevation: 2,
//               ),
//               menuItemStyleData: const MenuItemStyleData(height: 40),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
