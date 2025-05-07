// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:emp_app/app/core/common/common_methods.dart';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/api_error_handler.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_const.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/common/module.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/app/moduls/pharmacy/model/pharmafilter_model.dart';
import 'package:emp_app/app/moduls/pharmacy/model/presdetail_model.dart';
import 'package:emp_app/app/moduls/pharmacy/model/presviewer_model.dart';
import 'package:emp_app/app/moduls/pharmacy/widgets/bed_checkbox.dart';
import 'package:emp_app/app/moduls/pharmacy/widgets/floor_checkbox.dart';
import 'package:emp_app/app/moduls/pharmacy/widgets/ward_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PharmacyController extends GetxController with SingleGetTickerProviderMixin {
  bool isLoading = true;
  String tokenNo = '', loginId = '', empId = '';
  final ApiController apiController = Get.put(ApiController());
  final TextEditingController searchController = TextEditingController();
  List<PresviewerList> presviewerList = [];
  List<PresdetailList> presdetailList = [];
  List<PresviewerList> filterpresviewerList = [];
  ScrollController pharmacyScrollController = ScrollController();
  // final ScrollController pharmacyviewScrollController = ScrollController();
  FocusNode focusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();
  bool hasFocus = false;
  int SelectedIndex = -1;
  List<bool> blurState = []; // Track blur states for each row
  List<Wards> wards = [];
  List<Floors> floors = [];
  List<Beds> beds = [];
  List<String> selectedWardList = [];
  List<String> selectedFloorList = [];
  List<String> selectedBedList = [];
  bool callFilterAPi = false;
  int? sortBySelected;
  List<String> tempWardList = [];
  List<String> tempFloorsList = [];
  List<String> tempBedList = [];
  bool showShortButton = true;
  var isPresViewerNavigating = false.obs;
  var isPresMedicineNavigating = false.obs;
  // RxBool showPharmaDetailArrow = false.obs;
  RxBool showScrollDownArrow = false.obs; // RxBool
  RxBool showScrollUpArrow = false.obs;
  List<ModuleScreenRights> screens = [];
  List<ModuleScreenRights> empModuleScreenRightsTable = [];

  @override
  void onInit() {
    super.onInit();
    loadScreens();
    fetchpresViewer();
    GetPharmaFilterData();
    update();
    // pharmacyScrollController.addListener(() {
    //   double maxScroll = pharmacyScrollController.position.maxScrollExtent;
    //   double currentScroll = pharmacyScrollController.position.pixels;

    //   showScrollDownArrow.value = maxScroll > 0 && currentScroll < maxScroll;
    //   showScrollUpArrow.value = currentScroll > 0;
    //   update();
    // });
    pharmacyScrollController.addListener(() {
      double maxScroll = pharmacyScrollController.position.maxScrollExtent;
      double currentScroll = pharmacyScrollController.offset;

      print("Current: $currentScroll | Max: $maxScroll");

      showScrollDownArrow.value = currentScroll < maxScroll - 20;
      showScrollUpArrow.value = currentScroll > 20;

      update();
    });
  }

  void loadScreens() async {
    empModuleScreenRightsTable = await CommonMethods.fetchModuleScreens("Pharmacy");
    filteredList = originalList;
    update();
  }

  @override
  void onClose() {
    pharmacyScrollController.dispose(); //
    super.onClose();
  }

  void toggleBlur(int index) {
    blurState[index] = !blurState[index];
    update();
  }

  Future<List<PresviewerList>> fetchpresViewer({String? searchPrefix, bool isLoader = true}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      update();
      String url = ConstApiUrl.empPresViewerListAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "prefixText": searchPrefix ?? '', "wards": selectedWardList, "floors": selectedFloorList, "beds": selectedBedList};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      Rsponsedrpresviewer rsponsedrpresviewer = Rsponsedrpresviewer.fromJson(jsonDecode(response));

      presviewerList.clear();
      if (rsponsedrpresviewer.statusCode == 200) {
        presviewerList.assignAll(rsponsedrpresviewer.data ?? []);
        if (rsponsedrpresviewer.data != null && rsponsedrpresviewer.data!.isNotEmpty) {
          filterpresviewerList = rsponsedrpresviewer.data!;
        } else {
          filterpresviewerList = [];
        }
        isLoading = false;
      } else if (rsponsedrpresviewer.statusCode == 401) {
        filterpresviewerList.clear();
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (rsponsedrpresviewer.statusCode == 400) {
        filterpresviewerList.clear();
        presviewerList.clear();
        isLoading = false;
      } else {
        filterpresviewerList.clear();
        presviewerList.clear();
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "PharmacyScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    isLoading = false;
    return presviewerList.toList();
  }

  Future<List<PresdetailList>> fetchpresDetailList(String Mst_Id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      update();
      String url = ConstApiUrl.empPresDetailListAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId, "mstId": Mst_Id};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      Rsponsedrpresdetail rsponsedrpresdetail = Rsponsedrpresdetail.fromJson(jsonDecode(response));

      presdetailList.clear();
      if (rsponsedrpresdetail.statusCode == 200) {
        presdetailList.assignAll(rsponsedrpresdetail.data ?? []);
        blurState = List.generate(presdetailList.length, (index) => false);
        isLoading = false;
      } else if (rsponsedrpresdetail.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (rsponsedrpresdetail.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "PharmacyScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    isLoading = false;
    return [];
  }

  Future<List<PresdetailList>> GetPharmaFilterData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empPharmaFilterDataApi;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      pharmaFilterModel PharmaFilterModel = pharmaFilterModel.fromJson(jsonDecode(response));

      if (PharmaFilterModel.statusCode == 200) {
        if (PharmaFilterModel.data != null) {
          wards = PharmaFilterModel.data!.wards ?? [];
          floors = PharmaFilterModel.data!.floors ?? [];
          beds = PharmaFilterModel.data!.beds ?? [];
        }
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "PharmacyScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    return [];
  }

  // void filterSearchResults(String query) {
  //   if (query.isEmpty) {
  //     filterpresviewerList = presviewerList; // Show all data if search is empty
  //   } else {
  //     filterpresviewerList = presviewerList.where((item) => (item.patientName ?? "").toLowerCase().contains(query.toLowerCase())).toList();
  //   }
  //   update();
  // }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      filterpresviewerList = presviewerList; // Show all data if search is empty
    } else {
      filterpresviewerList = presviewerList.where((item) {
        final patientName = (item.patientName ?? "").toLowerCase();
        final ipdNo = (item.ipd ?? "").toUpperCase();

        // Check if query matches either patientName or ipdNo
        return patientName.contains(query.toLowerCase()) || ipdNo.contains(query.toUpperCase());
      }).toList();
    }
    update();
  }

  getSortData({bool isLoader = true}) async {
    try {
      isLoading = isLoader;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      loginId = await prefs.getString(AppString.keyLoginId) ?? "";
      tokenNo = await prefs.getString(AppString.keyToken) ?? "";
      Map data = {
        "loginId": loginId,
        "sortType": sortBySelected == 0
            ? "Patient Name[A to Z]"
            : sortBySelected == 1
                ? "Patient Name[Z to A]"
                : sortBySelected == 2
                    ? "Stay Days [Low - High]"
                    : "Stay Days [High - Low]"
      };
      String url = ConstApiUrl.empPatientsortDataApi;
      var response = await apiController.parseJsonBody(url, tokenNo, data);
      Rsponsedrpresviewer rsponsedrpresviewer = Rsponsedrpresviewer.fromJson(jsonDecode(response));
      if (rsponsedrpresviewer.statusCode == 200) {
        if (rsponsedrpresviewer.data != null && rsponsedrpresviewer.data!.isNotEmpty) {
          filterpresviewerList = rsponsedrpresviewer.data!;
        } else {
          filterpresviewerList = [];
        }
        isLoading = false;
      } else if (rsponsedrpresviewer.statusCode == 401) {
        prefs.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (rsponsedrpresviewer.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading = false;
      update();
    }
  }

  // double calculateAppBarHeight(BuildContext context, String patientName, String isEmergency) {
  //   final TextPainter textPainter = TextPainter(
  //     text: TextSpan(
  //       text: patientName,
  //       style: TextStyle(
  //         fontSize: getDynamicHeight(size: 0.015),
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //     maxLines: 2,
  //     textDirection: TextDirection.ltr,
  //   )..layout(maxWidth: MediaQuery.of(context).size.width * 0.8);

  //   int lines = (textPainter.size.height / textPainter.preferredLineHeight).ceil();

  //   // Adjusted values: Add your own layout heights
  //   double baseHeight = 0.0;
  //   baseHeight = isEmergency.toUpperCase() == "Y" ? getDynamicHeight(size: 0.145) : getDynamicHeight(size: 0.123); // minimum for 1 line
  //   double extraLineHeight = getDynamicHeight(size: 0.018); // for second line

  //   return lines > 1 ? baseHeight + extraLineHeight : baseHeight;
  // }

  double calculateAppBarHeight(BuildContext context, String patientName, String isEmergency) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: patientName,
        style: TextStyle(
          fontSize: getDynamicHeight(size: 0.015),
          fontWeight: FontWeight.bold,
        ),
      ),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width * 0.8); // Wider width

    int lines = (textPainter.size.height / textPainter.preferredLineHeight).ceil();
    double baseHeight = 0.0;
    baseHeight = textPainter.size.height > 0.0 ? textPainter.size.height * lines : baseHeight; // minimum for 1 line
    baseHeight += isEmergency.toUpperCase() == "Y"
        ? getDynamicHeight(size: 0.120)
        : getDynamicHeight(
            size: 0.123,
          );

    double extraLineHeight = 0;

    double finalHeight = baseHeight > 0.0 ? baseHeight + extraLineHeight : baseHeight;

    print('Lines: $lines');
    print('Text Height: ${textPainter.size.height}');
    print('Final AppBar Height: $finalHeight');

    return finalHeight;
  }

  List<Map<String, dynamic>> originalList = AppConst.pharmacygrid;
  List<Map<String, dynamic>> filteredList = [];

  void filterSearchpharmaResults(String query) {
    List<Map<String, dynamic>> tempList = [];
    if (query.isNotEmpty) {
      tempList = originalList.where((item) => item['label'].toLowerCase().contains(query.toLowerCase())).toList();
    } else {
      tempList = originalList;
    }

    filteredList = tempList;
    update();
  }

  Future<void> pharmacyFiltterBottomSheet() async {
    showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        isDismissible: true,
        useSafeArea: true,
        backgroundColor: AppColor.transparent,
        builder: (context) => Container(
              height: MediaQuery.of(context).size.height * 0.90,
              width: Get.width,
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: GetBuilder<PharmacyController>(builder: (controller) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Text(
                            AppString.filterby,
                            style: TextStyle(
                              // fontSize: 25,
                              fontSize: getDynamicHeight(size: 0.027),
                              color: AppColor.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.cancel),
                          )
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              Text(
                                AppString.selectWardsName,
                                style: TextStyle(
                                  // fontSize: 20,
                                  fontSize: getDynamicHeight(size: 0.022),
                                  color: AppColor.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              WardsCheckBoxes(controller: controller),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                AppString.floor,
                                style: TextStyle(
                                  // fontSize: 20,
                                  fontSize: getDynamicHeight(size: 0.022),
                                  color: AppColor.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              FloorsCheckBoxes(controller: controller),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                AppString.selectbed,
                                style: TextStyle(
                                  // fontSize: 20,
                                  fontSize: getDynamicHeight(size: 0.022),
                                  color: AppColor.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              BedsCheckBoxes(controller: controller),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          children: [
                            Expanded(
                                child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: AppColor.primaryColor),
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    callFilterAPi = true;
                                    if (selectedWardList.isNotEmpty || selectedFloorList.isNotEmpty || selectedBedList.isNotEmpty) {
                                      Navigator.pop(context);
                                      await fetchpresViewer(isLoader: false);
                                    } else {
                                      Get.rawSnackbar(message: AppString.plzselectoptiontosort);
                                    }
                                  },
                                  child: Text(
                                    AppString.apply,
                                    style: TextStyle(
                                      color: AppColor.white,
                                      // fontSize: 15,
                                      fontSize: getDynamicHeight(size: 0.017),
                                    ),
                                  )),
                            )),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        backgroundColor: AppColor.primaryColor),
                                    onPressed: () async {
                                      callFilterAPi = true;
                                      FocusScope.of(context).unfocus();
                                      selectedWardList = [];
                                      selectedFloorList = [];
                                      selectedBedList = [];
                                      await fetchpresViewer();
                                      Navigator.pop(context);
                                      controller.update();
                                    },
                                    child: Text(
                                      AppString.resetall,
                                      style: TextStyle(
                                        // fontSize: 16,
                                        fontSize: getDynamicHeight(size: 0.018),
                                        color: AppColor.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                );
              }),
            )).whenComplete(() {
      if (!callFilterAPi) {
        fetchpresViewer();
        selectedWardList = List.from(tempWardList);
        selectedFloorList = List.from(tempFloorsList);
        selectedBedList = List.from(tempBedList);
        update();
      }
    });
  }

  Future<void> sortBy() async {
    showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        isDismissible: true,
        useSafeArea: true,
        backgroundColor: AppColor.transparent,
        builder: (context) => Container(
              height: MediaQuery.of(context).size.height * 0.42,
              width: Get.width,
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: GetBuilder<PharmacyController>(builder: (controller) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 25,
                          ),
                          Text(
                            AppString.sortby,
                            style: TextStyle(
                              // fontSize: 20,
                              fontSize: getDynamicHeight(size: 0.022),
                              fontWeight: FontWeight.w700,
                              color: AppColor.black,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.cancel))
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  sortBySelected = 0;
                                  controller.update();
                                  getSortData(isLoader: true);
                                  Get.back();
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      AppString.patientnameAtoZ,
                                      style: TextStyle(
                                        // fontSize: 14,
                                        fontSize: getDynamicHeight(size: 0.016),
                                        fontWeight: FontWeight.w500,
                                        color: sortBySelected == 0 ? AppColor.primaryColor : AppColor.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(
                                color: AppColor.originalgrey,
                                thickness: 1,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  sortBySelected = 1;
                                  controller.update();
                                  getSortData(isLoader: true);
                                  Get.back();
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      AppString.patientnameZtoA,
                                      style: TextStyle(
                                        // fontSize: 14,
                                        fontSize: getDynamicHeight(size: 0.016),
                                        fontWeight: FontWeight.w500,
                                        color: sortBySelected == 1 ? AppColor.primaryColor : AppColor.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(
                                color: AppColor.originalgrey,
                                thickness: 1,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  sortBySelected = 2;
                                  controller.update();
                                  getSortData(isLoader: true);
                                  Get.back();
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      AppString.staydaysLtH,
                                      style: TextStyle(
                                        // fontSize: 14,
                                        fontSize: getDynamicHeight(size: 0.016),
                                        fontWeight: FontWeight.w500,
                                        color: sortBySelected == 2 ? AppColor.primaryColor : AppColor.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(
                                color: AppColor.originalgrey,
                                thickness: 1,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  sortBySelected = 3;
                                  controller.update();
                                  getSortData(isLoader: true);
                                  Get.back();
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      AppString.staydaysHtL,
                                      style: TextStyle(
                                        // fontSize: 14,
                                        fontSize: getDynamicHeight(size: 0.016),
                                        fontWeight: FontWeight.w500,
                                        color: sortBySelected == 3 ? AppColor.primaryColor : AppColor.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(
                                color: AppColor.originalgrey,
                                thickness: 1,
                              ),
                              Center(
                                child: SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          backgroundColor: AppColor.primaryColor),
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();

                                        // getSortData();
                                        sortBySelected = null;
                                        fetchpresViewer();
                                        Navigator.pop(context);
                                        controller.update();
                                      },
                                      child: Text(
                                        AppString.reset,
                                        style: TextStyle(
                                          // fontSize: 16,
                                          fontSize: getDynamicHeight(size: 0.018),
                                          color: AppColor.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ));
  }
}
