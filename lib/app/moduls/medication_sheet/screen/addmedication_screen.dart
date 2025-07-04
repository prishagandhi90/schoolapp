// ignore_for_file: must_be_immutable

import 'package:emp_app/app/app_custom_widget/common_dropdown_model.dart';
import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/searchservice_model.dart';
import 'package:emp_app/app/moduls/leave/screen/widget/custom_textformfield.dart';
import 'package:emp_app/app/moduls/medication_sheet/controller/medicationsheet_controller.dart';
import 'package:emp_app/app/moduls/routes/app_pages.dart';
import 'package:emp_app/my_navigator_observer.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class AddMedicationScreen extends StatelessWidget {
  int selectedMasterIndex, selectedDetailIndex;
  AddMedicationScreen({
    Key? key,
    required this.selectedMasterIndex,
    required this.selectedDetailIndex,
  }) : super(key: key);

  final ScrollController formScrollController = ScrollController();
  final ScrollController listScrollController = ScrollController();
  bool hasFormularyMedSelFromList = false;

  @override
  Widget build(BuildContext context) {
    Get.put(MedicationsheetController());
    return GetBuilder<MedicationsheetController>(
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColor.white,
          appBar: AppBar(
            title: Text(AppString.addmedication, style: AppStyle.primaryplusw700),
            centerTitle: true,
            backgroundColor: AppColor.white,
            elevation: 0,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back, color: AppColor.black),
            ),
          ),
          body: controller.isLoading
              ? Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: getDynamicHeight(size: 0.102),
                  ),
                  child: Center(child: ProgressWithIcon()),
                )
              : SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          controller: formScrollController,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.008)),
                            child: Column(
                              children: [
                                CustomTextFormField(
                                  readOnly: true,
                                  minLines: 1,
                                  maxLines: 10,
                                  decoration: InputDecoration(
                                    hintText: controller.nameController.text,
                                    hintStyle: TextStyle(
                                      fontSize: getDynamicHeight(size: 0.015),
                                      color: AppColor.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: CommonFontStyle.plusJakartaSans,
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: getDynamicHeight(size: 0.012),
                                      vertical: getDynamicHeight(size: 0.010),
                                    ),
                                    filled: true,
                                    fillColor: AppColor.white,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.black),
                                      borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.black),
                                      borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.black),
                                      borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                    ),
                                  ),
                                ),
                                SizedBox(height: getDynamicHeight(size: 0.006)),

                                /// Medication Type Dropdown
                                CustomDropdown(
                                  text: AppString.medicationtype,
                                  textStyle: TextStyle(
                                    color: AppColor.grey,
                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                  ),
                                  controller: controller.medicationTypeController,
                                  buttonStyleData: ButtonStyleData(
                                    height: getDynamicHeight(size: 0.048),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColor.black),
                                      borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                      color: AppColor.white,
                                    ),
                                  ),
                                  onChanged: (value) async {
                                    controller.update();
                                  },
                                  items: controller.medicationSheetDropdownTable
                                      .map((DropdownNamesTable item) => DropdownMenuItem<Map<String, String>>(
                                            value: {
                                              'value': item.value ?? '',
                                              'text': item.name ?? '',
                                            },
                                            child: Text(
                                              item.name ?? '',
                                              style: AppStyle.black.copyWith(
                                                // fontSize: 14,
                                                fontSize: getDynamicHeight(size: 0.016),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList(),
                                  width: double.infinity,
                                ),
                                SizedBox(height: getDynamicHeight(size: 0.006)),
                                // CustomAutoComplete<SearchserviceModel>(
                                //     controller: controller.FormularyMedicinesController,
                                //     // fromAdmittedScreen: controller.FormularyMedicinesController.text.isNotEmpty ? true : false,
                                //     fromAdmittedScreen: controller.fromAdmittedScreen,
                                //     hintText: AppString.formularymedicine,
                                //     hintStyle: AppStyle.grey,
                                //     isDense: true,
                                //     // onUpdate: () => controller.update(),
                                //     onChanged: (val) => controller.update(),
                                //     contentPadding: EdgeInsets.symmetric(
                                //       horizontal: getDynamicHeight(size: 0.012),
                                //       vertical: getDynamicHeight(size: 0.016),
                                //     ),
                                //     displayStringForOption: (SearchserviceModel option) => option.txt ?? '',
                                //     optionsBuilder: (TextEditingValue textEditingValue) async {
                                //       if (textEditingValue.text.trim().isEmpty) {
                                //         controller.FormularyMedicines_suggestions.clear();
                                //         return const Iterable<SearchserviceModel>.empty();
                                //       }
                                //       await controller.getFormularyMedicines_Autocomp(textEditingValue.text);
                                //       return controller.FormularyMedicines_suggestions;
                                //     },
                                //     onSelected: (SearchserviceModel selection) {
                                //       hasFormularyMedSelFromList = true;
                                //       controller.FormularyMedicinesIDController.text = selection.name ?? '';
                                //       controller.FormularyMedicinesController.text = selection.txt ?? '';
                                //       controller.update(); // Trigger state update if needed
                                //     },
                                //     onClearSuggestions: () {
                                //       controller.FormularyMedicines_suggestions.clear();
                                //     },
                                //     onSuffixIconPressed: () {
                                //       controller.FormularyMedicinesIDController.clear();
                                //       controller.update(); // Trigger state update if needed
                                //     },
                                //     onFocusOutside: () {
                                //       if (!hasFormularyMedSelFromList) {
                                //         controller.FormularyMedicinesController.clear();
                                //         controller.FormularyMedicinesIDController.clear();
                                //         controller.update();
                                //       }
                                //       hasFormularyMedSelFromList = false;
                                //     }),
                                Autocomplete<SearchserviceModel>(
                                  displayStringForOption: (SearchserviceModel option) => option.txt ?? '',
                                  optionsBuilder: (TextEditingValue textEditingValue) async {
                                    if (textEditingValue.text.trim().isEmpty) {
                                      controller.FormularyMedicines_suggestions.clear();
                                      return const Iterable<SearchserviceModel>.empty();
                                    }
                                    await controller.getFormularyMedicines_Autocomp(textEditingValue.text);
                                    return controller.FormularyMedicines_suggestions;
                                  },
                                  onSelected: (SearchserviceModel selection) {
                                    controller.FormularyMedicines_suggestions.clear();
                                    controller.FormularyMedicinesIDController.text = selection.name ?? '';
                                    controller.FormularyMedicinesController.text = selection.txt ?? '';
                                    controller.nonFormularyMedicinesController.clear();
                                    controller.update();
                                  },
                                  fieldViewBuilder: (context, nameController, focusNode, onEditingComplete) {
                                    final effectiveController = controller.FormularyMedicinesController.text.isNotEmpty
                                        ? controller.FormularyMedicinesController
                                        : nameController;
                                    return CustomTextFormField(
                                      controller: effectiveController,
                                      focusNode: focusNode,
                                      minLines: 1,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        hintText: 'Formulary Medicine',
                                        hintStyle: TextStyle(color: AppColor.grey, fontFamily: CommonFontStyle.plusJakartaSans),
                                        isDense: true,
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            // color: controller.nameController.text.isNotEmpty ? AppColor.black : AppColor.red,
                                            width: getDynamicHeight(size: 0.03),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          // borderSide: BorderSide(color: controller.nameController.text.isNotEmpty ? AppColor.black : AppColor.red),
                                        ),
                                        prefixIcon: Icon(Icons.search, color: AppColor.lightgrey1),
                                        suffixIcon: nameController.text.isNotEmpty || controller.nameController.text.isNotEmpty
                                            ? IconButton(
                                                icon: Icon(Icons.cancel_outlined, color: AppColor.black),
                                                onPressed: () {
                                                  focusNode.unfocus();
                                                  controller.FormularyMedicines_suggestions.clear();
                                                  controller.FormularyMedicinesController.clear();
                                                  controller.FormularyMedicinesIDController.clear();
                                                  SchedulerBinding.instance.addPostFrameCallback((_) {
                                                    controller.update();
                                                  });
                                                },
                                              )
                                            : null,
                                      ),
                                      onTapOutside: (event) {
                                        focusNode.unfocus();
                                      },
                                      onFieldSubmitted: (value) {
                                        focusNode.unfocus();
                                      },
                                    );
                                  },
                                ),
                                SizedBox(height: getDynamicHeight(size: 0.006)),
                                CustomTextFormField(
                                  controller: controller.nonFormularyMedicinesController,
                                  decoration: InputDecoration(
                                    hintText: AppString.nonformularymedicine,
                                    hintStyle: TextStyle(color: AppColor.grey, fontFamily: CommonFontStyle.plusJakartaSans),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: getDynamicHeight(size: 0.012),
                                      vertical: getDynamicHeight(size: 0.010),
                                    ),
                                    filled: true,
                                    fillColor: AppColor.white,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.black),
                                      borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.black),
                                      borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.black, width: 1.5),
                                      borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    controller.FormularyMedicinesController.clear();
                                    controller.FormularyMedicinesIDController.clear();
                                    controller.update();
                                  },
                                ),
                                SizedBox(height: getDynamicHeight(size: 0.005)),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomDropdown(
                                        text: AppString.insttyp,
                                        textStyle: TextStyle(
                                          color: AppColor.grey,
                                          fontFamily: CommonFontStyle.plusJakartaSans,
                                        ),
                                        controller: controller.instructionTypeController,
                                        buttonStyleData: ButtonStyleData(
                                          height: getDynamicHeight(size: 0.048),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: AppColor.black),
                                            borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                            color: AppColor.white,
                                          ),
                                        ),
                                        onChanged: (value) async {
                                          controller.update();
                                        },
                                        items: controller.instructionTypeDropdownTable
                                            .map((DropdownNamesTable item) => DropdownMenuItem<Map<String, String>>(
                                                  value: {
                                                    'value': item.value ?? '',
                                                    'text': item.name ?? '',
                                                  },
                                                  child: Text(
                                                    item.name ?? '',
                                                    style: AppStyle.black.copyWith(
                                                      // fontSize: 14,
                                                      fontSize: getDynamicHeight(size: 0.014),
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ))
                                            .toList(),
                                        width: double.infinity,
                                      ),
                                    ),
                                    SizedBox(width: getDynamicHeight(size: 0.006)),
                                    Expanded(
                                      child: SizedBox(
                                        height: getDynamicHeight(size: 0.048),
                                        child: CustomTextFormField(
                                          controller: controller.doseController,
                                          decoration: InputDecoration(
                                            hintText: AppString.dose,
                                            hintStyle: TextStyle(color: AppColor.grey),
                                            isDense: true,
                                            contentPadding: EdgeInsets.symmetric(
                                              horizontal: getDynamicHeight(size: 0.012),
                                              vertical: getDynamicHeight(size: 0.014),
                                            ),
                                            filled: true,
                                            fillColor: AppColor.white,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(color: AppColor.black),
                                              borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: AppColor.black),
                                              borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: AppColor.black, width: 1.5),
                                              borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            controller.update();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: getDynamicHeight(size: 0.006)),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: getDynamicHeight(size: 0.048), // 🔥 Same as dropdown
                                        child: CustomTextFormField(
                                          controller: controller.qtyController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: AppString.qty,
                                            hintStyle: TextStyle(color: AppColor.grey, fontFamily: CommonFontStyle.plusJakartaSans),
                                            isDense: true,
                                            contentPadding: EdgeInsets.symmetric(
                                              horizontal: getDynamicHeight(size: 0.012),
                                              vertical: getDynamicHeight(size: 0.014),
                                            ),
                                            filled: true,
                                            fillColor: AppColor.white,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(color: AppColor.black),
                                              borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)), // ✅ Apply radius here
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: AppColor.black),
                                              borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: AppColor.black, width: 1.5),
                                              borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            controller.update();
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: getDynamicHeight(size: 0.006)),
                                    Expanded(
                                      child: CustomDropdown(
                                        text: AppString.route,
                                        textStyle: TextStyle(color: AppColor.grey),
                                        controller: controller.routeController,
                                        buttonStyleData: ButtonStyleData(
                                          height: getDynamicHeight(size: 0.048),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: AppColor.black),
                                            borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                            color: AppColor.white,
                                          ),
                                        ),
                                        onChanged: (value) async {
                                          controller.update();
                                        },
                                        items: controller.drMedicationRouteDropdownTable
                                            .map((DropdownNamesTable item) => DropdownMenuItem<Map<String, String>>(
                                                  value: {
                                                    'value': item.value ?? '',
                                                    'text': item.name ?? '',
                                                  },
                                                  child: Text(
                                                    item.name ?? '',
                                                    style: AppStyle.black.copyWith(
                                                      // fontSize: 14,
                                                      fontSize: getDynamicHeight(size: 0.014),
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ))
                                            .toList(),
                                        width: double.infinity,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: getDynamicHeight(size: 0.006)),
                                CustomTextFormField(
                                  controller: controller.remarksController,
                                  minLines: 1,
                                  maxLines: 10,
                                  decoration: InputDecoration(
                                    hintText: AppString.remarks,
                                    hintStyle: TextStyle(color: AppColor.grey, fontFamily: CommonFontStyle.plusJakartaSans),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: getDynamicHeight(size: 0.012),
                                      vertical: getDynamicHeight(size: 0.014),
                                    ),
                                    filled: true,
                                    fillColor: AppColor.white,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.black),
                                      borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.black),
                                      borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.black, width: 1.5),
                                      borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    controller.update();
                                  },
                                ),
                                SizedBox(height: getDynamicHeight(size: 0.006)),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomDropdown(
                                        text: AppString.morning,
                                        textStyle: TextStyle(
                                            fontSize: getDynamicHeight(size: 0.013),
                                            color: AppColor.grey,
                                            fontFamily: CommonFontStyle.plusJakartaSans),
                                        controller: controller.FreqMorningController,
                                        buttonStyleData: ButtonStyleData(
                                          height: getDynamicHeight(size: 0.046),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: AppColor.black),
                                            borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.003)),
                                            color: AppColor.white,
                                          ),
                                        ),
                                        onChanged: (value) async {
                                          controller.update();
                                        },
                                        items: controller.drMedicationFreqDropdownTable
                                            .map((DropdownNamesTable item) => DropdownMenuItem<Map<String, String>>(
                                                  value: {
                                                    'value': item.value ?? '',
                                                    'text': item.name ?? '',
                                                  },
                                                  child: Text(
                                                    item.name ?? '',
                                                    style: AppStyle.black.copyWith(
                                                      // fontSize: 14,
                                                      fontSize: getDynamicHeight(size: 0.016),
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ))
                                            .toList(),
                                        width: double.infinity,
                                      ),
                                    ),
                                    SizedBox(width: getDynamicHeight(size: 0.004)), // spacing between dropdowns
                                    Expanded(
                                      child: CustomDropdown(
                                        text: AppString.afternoon,
                                        textStyle: TextStyle(fontSize: getDynamicHeight(size: 0.013), color: AppColor.grey),
                                        controller: controller.FreqAfternoonController,
                                        buttonStyleData: ButtonStyleData(
                                          height: getDynamicHeight(size: 0.046),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: AppColor.black),
                                            borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.003)),
                                            color: AppColor.white,
                                          ),
                                        ),
                                        onChanged: (value) async {
                                          controller.update();
                                        },
                                        items: controller.drMedicationFreqDropdownTable
                                            .map((DropdownNamesTable item) => DropdownMenuItem<Map<String, String>>(
                                                  value: {
                                                    'value': item.value ?? '',
                                                    'text': item.name ?? '',
                                                  },
                                                  child: Text(
                                                    item.name ?? '',
                                                    style: AppStyle.black.copyWith(
                                                      // fontSize: 14,
                                                      fontSize: getDynamicHeight(size: 0.016),
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ))
                                            .toList(),
                                        width: double.infinity,
                                      ),
                                    ),
                                    SizedBox(width: getDynamicHeight(size: 0.004)),
                                    Expanded(
                                      child: CustomDropdown(
                                        text: AppString.evening,
                                        textStyle: TextStyle(fontSize: getDynamicHeight(size: 0.013), color: AppColor.grey),
                                        controller: controller.FreqEveningController,
                                        buttonStyleData: ButtonStyleData(
                                          height: getDynamicHeight(size: 0.046),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: AppColor.black),
                                            borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.003)),
                                            color: AppColor.white,
                                          ),
                                        ),
                                        onChanged: (value) async {
                                          controller.update();
                                        },
                                        items: controller.drMedicationFreqDropdownTable
                                            .map((DropdownNamesTable item) => DropdownMenuItem<Map<String, String>>(
                                                  value: {
                                                    'value': item.value ?? '',
                                                    'text': item.name ?? '',
                                                  },
                                                  child: Text(
                                                    item.name ?? '',
                                                    style: AppStyle.black.copyWith(
                                                      // fontSize: 14,
                                                      fontSize: getDynamicHeight(size: 0.016),
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ))
                                            .toList(),
                                        width: double.infinity,
                                      ),
                                    ),
                                    SizedBox(width: getDynamicHeight(size: 0.004)),
                                    Expanded(
                                      child: CustomDropdown(
                                        text: AppString.night,
                                        textStyle: TextStyle(fontSize: getDynamicHeight(size: 0.013), color: AppColor.grey),
                                        controller: controller.FreqNightController,
                                        buttonStyleData: ButtonStyleData(
                                          height: getDynamicHeight(size: 0.046),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: AppColor.black),
                                            borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.003)),
                                            color: AppColor.white,
                                          ),
                                        ),
                                        onChanged: (value) async {
                                          controller.update();
                                        },
                                        items: controller.drMedicationFreqDropdownTable
                                            .map((DropdownNamesTable item) => DropdownMenuItem<Map<String, String>>(
                                                  value: {
                                                    'value': item.value ?? '',
                                                    'text': item.name ?? '',
                                                  },
                                                  child: Text(
                                                    item.name ?? '',
                                                    style: AppStyle.black.copyWith(
                                                      // fontSize: 14,
                                                      fontSize: getDynamicHeight(size: 0.016),
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ))
                                            .toList(),
                                        width: double.infinity,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: getDynamicHeight(size: 0.006)),
                                CustomTextFormField(
                                  controller: controller.daysController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: AppString.days,
                                    hintStyle: TextStyle(color: AppColor.grey, fontFamily: CommonFontStyle.plusJakartaSans),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: getDynamicHeight(size: 0.012),
                                      vertical: getDynamicHeight(size: 0.010),
                                    ),
                                    filled: true,
                                    fillColor: AppColor.white,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.black),
                                      borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.black),
                                      borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.black, width: 1.5),
                                      borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    controller.update();
                                  },
                                ),
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          final pickedDate = await showDatePicker(
                                            context: context,
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2100),
                                          );

                                          if (pickedDate != null) {
                                            final formattedDate =
                                                "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                                            controller.stopDateController.text = formattedDate;
                                            controller.update();
                                          }
                                          FocusScope.of(context).unfocus();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: getDynamicHeight(size: 0.012),
                                            vertical: getDynamicHeight(size: 0.011),
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: AppColor.black1),
                                            borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.003)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                controller.stopDateController.text.isNotEmpty
                                                    ? controller.stopDateController.text
                                                    : AppString.stopdate,
                                                style: TextStyle(
                                                  fontSize: getDynamicHeight(size: 0.014),
                                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                                  color: controller.stopDateController.text.isNotEmpty ? AppColor.black : AppColor.grey,
                                                ),
                                              ),
                                              Icon(Icons.calendar_today),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: getDynamicHeight(size: 0.004)),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          final time = await showTimePicker(
                                            context: context,
                                            initialTime: controller.stopTime ?? TimeOfDay.now(), // fallback agar null hai
                                          );
                                          if (time != null) {
                                            controller.stopTime = time;
                                            controller.update();
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: getDynamicHeight(size: 0.008),
                                            vertical: getDynamicHeight(size: 0.012),
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: AppColor.black1),
                                            borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.004)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                controller.stopTime != null
                                                    ? controller.stopTime!.format(context) // 🛑 ! lagaya hai, null nahi hai is point pe
                                                    : AppString.stoptime,
                                                style: TextStyle(
                                                  color: controller.stopTime != null ? AppColor.black : AppColor.grey,
                                                ),
                                              ),
                                              SizedBox(width: getDynamicHeight(size: 0.008)),
                                              Icon(Icons.timer_outlined),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: getDynamicHeight(size: 0.006)),
                                CustomTextFormField(
                                  controller: controller.flowRateController,
                                  decoration: InputDecoration(
                                    hintText: AppString.flowrate,
                                    hintStyle: TextStyle(color: AppColor.grey, fontFamily: CommonFontStyle.plusJakartaSans),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: getDynamicHeight(size: 0.012),
                                      vertical: getDynamicHeight(size: 0.014),
                                    ),
                                    filled: true,
                                    fillColor: AppColor.white,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.black),
                                      borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.black),
                                      borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.black, width: 1.5),
                                      borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    controller.update();
                                  },
                                ),
                                SizedBox(height: getDynamicHeight(size: 0.01)),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.teal,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006))),
                                  ),
                                  onPressed: controller.isSaveButtonEnabled()
                                      ? () async {
                                          await controller.saveAddMedication(selectedMasterIndex, selectedDetailIndex);
                                          selectedDetailIndex = -1;
                                        }
                                      : null,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: getDynamicHeight(size: 0.02),
                                      vertical: getDynamicHeight(size: 0.010),
                                    ),
                                    child: Text(AppString.save1,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.white,
                                          fontFamily: CommonFontStyle.plusJakartaSans,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: AppColor.black,
                        thickness: 1,
                      ),
                      // Added Medication Title
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(
                          horizontal: getDynamicHeight(size: 0.012),
                          vertical: getDynamicHeight(size: 0.008),
                        ),
                        child: Text(
                          "Added Medication (${controller.drTreatMasterList[selectedMasterIndex].detail!.length})",
                          style: TextStyle(
                            color: AppColor.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: getDynamicHeight(size: 0.018),
                            fontFamily: CommonFontStyle.plusJakartaSans,
                          ),
                        ),
                      ),
                      // Medication List
                      SizedBox(
                        height: getDynamicHeight(size: 0.045) *
                            (controller.drTreatMasterList[selectedMasterIndex].detail!.length < 5
                                ? controller.drTreatMasterList[selectedMasterIndex].detail!.length
                                : 5),
                        child: Scrollbar(
                          controller: listScrollController,
                          child: ListView.separated(
                            controller: listScrollController,
                            physics: controller.drTreatMasterList[selectedMasterIndex].detail!.length > 5
                                ? AlwaysScrollableScrollPhysics()
                                : NeverScrollableScrollPhysics(),
                            itemCount: controller.drTreatMasterList[selectedMasterIndex].detail!.length,
                            itemBuilder: (context, index) {
                              final item = controller.drTreatMasterList[selectedMasterIndex].detail![index];
                              return ListTile(
                                visualDensity: VisualDensity(vertical: -4),
                                title: Text(
                                  "${index + 1}. ${item.itemName?.txt ?? item.itemNameMnl.toString().trim()}",
                                  style: TextStyle(
                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                    fontSize: getDynamicHeight(size: 0.014),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => Divider(
                              color: Colors.grey.shade400,
                              endIndent: 8,
                              indent: 8,
                              thickness: 1,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.all(getDynamicHeight(size: 0.008)),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 167, 166, 166),
                        foregroundColor: AppColor.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: getDynamicHeight(size: 0.0135),
                          horizontal: getDynamicHeight(size: 0.0108),
                        ),
                        alignment: Alignment.center,
                      ),
                      child: Text(
                        controller.investRequisitController.webUserName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColor.white,
                          fontSize: getDynamicHeight(size: 0.013),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: getDynamicHeight(size: 0.006)),
                Expanded(
                  flex: 4,
                  child: Container(
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.isViewBtnclicked) return;
                        controller.isViewBtnclicked = true;
                        controller.filteredDetails = controller.drTreatMasterList[selectedMasterIndex].detail;
                        controller.selectedMasterIndex = selectedMasterIndex;
                        controller.searchController.clear();
                        Future.delayed(Duration(milliseconds: 200), () {
                          controller.update();
                        });

                        Future.delayed(Duration(milliseconds: 200), () {
                          final stack = MyNavigatorObserver.currentStack;
                          final currentIndex = stack.lastIndexWhere((r) => r.settings.name == Paths.VIEWMEDICATIONSCREEN);

                          String? previousRouteName;
                          debugPrint('currentIndex: ' + currentIndex.toString());
                          if (currentIndex > 0) {
                            previousRouteName = stack[currentIndex - 1].settings.name;
                            debugPrint("Previous screen before AddMedicationScreen: $previousRouteName");
                            Get.until((route) => route.settings.name == previousRouteName);
                          }
                          debugPrint('currentIndex123: ' + currentIndex.toString());

                          // Get.to(ViewMedicationScreen(
                          //   selectedMasterIndex: selectedMasterIndex,
                          // ));
                          Get.toNamed(
                            Paths.VIEWMEDICATIONSCREEN,
                            arguments: {
                              'selectedMasterIndex': selectedMasterIndex,
                            },
                          );
                        });
                        controller.isViewBtnclicked = false;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.orange,
                        foregroundColor: AppColor.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: getDynamicHeight(size: 0.0135),
                          horizontal: getDynamicHeight(size: 0.0108),
                        ),
                        alignment: Alignment.center,
                      ),
                      child: Text(
                        AppString.view,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColor.white,
                          fontSize: getDynamicHeight(size: 0.013),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
