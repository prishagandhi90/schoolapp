import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/invest_requisit/controller/invest_requisit_controller.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/externallab_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/servicegrp_model.dart';
import 'package:emp_app/app/moduls/leave/screen/widget/custom_textformfield.dart';
import 'package:flutter/material.dart';
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
              title: const Text('Investigation Requisition'),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: getDynamicHeight(size: 0.050),
                    child: TextFormField(
                      cursorColor: AppColor.black,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.012)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColor.lightgrey1,
                            width: getDynamicHeight(size: 0.00105),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          // borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.012)),
                          borderSide: BorderSide(color: AppColor.red),
                        ),
                        filled: true,
                        fillColor: AppColor.white,
                        hintText: 'Patient/UHID/IPD',
                        hintStyle: AppStyle.plusgrey,
                        border: OutlineInputBorder(borderSide: BorderSide(color: AppColor.red)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomDropdown(
                            text: 'Type',
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColor.red),
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
                            onChanged: (val) {},
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: CustomDropdown(
                            text: 'Normal',
                            buttonStyleData: ButtonStyleData(
                              height: 50,
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
                              print("Selected Priority: ${val?['text']}");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomDropdown(
                      text: 'Internal',
                      controller: controller.InExController,
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.black),
                          borderRadius: BorderRadius.circular(0),
                          color: AppColor.white,
                        ),
                      ),
                      onChanged: (value) {},
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
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomDropdown(
                      text: 'External lab',
                      controller: controller.InExController,
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.black),
                          borderRadius: BorderRadius.circular(0),
                          color: AppColor.white,
                        ),
                      ),
                      onChanged: (value) {
                        controller.update();
                      },
                      width: double.infinity,
                      items: controller.externalLab
                          .map((ExternallabModel item) => DropdownMenuItem<Map<String, String>>(
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
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomDropdown(
                      text: 'Service group',
                      controller: controller.serviceGroupController,
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.black),
                          borderRadius: BorderRadius.circular(0),
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
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomTextFormField(
                      hint: 'Diagnosis/Complaints...',
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
                        borderSide: BorderSide(color: AppColor.black, width: 1),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.black, width: 1),
                        borderRadius: BorderRadius.circular(0),
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
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomTextFormField(
                      hint: 'Clinical Remarks...',
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
                        borderSide: BorderSide(color: AppColor.black, width: 1),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.black, width: 1),
                        borderRadius: BorderRadius.circular(0),
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
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Cancel logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Save logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Hoistory',
                        style: TextStyle(color: AppColor.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Submit logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(color: AppColor.white),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.skip_next_outlined, color: Colors.white),
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
