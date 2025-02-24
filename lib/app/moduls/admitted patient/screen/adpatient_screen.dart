// ignore_for_file: deprecated_member_use

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/admitted%20patient/controller/adpatient_controller.dart';
import 'package:emp_app/app/moduls/admitted%20patient/screen/lab_report_screen.dart';
import 'package:emp_app/app/moduls/admitted%20patient/screen/lab_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdpatientScreen extends StatelessWidget {
  const AdpatientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AdpatientController());
    return GetBuilder<AdpatientController>(
      builder: (controller) {
        return Scaffold(
            backgroundColor: AppColor.white,
            appBar: AppBar(
              backgroundColor: AppColor.white,
              title: Text(
                'Admitted Patients',
                style: TextStyle(
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: CommonFontStyle.plusJakartaSans,
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Get.snackbar(
                        AppString.comingsoon,
                        '',
                        colorText: AppColor.white,
                        backgroundColor: AppColor.black,
                        duration: const Duration(seconds: 1),
                      );
                    },
                    icon: Image.asset(
                      AppImage.notification,
                      width: getDynamicHeight(size: 0.022), //20,
                    ))
              ],
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
                                        // controller.searchController.clear();
                                        // controller.fetchpresViewer(isLoader: false);
                                      },
                                      child: const Icon(Icons.cancel_outlined))
                                  : const SizedBox(),
                              prefixIcon: Icon(Icons.search, color: AppColor.lightgrey1),
                              hintText: AppString.searchpatient,
                              hintStyle: AppStyle.plusgrey,
                              filled: true,
                              fillColor: AppColor.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(getDynamicHeight(size: 0.027))),
                              ),
                            ),
                            onTap: () {
                              // controller.showShortButton = false;
                              // controller.update();
                            },
                            onChanged: (value) {
                              // controller.filterSearchResults(value);
                              // controller.searchController.clear();
                            },
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                              // Future.delayed(const Duration(milliseconds: 300));
                              // controller.showShortButton = true;
                              // controller.update();
                            },
                            onFieldSubmitted: (v) {
                              // if (controller.searchController.text.trim().isNotEmpty) {
                              //   controller.fetchpresViewer(
                              //     searchPrefix: controller.searchController.text.trim(),
                              //     isLoader: false,
                              //   );
                              //   controller.searchController.clear();
                              // }
                              // Future.delayed(const Duration(milliseconds: 800));
                              // controller.showShortButton = true;
                              // controller.update();
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: getDynamicHeight(size: 0.010)), // Space between items
                      Expanded(
                        flex: 1.5.toInt(),
                        child: Container(
                          height: getDynamicHeight(size: 0.052), // Adjust height as needed
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.black),
                            borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.012)),
                          ),
                          child: Center(
                              child: GestureDetector(
                                  onTap: () {},
                                  child: Image.asset(
                                    AppImage.filter,
                                  ))),
                        ),
                      ),
                      SizedBox(width: getDynamicHeight(size: 0.010)), // Space between items
                      Expanded(
                        flex: 1.5.toInt(),
                        child: Container(
                          // height: 50, // Adjust height as needed
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.black),
                            borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.012)),
                          ),
                          child: Center(
                            child: IconButton(
                              icon: Icon(Icons.filter_alt, color: AppColor.black, size: getDynamicHeight(size: 0.027)),
                              onPressed: () async {
                                controller.callFilterAPi = false;
                                controller.tempOrgsList = List.unmodifiable(controller.selectedorgsList);
                                controller.tempFloorsList = List.unmodifiable((controller.selectedFloorsList));
                                controller.tempWardList = List.unmodifiable(controller.selectedwardsList);

                                controller.AdpatientFiltterBottomSheet();
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
                    padding: EdgeInsets.all(10),
                    itemCount: controller.patients.length,
                    itemBuilder: (context, index) {
                      return _buildPatientCard(index);
                    },
                  ),
                ),
              ],
            ));
      },
    );
  }

  Widget _buildPatientCard(int index) {
    return GetBuilder<AdpatientController>(
        builder: (controller) => controller.patientdata.isNotEmpty
            ? Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.patientdata[index].bedNo.toString(),
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            controller.patientdata[index].ipdNo.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            controller.patientdata[index].floor.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),

                    // Patient Details
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller.patientdata[index].patientName.toString(),
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.primaryColor),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  customButton: Icon(Icons.menu, color: Colors.black),
                                  items: ["Lab Summary", "Lab Report"].map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item, style: TextStyle(fontSize: 14)),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    if (value == "Lab Summary") {
                                      Get.to(LabSummaryScreen());
                                    } else if (value == "Lab Report") {
                                      Get.to(LabReportScreen());
                                    }
                                  },
                                  dropdownStyleData: DropdownStyleData(
                                    width: 150, padding: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                    ),
                                    // offset: Offset(10, 5), // ✅ Dropdown menu exact menu end se start hoga
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.patientdata[index].admType.toString(),
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Text.rich(TextSpan(
                                    text: 'DOA: ',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                        text: controller.patientdata[index].doa.toString(),
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                                  // Text(controller.filterpatientdata[index].doa.toString()),
                                ],
                              ),
                              Spacer(), // 🟢 Yeh `referredDr` ko center lane me help karega
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center, // ✅ Yeh text ko center karega
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    controller.patientdata[index].referredDr.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Text.rich(TextSpan(
                                    text: 'Total Days: ',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                        text: controller.patientdata[index].totalDays.toString(),
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                                  // Text(controller.filterpatientdata[index].totalDays.toString(), textAlign: TextAlign.center),
                                ],
                              ),
                              Spacer(), // 🟢 Yeh dono columns ke beech equal space dega
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Text(
                "No Patients Available",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
              )));
  }

  // Widget _buildPatientCard(Map<String, dynamic> patient) {
  //   return GetBuilder<AdpatientController>(
  //     builder: (controller) {
  //       return Card(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         margin: EdgeInsets.symmetric(vertical: 8),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // Top Header
  //             Container(
  //               decoration: BoxDecoration(
  //                 color: Colors.teal,
  //                 borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
  //               ),
  //               padding: EdgeInsets.all(8),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     patient["room"],
  //                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  //                   ),
  //                   Text(
  //                     patient["id"],
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                   Text(
  //                     patient["floor"],
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                 ],
  //               ),
  //             ),

  //             // Patient Details
  //             Padding(
  //               padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(
  //                         patient["name"],
  //                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
  //                       ),
  //                       IconButton(
  //                           onPressed: () {
  //                             // DropdownButton2 on Menu Icon
  //                             DropdownButtonHideUnderline(
  //                                 child: DropdownButton2<String>(
  //                               customButton: Icon(Icons.menu, color: Colors.black),
  //                               items: controller.menuItems.map((String item) {
  //                                 return DropdownMenuItem<String>(
  //                                   value: item,
  //                                   child: Text(item, style: TextStyle(fontSize: 14)),
  //                                 );
  //                               }).toList(),
  //                               onChanged: (String? value) {
  //                                 if (value == "View") {
  //                                   print("View Patient: ${patient["name"]}");
  //                                 } else if (value == "Edit") {
  //                                   print("Edit Patient: ${patient["name"]}");
  //                                 } else if (value == "Delete") {
  //                                   print("Delete Patient: ${patient["name"]}");
  //                                 }
  //                               },
  //                               dropdownStyleData: DropdownStyleData(
  //                                 width: 120,
  //                                 decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(8),
  //                                   color: Colors.white,
  //                                 ),
  //                               ),
  //                             ));
  //                           },
  //                           icon: Icon(Icons.menu))
  //                     ],
  //                   ),

  //                   // Doctor Name & Total Days in a Row
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             patient["payment"],
  //                           ),
  //                           SizedBox(height: 5),
  //                           Text(
  //                             patient["doa"],
  //                           ),
  //                         ],
  //                       ),
  //                       Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(patient["doctor"]), // Doctor's Name
  //                           SizedBox(height: 5),
  //                           Text("${patient["days"]}"), // Total Days
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
