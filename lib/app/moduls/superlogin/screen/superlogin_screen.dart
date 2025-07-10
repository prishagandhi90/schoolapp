import 'package:schoolapp/app/core/util/app_image.dart';
import 'package:schoolapp/app/moduls/superlogin/model/common_dropdown_model.dart';
import 'package:schoolapp/app/moduls/superlogin/screen/custom_dropdown_search.dart';
import 'package:schoolapp/app/app_custom_widget/dropdown_G_model.dart';
import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/app_font_name.dart';
import 'package:schoolapp/app/core/util/app_string.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:schoolapp/app/moduls/login/controller/login_controller.dart';
import 'package:schoolapp/app/moduls/superlogin/controller/superlogin_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SuperloginScreen extends GetView<LoginController> {
  final String mobileNo;
  const SuperloginScreen({super.key, required this.mobileNo});

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Center(
                          child: Image.asset(
                            AppImage.venuslogo,
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
                          controller: controller.numbercontroller..text = mobileNo,
                          keyboardType: TextInputType.number,
                          enabled: false,
                          readOnly: true,
                          style: TextStyle(color: AppColor.black),
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
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.black),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColor.black, // Border color for disabled state
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: Sizes.px20),
                        CustomDropDownSearch(
                          hinttext: AppString.selectUsername,
                          selectedValue: controller.selectedUserName,
                          items: controller.filteredItems
                              .map((DropdownTable item) => DropdownMenuItem<Dropdown_G>(
                                  value: Dropdown_G(
                                    id: item.id ?? '',
                                    name: item.name ?? '',
                                  ),
                                  child: Text(item.name.toString())))
                              .toList(),
                          onChange: (Dropdown_G? value) {
                            controller.userNameOnClk(value);
                          },
                          searchcontroller: controller.searchFieldController,
                          searchFocusNode: controller.searchFocusNode,
                          SearchYN: true,
                        ),

                        SizedBox(height: Sizes.px40),
                        SizedBox(
                          height: Sizes.w * 0.13,
                          width: Sizes.w * 0.60,
                          child: ElevatedButton(
                            onPressed: () async {
                              await controller.fetchSperLoginCred();
                              // loginController.isLoadingLogin ? null : await loginController.requestLogin(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.lightgreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              AppString.loginAs,
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
        );
      },
    );
  }
}
