import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/medication_sheet/controller/medicationsheet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

class MedicationScreen extends StatelessWidget {
  MedicationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerHeight;

    if (screenWidth < 360) {
      containerHeight = 80; // Small screen fix (static for tiny devices)
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
                              borderSide: BorderSide(color: AppColor.lightgrey1, width: 1.0),
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
                              borderRadius: BorderRadius.all(Radius.circular(getDynamicHeight(size: 0.027))),
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
                          borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.012)),
                        ),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              // controller.sortBy();
                            },
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child:
                                  Image.asset(AppImage.filter, height: getDynamicHeight(size: 0.02), width: getDynamicHeight(size: 0.02)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: getDynamicHeight(size: 0.010)),
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
                  itemCount: treatmentList.length, // Your list of treatments
                  itemBuilder: (context, index) {
                    final item = treatmentList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        // margin: EdgeInsets.symmetric(vertical: 6),
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.primaryColor),
                          borderRadius: BorderRadius.circular(6),
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
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Treatment Date:  ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextSpan(
                                    text: treatmentList[index],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // 🔹 Icons
                            Row(
                              children: [
                                Icon(Icons.remove_red_eye_outlined, size: 20),
                                SizedBox(width: 5),
                                IconButton(
                                    onPressed: () {
                                      controller.medicationbottomsheet(context, index);
                                    },
                                    icon: Icon(Icons.menu, size: 20))
                              ],
                            ),
                          ],
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
            padding: const EdgeInsets.all(8.0),
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

  List<String> treatmentList = [
    "02/06/2025",
    "07/06/2025",
    "15/06/2025",
    "20/06/2025",
    "28/06/2025",
  ];
}

// GestureDetector(
//                 onTap: () {
//                   controller.searchLeaveNameListData = null;
//                   controller.selectOperationName();
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.white,
//                     border: Border.all(
//                       width: 1,
//                       color: ConstColor.borderColor,
//                     ),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: Sizes.crossLength * 0.010,
//                       vertical: Sizes.crossLength * 0.015,
//                     ),
//                     // padding: const EdgeInsets.only(
//                     //     left: 10, right: 10, top: 15, bottom: 15),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Expanded(
//                           child: controller.selectedleaveList.isEmpty
//                               ? Row(
//                                   children: [
//                                     Expanded(
//                                       child: AppText(
//                                         text: 'Select Surgery',
//                                         fontColor: ConstColor.hintTextColor,
//                                       ),
//                                     ),
//                                     // SvgPicture.asset(
//                                     //   ConstAsset.down,
//                                     //   height: 20,
//                                     //   width: 20,
//                                     //   fit: BoxFit.cover,
//                                     // ),
//                                   ],
//                                 )
//                               : Wrap(
//                                   runSpacing: 5,
//                                   spacing: 8,
//                                   children: [
//                                     for (int i = 0; i < controller.selectedleaveList.length; i++)
//                                       Container(
//                                         decoration: BoxDecoration(
//                                             border: Border.all(width: 1, color: ConstColor.hintTextColor),
//                                             borderRadius: BorderRadius.circular(10),
//                                             color: Colors.white),
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(left: 7, right: 5, top: 5, bottom: 5),
//                                           child: Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Flexible(
//                                                 child: AppText(
//                                                   text: controller.selectedleaveList[i].name ?? '',
//                                                   maxLine: 1,
//                                                   overflow: TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   FocusScope.of(context).unfocus();
//                                                   controller.selectedOperationId.remove(controller.selectedleaveList[i].value.toString());
//                                                   controller.selectedleaveList.remove(controller.selectedleaveList[i]);
//                                                   controller.update();
//                                                 },
//                                                 child: const Icon(
//                                                   Icons.cancel_outlined,
//                                                   size: 20,
//                                                   color: ConstColor.errorBorderColor,
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       )
//                                   ],
//                                 ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
