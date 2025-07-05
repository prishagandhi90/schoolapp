import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/IPD/admitted%20patient/controller/adpatient_controller.dart';
import 'package:emp_app/app/moduls/IPD/dietician_checklist/screen/dietician_checklist_screen.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/moduls/IPD/invest_requisit/controller/invest_requisit_controller.dart';
import 'package:emp_app/app/moduls/notification/screen/notification_screen.dart';
import 'package:emp_app/app/moduls/routes/app_pages.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class IpdDashboardScreen extends StatelessWidget {
  IpdDashboardScreen({Key? key}) : super(key: key);

  final adPatientController = Get.put(AdPatientController());

  @override
  Widget build(BuildContext context) {
    late final DashboardController dashboardController;
    try {
      // Try to find the existing controller
      dashboardController = Get.find<DashboardController>();
    } catch (e) {
      // Agar controller nahi milta to put karenge
      dashboardController = Get.put(DashboardController());
    }
    return GetBuilder<AdPatientController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.white,
          drawer: Drawer(
            backgroundColor: AppColor.white,
            child: ListView(
              children: [
                Padding(padding: EdgeInsets.symmetric(vertical: getDynamicHeight(size: 0.022))),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.012)),
                  child: TextFormField(
                    focusNode: controller.focusNode,
                    cursorColor: AppColor.grey,
                    controller: controller.textEditingController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.lightgrey1, width: 1.0),
                        borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.027)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.027)),
                        borderSide: BorderSide(
                          color: AppColor.lightgrey1,
                        ),
                      ),
                      prefixIcon: Icon(Icons.search, color: AppColor.lightgrey1),
                      suffixIcon: controller.hasFocus
                          ? IconButton(
                              icon: Icon(
                                Icons.cancel_outlined,
                                color: AppColor.lightgrey1,
                              ),
                              onPressed: () {
                                controller.textEditingController.clear();
                                controller.filterSearchAdPatientResults('');
                              },
                            )
                          : null,
                      hintText: AppString.search,
                      hintStyle: TextStyle(
                        color: AppColor.lightgrey1,
                        fontFamily: CommonFontStyle.plusJakartaSans,
                      ),
                      filled: true,
                      focusColor: AppColor.originalgrey,
                      fillColor: AppColor.white,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                    ),
                    onChanged: (value) {
                      controller.filterSearchAdPatientResults(value);
                    },
                  ),
                ),
                GetBuilder<AdPatientController>(
                  builder: (controller) {
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: getDynamicHeight(size: 0.032)),
                      shrinkWrap: true,
                      itemCount: controller.filteredList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            controller.drawerListInClk(context, index);
                          },
                          child: SizedBox(
                            height: getDynamicHeight(size: 0.050),
                            child: ListTile(
                              leading: Image.asset(
                                controller.filteredList[index]['image'],
                                height: getDynamicHeight(size: 0.027),
                                width: getDynamicHeight(size: 0.027),
                                color: AppColor.primaryColor,
                              ),
                              title: Text(
                                controller.filteredList[index]['label'],
                                style: TextStyle(
                                  // fontSize: 16.0,
                                  fontSize: controller.getResponsiveFontSize(context, 16),
                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                ),
                                maxLines: 2,
                              ),
                              trailing: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    controller.drawerListInClk(context, index);
                                  },
                                  icon: const Icon(Icons.arrow_forward_ios)),
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
          appBar: AppBar(
            title: Text(AppString.ipd, style: AppStyle.primaryplusw700),
            backgroundColor: AppColor.white,
            centerTitle: true,
            leading: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Image.asset(
                    AppImage.drawer,
                    width: getDynamicHeight(size: 0.022),
                    color: AppColor.black,
                  ),
                );
              },
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
                      // 🔹 Show red badge if there are new notifications
                      if (dashboardController.notificationCount != "0") // 👈 Condition lagayi
                        Positioned(
                          right: -2,
                          top: -6,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColor.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              dashboardController.notificationCount,
                              style: TextStyle(
                                color: AppColor.white,
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
          ),
          body: GetBuilder<AdPatientController>(
            builder: (controller) {
              if (controller.isLoading) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: getDynamicHeight(size: 0.102),
                  ),
                  child: Center(child: CircularProgressIndicator()),
                ); // 🔹 Jab tak data load ho raha hai
              }
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      _buildPatientCard(
                        title: AppString.admittedPatient,
                        count: controller.patientsData.length,
                        context: context,
                        index: index,
                        leading: Image.asset(
                          AppImage.adpatient, // ye ab string ke jagah asset ban gaya
                          height: Sizes.px40,
                          width: Sizes.px40,
                          fit: BoxFit.contain,
                          color: AppColor.teal, // optional
                        ),
                        onTap: () {
                          if (controller.isAdmittedPatients_Navigating.value) return;
                          controller.isAdmittedPatients_Navigating.value = true;

                          if (controller.screenRightsTable.isNotEmpty) {
                            if (controller.screenRightsTable[0].rightsYN == "N") {
                              controller.isAdmittedPatients_Navigating.value = false;
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

                          controller.FromScreen_Redirection = "";
                          controller.WebLoginUser = "";
                          controller.update();

                          // Get.to(() => AdpatientScreen())!.then((value) async {
                          Get.toNamed(Paths.IPDADMITTEDPATIENTS)!.then((value) async {
                            final controller = Get.put(AdPatientController());
                            controller.sortBySelected = -1;
                            await controller.resetForm();
                            await controller.fetchData();
                            final bottomBarController = Get.find<BottomBarController>();
                            bottomBarController.currentIndex.value = 0;
                            bottomBarController.isIPDHome.value = true;
                            hideBottomBar.value = false;
                            var dashboardController = Get.put(DashboardController());
                            await dashboardController.getDashboardDataUsingToken();
                          });

                          // PersistentNavBarNavigator.pushNewScreen(
                          //   context,
                          //   screen: AdpatientScreen(),
                          //   withNavBar: false,
                          //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          // ).then((value) async {
                          //   final controller = Get.put(AdPatientController());
                          //   controller.sortBySelected = -1;
                          //   await controller.resetForm();
                          //   await controller.fetchData();
                          //   final bottomBarController = Get.find<BottomBarController>();
                          //   bottomBarController.currentIndex.value = 0;
                          //   bottomBarController.isIPDHome.value = true;
                          //   hideBottomBar.value = false;
                          //   var dashboardController = Get.put(DashboardController());
                          //   await dashboardController.getDashboardDataUsingToken();
                          // });
                          controller.isAdmittedPatients_Navigating.value = false;
                        },
                      ),
                      _buildPatientCard(
                        title: 'Investigation Requisition',
                        // count: controller.patientsData.length,
                        // context: context,
                        // index: index,
                        leading: Image.asset(
                          AppImage.investrequisite, // ye ab string ke jagah asset ban gaya
                          height: Sizes.px40,
                          width: Sizes.px40,
                          fit: BoxFit.contain,
                          color: AppColor.teal, // optional
                        ),
                        onTap: () async {
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
                          controller.FromScreen_Redirection = "";
                          controller.WebLoginUser = "";
                          controller.update();
                          final envReqController = Get.put(InvestRequisitController());
                          await envReqController.resetForm();
                          // ⬇️ Call the dialog function directly

                          await envReqController.loginAlertDialog(
                            fromScreen: "INVESTIGATION REQUISITION",
                            context,
                            "INVESTIGATION REQUISITION",
                            "",
                            "",
                            "",
                            fromScreenRedirection: "INVESTIGATION REQUISITION",
                          );

                          // ⬇️ Ye tab chalega jab dialog band ho jayega
                          // final controller = Get.put(AdPatientController());
                          controller.sortBySelected = -1;
                          await controller.resetForm();
                          await controller.fetchData();
                          controller.isInvestigationReq_Navigating.value = false;
                        },
                      ),
                      _buildPatientCard(
                        title: 'Medication Sheet',
                        // count: controller.patientsData.length,
                        // context: context,
                        // index: index,
                        leading: Image.asset(
                          AppImage.medication, // ye ab string ke jagah asset ban gaya
                          height: Sizes.px40,
                          width: Sizes.px40,
                          fit: BoxFit.contain,
                          color: AppColor.teal, // optional
                        ),
                        onTap: () async {
                          if (controller.isInvestigationReq_Navigating.value) return;
                          controller.isInvestigationReq_Navigating.value = true;

                          if (controller.screenRightsTable.isNotEmpty) {
                            if (controller.screenRightsTable[2].rightsYN == "N") {
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
                          controller.FromScreen_Redirection = "";
                          controller.WebLoginUser = "";
                          controller.update();
                          final envReqController = Get.put(InvestRequisitController());
                          await envReqController.resetForm();
                          // ⬇️ Call the dialog function directly
                          await envReqController.loginAlertDialog(
                            context,
                            "MEDICATION SHEET",
                            "",
                            "",
                            "",
                            fromScreen: "MEDICATION SHEET",
                            fromScreenRedirection: "MEDICATION SHEET",
                          );
                          // ⬇️ Ye tab chalega jab dialog band ho jayega
                          // final controller = Get.put(AdPatientController());
                          controller.sortBySelected = -1;
                          await controller.resetForm();
                          await controller.fetchData();
                          controller.isInvestigationReq_Navigating.value = false;
                        },
                      ),
                      _buildPatientCard(
                        title: 'Dietician Checklist',
                        // count: controller.patientsData.length,
                        // context: context,
                        // index: index,
                        leading: SvgPicture.asset(
                          AppImage.dieticiansvg,
                          height: Sizes.px40,
                          width: Sizes.px40,
                          color: AppColor.teal, // 🔷 Color applied here
                        ),
                        onTap: () async {
                          Get.to(DieticianChecklistScreen());
                          // if (controller.isInvestigationReq_Navigating.value) return;
                          // controller.isInvestigationReq_Navigating.value = true;
                          // if (controller.screenRightsTable.isNotEmpty) {
                          //   if (controller.screenRightsTable[2].rightsYN == "N") {
                          //     controller.isInvestigationReq_Navigating.value = false;
                          //     Get.snackbar(
                          //       "You don't have access to this screen",
                          //       '',
                          //       colorText: AppColor.white,
                          //       backgroundColor: AppColor.black,
                          //       duration: const Duration(seconds: 1),
                          //     );
                          //     return;
                          //   }
                          // }
                          // controller.FromScreen_Redirection = "";
                          // controller.WebLoginUser = "";
                          // controller.update();
                          // final envReqController = Get.put(InvestRequisitController());
                          // await envReqController.resetForm();
                          // // ⬇️ Call the dialog function directly
                          // await envReqController.loginAlertDialog(
                          //   context,
                          //   "Dietician Checklist",
                          //   "",
                          //   "",
                          //   "",
                          //   fromScreen: "Dietician Checklist",
                          //   fromScreenRedirection: "Dietician Checklist",
                          // );
                          // // ⬇️ Ye tab chalega jab dialog band ho jayega
                          // // final controller = Get.put(AdPatientController());
                          // controller.sortBySelected = -1;
                          // await controller.resetForm();
                          // await controller.fetchData();
                          // // controller.isInvestigationReq_Navigating.value = false;
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPatientCard({
    required String title,
    BuildContext? context,
    int? count,
    int? index,
    Widget? leading, // 🟢 Replace imagePath & icon with this
    VoidCallback? onTap,
  }) {
    double cardHeight = Sizes.h * 0.12;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColor.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppColor.teal, width: 1),
        ),
        margin: EdgeInsets.symmetric(
          vertical: getDynamicHeight(size: 0.007),
          horizontal: getDynamicHeight(size: 0.01),
        ),
        child: SizedBox(
          height: cardHeight,
          child: Padding(
            padding: EdgeInsets.all(getDynamicHeight(size: 0.01)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Column (Title + Count)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: Sizes.px18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Icon(Icons.arrow_forward_ios, size: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: Sizes.px8),
                    Text(
                      count != null ? "$count" : " ",
                      style: TextStyle(
                        fontSize: Sizes.px20,
                        fontWeight: FontWeight.bold,
                        color: count != null ? Colors.black : Colors.transparent,
                      ),
                    ),
                  ],
                ),

                // Right Side (Icon/Image/SVG)
                Container(
                  height: Sizes.px40,
                  width: Sizes.px40,
                  alignment: Alignment.center,
                  child: leading ??
                      SizedBox(
                        height: Sizes.px40,
                        width: Sizes.px40,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
