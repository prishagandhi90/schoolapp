// ignore_for_file: deprecated_member_use

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/admitted%20patient/controller/adpatient_controller.dart';
import 'package:emp_app/app/moduls/admitted%20patient/controller/labreport_controller.dart';
import 'package:emp_app/app/moduls/admitted%20patient/screen/lab_reports_view_copy.dart';
import 'package:emp_app/app/moduls/admitted%20patient/screen/lab_summary_screen.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class AdpatientScreen extends StatelessWidget {
  const AdpatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AdPatientController());
    return GetBuilder<AdPatientController>(
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
              leading: IconButton(
                  onPressed: () {
                    final bottomBarController = Get.find<BottomBarController>();
                    bottomBarController.isAdmittedPatient.value = true;
                    controller.searchController.clear(); // Search text clear karna
                    controller.activateSearch(false); // Search mode deactivate karna
                    print("After reset: sortBySelected = ${controller.sortBySelected}");
                    controller.sortBySelected = null;
                    controller.update();

                    // **Fresh Data fetch karna**
                    controller.fetchDeptwisePatientList();

                    Navigator.pop(context); // UI ko refresh karna
                  },
                  icon: Icon(Icons.arrow_back_ios, color: AppColor.black)),
            ),
            body: controller.isLoading
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: getDynamicHeight(size: 0.102),
                    ),
                    child: Center(child: ProgressWithIcon()),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      if (controller.sortBySelected != null) {
                        await controller.getSortData(isLoader: true);
                        return;
                      }
                      await controller.fetchDeptwisePatientList();
                    },
                    child: SizedBox(
                      // height: MediaQuery.of(context).size.height * 0.82,
                      child: Column(
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
                                                  controller.searchController.clear();
                                                  controller.fetchDeptwisePatientList(isLoader: false);
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
                                        controller.filterSearchResults(value);
                                        // controller.searchController.clear();
                                      },
                                      onTapOutside: (event) {
                                        FocusScope.of(context).unfocus();
                                        Future.delayed(const Duration(milliseconds: 300));
                                        controller.update();
                                      },
                                      onFieldSubmitted: (v) {
                                        if (controller.searchController.text.trim().isNotEmpty) {
                                          controller.fetchDeptwisePatientList(
                                            searchPrefix: controller.searchController.text.trim(),
                                            isLoader: false,
                                          );
                                          controller.searchController.clear();
                                        }
                                        Future.delayed(const Duration(milliseconds: 800));
                                        controller.update();
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
                                            onTap: () {
                                              controller.sortBy();
                                            },
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
                                          controller.tempOrgsList = List.unmodifiable(controller.selectedOrgsList);
                                          controller.tempFloorsList = List.unmodifiable((controller.selectedFloorsList));
                                          controller.tempWardList = List.unmodifiable(controller.selectedWardsList);

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
                              controller: controller.adPatientScrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.all(10),
                              itemCount: controller.filterpatientsData.length,
                              itemBuilder: (context, index) {
                                return _buildPatientCard(index, context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
      },
    );
  }

  Widget _buildPatientCard(int index, BuildContext context) {
    return GetBuilder<AdPatientController>(
      builder: (controller) => controller.filterpatientsData.isNotEmpty
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
                          controller.filterpatientsData[index].bedNo.toString(),
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          controller.filterpatientsData[index].ipdNo.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          controller.filterpatientsData[index].floor.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                controller.filterpatientsData[index].patientName.toString(),
                                maxLines: 2,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.primaryColor,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            SizedBox(
                              width: 40,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  customButton: Icon(Icons.menu, color: Colors.black),
                                  items: ["Lab Summary", "Lab Report"].map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item, style: TextStyle(fontSize: 14)),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) async {
                                    if (value == "Lab Summary") {
                                      // Get.to(LabSummaryScreen());
                                      var adPatientController = Get.put(AdPatientController());
                                      adPatientController.ipdNo = controller.filterpatientsData[index].ipdNo ?? '';
                                      adPatientController.uhid = controller.filterpatientsData[index].uhid ?? '';
                                      adPatientController.update();
                                      await adPatientController.fetchsummarylabdata();
                                      Get.to(() => LabSummaryScreen());
                                    } else if (value == "Lab Report") {
                                      // Get.to(LabReportScreen());
                                      var labreportsController = Get.put(LabReportsController());
                                      labreportsController.showSwipe = true;
                                      hideBottomBar.value = true;
                                      labreportsController.labReportsList = [];
                                      labreportsController.allReportsList = [];
                                      labreportsController.allDatesList = [];
                                      labreportsController.update();
                                      labreportsController.showSwipe = true;
                                      hideBottomBar.value = true;
                                      labreportsController.getLabReporst(
                                          ipdNo: controller.filterpatientsData[index].ipdNo ?? '', uhidNo: controller.filterpatientsData[index].uhid ?? '');
                                      labreportsController.commonList = [];
                                      labreportsController.dataContain = [];
                                      labreportsController.scrollLister();
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: LabReportsViewCopy(
                                          bedNumber: controller.filterpatientsData[index].bedNo ?? '',
                                          patientName: controller.filterpatientsData[index].patientName ?? "",
                                        ),
                                        withNavBar: true,
                                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                      ).then((value) {
                                        hideBottomBar.value = true;
                                      });
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
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.filterpatientsData[index].admType.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text.rich(TextSpan(
                                  text: 'DOA: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(
                                      text: controller.filterpatientsData[index].doa.toString(),
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
                                  controller.filterpatientsData[index].referredDr.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text.rich(TextSpan(
                                  text: 'Total Days: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(
                                      text: controller.filterpatientsData[index].totalDays.toString(),
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
              ),
            ),
    );
  }
}
