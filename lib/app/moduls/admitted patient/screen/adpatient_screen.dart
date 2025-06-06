import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/admitted%20patient/controller/adpatient_controller.dart';
import 'package:emp_app/app/moduls/admitted%20patient/controller/labreport_controller.dart';
import 'package:emp_app/app/moduls/admitted%20patient/screen/lab_reports_view.dart';
import 'package:emp_app/app/moduls/admitted%20patient/screen/lab_summary_screen.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/admitted%20patient/screen/speechtotext_screen.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/moduls/invest_requisit/controller/invest_requisit_controller.dart';
import 'package:emp_app/app/moduls/notification/screen/notification_screen.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class AdpatientScreen extends StatelessWidget {
  AdpatientScreen({super.key});
  final adPatientController = Get.find<AdPatientController>();
  final dashboardController = Get.find<DashboardController>();
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
                AppString.admittedPatient,
                style: AppStyle.primaryplusw700,
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: NotificationScreen(),
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      ).then((value) async {
                        Get.back();
                        await adPatientController.fetchDeptwisePatientList();
                        // var dashboardController = Get.put(DashboardController());
                        await dashboardController.getDashboardDataUsingToken();
                        var bottomBarController = Get.find<BottomBarController>();
                        bottomBarController.currentIndex.value = 0;
                        bottomBarController.persistentController.value.index = 0;
                        bottomBarController.isIPDHome.value = true;
                        hideBottomBar.value = false;
                      });
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Image.asset(
                          AppImage.notification,
                          width: getDynamicHeight(size: 0.022),
                        ),
                        if (dashboardController.notificationCount != "0") // 👈 Condition lagayi
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
                ),
              ],
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    final bottomBarController = Get.find<BottomBarController>();
                    bottomBarController.isIPDHome.value = true;
                    controller.searchController.clear(); // Search text clear karna
                    controller.activateSearch(false); // Search mode deactivate karna
                    // print("After reset: sortBySelected = ${controller.sortBySelected}");
                    controller.sortBySelected = null;
                    controller.update();

                    // **Fresh Data fetch karna**
                    controller.fetchDeptwisePatientList(); // Fetch data from server
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
                                            child: Image.asset(AppImage.filter))),
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
                                return _buildPatientCard(index, context, controller);
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

  Widget _buildPatientCard(int index, BuildContext context, AdPatientController controller) {
    return controller.filterpatientsData.isNotEmpty
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
                        style: TextStyle(color: AppColor.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        controller.filterpatientsData[index].ipdNo.toString(),
                        style: TextStyle(color: AppColor.white),
                      ),
                      Text(
                        controller.filterpatientsData[index].floor.toString(),
                        style: TextStyle(color: AppColor.white),
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
                                fontSize: Sizes.px16,
                                fontWeight: FontWeight.bold,
                                color: AppColor.primaryColor,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                          SizedBox(width: getDynamicHeight(size: 0.010)),
                          GestureDetector(
                            onTap: () {
                              controller.ipdNo = controller.filterpatientsData[index].ipdNo ?? '';
                              controller.uhid = controller.filterpatientsData[index].uhid ?? '';
                              controller.patientName = controller.filterpatientsData[index].patientName ?? '';
                              controller.bedNo = controller.filterpatientsData[index].bedNo ?? '';
                              controller.update();
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: VoiceScreen(),
                                withNavBar: false,
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              );
                            },
                            child: const Icon(Icons.mic_none_rounded),
                          ),
                          SizedBox(width: getDynamicHeight(size: 0.010)),
                          SizedBox(
                            width: getDynamicHeight(size: 0.040),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                  customButton: Icon(Icons.menu, color: AppColor.black),
                                  items: [
                                    _buildMenuItem("Lab Summary"),
                                    _buildDivider(),
                                    _buildMenuItem("Lab Reports"),
                                    _buildDivider(),
                                    _buildMenuItem("Investigation Requisition"),
                                    _buildDivider(),
                                    _buildMenuItem("Investigation History"),
                                  ],
                                  onChanged: (String? value) async {
                                    if (value == "Lab Summary") {
                                      // Get.dialog(
                                      //   Center(child: ProgressWithIcon()),
                                      //   barrierDismissible: false,
                                      // );
                                      controller.ipdNo = controller.filterpatientsData[index].ipdNo ?? '';
                                      controller.uhid = controller.filterpatientsData[index].uhid ?? '';
                                      controller.update();

                                      Future.microtask(() async {
                                        controller.fetchsummarylabdata();
                                        await controller.resetForm();
                                      });
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: LabSummaryScreen(),
                                        withNavBar: false,
                                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                      ).then((value) async {
                                        Future.microtask(() async {
                                          if (controller.sortBySelected != null) {
                                            await controller.getSortData(isLoader: true);
                                            return;
                                          }
                                          await controller.fetchDeptwisePatientList();
                                        });
                                      });
                                    } else if (value == "Lab Report") {
                                      var labreportsController = Get.put(LabReportsController());
                                      labreportsController.showSwipe = true;
                                      hideBottomBar.value = true;
                                      labreportsController.labReportsList = [];
                                      labreportsController.allReportsList = [];
                                      labreportsController.allDatesList = [];
                                      labreportsController.update();
                                      labreportsController.getLabReporst(
                                        ipdNo: controller.filterpatientsData[index].ipdNo ?? '',
                                        uhidNo: controller.filterpatientsData[index].uhid ?? '',
                                      );
                                      labreportsController.commonList = [];
                                      labreportsController.dataContain = [];
                                      labreportsController.scrollLister();
                                      await PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: LabReportsView(
                                          bedNumber: controller.filterpatientsData[index].bedNo ?? '',
                                          patientName: controller.filterpatientsData[index].patientName ?? "",
                                          ipdNo: controller.filterpatientsData[index].ipdNo ?? '',
                                          uhidNo: controller.filterpatientsData[index].uhid ?? '',
                                        ),
                                        withNavBar: false,
                                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                      ).then((value) async {
                                        if (controller.sortBySelected != null) {
                                          await controller.getSortData(isLoader: true);
                                          return;
                                        }
                                        await controller.fetchDeptwisePatientList();
                                      });
                                    } else if (value == "Investigation Requisition") {
                                      if (controller.isInvestigationReq_Navigating.value) return;
                                      controller.isInvestigationReq_Navigating.value = true;

                                      if (controller.screenRightsTable.isNotEmpty) {
                                        if (controller.screenRightsTable[1].rightsYN == "N") {
                                          controller.isInvestigationReq_Navigating.value = false;
                                          Get.snackbar(
                                            "You don't have access to this screen",
                                            '',
                                            colorText: AppColor.white,
                                            backgroundColor: AppColor.black,
                                            duration: const Duration(seconds: 1),
                                          );
                                          return;
                                        }
                                      }

                                      final investRequisitController = Get.put(InvestRequisitController());
                                      String patientDetails = '${controller.filterpatientsData[index].patientName} | '
                                          '${controller.filterpatientsData[index].ipdNo} | '
                                          '${controller.filterpatientsData[index].uhid}';

                                      // investRequisitController.mobileController.clear();
                                      // investRequisitController.passwordController.clear();
                                      await investRequisitController.resetForm();
                                      investRequisitController.loginAlertDialog(
                                        fromScreen: ScreenType.AdpatientScreen,
                                        context,
                                        "INVESTIGATION REQUISITION",
                                        patientDetails,
                                        controller.filterpatientsData[index].ipdNo ?? "",
                                        controller.filterpatientsData[index].uhid ?? "",
                                      );
                                      controller.isInvestigationReq_Navigating.value = false;
                                    } else if (value == "Investigation History") {
                                      if (controller.isInvestigationReq_Navigating.value) return;
                                      controller.isInvestigationReq_Navigating.value = true;

                                      if (controller.screenRightsTable.isNotEmpty) {
                                        if (controller.screenRightsTable[1].rightsYN == "N") {
                                          controller.isInvestigationReq_Navigating.value = false;
                                          Get.snackbar(
                                            "You don't have access to this screen",
                                            '',
                                            colorText: AppColor.white,
                                            backgroundColor: AppColor.black,
                                            duration: const Duration(seconds: 1),
                                          );
                                          return;
                                        }
                                      }

                                      final investRequisitController = Get.put(InvestRequisitController());
                                      String patientDetails = '${controller.filterpatientsData[index].patientName} | '
                                          '${controller.filterpatientsData[index].ipdNo} | '
                                          '${controller.filterpatientsData[index].uhid}';

                                      // investRequisitController.mobileController.clear();
                                      // investRequisitController.passwordController.clear();
                                      await investRequisitController.resetForm();
                                      // investRequisitController.HistoryBottomSheet();
                                      investRequisitController.loginAlertDialog(
                                        fromScreen: ScreenType.InvestRequisitScreen,
                                        context,
                                        "INVESTIGATION HISTORY",
                                        patientDetails,
                                        controller.filterpatientsData[index].ipdNo ?? "",
                                        controller.filterpatientsData[index].uhid ?? "",
                                      );
                                      controller.isInvestigationReq_Navigating.value = false;
                                    }
                                  },
                                  dropdownStyleData: DropdownStyleData(
                                    width: getDynamicHeight(size: 0.22), // 👈 wider dropdown dynamically
                                    padding: EdgeInsets.symmetric(
                                      vertical: getDynamicHeight(size: 0.004),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        getDynamicHeight(size: 0.007),
                                      ),
                                      color: AppColor.white,
                                    ),
                                    elevation: 4,
                                  ),
                                  menuItemStyleData: MenuItemStyleData(
                                    height: getDynamicHeight(size: 0.020), // 👈 shorter item height dynamically
                                    padding: EdgeInsets.symmetric(
                                      horizontal: getDynamicHeight(size: 0.02),
                                    ),
                                  )),
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
                              SizedBox(
                                height: getDynamicHeight(size: 0.004),
                              ),
                              Text.rich(TextSpan(
                                text: AppString.doa,
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
                              SizedBox(
                                height: getDynamicHeight(size: 0.004),
                              ),
                              Text.rich(TextSpan(
                                text: AppString.totaldays,
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
              AppString.nopatientavaiable,
              style: TextStyle(fontSize: Sizes.px16, fontWeight: FontWeight.bold, color: AppColor.red1),
            ),
          );
  }

  DropdownMenuItem<String> _buildMenuItem(String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(
        value,
        style: TextStyle(fontSize: Sizes.px14, color: AppColor.black),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  DropdownMenuItem<String> _buildDivider() {
    return DropdownMenuItem<String>(
      enabled: false,
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.black,
      ),
    );
  }
}
