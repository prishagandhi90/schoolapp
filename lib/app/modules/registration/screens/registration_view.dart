import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/app/app_custom_widget/custom_date_picker.dart';
import 'package:schoolapp/app/app_custom_widget/custom_dropdown.dart';
import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/app_font_name.dart';
import 'package:schoolapp/app/core/util/app_string.dart';
import 'package:schoolapp/app/core/util/app_style.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/leave/screen/widget/custom_textformfield.dart';
import 'package:schoolapp/app/modules/registration/controller/registration_controller.dart';
import 'package:intl/intl.dart';

class RegistrationScreen extends GetView<RegistrationController> {
  RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(RegistrationController());
    return GetBuilder<RegistrationController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(title: Text("Student Registration")),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getDynamicHeight(size: 0.007),
                vertical: getDynamicHeight(size: 0.018),
              ),
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: controller.firstNameController,
                    hint: AppString.firstName,
                    hintStyle: AppStyle.black.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: getDynamicHeight(size: 0.016),
                    ),
                    keyboardType: TextInputType.multiline,
                    scrollPhysics: BouncingScrollPhysics(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.black,
                        width: getDynamicHeight(size: 0.0008),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.black,
                        width: getDynamicHeight(size: 0.0008),
                      ),
                    ),
                    onChanged: (value) {
                      controller.update();
                    },
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onFieldSubmitted: (value) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppString.notesisrequired;
                      }
                      return null;
                    },
                  ),
                  CustomTextFormField(
                    controller: controller.fatherNameController,
                    hint: AppString.fatherName,
                    hintStyle: AppStyle.black.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: getDynamicHeight(size: 0.016),
                    ),
                    keyboardType: TextInputType.multiline,
                    scrollPhysics: BouncingScrollPhysics(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.black,
                        width: getDynamicHeight(size: 0.0008),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.black,
                        width: getDynamicHeight(size: 0.0008),
                      ),
                    ),
                    onChanged: (value) {
                      controller.update();
                    },
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onFieldSubmitted: (value) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppString.notesisrequired;
                      }
                      return null;
                    },
                  ),
                  CustomTextFormField(
                    controller: controller.surnameController,
                    hint: AppString.surname,
                    hintStyle: AppStyle.black.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: getDynamicHeight(size: 0.016),
                    ),
                    keyboardType: TextInputType.multiline,
                    scrollPhysics: BouncingScrollPhysics(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.black,
                        width: getDynamicHeight(size: 0.0008),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.black,
                        width: getDynamicHeight(size: 0.0008),
                      ),
                    ),
                    onChanged: (value) {
                      controller.update();
                    },
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onFieldSubmitted: (value) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppString.notesisrequired;
                      }
                      return null;
                    },
                  ),
                  CustomDatePicker(
                    dateController: controller.dobController,
                    hintText: AppString.from,
                    onDateSelected: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        controller.selectedDOB = picked;
                        controller.dobController.text = DateFormat('yyyy-MM-dd').format(picked);
                        controller.update();
                      }
                    },
                  ),
                  CustomDropdown(
                    text: AppString.investigationType,
                    textStyle: TextStyle(
                        color: AppColor.black.withOpacity(0.4), fontFamily: CommonFontStyle.plusJakartaSans, fontSize: getDynamicHeight(size: 0.015)),
                    buttonStyleData: ButtonStyleData(
                      height: getDynamicHeight(size: 0.0475),
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.black),
                        borderRadius: BorderRadius.circular(0),
                        color: AppColor.white,
                      ),
                    ),
                    controller: controller.selectedGender,
                    items: [
                      {'value': '', 'text': '--select--'}, // Empty value so that it doesn't save
                      {'value': 'Male', 'text': 'Male'},
                      {'value': 'Female', 'text': 'Female'},
                      {'value': 'Other', 'text': 'Other'},
                    ].map((Map<String, String> item) {
                      return DropdownMenuItem<Map<String, String>>(
                        value: item,
                        child: Text(
                          item['text'] ?? '',
                          style: AppStyle.black,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      controller.selectedGender.text = val!['text'].toString();
                      controller.update();
                    },
                  ),
                  CustomTextFormField(
                    controller: controller.addressController,
                    hint: AppString.address,
                    hintStyle: AppStyle.black.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: getDynamicHeight(size: 0.016),
                    ),
                    minLines: 3,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    scrollPhysics: BouncingScrollPhysics(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.black,
                        width: getDynamicHeight(size: 0.0008),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.black,
                        width: getDynamicHeight(size: 0.0008),
                      ),
                    ),
                    onChanged: (value) {
                      controller.update();
                    },
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onFieldSubmitted: (value) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppString.notesisrequired;
                      }
                      return null;
                    },
                  ),
                  CustomTextFormField(
                    controller: controller.pincodeController,
                    hint: AppString.pincode,
                    hintStyle: AppStyle.black.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: getDynamicHeight(size: 0.016),
                    ),
                    keyboardType: TextInputType.number,
                    scrollPhysics: BouncingScrollPhysics(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.black,
                        width: getDynamicHeight(size: 0.0008),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.black,
                        width: getDynamicHeight(size: 0.0008),
                      ),
                    ),
                    onChanged: (value) {
                      controller.update();
                    },
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onFieldSubmitted: (value) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppString.notesisrequired;
                      }
                      return null;
                    },
                  ),
                  CustomTextFormField(
                    controller: controller.cityController,
                    hint: AppString.city,
                    hintStyle: AppStyle.black.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: getDynamicHeight(size: 0.016),
                    ),
                    keyboardType: TextInputType.multiline,
                    scrollPhysics: BouncingScrollPhysics(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.black,
                        width: getDynamicHeight(size: 0.0008),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.black,
                        width: getDynamicHeight(size: 0.0008),
                      ),
                    ),
                    onChanged: (value) {
                      controller.update();
                    },
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onFieldSubmitted: (value) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppString.notesisrequired;
                      }
                      return null;
                    },
                  ),
                  CustomTextFormField(
                    controller: controller.mobile1Controller,
                    hint: AppString.mobile1,
                    hintStyle: AppStyle.black.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: getDynamicHeight(size: 0.016),
                    ),
                    keyboardType: TextInputType.phone,
                    scrollPhysics: BouncingScrollPhysics(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.black,
                        width: getDynamicHeight(size: 0.0008),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.black,
                        width: getDynamicHeight(size: 0.0008),
                      ),
                    ),
                    onChanged: (value) {
                      controller.update();
                    },
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onFieldSubmitted: (value) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppString.notesisrequired;
                      }
                      return null;
                    },
                  ),
                  CustomTextFormField(
                    controller: controller.mobile2Controller,
                    hint: AppString.mobile2,
                    hintStyle: AppStyle.black.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: getDynamicHeight(size: 0.016),
                    ),
                    keyboardType: TextInputType.number,
                    scrollPhysics: BouncingScrollPhysics(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.black,
                        width: getDynamicHeight(size: 0.0008),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.black,
                        width: getDynamicHeight(size: 0.0008),
                      ),
                    ),
                    onChanged: (value) {
                      controller.update();
                    },
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onFieldSubmitted: (value) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppString.notesisrequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await controller.saveRegistrationEntry(context);
                    },
                    child: Text(
                      AppString.save,
                      style: TextStyle(
                        color: AppColor.black,
                        fontSize: getDynamicHeight(size: 0.017),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
