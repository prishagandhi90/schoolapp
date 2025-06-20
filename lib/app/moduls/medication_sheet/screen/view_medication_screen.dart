import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
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
                  firstChild: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 🔹 Custom Container with Text (Instead of TabBar)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          // color: AppColor.lightblue,
                          border: Border.all(color: AppColor.black1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "KISHOR PRABHUBHAI DARJI ( A/1469/25 )", // ✅ Replace with any dynamic text you want
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 13,
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

                  // 🔄 Second View: Search TextField
                  secondChild: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.searchController,
                          decoration: InputDecoration(
                            hintText: "Search...",
                            prefixIcon: const Icon(Icons.search),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            filled: true,
                            fillColor: AppColor.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppColor.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
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
                                  width: 65,
                                  height: constraints.maxHeight, // 💥 dynamic height from main container
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey.shade400, width: 1),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red, size: 22),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${index + 1}. ${item.itemName!.txt.toString()}",
                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      const Icon(Icons.menu),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Remarks: ',
                                          style: TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        TextSpan(
                                          text: item.remark.toString().isNotEmpty ? item.remark.toString() : 'No Remarks',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      item.freq1!.isNotEmpty || item.freq2!.isNotEmpty || item.freq3!.isNotEmpty || item.freq4!.isNotEmpty
                                          ? '${item.freq1} - ${item.freq2} - ${item.freq3} - ${item.freq4}'
                                          : 'No Frequency',
                                      style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Flow Rate: ',
                                          style: TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        TextSpan(
                                          text: item.flowRate.toString().isNotEmpty ? item.flowRate.toString() : 'No Flow Rate',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
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
        );
      },
    );
  }

  final List<Map<String, String>> medicationList = [
    {'type': 'Inj', 'name': 'Levofuxin 500 MG Inj', 'composition': 'Levofloxacin', 'qty': '1', 'remarks': '+100 CC NS', 'flow': '30ML/HR', 'dosage': '0 - 1 - 0 - 1'},
    {'type': 'Cap', 'name': 'Ecosprin AV 75/10 MG Cap', 'composition': 'Aspirin + Atorvastatin', 'qty': '15', 'remarks': '', 'flow': '', 'dosage': '0 - 1 - 0 - 1'},
  ];
}
