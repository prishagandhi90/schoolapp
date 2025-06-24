// ignore_for_file: must_be_immutable

import 'package:emp_app/app/app_custom_widget/common_dropdown_model.dart';
import 'package:emp_app/app/app_custom_widget/custom_date_picker.dart';
import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/searchservice_model.dart';
import 'package:emp_app/app/moduls/leave/screen/widget/custom_textformfield.dart';
import 'package:emp_app/app/moduls/medication_sheet/controller/medicationsheet_controller.dart';
import 'package:emp_app/app/moduls/medication_sheet/screen/view_medication_screen.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class AddMedicationScreen extends StatelessWidget {
  int selectedIndex;
  AddMedicationScreen({Key? key, required this.selectedIndex}) : super(key: key);

  final ScrollController formScrollController = ScrollController();
  final ScrollController listScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Get.put(MedicationsheetController());
    return GetBuilder<MedicationsheetController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(
            title: Text(AppString.addmedication, style: AppStyle.primaryplusw700),
            centerTitle: true,
            backgroundColor: AppColor.white,
            elevation: 0,
            leading: GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_back, color: AppColor.black)),
          ),
          body: Column(
            children: [
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  controller: formScrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        CustomTextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: controller.nameController.text,
                            hintStyle: TextStyle(
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontFamily: CommonFontStyle.plusJakartaSans,
                            ),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            filled: true,
                            fillColor: AppColor.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.black),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.black),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.black),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        SizedBox(height: 6),

                        /// Medication Type Dropdown
                        CustomDropdown(
                          text: "Medication Type",
                          textStyle: TextStyle(color: AppColor.grey),
                          controller: controller.medicationTypeController,
                          buttonStyleData: ButtonStyleData(
                            height: 48,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColor.black),
                              borderRadius: BorderRadius.circular(4),
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
                        SizedBox(height: 6),
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
                            controller.update();
                          },
                          fieldViewBuilder: (context, nameController, focusNode, onEditingComplete) {
                            return CustomTextFormField(
                              controller: nameController,
                              focusNode: focusNode,
                              minLines: 1,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                hintText: 'Formulary Medicine',
                                hintStyle: TextStyle(color: AppColor.grey),
                                isDense: true,
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    // color: controller.nameController.text.isNotEmpty ? AppColor.black : AppColor.red,
                                    width: getDynamicHeight(size: 0.0008),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(0)),
                                  // borderSide: BorderSide(color: controller.nameController.text.isNotEmpty ? AppColor.black : AppColor.red),
                                ),
                                prefixIcon: Icon(Icons.search, color: AppColor.lightgrey1),
                                suffixIcon: nameController.text.isNotEmpty || controller.nameController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.cancel_outlined, color: AppColor.black),
                                        onPressed: () {
                                          focusNode.unfocus();
                                          controller.FormularyMedicines_suggestions.clear();
                                          nameController.clear();
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
                        SizedBox(height: 6),
                        CustomTextFormField(
                          decoration: InputDecoration(
                            hintText: "Non Formulary Medicine",
                            hintStyle: TextStyle(color: AppColor.grey),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            filled: true,
                            fillColor: AppColor.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.black),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.black),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.black, width: 1.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: CustomDropdown(
                                text: "Inst Typ",
                                textStyle: TextStyle(color: AppColor.grey),
                                controller: controller.instructionTypeController,
                                buttonStyleData: ButtonStyleData(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColor.black),
                                    borderRadius: BorderRadius.circular(4),
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
                                              fontSize: getDynamicHeight(size: 0.016),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                width: double.infinity,
                              ),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: SizedBox(
                                height: 48,
                                child: CustomTextFormField(
                                  decoration: InputDecoration(
                                    hintText: "Dose",
                                    hintStyle: TextStyle(color: AppColor.grey),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                    filled: true,
                                    fillColor: AppColor.white,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.black),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.black),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.black, width: 1.5),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 48, // 🔥 Same as dropdown
                                child: CustomTextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Qty',
                                    hintStyle: TextStyle(color: AppColor.grey),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                    filled: true,
                                    fillColor: AppColor.white,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.black),
                                      borderRadius: BorderRadius.circular(4), // ✅ Apply radius here
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.black),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.black, width: 1.5),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: CustomDropdown(
                                text: "Route",
                                textStyle: TextStyle(color: AppColor.grey),
                                controller: controller.routeController,
                                buttonStyleData: ButtonStyleData(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColor.black),
                                    borderRadius: BorderRadius.circular(4),
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
                        SizedBox(height: 6),
                        CustomTextFormField(
                          controller: controller.remarksController,
                          minLines: 1,
                          maxLines: 10,
                          decoration: InputDecoration(
                            hintText: "Remarks",
                            hintStyle: TextStyle(color: AppColor.grey),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            filled: true,
                            fillColor: AppColor.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.black),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.black),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.black, width: 1.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: CustomDropdown(
                                text: "Morning",
                                textStyle: TextStyle(fontSize: 13, color: AppColor.grey),
                                controller: controller.FreqMorningController,
                                buttonStyleData: ButtonStyleData(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColor.black),
                                    borderRadius: BorderRadius.circular(3),
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
                            SizedBox(width: 4), // spacing between dropdowns
                            Expanded(
                              child: CustomDropdown(
                                text: "Afternoon",
                                textStyle: TextStyle(fontSize: 13, color: AppColor.grey),
                                controller: controller.FreqAfternoonController,
                                buttonStyleData: ButtonStyleData(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColor.black),
                                    borderRadius: BorderRadius.circular(3),
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
                            SizedBox(width: 4),
                            Expanded(
                              child: CustomDropdown(
                                text: "Evening",
                                textStyle: TextStyle(fontSize: 13, color: AppColor.grey),
                                controller: controller.FreqEveningController,
                                buttonStyleData: ButtonStyleData(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColor.black),
                                    borderRadius: BorderRadius.circular(3),
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
                            SizedBox(width: 4),
                            Expanded(
                              child: CustomDropdown(
                                text: "Night",
                                textStyle: TextStyle(fontSize: 13, color: AppColor.grey),
                                controller: controller.FreqNightController,
                                buttonStyleData: ButtonStyleData(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColor.black),
                                    borderRadius: BorderRadius.circular(3),
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
                        SizedBox(height: 6),
                        CustomTextFormField(
                          decoration: InputDecoration(
                            hintText: "Days",
                            hintStyle: TextStyle(color: AppColor.grey),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            filled: true,
                            fillColor: AppColor.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.black),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.black),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.black, width: 1.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: CustomDatePicker(
                                dateController: controller.dateController,
                                style: TextStyle(fontSize: getDynamicHeight(size: 0.014)),
                                hintText: 'Select Date',
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColor.black1),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColor.black1),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: () async {
                                      final pickedDate = await showDatePicker(
                                        context: context,
                                        // initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );

                                      if (pickedDate != null) {
                                        final formattedDate =
                                            "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                                        controller.dateController.text = formattedDate;
                                      }
                                      FocusScope.of(context).unfocus();
                                    },
                                  ),
                                ),
                                // onDateSelected: () async {
                                //   final pickedDate = await showDatePicker(
                                //     context: context,
                                //     initialDate: DateTime.now(),
                                //     firstDate: DateTime(2000),
                                //     lastDate: DateTime(2100),
                                //   );
                                //   if (pickedDate != null) {
                                //     final formattedDate =
                                //         "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                                //     dateController.text = formattedDate;
                                //   }
                                // },
                              ),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                                child: InkWell(
                              onTap: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: controller.selectedTime,
                                );
                                if (time != null) {
                                  controller.selectedTime = time;
                                  controller.update();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColor.black1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(controller.selectedTime.format(context)),
                                    SizedBox(width: 8),
                                    Icon(Icons.timer_outlined),
                                  ],
                                ),
                              ),
                            ))
                          ],
                        ),
                        SizedBox(height: 6),
                        CustomTextFormField(
                          decoration: InputDecoration(
                            hintText: "Flow Rate",
                            hintStyle: TextStyle(color: AppColor.grey),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            filled: true,
                            fillColor: AppColor.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.black),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.black),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.black, width: 1.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.teal,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Text("SAVE", style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.white)),
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  "Added Medication (${controller.drTreatMasterList[selectedIndex].detail!.length})",
                  style: TextStyle(color: AppColor.teal, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              // Medication List
              Expanded(
                flex: 1,
                child: Scrollbar(
                  controller: listScrollController,
                  child: ListView.separated(
                    controller: listScrollController,
                    shrinkWrap: true,
                    itemCount: controller.drTreatMasterList[selectedIndex].detail!.length,
                    itemBuilder: (context, index) {
                      final item = controller.drTreatMasterList[selectedIndex].detail![index];
                      return ListTile(
                        visualDensity: VisualDensity(vertical: -4), // 🔥 this removes extra vertical space
                        // dense: true,
                        title: Text(
                          "${index + 1}. ${item.itemName?.txt ?? ''}",
                          style: TextStyle(fontFamily: CommonFontStyle.plusJakartaSans, fontSize: getDynamicHeight(size: 0.014)),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.grey.shade400,
                      endIndent: 8,
                      indent: 8,
                      thickness: 1,
                      height: 0, // zero gap if you want tight spacing
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
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
                SizedBox(width: 6),
                Expanded(
                  flex: 4,
                  child: Container(
                    child: TextButton(
                      onPressed: () {
                        Get.to(ViewMedicationScreen(
                          selectedIndex: selectedIndex,
                        ));
                      },
                      style: TextButton.styleFrom(
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
                        'View',
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
