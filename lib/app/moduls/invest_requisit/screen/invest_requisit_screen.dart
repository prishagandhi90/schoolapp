// ignore_for_file: deprecated_member_use

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/invest_requisit/controller/invest_requisit_controller.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/externallab_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/searchservice_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/servicegrp_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/screen/invest_service_screen.dart';
import 'package:emp_app/app/moduls/leave/screen/widget/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class InvestRequisitScreen extends StatelessWidget {
  const InvestRequisitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(InvestRequisitController());

    return GetBuilder<InvestRequisitController>(
      builder: (controller) {
        return Scaffold(
            backgroundColor: AppColor.white,
            appBar: AppBar(
              backgroundColor: AppColor.white,
              title: Text(AppString.investigationrequisition, style: AppStyle.primaryplusw700),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getDynamicHeight(size: 0.007),
                  vertical: getDynamicHeight(size: 0.018),
                ),
                child: Column(
                  children: [
                    Autocomplete<SearchserviceModel>(
                        displayStringForOption: (SearchserviceModel option) => option.txt ?? '',
                        optionsBuilder: (TextEditingValue textEditingValue) async {
                          if (textEditingValue.text.trim().isEmpty) {
                            controller.suggestions.clear();
                            return const Iterable<SearchserviceModel>.empty();
                          }
                          await controller.getSuggestions(textEditingValue.text);
                          return controller.suggestions;
                        },
                        onSelected: (SearchserviceModel selection) {
                          print('Selected City: ${selection.txt} (ID: ${selection.name})');
                          controller.nameController.text = selection.txt ?? '';
                          controller.ipdNo = selection.name ?? '';
                          controller.uhid = controller.getUHId(selection.txt ?? '');
                          controller.suggestions.clear();
                          controller.update();
                        },
                        fieldViewBuilder: (context, nameController, focusNode, onEditingComplete) {
                          final effectiveController = controller.nameController.text.isNotEmpty && controller.fromAdmittedScreen
                              ? controller.nameController
                              : nameController;
                          return CustomTextFormField(
                            controller: effectiveController,
                            focusNode: focusNode,
                            // readOnly: controller.nameController.text.isNotEmpty &&
                            //     controller.fromAdmittedScreen, // 👈 make readonly if patientname passed
                            minLines: 1,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              hintText: AppString.patientuhidipd,
                              isDense: true,
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: controller.nameController.text.isNotEmpty ? AppColor.black : AppColor.red,
                                  width: getDynamicHeight(size: 0.0008),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(0)),
                                borderSide: BorderSide(color: controller.nameController.text.isNotEmpty ? AppColor.black : AppColor.red),
                              ),
                              prefixIcon: Icon(Icons.search, color: AppColor.lightgrey1),
                              suffixIcon: nameController.text.isNotEmpty || controller.nameController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.cancel_outlined, color: AppColor.black),
                                      onPressed: () {
                                        focusNode.unfocus();
                                        controller.nameController.clear();
                                        nameController.clear();
                                        controller.suggestions.clear();
                                        controller.ipdNo = '';
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
                        }),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: getDynamicHeight(size: 0.007),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: CustomDropdown(
                              text: AppString.investigationType,
                              buttonStyleData: ButtonStyleData(
                                height: getDynamicHeight(size: 0.0475),
                                padding: const EdgeInsets.symmetric(horizontal: 0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: controller.typeController.text.isEmpty || controller.typeController.text == '--select--'
                                          ? AppColor.red
                                          : AppColor.black),
                                  borderRadius: BorderRadius.circular(0),
                                  color: AppColor.white,
                                ),
                              ),
                              controller: controller.typeController,
                              items: [
                                {'value': '', 'text': '--select--'}, // Empty value so that it doesn't save
                                {'value': 'Lab', 'text': 'Lab'},
                                {'value': 'Radio', 'text': 'Radio'},
                                {'value': 'Other Investigation', 'text': 'Other Investigation'},
                              ].map((Map<String, String> item) {
                                return DropdownMenuItem<Map<String, String>>(
                                  value: item,
                                  child: Text(
                                    item['text'] ?? '',
                                    style: AppStyle.black,
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) async {
                                await controller.fetchServiceGroup();
                                controller.typeController.text = val?['text'] ?? '';
                                controller.serviceGroupController.text = '';
                                controller.ExternalLabController.text = '';
                                controller.ExternalLabIdController.text = '';
                                controller.update();
                              },
                            ),
                          ),
                          SizedBox(
                            width: getDynamicHeight(size: 0.01055),
                          ),
                          Expanded(
                            flex: 4,
                            child: CustomDropdown(
                              text: AppString.normal,
                              buttonStyleData: ButtonStyleData(
                                height: getDynamicHeight(size: 0.0475),
                                padding: const EdgeInsets.symmetric(horizontal: 0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColor.black),
                                  borderRadius: BorderRadius.circular(0),
                                  color: AppColor.white,
                                ),
                              ),
                              controller: controller.priorityController,
                              items: [
                                {'value': 'Normal', 'text': 'Normal'},
                                {'value': 'Urgent', 'text': 'Urgent'},
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
                                controller.priorityController.text = val?['text'] ?? '';
                                print("Selected Priority: ${val?['text']}");
                                controller.update();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: getDynamicHeight(size: 0.007),
                      ),
                      child: CustomDropdown(
                        text: AppString.internal,
                        controller: controller.InExController,
                        buttonStyleData: ButtonStyleData(
                          height: getDynamicHeight(size: 0.0475),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.black),
                            color: AppColor.white,
                          ),
                        ),
                        onChanged: (value) {
                          if (controller.InExController.text.toLowerCase() == 'internal') {
                            controller.ExternalLabController.text = '';
                          }
                          controller.update();
                        },
                        width: double.infinity,
                        items: [
                          {'value': 'Internal', 'text': 'Internal'},
                          {'value': 'External', 'text': 'External'},
                        ].map((Map<String, String> item) {
                          return DropdownMenuItem<Map<String, String>>(
                            value: item,
                            child: Text(
                              item['text'] ?? '',
                              style: AppStyle.black,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: getDynamicHeight(size: 0.007),
                      ),
                      child: CustomDropdown(
                        text: AppString.selectExternallab,
                        controller: controller.ExternalLabController,
                        enabled: controller.InExController.text.toLowerCase() == 'external',
                        buttonStyleData: ButtonStyleData(
                          height: getDynamicHeight(size: 0.0475),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.black),
                            color: AppColor.white,
                          ),
                        ),
                        onChanged: (value) {
                          controller.ExternalLabIdController.text = value?['value'] ?? '';
                          controller.update();
                        },
                        width: double.infinity,
                        items: controller.externalLab
                            .map((ExternallabModel item) => DropdownMenuItem<Map<String, String>>(
                                  value: {
                                    'value': item.id ?? '', // Use the value as the item value
                                    'text': item.name ?? '', // Display the name in the dropdown
                                  },
                                  child: Text(
                                    item.name ?? '', // Display the name in the dropdown
                                    style: AppStyle.black.copyWith(
                                      // fontSize: 14,
                                      fontSize: getDynamicHeight(size: 0.016),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: getDynamicHeight(size: 0.007),
                      ),
                      child: CustomDropdown(
                        text: AppString.selectServicegroup,
                        controller: controller.serviceGroupController,
                        buttonStyleData: ButtonStyleData(
                          height: getDynamicHeight(size: 0.0475),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.black),
                            color: AppColor.white,
                          ),
                        ),
                        onChanged: (value) {
                          controller.update();
                        },
                        width: double.infinity,
                        items: controller.serviceGroup
                            .map((ServicegrpModel item) => DropdownMenuItem<Map<String, String>>(
                                  value: {
                                    'value': item.name ?? '', // Use the value as the item value
                                    'text': item.name ?? '', // Display the name in the dropdown
                                  },
                                  child: Text(
                                    item.name ?? '', // Display the name in the dropdown
                                    style: AppStyle.black.copyWith(
                                      // fontSize: 14,
                                      fontSize: getDynamicHeight(size: 0.016),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: getDynamicHeight(size: 0.007),
                      ),
                      child: CustomTextFormField(
                        hint: AppString.diagnosiscomplaint,
                        hintStyle: AppStyle.black.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: getDynamicHeight(size: 0.016),
                        ),
                        minLines: 3,
                        maxLines: null,
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
                        onChanged: (value) {},
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
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: getDynamicHeight(size: 0.007),
                      ),
                      child: CustomTextFormField(
                        hint: AppString.clinicalremarks,
                        hintStyle: AppStyle.black.copyWith(
                          // fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontSize: getDynamicHeight(size: 0.016),
                        ),
                        minLines: 3,
                        maxLines: null,
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
                        onChanged: (value) {},
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
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(
                bottom: getDynamicHeight(size: 0.002),
                left: getDynamicHeight(size: 0.007),
                right: getDynamicHeight(size: 0.007),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: getDynamicHeight(size: 0.05), // 👈 Fixed height for all buttons
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 167, 166, 166),
                          foregroundColor: AppColor.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 0), // 👈 Remove vertical padding
                        ),
                        child: Center(
                          child: Text(
                            controller.webUserName,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColor.white,
                              fontSize: getDynamicHeight(size: 0.013),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getDynamicHeight(size: 0.004),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (controller.ipdNo == '') {
                          Get.snackbar(AppString.error, AppString.plzselectavalidpatient,
                              duration: Duration(seconds: 5),
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: AppColor.red.withOpacity(0.8),
                              colorText: AppColor.white);
                          return;
                        }
                        if (controller.isHistorySheetOpen) return;
                        controller.isHistorySheetOpen = true;
                        await controller.fetchGetHistoryList(controller.ipdNo);
                        await controller.HistoryBottomSheet();
                        controller.isHistorySheetOpen = false;
                        controller.update();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: getDynamicHeight(size: 0.0125),
                        ),
                      ),
                      child: Text(
                        AppString.history,
                        style: TextStyle(
                          color: AppColor.white,
                          fontSize: getDynamicHeight(size: 0.016),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getDynamicHeight(size: 0.004),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isNextButtonEnabled()
                          ? () async {
                              if (controller.isNextButtonClicked) return;
                              controller.isNextButtonClicked = true;

                              controller.getQueryList.clear();
                              controller.selectedServices.clear();
                              controller.selectedTop = 20;
                              controller.searchController.text = '';
                              controller.fetchGetQueryList(controller.ipdNo);
                              controller.patientName = controller.nameController.text;
                              controller.drIdController.text = "";
                              controller.drNameController.text = "";
                              Get.to(() => InvestServiceScreen());

                              controller.isNextButtonClicked = false;
                              controller.update();
                            }
                          : null,
                      // onPressed: () async {
                      //   if (controller.isNextButtonClicked) return;
                      //   controller.isNextButtonClicked = true;

                      //   if (controller.isNextButtonEnabled()) {
                      //     controller.getQueryList.clear();
                      //     controller.selectedServices.clear();
                      //     controller.selectedTop = 20;
                      //     controller.searchController.text = '';
                      //     controller.fetchGetQueryList(controller.ipdNo);
                      //     controller.patientName = controller.nameController.text;
                      //     controller.drIdController.text = "";
                      //     controller.drNameController.text = "";
                      //     Get.to(() => InvestServiceScreen());
                      //   } else {
                      //     controller.isNextButtonClicked = false;
                      //     controller.update();
                      //     return null;
                      //   }
                      //   controller.isNextButtonClicked = false;
                      //   controller.update();
                      // },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: getDynamicHeight(size: 0.0125),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppString.next,
                            style: TextStyle(
                              color: AppColor.white,
                              fontFamily: CommonFontStyle.plusJakartaSans,
                              fontSize: getDynamicHeight(size: 0.016),
                            ),
                          ),
                          SizedBox(
                            width: getDynamicHeight(size: 0.004),
                          ),
                          Icon(Icons.skip_next_outlined, color: AppColor.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
