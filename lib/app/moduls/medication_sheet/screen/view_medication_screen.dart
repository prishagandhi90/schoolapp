// ignore_for_file: must_be_immutable

import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/leave/screen/widget/custom_textformfield.dart';
import 'package:emp_app/app/moduls/medication_sheet/controller/medicationsheet_controller.dart';
import 'package:emp_app/app/moduls/medication_sheet/screen/addmedication_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class ViewMedicationScreen extends StatelessWidget {
  int selectedMasterIndex; // Default selected index for the first tab
  ViewMedicationScreen({Key? key, required this.selectedMasterIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MedicationsheetController>(
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.activateSearch(false); // Reset search before going back
            controller.isSearching = false;
            return true;
          },
          child: Scaffold(
            backgroundColor: AppColor.white,
            appBar: AppBar(
              backgroundColor: AppColor.white,
              centerTitle: true,
              automaticallyImplyLeading: false, // important: so we control leading manually
              leading: controller.isSearching
                  ? null
                  : IconButton(
                      icon: Icon(Icons.arrow_back, color: AppColor.black),
                      onPressed: () {
                        controller.activateSearch(false); // Just in case
                        Get.back();
                      },
                    ),
              title: controller.isSearching
                  ? TextFormField(
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: getDynamicHeight(size: 0.015),
                          vertical: getDynamicHeight(size: 0.012),
                        ),
                        filled: true,
                        fillColor: AppColor.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.015)),
                          borderSide: BorderSide(color: AppColor.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.015)),
                          borderSide: BorderSide(color: AppColor.black),
                        ),
                      ),
                      onChanged: (value) {
                        controller.filterSearchResults(value);
                      },
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                        // controller.showShortButton = true;
                        controller.update();
                      },
                      onFieldSubmitted: (v) {
                        if (controller.searchController.text.trim().isNotEmpty) {
                          // controller.fetchLeaveOTList(controller.selectedRole, controller.selectedLeaveType);
                          controller.searchController.clear();
                        }
                        Future.delayed(const Duration(milliseconds: 800));
                        // controller.showShortButton = true;
                        controller.update();
                      },
                    )
                  : Text("View Medication", style: AppStyle.primaryplusw700),
              actions: [
                IconButton(
                  icon: Icon(
                    controller.isSearching ? Icons.close : Icons.search,
                    color: AppColor.black,
                  ),
                  onPressed: controller.toggleSearch,
                ),
                IconButton(
                  icon: Icon(Icons.notifications_none, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
                    child: CustomTextFormField(
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
                          borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.008)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.black),
                          borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.008)),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.black),
                          borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.008)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.filteredDetails?.length ?? 0,
                      itemBuilder: (context, index) {
                        final item = controller.filteredDetails![index];
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            return Slidable(
                              key: ValueKey(index),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                extentRatio: 0.18,
                                children: [
                                  Container(
                                    width: getDynamicHeight(size: 0.065), // 🔁 approx 65,
                                    height: constraints.maxHeight, // 💥 dynamic height from main container
                                    decoration: BoxDecoration(
                                      color: AppColor.white,
                                      border: Border.all(color: Colors.grey.shade400, width: 1),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(getDynamicHeight(size: 0.011)),
                                        bottomRight: Radius.circular(getDynamicHeight(size: 0.011)),
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.delete, color: AppColor.red, size: getDynamicHeight(size: 0.030)),
                                      onPressed: () async {
                                        await controller.deleteMedicationSheet(
                                            mstId: controller.drTreatMasterList[selectedMasterIndex].detail![index].drMstId!,
                                            dtlId: controller.drTreatMasterList[selectedMasterIndex].detail![index].drDtlId!);
                                        controller.filteredDetails!.removeAt(index);
                                        controller.update();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  await controller.editDrTreatmentDetailList(controller.drTreatMasterList[selectedMasterIndex].detail![index]);
                                  Get.to(
                                    AddMedicationScreen(
                                      selectedMasterIndex: selectedMasterIndex,
                                      selectedDetailIndex: index,
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: getDynamicHeight(size: 0.005),
                                    vertical: getDynamicHeight(size: 0.005),
                                  ),
                                  padding: EdgeInsets.all(getDynamicHeight(size: 0.010)),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColor.black),
                                    borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.011)),
                                    color: AppColor.primaryColor.withOpacity(0.2),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "${index + 1}. ${item.itemName?.txt?.isNotEmpty == true && item.itemName?.txt?.toString().toUpperCase() != 'NULL' ? item.itemName!.txt! : item.itemNameMnl?.isNotEmpty == true ? item.itemNameMnl! : ''}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily: CommonFontStyle.plusJakartaSans,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => controller.viewbottomsheet(context, selectedMasterIndex, index),
                                            child: Icon(Icons.menu),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: getDynamicHeight(size: 0.003)),
                                      Visibility(
                                        visible: item.remark.toString().isNotEmpty && item.remark.toString().toUpperCase() != 'NULL',
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Remarks: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                                ),
                                              ),
                                              TextSpan(
                                                text: item.remark.toString().isNotEmpty && item.remark.toString().toUpperCase() != 'NULL' ? item.remark.toString() : '',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColor.black1,
                                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: getDynamicHeight(size: 0.001)),
                                        child: Text(
                                          (item.freq1?.isNotEmpty ?? false) ||
                                                  (item.freq2?.isNotEmpty ?? false) ||
                                                  (item.freq3?.isNotEmpty ?? false) ||
                                                  (item.freq4?.isNotEmpty ?? false)
                                              ? '${item.freq1 ?? ''} - ${item.freq2 ?? ''} - ${item.freq3 ?? ''} - ${item.freq4 ?? ''}'
                                              : '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: AppColor.black1,
                                            fontFamily: CommonFontStyle.plusJakartaSans,
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: item.flowRate.toString().isNotEmpty && item.flowRate.toString().toUpperCase() != 'NULL',
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: 'Flow Rate: ',
                                                style: TextStyle(fontWeight: FontWeight.w500),
                                              ),
                                              TextSpan(
                                                text: item.flowRate.toString().isNotEmpty && item.flowRate.toString().toUpperCase() != 'NULL'
                                                    ? item.flowRate.toString()
                                                    : '',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColor.black1,
                                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                                ),
                                              ),
                                            ],
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
                      },
                    ),
                  )
                ],
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
                      fontFamily: CommonFontStyle.plusJakartaSans,
                    ),
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
