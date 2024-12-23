import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emp_app/app/app_custom_widget/common_dropdown_model.dart';
import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/login/controller/login_controller.dart';
import 'package:emp_app/app/moduls/superlogin/controller/superlogin_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SuperloginScreen extends GetView<LoginController> {
  const SuperloginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Sizes.init(context);

    Get.put(SuperloginController());
    return GetBuilder<SuperloginController>(
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColor.backgroundcolor,
          body: SafeArea(
            maintainBottomViewPadding: true,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Sizes.px40, // Adjusted using Sizes
                  horizontal: Sizes.px15,
                ),
                child: Form(
                  // key: controller.superloginFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/Venus_Hospital_New_Logo-removebg-preview.png',
                              width: Sizes.w * 0.8, // Dynamic width
                            ),
                          ),
                          SizedBox(height: Sizes.h * 0.04), // Dynamic height
                          Align(
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              AppString.superlogin,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Sizes.px22, // Dynamic font size
                                fontFamily: CommonFontStyle.plusJakartaSans,
                              ),
                            ),
                          ),
                          SizedBox(height: Sizes.h * 0.01), // Dynamic height
                          Align(
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              AppString.pleaselogin,
                              style: TextStyle(
                                fontSize: Sizes.px20, // Dynamic font size
                                fontFamily: CommonFontStyle.plusJakartaSans,
                              ),
                            ),
                          ),
                          SizedBox(height: Sizes.px40), // Dynamic height
                          TextFormField(
                            // controller: loginController.numberController,
                            keyboardType: TextInputType.number,
                            enabled: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppString.plzentermobileno;
                              }
                              if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                return AppString.entervalidmobileno;
                              }
                              return null;
                            },
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            decoration: InputDecoration(
                              hintText: AppString.entermobileno,
                              hintStyle: TextStyle(
                                fontFamily: CommonFontStyle.plusJakartaSans,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColor.primaryColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColor.primaryColor),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColor.primaryColor),
                              ),
                            ),
                          ),
                          SizedBox(height: Sizes.px20),
                          // DropdownButtonHideUnderline(
                          //   child: DropdownButton2<Map<String, String>>(
                          //     key: UniqueKey(),
                          //     isExpanded: true,
                          //     hint: Text(
                          //       'Enter Name',
                          //       style: TextStyle(
                          //         fontSize: 14,
                          //         color: AppColor.black,
                          //       ),
                          //     ),
                          //     items: controller.userTable
                          //         .map((DropdownTable item) => DropdownMenuItem<Map<String, String>>(
                          //               value: {
                          //                 'value': item.id ?? '',
                          //                 'text': item.name ?? '',
                          //               },
                          //               child: Text(
                          //                 item.name ?? '',
                          //                 style: AppStyle.black.copyWith(fontSize: 14),
                          //                 overflow: TextOverflow.ellipsis,
                          //               ),
                          //             ))
                          //         .toList(),
                          //     value: controller.userTable
                          //         .map((DropdownTable item) => DropdownMenuItem<Map<String, String>>(
                          //               value: {
                          //                 'value': item.id ?? '',
                          //                 'text': item.name ?? '',
                          //               },
                          //               child: Text(
                          //                 item.name ?? '',
                          //                 style: AppStyle.black.copyWith(fontSize: 14),
                          //                 overflow: TextOverflow.ellipsis,
                          //               ),
                          //             ))
                          //         .toList()
                          //         .firstWhereOrNull(
                          //           (item) => item.value?['text'] == controller.userName_nm_controller.text,
                          //         )
                          //         ?.value, // Get selected value from the controller
                          //     onChanged: (value) async {
                          //       // FocusManager.instance.primaryFocus?.unfocus();
                          //       if (value != null) {
                          //         controller.userName_nm_controller.text = value['text'] ?? ''; // Update the controller with selected value
                          //         // onChanged(value); // Call the custom onChanged method
                          //         await controller.UserNameChangeMethod(value);
                          //         print("Selected value: ${value['text']}"); // Debugging line to check selected value
                          //       }
                          //     },
                          //     buttonStyleData: ButtonStyleData(
                          //       height: 50,
                          //       padding: const EdgeInsets.symmetric(horizontal: 0),
                          //       decoration: BoxDecoration(
                          //         border: Border.all(color: AppColor.black),
                          //         borderRadius: BorderRadius.circular(0),
                          //         color: AppColor.white,
                          //       ),
                          //     ),
                          //     menuItemStyleData: const MenuItemStyleData(
                          //       height: 40,
                          //     ),

                          //     dropdownStyleData: DropdownStyleData(
                          //       useSafeArea: false, // यह dropdown को safe area से बाहर जाने की अनुमति देगा
                          //       useRootNavigator: true,
                          //       maxHeight: MediaQuery.of(context).size.height * 0.4, // स्क्रीन की ऊंचाई का 40% तक सीमित करें
                          //       decoration: BoxDecoration(
                          //         border: Border.all(color: Colors.black),
                          //         borderRadius: BorderRadius.circular(0),
                          //         color: Colors.white,
                          //       ),
                          //       scrollbarTheme: ScrollbarThemeData(
                          //         radius: const Radius.circular(8),
                          //         thickness: WidgetStateProperty.all(6),
                          //         thumbVisibility: WidgetStateProperty.all(true),
                          //         thumbColor: WidgetStateProperty.all(AppColor.black.withOpacity(0.5)),
                          //       ),
                          //       offset: const Offset(0, -4), // ड्रॉपडाउन को थोड़ा ऊपर शिफ्ट करें
                          //     ),
                          //     onMenuStateChange: (isOpen) {
                          //       if (isOpen) {
                          //       } else {}
                          //     },
                          //   ),
                          // ),
                          CustomDropdown(
                            text: 'Enter Name',
                            controller: controller.userName_nm_controller,
                            onChanged: (value) async {
                              await controller.UserNameChangeMethod(value);
                            },
                            items: controller.filteredItems
                                .map((DropdownTable item) => DropdownMenuItem<Map<String, String>>(
                                      value: {
                                        'value': item.id ?? '',
                                        'text': item.name ?? '',
                                      },
                                      child: Text(
                                        item.name ?? '',
                                        style: AppStyle.black.copyWith(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                .toList(),
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColor.black),
                                borderRadius: BorderRadius.circular(0),
                                color: AppColor.white,
                              ),
                            ),
                            dropdownSearchData: DropdownSearchData(
                              searchController: controller.userName_nm_controller,
                              searchInnerWidgetHeight: 50,
                              searchInnerWidget: Container(
                                height: 50,
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 4,
                                  right: 8,
                                  left: 8,
                                ),
                                child: TextFormField(
                                  expands: true,
                                  maxLines: null,
                                  controller: controller.searchFieldController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    hintText: 'Search for an item...',
                                    hintStyle: const TextStyle(fontSize: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onChanged: (searchValue) {
                                    // Call the search logic or update UI dynamically
                                    controller.updateSearchResults(searchValue);
                                  },
                                ),
                              ),
                              searchMatchFn: (item, searchValue) {
                                // return item.value.toString().contains(searchValue);
                                return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
                              },
                            ),
                          ),
                          // ),
                          SizedBox(height: Sizes.px40),
                          SizedBox(
                            height: Sizes.w * 0.13,
                            width: Sizes.w * 0.40,
                            child: ElevatedButton(
                              onPressed: () async {
                                // loginController.isLoadingLogin ? null : await loginController.requestLogin(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.lightgreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                AppString.login,
                                style: TextStyle(
                                  color: AppColor.black,
                                  fontSize: Sizes.px20, // Dynamic font size
                                  fontWeight: FontWeight.w700,
                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
