// ignore_for_file: must_be_immutable

import 'package:emp_app/app/app_custom_widget/common_methods.dart';
import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/searchservice_model.dart';
import 'package:emp_app/app/moduls/leave/screen/widget/custom_textformfield.dart';
import 'package:emp_app/app/moduls/medication_sheet/controller/medicationsheet_controller.dart';
import 'package:emp_app/app/moduls/notification/screen/notification_screen.dart';
import 'package:emp_app/app/moduls/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MedicationScreen extends StatelessWidget {
  MedicationScreen({Key? key}) : super(key: key);
  final dashboardController = Get.isRegistered<DashboardController>() ? Get.find<DashboardController>() : Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    Get.put(MedicationsheetController());

    return GetBuilder<MedicationsheetController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(
            title: Text(AppString.medicationsheet, style: AppStyle.primaryplusw700),
            backgroundColor: AppColor.white,
            centerTitle: true,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 13),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Filter icon
                    GestureDetector(
                      onTap: () {
                        controller.showSortFilterBottomSheet(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 10), // 👈 Minimal spacing between icons
                        child: Icon(
                          Icons.filter_alt,
                          color: AppColor.black,
                          size: getDynamicHeight(size: 0.024),
                        ),
                      ),
                    ),
                    // Notification icon with badge
                    GestureDetector(
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: NotificationScreen(),
                          withNavBar: false,
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        ).then((value) async {
                          // Navigator.pop(context);
                          // Get.back();
                          // await controller.fetchDrTreatmentData(ipdNo: controller.ipdNo.toString(), treatTyp: 'Medication Sheet');
                          // await dashboardController.getDashboardDataUsingToken();
                          // var bottomBarController = Get.find<BottomBarController>();
                          // bottomBarController.currentIndex.value = 0;
                          // bottomBarController.persistentController.value.index = 0;
                          // bottomBarController.isIPDHome.value = true;
                          // hideBottomBar.value = false;
                        });
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Image.asset(
                            AppImage.notification,
                            width: getDynamicHeight(size: 0.022),
                          ),
                          if (dashboardController.notificationCount != "0")
                            Positioned(
                              right: -2,
                              top: -6,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  dashboardController.notificationCount,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: controller.isLoading
              ? Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: getDynamicHeight(size: 0.102),
                  ),
                  child: Center(child: ProgressWithIcon()),
                )
              : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(getDynamicHeight(size: 0.012)),
                      child: Row(
                        children: [
                          // Search Bar (60%)
                          Expanded(
                            // flex: 7,
                            // ignore: deprecated_member_use
                            child: WillPopScope(
                              onWillPop: () async {
                                // Unfocus the TextFormField and dismiss the keyboard
                                FocusScope.of(context).unfocus();
                                return true; // Allow navigation to go back
                              },
                              // child: CustomAutoComplete<SearchserviceModel>(
                              //   controller: controller.nameController,
                              //   maxLines: null,
                              //   minLines: 1,
                              //   hintText: AppString.patientuhidipd,
                              //   fromAdmittedScreen: controller.fromAdmittedScreen,
                              //   hintStyle: AppStyle.grey.copyWith(
                              //     fontSize: getDynamicHeight(size: 0.012),
                              //   ),
                              //   displayStringForOption: (SearchserviceModel option) => option.txt ?? '',
                              //   optionsBuilder: (TextEditingValue textEditingValue) async {
                              //     if (textEditingValue.text.trim().isEmpty) {
                              //       controller.suggestions.clear();
                              //       return const Iterable<SearchserviceModel>.empty();
                              //     }
                              //     await controller.getSuggestions(textEditingValue.text);
                              //     return controller.suggestions;
                              //   },
                              //   onSelected: (SearchserviceModel selection) async {
                              //     controller.nameController.text = selection.txt ?? '';
                              //     controller.ipdNo = selection.name ?? '';
                              //     controller.uhid = controller.getUHId(selection.txt ?? '');
                              //     controller.suggestions.clear();
                              //     controller.isLoading = true;
                              //     // controller.update();
                              //     await controller.fetchDrTreatmentData(ipdNo: selection.name ?? '', treatTyp: 'Medication Sheet', isload: false);
                              //   },
                              //   onClearSuggestions: () {
                              //     controller.suggestions.clear();
                              //   },
                              //   onSuffixIconPressed: () {
                              //     controller.nameController.clear();
                              //     controller.suggestions.clear();
                              //     controller.ipdNo = '';
                              //     controller.drTreatMasterList.clear();
                              //     SchedulerBinding.instance.addPostFrameCallback((_) {
                              //       controller.update();
                              //     });
                              //   },
                              // ),
                              child: Autocomplete<SearchserviceModel>(
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
                                    // controller.update();
                                    controller.searchFocusNode.unfocus();
                                    controller.nameController.text = selection.txt ?? '';
                                    controller.ipdNo = selection.name ?? '';
                                    controller.uhid = controller.getUHId(selection.txt ?? '');
                                    controller.suggestions.clear();

                                    controller.isLoading = true;
                                    // controller.update();
                                    await controller.fetchDrTreatmentData(
                                      ipdNo: selection.name ?? '',
                                      treatTyp: 'Medication Sheet',
                                      isload: false,
                                    );
                                  },
                                  fieldViewBuilder: (context, nameController, focusNode, onEditingComplete) {
                                    final effectiveController = controller.nameController.text.isNotEmpty && controller.fromAdmittedScreen
                                        ? controller.nameController
                                        : nameController;
                                    controller.setFocusNode(focusNode);
                                    return CustomTextFormField(
                                      controller: effectiveController,
                                      focusNode: focusNode,
                                      style: TextStyle(fontSize: getDynamicHeight(size: 0.014)),
                                      // readOnly: controller.nameController.text.isNotEmpty &&
                                      //     controller.fromAdmittedScreen, // 👈 make readonly if patientname passed
                                      minLines: 1,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        hintText: AppString.patientuhidipd,
                                        isDense: true,
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: controller.nameController.text.isNotEmpty ? AppColor.black : AppColor.red,
                                            width: getDynamicHeight(size: 0.03),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          borderSide:
                                              BorderSide(color: controller.nameController.text.isNotEmpty ? AppColor.black : AppColor.red),
                                        ),
                                        prefixIcon: Icon(Icons.search, color: AppColor.lightgrey1),
                                        suffixIcon: nameController.text.isNotEmpty || controller.nameController.text.isNotEmpty
                                            ? IconButton(
                                                icon: Icon(Icons.cancel_outlined, color: AppColor.black),
                                                onPressed: () {
                                                  focusNode.unfocus();
                                                  controller.nameController.clear();
                                                  nameController.clear();
                                                  controller.suggestions.clear();
                                                  controller.ipdNo = '';
                                                  controller.drTreatMasterList.clear();
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
                                  }),
                            ),
                          ),
                          // 🔽 Same size as IconButton wala niche container
                          // SizedBox(width: getDynamicHeight(size: 0.010)),
                          // Expanded(
                          //   flex: 1.5.toInt(),
                          //   child: Container(
                          //     height: containerHeight,
                          //     decoration: BoxDecoration(
                          //       border: Border.all(color: AppColor.black),
                          //       borderRadius: BorderRadius.circular(
                          //         getDynamicHeight(size: 0.012),
                          //       ),
                          //     ),
                          //     child: Center(
                          //       child: GestureDetector(
                          //         onTap: () {
                          //           controller.sortByBottomSheet();
                          //         },
                          //         child: FittedBox(
                          //           fit: BoxFit.contain,
                          //           child: Image.asset(
                          //             AppImage.filter,
                          //             height: getDynamicHeight(size: 0.02),
                          //             width: getDynamicHeight(size: 0.02),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(width: getDynamicHeight(size: 0.008)),
                          // Expanded(
                          //   flex: 1.5.toInt(),
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //       border: Border.all(color: AppColor.black),
                          //       borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.012)),
                          //     ),
                          //     child: Center(
                          //       child: IconButton(
                          //         icon: Icon(
                          //           Icons.filter_alt,
                          //           color: AppColor.black,
                          //           size: getDynamicHeight(size: 0.027), // 🔁 Same size
                          //         ),
                          //         onPressed: () async {
                          //           controller.showDateBottomSheet(context);
                          //         },
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await controller.fetchDrTreatmentData(
                              ipdNo: controller.ipdNo.toString(), treatTyp: 'Medication Sheet', isload: true);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SlidableAutoCloseBehavior(
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
                                            onPressed: () async {
                                              Slidable.of(context)?.close();
                                              await Future.delayed(Duration(milliseconds: 200));
                                              await controller.editDrTreatmentMasterList(controller.drTreatMasterList[index]);
                                              controller.showMedicationDialog(context, -1);
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
                                            onPressed: () async {
                                              Slidable.of(context)?.close();
                                              await Future.delayed(Duration(milliseconds: 200));
                                              await controller.editDrTreatmentMasterList(controller.drTreatMasterList[index]);
                                              await controller.showMedicationDialog(context, index);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    child: GestureDetector(
                                      onTap: () async {
                                        controller.isLoading = true;
                                        controller.selectedDetailIndex = -1;
                                        controller.clearAddMedication();
                                        // controller.update();
                                        // Get.to(
                                        //   AddMedicationScreen(
                                        //     selectedMasterIndex: index,
                                        //     selectedDetailIndex: -1,
                                        //   ),
                                        // );
                                        Get.toNamed(
                                          Paths.AddMEDICATIONSCREEN,
                                          arguments: {
                                            'selectedMasterIndex': index,
                                            'selectedDetailIndex': -1,
                                          },
                                        );
                                        controller.isLoading = false;
                                        controller.update();
                                      },
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
                                                    text: formatDateTime_dd_MMM_yy_HH_mm(controller.drTreatMasterList[index].date),
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
                                                    onTap: () async {
                                                      if (controller.isViewBtnclicked) return;
                                                      controller.isViewBtnclicked = true;
                                                      controller.isLoading = true;
                                                      controller.update();
                                                      controller.filteredDetails = controller.drTreatMasterList[index].detail;
                                                      controller.selectedMasterIndex = index;
                                                      controller.searchController.clear();
                                                      Get.toNamed(
                                                        Paths.VIEWMEDICATIONSCREEN,
                                                        arguments: {
                                                          'selectedMasterIndex': index,
                                                        },
                                                      );
                                                      // Get.to(ViewMedicationScreen(
                                                      //   selectedMasterIndex: index,
                                                      // ));
                                                      controller.isLoading = false;
                                                      controller.isViewBtnclicked = false;
                                                    },
                                                    child: Icon(
                                                      Icons.remove_red_eye_outlined,
                                                      size: getDynamicHeight(size: 0.021),
                                                    )),
                                                // SizedBox(width: getDynamicHeight(size: 0.002)),
                                                IconButton(
                                                  onPressed: () {
                                                    if (controller.isMenuBtnclicked) return;
                                                    controller.isMenuBtnclicked = true;
                                                    controller.medicationbottomsheet(context, index);
                                                    controller.isMenuBtnclicked = false;
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
                      ),
                    ),
                  ],
                ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColor.teal1,
            onPressed: () {
              if (controller.isPlusBtnclicked) return;
              controller.isPlusBtnclicked = true;
              controller.isTemplateVisible = true;
              controller.showMedicationDialog(context, -1);
              controller.isPlusBtnclicked = false;
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
                  controller.webUserName,
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
