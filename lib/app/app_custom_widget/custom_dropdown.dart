// ignore_for_file: deprecated_member_use

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/app_font_name.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdown extends StatelessWidget {
  final String text;
  final String? labelText;
  final TextEditingController controller;
  final Function(Map<String, String>?) onChanged;
  final List<DropdownMenuItem<Map<String, String>>> items;
  final double width;
  final InputDecoration? decoration;
  final Function(bool)? onMenuStateChange;
  final ButtonStyleData? buttonStyleData;
  final DropdownSearchData<Map<String, String>>? dropdownSearchData;
  final TextStyle? textStyle;
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
    this.enabled = true,
    this.textStyle, // ✅ default true
    this.labelText,
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
            style: textStyle ??
                TextStyle(
                  fontSize: getDynamicHeight(size: 0.016),
                  color: enabled ? AppColor.black : AppColor.black.withOpacity(0.4),
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
          menuItemStyleData: MenuItemStyleData(
            height: getDynamicHeight(size: 0.038),
          ),
          dropdownSearchData: dropdownSearchData,
          dropdownStyleData: DropdownStyleData(
            useSafeArea: false,
            useRootNavigator: true,
            maxHeight: screenHeight * 0.4,
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.black),
              borderRadius: BorderRadius.circular(0),
              color: AppColor.white,
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

//multiple select checkbox and select all in dropdown
// class CustomDropdown extends StatelessWidget {
//   final String text;
//   final TextEditingController controller;
//   final Function(Map<String, String>?) onChanged;
//   final List<DropdownMenuItem<Map<String, String>>> items;
//   final double width;
//   final InputDecoration? decoration;
//   final Function(bool)? onMenuStateChange;
//   final ButtonStyleData? buttonStyleData;
//   final DropdownSearchData<Map<String, String>>? dropdownSearchData;
//   final TextStyle? textStyle;
//   final bool enabled;
//   final bool showCheckboxes;

//   CustomDropdown({
//     super.key,
//     required this.text,
//     required this.controller,
//     required this.onChanged,
//     required this.items,
//     this.width = double.infinity,
//     this.decoration,
//     this.onMenuStateChange,
//     this.buttonStyleData,
//     this.dropdownSearchData,
//     this.enabled = true,
//     this.textStyle,
//     this.showCheckboxes = false,
//   });

//   final ValueNotifier<List<String>> selectedValuesNotifier = ValueNotifier([]);

//   bool isAllSelected(List<String> selectedValues) {
//     final allItems = items.map((item) => item.value?['text']).whereType<String>().toSet();
//     return selectedValues.toSet().containsAll(allItems);
//   }

//   void toggleSelectAll(bool? value, ValueNotifier<List<String>> notifier) {
//     if (value == true) {
//       notifier.value = items.map((item) => item.value?['text'] ?? '').toList();
//     } else {
//       notifier.value = [];
//     }
//     controller.text = notifier.value.join(', ');
//     onChanged({'text': 'Select All'});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;

//     // Initial setup
//     selectedValuesNotifier.value = controller.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

//     return SizedBox(
//       width: width,
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton2<Map<String, String>>(
//           isExpanded: true,
//           hint: Text(
//             text,
//             style: textStyle ??
//                 TextStyle(
//                   fontSize: 14,
//                   color: enabled ? Colors.black : Colors.black.withOpacity(0.4),
//                 ),
//           ),
//           items: enabled
//               ? showCheckboxes
//                   ? [
//                       DropdownMenuItem<Map<String, String>>(
//                         value: {'text': 'Select All'},
//                         enabled: false,
//                         child: ValueListenableBuilder<List<String>>(
//                           valueListenable: selectedValuesNotifier,
//                           builder: (context, selectedValues, _) {
//                             return CheckboxListTile(
//                               value: isAllSelected(selectedValues),
//                               title: const Text('Select All'),
//                               controlAffinity: ListTileControlAffinity.leading,
//                               onChanged: (bool? value) {
//                                 toggleSelectAll(value, selectedValuesNotifier);
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                       ...items.map((item) {
//                         final itemText = item.value?['text'] ?? '';
//                         return DropdownMenuItem<Map<String, String>>(
//                           value: item.value,
//                           enabled: false,
//                           child: ValueListenableBuilder<List<String>>(
//                             valueListenable: selectedValuesNotifier,
//                             builder: (context, selectedValues, _) {
//                               final isChecked = selectedValues.contains(itemText);
//                               return CheckboxListTile(
//                                 value: isChecked,
//                                 title: Text(itemText),
//                                 controlAffinity: ListTileControlAffinity.leading,
//                                 onChanged: (bool? value) {
//                                   final updatedList = [...selectedValues];
//                                   if (value == true) {
//                                     updatedList.add(itemText);
//                                   } else {
//                                     updatedList.remove(itemText);
//                                   }
//                                   selectedValuesNotifier.value = updatedList;
//                                   controller.text = updatedList.join(', ');
//                                   onChanged(item.value);
//                                 },
//                               );
//                             },
//                           ),
//                         );
//                       }).toList(),
//                     ]
//                   : items
//               : [],
//           value: showCheckboxes
//               ? null
//               : items
//                   .firstWhere(
//                     (item) => item.value?['text'] == controller.text,
//                     orElse: () => DropdownMenuItem(value: null, child: const SizedBox()),
//                   )
//                   .value,
//           onChanged: enabled
//               ? (value) {
//                   if (!showCheckboxes && value != null) {
//                     controller.text = value['text'] ?? '';
//                     onChanged(value);
//                   }
//                 }
//               : null,
//           buttonStyleData: buttonStyleData,
//           menuItemStyleData: const MenuItemStyleData(height: 40),
//           dropdownSearchData: dropdownSearchData,
//           dropdownStyleData: DropdownStyleData(
//             maxHeight: screenHeight * 0.4,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.black),
//               borderRadius: BorderRadius.circular(4),
//               color: Colors.white,
//             ),
//             scrollbarTheme: ScrollbarThemeData(
//               radius: const Radius.circular(8),
//               thickness: WidgetStateProperty.all(6),
//               thumbVisibility: WidgetStateProperty.all(true),
//               thumbColor: WidgetStateProperty.all(Colors.black.withOpacity(0.5)),
//             ),
//             offset: const Offset(0, -4),
//           ),
//           onMenuStateChange: onMenuStateChange,
//         ),
//       ),
//     );
//   }
// }


//screen me custom add karne ka code
// CustomDropdown(
//   text: 'Select Fruits',
//   controller: dropdownController,
//   onChanged: (value) {
//     print('Selected values: ${dropdownController.text}');
//   },
//   items: ['Apple', 'Banana', 'Orange', 'Mango'].map((e) {
//     return DropdownMenuItem<Map<String, String>>(
//       value: {'text': e},
//       child: Text(e),
//     );
//   }).toList(),
//   showCheckboxes: true,
// )