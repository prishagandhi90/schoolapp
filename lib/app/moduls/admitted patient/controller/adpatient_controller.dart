import 'dart:convert';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_const.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/admitted%20patient/model/patientdata_model.dart';
import 'package:emp_app/app/moduls/admitted%20patient/model/patientsummary_labdata_model.dart';
import 'package:emp_app/app/moduls/admitted%20patient/widgets/floor_checkbox.dart';
import 'package:emp_app/app/moduls/admitted%20patient/widgets/organization_checkbox.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/adpatientfilter_model.dart';

class AdPatientController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  String tokenNo = '', loginId = '', empId = '';
  String ipdNo = '', uhid = '';
  final ApiController apiController = Get.put(ApiController());
  // List<PatientdataModel> patientdata = [];
  List<PatientdataModel> patientsData = [];
  List<PatientdataModel> filterpatientsData = [];
  List<LabData> labdata = [];
  List<FilterPatientList> filterdata = [];
  List<String> selectedOrgsList = [];
  List<String> selectedFloorsList = [];
  List<String> selectedWardsList = [];
  bool callFilterAPi = false;
  List<Orgs> orgsList = [];
  List<Floors> floorsList = [];
  List<Wards> wardList = [];
  List<String> tempOrgsList = [];
  List<String> tempFloorsList = [];
  List<String> tempWardList = [];
  bool isSearchActive = false;
  var isAdpatientData = false.obs;
  var isSelectionMode = false.obs;
  int? sortBySelected;
  FocusNode focusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();
  bool hasFocus = false;
  var isPresViewerNavigating = false.obs;
  final ScrollController verticalScrollControllerLeft = ScrollController();
  final ScrollController verticalScrollControllerRight = ScrollController();
  final ScrollController horizontalScrollController = ScrollController();
  final ScrollController adPatientScrollController = ScrollController();
  final bottomBarController = Get.put(BottomBarController());
  late final String date1, date2, date3, date4, date5, date6, date7;

  @override
  void onInit() {
    super.onInit();
    // generateLast7Days();
    _syncScrollControllers();
    // fetchDeptwisePatientList();
    getPatientDashboardFilters();
    update();
    // fetchsummarylabdata();

    adPatientScrollController.addListener(() {
      if (adPatientScrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (hideBottomBar.value) {
          hideBottomBar.value = false;
          bottomBarController.update();
        }
      } else if (adPatientScrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (!hideBottomBar.value) {
          hideBottomBar.value = true;
          bottomBarController.update();
        }
      }
    });
    filteredList = List.from(originalList);
  }

  void _syncScrollControllers() {
    verticalScrollControllerLeft.addListener(() {
      if (verticalScrollControllerRight.hasClients && verticalScrollControllerRight.offset != verticalScrollControllerLeft.offset) {
        verticalScrollControllerRight.jumpTo(verticalScrollControllerLeft.offset);
      }
    });

    verticalScrollControllerRight.addListener(() {
      if (verticalScrollControllerLeft.hasClients && verticalScrollControllerLeft.offset != verticalScrollControllerRight.offset) {
        verticalScrollControllerLeft.jumpTo(verticalScrollControllerRight.offset);
      }
    });
  }

  @override
  void onClose() {
    verticalScrollControllerLeft.dispose();
    verticalScrollControllerRight.dispose();
    horizontalScrollController.dispose();
    // searchController.dispose();
    super.onClose();
  }

  Future<List<PatientdataModel>> fetchDeptwisePatientList({String? searchPrefix, bool isLoader = true}) async {
    try {
      isLoading = true;
      update();
      String url = ConstApiUrl.empfilterpatientdataList;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {
        "loginId": loginId,
        "prefixText": searchPrefix ?? "",
        "orgs": selectedOrgsList,
        "floors": selectedFloorsList,
        "wards": selectedWardsList
      };

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      Rsponsedpatientdata rsponsedpatientdata = Rsponsedpatientdata.fromJson(jsonDecode(response));
      patientsData.clear();
      if (rsponsedpatientdata.statusCode == 200) {
        patientsData.assignAll(rsponsedpatientdata.data ?? []);
        if (rsponsedpatientdata.data != null && rsponsedpatientdata.data!.isNotEmpty) {
          filterpatientsData = rsponsedpatientdata.data!;
        } else {
          filterpatientsData = [];
        }
        isLoading = false;
      } else if (rsponsedpatientdata.statusCode == 401) {
        filterpatientsData.clear();
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (rsponsedpatientdata.statusCode == 400) {
        filterpatientsData.clear();
        patientsData.clear();
        isLoading = false;
      } else {
        isLoading = false;
        filterpatientsData.clear();
        patientsData.clear();
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading = false;
      update();
    }
    return patientsData.toList();
  }

  Future<List<PatientdataModel>> getPatientDashboardFilters({bool isLoader = true}) async {
    try {
      isLoading = true;
      String url = ConstApiUrl.patientDashboardFilters;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      AdpatientFilterModel patientFilterModel = AdpatientFilterModel.fromJson(jsonDecode(response));

      if (patientFilterModel.statusCode == 200) {
        if (patientFilterModel.data != null) {
          wardList = patientFilterModel.data!.wards ?? [];
          floorsList = patientFilterModel.data!.floors ?? [];
          orgsList = patientFilterModel.data!.orgs ?? [];
        }
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading = false;
      update();
    }
    return [];
  }

  Future<List<LabData>> fetchsummarylabdata({bool isLoader = true}) async {
    try {
      isLoading = true;
      update();
      String url = ConstApiUrl.empPatientSummaryLabData;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      // var jsonbodyObj = {"loginId": loginId, "ipdNo": "A/3761/24", "uhid": "U/74859/17"};
      var jsonbodyObj = {"loginId": loginId, "ipdNo": ipdNo, "uhid": uhid};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      RsponsePatientlabsummarydata rsponsePatientlabsummarydata = RsponsePatientlabsummarydata.fromJson(jsonDecode(response));

      if (rsponsePatientlabsummarydata.statusCode == 200) {
        labdata.clear();
        labdata.assignAll(rsponsePatientlabsummarydata.data?.labData ?? []);
        isLoading = false;
      } else if (rsponsePatientlabsummarydata.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (rsponsePatientlabsummarydata.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading = false;
      update();
    }
    isLoading = false;
    return [];
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      filterpatientsData = patientsData; // Show all data if search is empty
    } else {
      filterpatientsData = patientsData.where((item) {
        final patientName = (item.patientName ?? "").toLowerCase();
        final ipdNo = (item.ipdNo ?? "").toUpperCase();

        // Check if query matches either patientName or ipdNo
        return patientName.contains(query.toLowerCase()) || ipdNo.contains(query.toUpperCase());
      }).toList();
    }
    update();
  }

  List<Map<String, dynamic>> originalList = AppConst.adpatientgrid;
  List<Map<String, dynamic>> filteredList = [];

  void filterSearchAdPatientResults(String query) {
    List<Map<String, dynamic>> tempList = [];
    if (query.isNotEmpty) {
      tempList = originalList.where((item) => item['label'].toLowerCase().contains(query.toLowerCase())).toList();
    } else {
      tempList = originalList;
    }

    filteredList = tempList;
    update();
  }

  activateSearch(bool isActive) async {
    isSearchActive = isActive;
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
      String url = ConstApiUrl.empSortDeptPatientList;
      var response = await apiController.parseJsonBody(url, tokenNo, data);
      Rsponsedpatientdata rsponsedpatientdata = Rsponsedpatientdata.fromJson(jsonDecode(response));
      if (rsponsedpatientdata.statusCode == 200) {
        if (rsponsedpatientdata.data != null && rsponsedpatientdata.data!.isNotEmpty) {
          filterpatientsData = rsponsedpatientdata.data!;
        } else {
          filterpatientsData = [];
        }
        isLoading = false;
      } else if (rsponsedpatientdata.statusCode == 401) {
        prefs.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (rsponsedpatientdata.statusCode == 400) {
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

  Future<void> AdpatientFiltterBottomSheet() async {
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
              child: GetBuilder<AdPatientController>(builder: (controller) {
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
                                AppString.selectOrgsName,
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
                              organizationCheckBoxes(controller: controller),
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
                              floorCheckBox(controller: controller),
                              SizedBox(
                                height: 15,
                              ),
                              // Text(
                              //   AppString.selectbed,
                              //   style: TextStyle(
                              //     // fontSize: 20,
                              //     fontSize: getDynamicHeight(size: 0.022),
                              //     color: AppColor.black,
                              //     fontWeight: FontWeight.w700,
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              // WardsCheckBox(controller: controller),
                              // const SizedBox(
                              //   height: 10,
                              // ),
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
                                    if (selectedOrgsList.isNotEmpty || selectedFloorsList.isNotEmpty || selectedWardsList.isNotEmpty) {
                                      Navigator.pop(context);
                                      controller.isSearchActive = false;
                                      controller.searchController.clear();

                                      sortBySelected = -1;

                                      await fetchDeptwisePatientList();
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
                                      selectedOrgsList = [];
                                      selectedFloorsList = [];
                                      selectedWardsList = [];

                                      controller.isSearchActive = false;
                                      controller.searchController.clear();
                                      sortBySelected = -1;

                                      await fetchDeptwisePatientList();
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
        fetchDeptwisePatientList();
        selectedOrgsList = List.from(tempOrgsList);
        selectedFloorsList = List.from(tempFloorsList);
        selectedWardsList = List.from(tempWardList);
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
              child: GetBuilder<AdPatientController>(builder: (controller) {
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
                                onTap: () async {
                                  controller.isSearchActive = false;
                                  controller.searchController.clear();

                                  sortBySelected = 0;
                                  controller.update();
                                  await getSortData(isLoader: true);
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
                                onTap: () async {
                                  controller.isSearchActive = false;
                                  controller.searchController.clear();

                                  sortBySelected = 1;
                                  controller.update();
                                  await getSortData(isLoader: true);
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
                                onTap: () async {
                                  controller.isSearchActive = false;
                                  controller.searchController.clear();

                                  sortBySelected = 2;
                                  controller.update();
                                  await getSortData(isLoader: true);
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
                                onTap: () async {
                                  controller.isSearchActive = false;
                                  controller.searchController.clear();

                                  sortBySelected = 3;
                                  controller.update();
                                  await getSortData(isLoader: true);
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
                                      onPressed: () async {
                                        FocusScope.of(context).unfocus();
                                        sortBySelected = null;
                                        await fetchDeptwisePatientList();
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

  resetForm() async {
    selectedOrgsList.clear();
    selectedWardsList.clear();
    selectedFloorsList.clear();
    searchController.clear();
    isSearchActive = false;
    filterpatientsData.clear();
    patientsData.clear();
    update();
  }
}
