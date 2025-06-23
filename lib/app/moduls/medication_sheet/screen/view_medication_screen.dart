// ignore_for_file: must_be_immutable

import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/medication_sheet/controller/medicationsheet_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class ViewMedicationScreen extends StatelessWidget {
  int selectedIndex; // Default selected index for the first tab
  ViewMedicationScreen({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MedicationsheetController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(
            title: Text(AppString.viewmedication, style: AppStyle.primaryplusw700),
            backgroundColor: AppColor.white,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: controller.isSearchActive ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  firstChild: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 🔹 Custom Container with Text (Instead of TabBar)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: getDynamicHeight(size: 0.015),
                            vertical: getDynamicHeight(size: 0.012),
                          ),
                          decoration: BoxDecoration(
                            // color: AppColor.lightblue,
                            border: Border.all(color: AppColor.black1),
                            borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.015)),
                          ),
                          child: Text(
                            "KISHOR PRABHUBHAI DARJI ( A/1469/25 )", // ✅ Replace with any dynamic text you want
                            style: TextStyle(
                              color: AppColor.black,
                              fontSize: Sizes.px12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // 🔍 Search icon
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () async {
                            final slidable = Slidable.of(context);
                            if (slidable != null && slidable.actionPaneType.value != ActionPaneType.none) {
                              slidable.close();
                              await Future.delayed(const Duration(milliseconds: 300));
                            }
                            controller.activateSearch(true);
                          },
                        ),
                      ],
                    ),
                  ),

                  // 🔄 Second View: Search TextField
                  secondChild: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
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
                            // controller.filterSearchResults(value, controller.selectedLeaveType);
                          },
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                            // controller.showShortButton = true;
                            controller.update();
                          },
                          onFieldSubmitted: (v) {
                            // if (controller.searchController.text.trim().isNotEmpty) {
                            //   controller.fetchLeaveOTList(controller.selectedRole, controller.selectedLeaveType);
                            //   controller.searchController.clear();
                            // }
                            // Future.delayed(const Duration(milliseconds: 800));
                            // controller.showShortButton = true;
                            // controller.update();
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () async {
                          controller.clearSearch();
                          controller.activateSearch(false);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.drTreatMasterList[selectedIndex].detail.length,
                    itemBuilder: (context, index) {
                      final item = controller.drTreatMasterList[selectedIndex].detail[index];
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return Slidable(
                            key: ValueKey(index),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              extentRatio: 0.18,
                              children: [
                                Container(
                                  width: getDynamicHeight(size: 0.085), // 🔁 approx 65,
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
                                    icon: Icon(Icons.delete, color: AppColor.red, size: getDynamicHeight(size: 0.018)),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: getDynamicHeight(size: 0.010),
                                vertical: getDynamicHeight(size: 0.008),
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
                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      GestureDetector(onTap: () => controller.viewbottomsheet(context, index), child: Icon(Icons.menu)),
                                    ],
                                  ),
                                  SizedBox(height: getDynamicHeight(size: 0.003)),
                                  Visibility(
                                    visible: item.remark.toString().isNotEmpty && item.remark.toString().toUpperCase() != 'NULL',
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Remarks: ',
                                            style: TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                          TextSpan(
                                            text: item.remark.toString().isNotEmpty && item.remark.toString().toUpperCase() != 'NULL'
                                                ? item.remark.toString()
                                                : '',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: AppColor.black1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: getDynamicHeight(size: 0.006)),
                                    child: Text(
                                      item.freq1!.isNotEmpty || item.freq2!.isNotEmpty || item.freq3!.isNotEmpty || item.freq4!.isNotEmpty
                                          ? '${item.freq1} - ${item.freq2} - ${item.freq3} - ${item.freq4}'
                                          : 'No Frequency',
                                      style: TextStyle(fontWeight: FontWeight.w400, color: AppColor.black1),
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
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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
