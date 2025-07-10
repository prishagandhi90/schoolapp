import 'package:schoolapp/app/app_custom_widget/dropdown_G_model.dart';
import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get/get.dart';

class CustomDropDownSearch extends StatelessWidget {
  final String? text;
  final String hinttext;
  final Dropdown_G? selectedValue;
  final Function? onChange;
  final List<DropdownMenuItem<Dropdown_G>>? items;
  final TextEditingController? searchcontroller;
  final FocusNode? searchFocusNode;
  final bool? SearchYN;

  const CustomDropDownSearch({
    super.key,
    this.text,
    required this.hinttext,
    this.selectedValue,
    this.onChange,
    this.items,
    this.searchcontroller,
    this.searchFocusNode,
    required this.SearchYN,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<Dropdown_G>(
          isExpanded: true,
          hint: Text(
            hinttext,
            style: TextStyle(
              // fontSize: 14,
              fontSize: getDynamicHeight(size: 0.016),
              color: Theme.of(context).hintColor,
            ),
          ),
          value: items
              ?.firstWhereOrNull(
                (item) => item.value?.name == selectedValue?.name,
              )
              ?.value,
          items: items,
          onChanged: (Dropdown_G? value) {
            onChange!(value);
          },
          buttonStyleData: ButtonStyleData(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.black),
              borderRadius: BorderRadius.circular(0),
              color: AppColor.white,
            ),
          ),
          dropdownStyleData: const DropdownStyleData(
            maxHeight: 200,
          ),
          menuItemStyleData: const MenuItemStyleData(height: 40),
          dropdownSearchData: SearchYN == true
              ? DropdownSearchData(
                  searchController: searchcontroller,
                  searchInnerWidgetHeight: 130,
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
                        hintText: 'Search....',
                        hintStyle: TextStyle(
                          // fontSize: 12,
                          fontSize: getDynamicHeight(size: 0.014),
                        ),
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
          onMenuStateChange: (isOpen) {
            if (isOpen) {
              SearchYN == true
                  ? Future.delayed(const Duration(milliseconds: 100), () {
                      searchFocusNode!.requestFocus();
                    })
                  : null;
            }
          },
        ),
      ),
    );
  }
}
