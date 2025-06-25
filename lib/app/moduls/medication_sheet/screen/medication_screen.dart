// ignore_for_file: must_be_immutable

import 'package:emp_app/app/app_custom_widget/custom_autocomplete.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/searchservice_model.dart';
import 'package:emp_app/app/moduls/medication_sheet/controller/medicationsheet_controller.dart';
import 'package:emp_app/app/moduls/medication_sheet/screen/addmedication_screen.dart';
import 'package:emp_app/app/moduls/medication_sheet/screen/view_medication_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class MedicationScreen extends StatelessWidget {
  MedicationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerHeight;

    if (screenWidth < 360) {
      containerHeight = getDynamicHeight(size: 0.076); // Small screen fix (static for tiny devices)
    } else if (screenWidth > 600) {
      containerHeight = getDynamicHeight(size: 0.040); // iPad
    } else {
      containerHeight = getDynamicHeight(size: 0.050); // Normal
    }
    Get.put(MedicationsheetController());
    return GetBuilder<MedicationsheetController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(
            title: Text(AppString.medicationsheet, style: AppStyle.primaryplusw700),
            backgroundColor: AppColor.white,
            centerTitle: true,
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(getDynamicHeight(size: 0.012)),
                child: Row(
                  children: [
                    // Search Bar (60%)
                    Expanded(
                      flex: 7,
                      // ignore: deprecated_member_use
                      child: WillPopScope(
                        onWillPop: () async {
                          // Unfocus the TextFormField and dismiss the keyboard
                          FocusScope.of(context).unfocus();
                          return true; // Allow navigation to go back
                        },
                        child: CustomAutoComplete<SearchserviceModel>(
                          controller: controller.nameController,
                          hintText: AppString.patientuhidipd,
                          displayStringForOption: (SearchserviceModel option) => option.txt ?? '',
                          optionsBuilder: (TextEditingValue textEditingValue) async {
                            if (textEditingValue.text.trim().isEmpty) {
                              controller.suggestions.clear();
                              return const Iterable<SearchserviceModel>.empty();
                            }
                            await controller.getSuggestions(textEditingValue.text);
                            return controller.suggestions;
                          },
                          onSelected: (SearchserviceModel selection) async {
                            controller.nameController.text = selection.txt ?? '';
                            controller.ipdNo = selection.name ?? '';
                            controller.uhid = controller.getUHId(selection.txt ?? '');
                            controller.suggestions.clear();
                            await controller.fetchDrTreatmentData(ipdNo: selection.name ?? '', treatTyp: 'Medication Sheet');
                            controller.update(); // Trigger state update if needed
                          },
                          onClearSuggestions: () {
                            controller.suggestions.clear();
                          },
                          onSuffixIconPressed: () {
                            controller.nameController.clear();
                            controller.suggestions.clear();
                            controller.ipdNo = '';
                            controller.drTreatMasterList.clear();
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              controller.update();
                            });
                          },
                        ),
                        // child: Autocomplete<SearchserviceModel>(
                        //     displayStringForOption: (SearchserviceModel option) => option.txt ?? '',
                        //     optionsBuilder: (TextEditingValue textEditingValue) async {
                        //       if (textEditingValue.text.trim().isEmpty) {
                        //         controller.suggestions.clear();
                        //         return const Iterable<SearchserviceModel>.empty();
                        //       }
                        //       await controller.getSuggestions(textEditingValue.text);
                        //       return controller.suggestions;
                        //     },
                        //     onSelected: (SearchserviceModel selection) async {
                        //       controller.nameController.text = selection.txt ?? '';
                        //       controller.ipdNo = selection.name ?? '';
                        //       controller.uhid = controller.getUHId(selection.txt ?? '');
                        //       controller.suggestions.clear();
                        //       await controller.fetchDrTreatmentData(ipdNo: selection.name ?? '', treatTyp: 'Medication Sheet');
                        //       controller.update();
                        //     },
                        //     fieldViewBuilder: (context, nameController, focusNode, onEditingComplete) {
                        //       final effectiveController = controller.nameController.text.isNotEmpty && controller.fromAdmittedScreen
                        //           ? controller.nameController
                        //           : nameController;
                        //       return CustomTextFormField(
                        //         controller: effectiveController,
                        //         focusNode: focusNode,
                        //         style: TextStyle(fontSize: getDynamicHeight(size: 0.014)),
                        //         // readOnly: controller.nameController.text.isNotEmpty &&
                        //         //     controller.fromAdmittedScreen, // 👈 make readonly if patientname passed
                        //         minLines: 1,
                        //         maxLines: null,
                        //         keyboardType: TextInputType.multiline,
                        //         decoration: InputDecoration(
                        //           hintText: AppString.patientuhidipd,
                        //           isDense: true,
                        //           border: OutlineInputBorder(),
                        //           focusedBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(
                        //               color: controller.nameController.text.isNotEmpty ? AppColor.black : AppColor.red,
                        //               width: getDynamicHeight(size: 0.0008),
                        //             ),
                        //           ),
                        //           enabledBorder: OutlineInputBorder(
                        //             borderRadius: BorderRadius.all(Radius.circular(0)),
                        //             borderSide:
                        //                 BorderSide(color: controller.nameController.text.isNotEmpty ? AppColor.black : AppColor.red),
                        //           ),
                        //           prefixIcon: Icon(Icons.search, color: AppColor.lightgrey1),
                        //           suffixIcon: nameController.text.isNotEmpty || controller.nameController.text.isNotEmpty
                        //               ? IconButton(
                        //                   icon: Icon(Icons.cancel_outlined, color: AppColor.black),
                        //                   onPressed: () {
                        //                     focusNode.unfocus();
                        //                     controller.nameController.clear();
                        //                     nameController.clear();
                        //                     controller.suggestions.clear();
                        //                     controller.ipdNo = '';
                        //                     SchedulerBinding.instance.addPostFrameCallback((_) {
                        //                       controller.update();
                        //                     });
                        //                   },
                        //                 )
                        //               : null,
                        //         ),
                        //         onTapOutside: (event) {
                        //           focusNode.unfocus();
                        //         },
                        //         onFieldSubmitted: (value) {
                        //           focusNode.unfocus();
                        //         },
                        //       );
                        //     }),
                      ),
                    ),
                    // 🔽 Same size as IconButton wala niche container
                    SizedBox(width: getDynamicHeight(size: 0.010)),
                    Expanded(
                      flex: 1.5.toInt(),
                      child: Container(
                        height: containerHeight,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.black),
                          borderRadius: BorderRadius.circular(
                            getDynamicHeight(size: 0.012),
                          ),
                        ),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              controller.sortByBottomSheet();
                            },
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Image.asset(
                                AppImage.filter,
                                height: getDynamicHeight(size: 0.02),
                                width: getDynamicHeight(size: 0.02),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: getDynamicHeight(size: 0.008)),
                    Expanded(
                      flex: 1.5.toInt(),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.black),
                          borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.012)),
                        ),
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.filter_alt,
                              color: AppColor.black,
                              size: getDynamicHeight(size: 0.027), // 🔁 Same size
                            ),
                            onPressed: () async {
                              controller.showDateBottomSheet(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListView.builder(
                    itemCount: controller.drTreatMasterList.length, // Your list of treatments
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(getDynamicHeight(
                          size: 0.002,
                        )),
                        child: Slidable(
                          key: ValueKey(index),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            extentRatio: 0.27, // ~18% each
                            children: [
                              // 🔷 Copy Button
                              Container(
                                height: getDynamicHeight(size: 0.050),
                                width: getDynamicHeight(size: 0.050),
                                decoration: BoxDecoration(
                                  color: AppColor.teal,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(0),
                                    bottomLeft: Radius.circular(0),
                                  ),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.copy,
                                    color: AppColor.white,
                                    size: getDynamicHeight(size: 0.025),
                                  ),
                                  onPressed: () {
                                    controller.showMedicationDialog(context);
                                  },
                                ),
                              ),
                              // 🔷 Edit Button
                              Container(
                                height: getDynamicHeight(size: 0.050),
                                width: getDynamicHeight(size: 0.050),
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                    width: getDynamicHeight(size: 0.001),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(getDynamicHeight(size: 0.008)),
                                    bottomRight: Radius.circular(getDynamicHeight(size: 0.008)),
                                  ),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: AppColor.teal,
                                    size: getDynamicHeight(size: 0.025),
                                  ),
                                  onPressed: () {
                                    controller.showMedicationDialog(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () => Get.to(AddMedicationScreen(selectedIndex: index)),
                            child: Container(
                              // margin: EdgeInsets.symmetric(vertical: 6),
                              padding: EdgeInsets.symmetric(
                                horizontal: getDynamicHeight(size: 0.003),
                                vertical: getDynamicHeight(size: 0.000),
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColor.primaryColor),
                                borderRadius: BorderRadius.circular(
                                  getDynamicHeight(size: 0.0055),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // 🔹 Index and Date
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "${index + 1}.  ",
                                          style: AppStyle.black,
                                        ),
                                        TextSpan(
                                          text: AppString.treatmentdate,
                                          style: AppStyle.black,
                                        ),
                                        TextSpan(
                                          text: controller.drTreatMasterList[index].date.toString(),
                                          style: AppStyle.black.copyWith(
                                            fontSize: getDynamicHeight(size: 0.013),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 🔹 Icons
                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            controller.selectedMasterIndex = index;
                                            controller.update();
                                            Get.to(ViewMedicationScreen(
                                              selectedIndex: index,
                                            ));
                                          },
                                          child: Icon(
                                            Icons.remove_red_eye_outlined,
                                            size: getDynamicHeight(size: 0.021),
                                          )),
                                      // SizedBox(width: getDynamicHeight(size: 0.002)),
                                      IconButton(
                                        onPressed: () {
                                          controller.medicationbottomsheet(context, index);
                                        },
                                        icon: Icon(
                                          Icons.menu,
                                          size: getDynamicHeight(size: 0.021),
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
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColor.teal1,
            onPressed: () {
              controller.showMedicationDialog(context);
            },
            child: Icon(
              Icons.add_circle_outlined,
              color: AppColor.black,
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.all(
              getDynamicHeight(size: 0.007),
            ),
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
        );
      },
    );
  }
}
