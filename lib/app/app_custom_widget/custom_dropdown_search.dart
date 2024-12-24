import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emp_app/app/app_custom_widget/dropdown_G_model.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdownSearch extends StatelessWidget {
  final String text; // Label for the dropdown
  // final TextEditingController controller; // To manage the selected value
  final Function(Dropdown_G?) onChanged; // Custom onChanged callback for Map<String, String>
  final List<DropdownMenuItem<Dropdown_G>> items; // List of items with Map<String, String>
  final double width; // To set width dynamically
  final InputDecoration? decoration; // Custom decoration if needed
  final Function(bool)? onMenuStateChange; // Menu state change callback
  final ButtonStyleData? buttonStyleData;
  final DropdownSearchData<Map<String, String>>? dropdownSearchData;
  final Dropdown_G? selectedValue;

  final TextEditingController? searchcontroller;
  final FocusNode? searchFocusNode;
  final bool? SearchYN;

  CustomDropdownSearch({
    required this.text,
    // required this.controller,
    required this.onChanged,
    this.selectedValue,
    required this.items,
    this.width = double.infinity,
    this.decoration,
    this.onMenuStateChange,
    this.buttonStyleData,
    this.dropdownSearchData,
    this.searchcontroller,
    this.searchFocusNode,
    this.SearchYN,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<Dropdown_G>(
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
          // value: items
          //     .firstWhereOrNull(
          //       (item) => item.value?.name == controller.text,
          //     )
          //     ?.value, // Get selected value from the controller
          value: selectedValue,
          onChanged: (Dropdown_G? value) {
            onChanged(value);
          },

          buttonStyleData: buttonStyleData,
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
          dropdownSearchData: SearchYN == true
              ? DropdownSearchData(
                  searchController: searchcontroller,
                  searchInnerWidgetHeight: 100,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8),
                    child: TextFormField(
                      controller: searchcontroller,
                      focusNode: searchFocusNode,
                      maxLines: 200,
                      minLines: 1,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        hintText: 'Search for an item...',
                        hintStyle: const TextStyle(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return item.value!.name!.toLowerCase().contains(searchValue.toLowerCase());
                  },
                )
              : null,
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
              SearchYN == true
                  ? Future.delayed(const Duration(milliseconds: 100), () {
                      searchFocusNode!.requestFocus();
                    })
                  : null;
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
