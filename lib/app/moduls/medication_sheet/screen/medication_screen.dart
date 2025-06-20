// ignore_for_file: must_be_immutable

import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/medication_sheet/controller/medicationsheet_controller.dart';
import 'package:emp_app/app/moduls/medication_sheet/screen/addmedication_screen.dart';
import 'package:emp_app/app/moduls/medication_sheet/screen/view_medication_screen.dart';
import 'package:flutter/material.dart';
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
                        child: TextFormField(
                          cursorColor: AppColor.black,
                          controller: controller.searchController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(getDynamicHeight(size: 0.012)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.lightgrey1, width: getDynamicHeight(size: 0.001)),
                              borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.012)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.012)),
                              borderSide: BorderSide(
                                color: AppColor.black,
                              ),
                            ),
                            suffixIcon: controller.searchController.text.trim().isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      controller.searchController.clear();
                                      // controller.fetchDeptwisePatientList(isLoader: false);
                                    },
                                    child: const Icon(Icons.cancel_outlined))
                                : const SizedBox(),
                            prefixIcon: Icon(Icons.search, color: AppColor.lightgrey1),
                            hintText: AppString.search,
                            hintStyle: AppStyle.plusgrey,
                            filled: true,
                            fillColor: AppColor.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(
                                getDynamicHeight(size: 0.027),
                              )),
                            ),
                          ),
                          onTap: () {
                            controller.update();
                          },
                          onChanged: (value) {
                            // controller.filterSearchResults(value);
                            // controller.searchController.clear();
                          },
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                            Future.delayed(const Duration(milliseconds: 300));
                            controller.update();
                          },
                          onFieldSubmitted: (v) {
                            // if (controller.searchController.text.trim().isNotEmpty) {
                            //   controller.fetchDeptwisePatientList(
                            //     searchPrefix: controller.searchController.text.trim(),
                            //     isLoader: false,
                            //   );
                            //   controller.searchController.clear();
                            // }
                            Future.delayed(const Duration(milliseconds: 800));
                            controller.update();
                          },
                        ),
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
                              // controller.sortBy();
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
                              // controller.callFilterAPi = false;
                              // controller.tempOrgsList = List.unmodifiable(controller.selectedOrgsList);
                              // controller.tempFloorsList = List.unmodifiable((controller.selectedFloorsList));
                              // controller.tempWardList = List.unmodifiable(controller.selectedWardsList);

                              // controller.AdpatientFiltterBottomSheet();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
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
                          extentRatio: 0.21, // ~18% each
                          children: [
                            // 🔷 Copy Button
                            Container(
                              height: getDynamicHeight(size: 0.050),
                              width: getDynamicHeight(size: 0.050),
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  bottomLeft: Radius.circular(0),
                                ),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.copy,
                                  color: Colors.white,
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
                                color: Colors.white,
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
                                  color: Colors.teal,
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
                                        text: "Treatment Date:  ",
                                        style: AppStyle.black,
                                      ),
                                      TextSpan(
                                        text: controller.drTreatMasterList[index].date.toString(),
                                        style: AppStyle.black,
                                      ),
                                    ],
                                  ),
                                ),

                                // 🔹 Icons
                                Row(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          Get.to(ViewMedicationScreen(
                                            selectedIndex: index,
                                          ));
                                        },
                                        child: Icon(
                                          Icons.remove_red_eye_outlined,
                                          size: getDynamicHeight(size: 0.021),
                                        )),
                                    SizedBox(width: getDynamicHeight(size: 0.004)),
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
                  foregroundColor: AppColor.blackColor,
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
