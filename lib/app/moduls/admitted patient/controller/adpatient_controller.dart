import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:emp_app/app/core/common/common_methods.dart';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/api_error_handler.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_const.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/admitted%20patient/model/patientdata_model.dart';
import 'package:emp_app/app/moduls/admitted%20patient/model/patientsummary_labdata_model.dart';
import 'package:emp_app/app/moduls/admitted%20patient/screen/adpatient_screen.dart';
import 'package:emp_app/app/moduls/admitted%20patient/widgets/floor_checkbox.dart';
import 'package:emp_app/app/moduls/admitted%20patient/widgets/organization_checkbox.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/common/module.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/moduls/invest_requisit/controller/invest_requisit_controller.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mime/mime.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/adpatientfilter_model.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;

class AdPatientController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController labSummarySearchController = TextEditingController();
  bool isLoading = true;
  String tokenNo = '', loginId = '', empId = '';
  String ipdNo = '', uhid = '', patientName = '', bedNo = '';
  final ApiController apiController = Get.put(ApiController());
  // List<PatientdataModel> patientdata = [];
  List<PatientdataModel> patientsData = [];
  List<PatientdataModel> filterpatientsData = [];
  List<LabData> labdata = [];
  List<LabData> filterlabdata = [];
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
  List<Map<String, dynamic>> originalList = AppConst.adpatientgrid;
  List<Map<String, dynamic>> filteredList = [];
  var isAdmittedPatients_Navigating = false.obs;
  var isInvestigationReq_Navigating = false.obs;
  List<ModuleScreenRights> screenRightsTable = [];

  @override
  void onInit() {
    super.onInit();
    // generateLast7Days();
    _syncScrollControllers();
    // fetchDeptwisePatientList();
    getPatientDashboardFilters();
    loadScreens();
    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        isPlaying = false;
        update();
      }
    });
    fetchData();
    // update();
    // fetchsummarylabdata();

    // adPatientScrollController.addListener(() {
    //   if (adPatientScrollController.position.userScrollDirection == ScrollDirection.forward) {
    //     if (hideBottomBar.value) {
    //       hideBottomBar.value = false;
    //       bottomBarController.update();
    //     }
    //   } else if (adPatientScrollController.position.userScrollDirection == ScrollDirection.reverse) {
    //     if (!hideBottomBar.value) {
    //       hideBottomBar.value = true;
    //       bottomBarController.update();
    //     }
    //   }
    // });
    filteredList = List.from(originalList);
  }

  void loadScreens() async {
    screenRightsTable = await CommonMethods.fetchModuleScreens("IPD");
    filteredList = originalList;
    update();
  }

  Future<void> fetchData() async {
    await fetchDeptwisePatientList();
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

  Future<List<PatientdataModel>> fetchDeptwisePatientList({String? searchPrefix, bool isLoader = true}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      isLoading = true;
      update();

      String url = ConstApiUrl.empFilterpatientdataList;
      loginId = pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "prefixText": searchPrefix ?? "", "orgs": selectedOrgsList, "floors": selectedFloorsList, "wards": selectedWardsList};

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

      ApiErrorHandler.handleError(
        screenName: "adPatientListScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    return patientsData.toList();
  }

  Future<List<PatientdataModel>> getPatientDashboardFilters({bool isLoader = true}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empPatientDashboardFilters;
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
      ApiErrorHandler.handleError(
        screenName: "adPatientListScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    return [];
  }

  Future<List<LabData>> fetchsummarylabdata({bool isLoader = true}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      update();
      String url = ConstApiUrl.empPatientSummaryLabData;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      // var jsonbodyObj = {"loginId": loginId, "ipdNo": "A/3761/24", "uhid": "U/74859/17"};
      var jsonbodyObj = {"loginId": loginId, "ipdNo": ipdNo, "uhid": uhid};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      RsponsePatientlabsummarydata rsponsePatientlabsummarydata = RsponsePatientlabsummarydata.fromJson(jsonDecode(response));

      if (rsponsePatientlabsummarydata.statusCode == 200) {
        labdata.clear();
        labdata.assignAll(rsponsePatientlabsummarydata.data?.labData ?? []);

        patientName = rsponsePatientlabsummarydata.data?.patientName ?? "";
        bedNo = rsponsePatientlabsummarydata.data?.bedNo ?? "";

        if (rsponsePatientlabsummarydata.data != null && rsponsePatientlabsummarydata.data!.labData!.isNotEmpty) {
          filterlabdata = rsponsePatientlabsummarydata.data!.labData ?? [];
        } else {
          filterlabdata = [];
        }

        isLoading = false;
      } else if (rsponsePatientlabsummarydata.statusCode == 401) {
        filterlabdata.clear();
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (rsponsePatientlabsummarydata.statusCode == 400) {
        filterlabdata.clear();
        labdata.clear();
        isLoading = false;
      } else {
        filterlabdata.clear();
        labdata.clear();
        isLoading = false;
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "adPatientListScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    return labdata.toList();
  }

  var searchQuery = "".obs; // Observable search query

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    update(); // GetBuilder ke liye UI refresh karega
  }

  void clearSearch() {
    fetchsummarylabdata();
    update();
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

  void filterLabSummarySearchResults(String query) {
    if (query.isEmpty) {
      filterlabdata = labdata; // Show all data if search is empty
    } else {
      filterlabdata = labdata.where((item) {
        final formatTest = (item.formattest ?? "").toLowerCase();
        final testName = (item.testName ?? "").toLowerCase();

        // Check if query matches either patientName or ipdNo
        return formatTest.contains(query.toLowerCase()) || testName.contains(query.toLowerCase());
      }).toList();
    }
    update();
  }

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

  double getResponsiveFontSize(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    return width > 600 ? size * 1.2 : size; // iPad pe 20% zyada, baki normal
  }

  getSortData({bool isLoader = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      isLoading = isLoader;
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

      ApiErrorHandler.handleError(
        screenName: "DeptwisePatientListScreen",
        error: e.toString(),
        loginID: prefs.getString(AppString.keyLoginId) ?? '',
        tokenNo: prefs.getString(AppString.keyToken) ?? '',
        empID: prefs.getString(AppString.keyEmpId) ?? '',
      );
    }
  }

  Future<void> AdpatientFiltterBottomSheet() async {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      isDismissible: true,
      useSafeArea: true,
      backgroundColor: AppColor.transparent,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: GetBuilder<AdPatientController>(
              builder: (controller) {
                return Column(
                  children: [
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 30),
                        Text(
                          AppString.filterby,
                          style: TextStyle(
                            fontSize: getDynamicHeight(size: 0.027),
                            color: AppColor.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.cancel),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        children: [
                          SizedBox(height: 25),
                          Text(
                            AppString.selectOrgsName,
                            style: TextStyle(
                              fontSize: getDynamicHeight(size: 0.022),
                              color: AppColor.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 10),
                          organizationCheckBoxes(controller: controller),
                          SizedBox(height: 15),
                          Text(
                            AppString.floor,
                            style: TextStyle(
                              fontSize: getDynamicHeight(size: 0.022),
                              color: AppColor.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10),
                          floorCheckBox(controller: controller),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
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
                                  backgroundColor: AppColor.primaryColor,
                                ),
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  callFilterAPi = true;
                                  if (selectedOrgsList.isNotEmpty || selectedFloorsList.isNotEmpty) {
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
                                    fontSize: getDynamicHeight(size: 0.017),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: AppColor.primaryColor,
                                ),
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
                                    fontSize: getDynamicHeight(size: 0.018),
                                    color: AppColor.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    ).whenComplete(() {
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

  void showSimpleDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Normal Range"),
          content: Text((labdata[index].normalRange ?? "No Normal Range Available")),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog close karega
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Information"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "a. To view the normal range for a test, simply long press on the specific test name or its corresponding report name, and the normal range will be displayed."),
                SizedBox(height: 8),
                Text("b. Any test values that are abnormal will be displayed in red colour for clear identification."),
                SizedBox(height: 8),
                Text("c. Blue background colour indicates provisional report which is pending to verify by pathologist/microbiologist."),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog close karega
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> drawerListInClk(BuildContext context, int index) async {
    switch (index) {
      case 0:
        if (isAdmittedPatients_Navigating.value) return;
        isAdmittedPatients_Navigating.value = true;

        if (screenRightsTable.isNotEmpty) {
          if (screenRightsTable[0].rightsYN == "N") {
            isAdmittedPatients_Navigating.value = false;
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

        Navigator.pop(context);
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: AdpatientScreen(),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        ).then((value) async {
          final bottomBarController = Get.put(BottomBarController());
          bottomBarController.currentIndex.value = -1;
          bottomBarController.persistentController.value.index = 0;
          bottomBarController.currentIndex.value = 0;
          bottomBarController.isIPDHome.value = true;
          hideBottomBar.value = true;
          var dashboardController = Get.put(DashboardController());
          await dashboardController.getDashboardDataUsingToken();
        });

        isAdmittedPatients_Navigating.value = false;
        break;
      case 1:
        if (isInvestigationReq_Navigating.value) return;
        isInvestigationReq_Navigating.value = true;

        if (screenRightsTable.isNotEmpty) {
          if (screenRightsTable[1].rightsYN == "N") {
            isInvestigationReq_Navigating.value = false;
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

        final envReqController = Get.put(
          InvestRequisitController(),
        );
        await envReqController.resetForm();
        // ⬇️ Call the dialog function directly
        await envReqController.loginAlertDialog(
          context,
          "INVESTIGATION REQUISITION",
          "",
          "",
          "",
        );

        // ⬇️ Ye tab chalega jab dialog band ho jayega
        final controller = Get.put(AdPatientController());
        controller.sortBySelected = -1;
        await controller.resetForm();
        await fetchData();

        final bottomBarController = Get.find<BottomBarController>();
        bottomBarController.currentIndex.value = 0;
        bottomBarController.isIPDHome.value = true;
        hideBottomBar.value = false;
        isInvestigationReq_Navigating.value = false;
        break;
    }
  }

  resetForm() async {
    selectedOrgsList.clear();
    selectedWardsList.clear();
    selectedFloorsList.clear();
    searchController.clear();
    isSearchActive = false;
    filterpatientsData.clear();
    patientsData.clear();
    labSummarySearchController.clear();
    update();
  }

  //speech to text
  final stt.SpeechToText speech = stt.SpeechToText();
  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer player = AudioPlayer();

  bool isListening = false;
  bool isRecording = false;
  bool isPlaying = false;
  List<int> audioBytes = [];

  String recognizedText = '';
  String translatedText = '';
  String? filePath;
  bool apiCall = false;
  int seconds = 0;
  late DateTime startTime;
  Timer? timer;

  Future<void> startListeningAndRecording() async {
    try {
      bool available = await speech.initialize();
      bool hasPermission = await audioRecorder.hasPermission();

      if (available && hasPermission) {
        recognizedText = '';
        translatedText = '';
        isListening = true;
        isRecording = true;
        seconds = 0;
        startTime = DateTime.now();
        // audioBytes.remove;
        audioBytes.remove;

        Directory? dir;

        if (Platform.isAndroid) {
          dir = Directory('/storage/emulated/0/Download');
          if (!(await dir.exists())) {
            dir = await getExternalStorageDirectory();
            if (dir != null) {
              // Optional: Create a subdirectory for organization
              dir = Directory(p.join(dir.path, 'VoiceRecordings'));
              if (!await dir.exists()) {
                await dir.create(recursive: true);
              }
            }
          }
        } else {
          dir = await getApplicationDocumentsDirectory();
        }

        if (dir == null) {
          throw Exception('Unable to get directory for saving audio');
        }

        filePath = p.join(dir.path, 'voice_${DateTime.now().millisecondsSinceEpoch}.m4a');

        await audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc, sampleRate: 48000, bitRate: 128000),
          path: filePath!,
        );
        // if (filePath != null) {
        //   final file = File(filePath!);
        //   audioBytes = await file.readAsBytes(); // ✅ collect after recording
        // }

        timer = Timer.periodic(const Duration(seconds: 1), (_) {
          seconds = DateTime.now().difference(startTime).inSeconds;
          update();
        });
        speech.listen(
          onResult: (result) {
            recognizedText = result.recognizedWords;
            update();
          },
          localeId: '', // auto detect
        );
        update();
      } else {
        Get.snackbar('Error', 'Microphone permission not granted or Speech not available');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to start listening and recording: $e');
    }
  }

  Future<void> stopListeningAndRecording() async {
    try {
      if (isListening) await speech.stop();
      if (isRecording) await audioRecorder.stop();

      isListening = false;
      isRecording = false;

      timer?.cancel();
      update();
      await _transcribeAndTranslateAudio(filePath!);

      // if (filePath != null) {
      //   final file = File(filePath!);
      //   if (await file.exists()) {
      //     audioBytes = await file.readAsBytes(); // Read bytes into audioBytes
      //     print('Audio bytes read successfully, length: ${audioBytes.length}');
      //   } else {
      //     throw Exception('Recorded file does not exist at $filePath');
      //   }
      // } else {
      //   throw Exception('File path is null');
      // }

      // if (audioBytes.isNotEmpty) {
      //   await uploadVoiceToServer(
      //     bytes: audioBytes,
      //     filename: 'voice_${DateTime.now().millisecondsSinceEpoch}.m4a',
      //     loginId: loginId,
      //     empId: empId,
      //     uhid: uhid,
      //     ipdNo: ipdNo,
      //     patientName: patientName,
      //     doctorName: '',
      //     createdUser: '',
      //     translatedText: 'ascgfgdf',
      //   );
      // }
    } catch (e) {
      Get.snackbar('Error', 'Failed to stop: $e');
    }
  }

  Future<void> _transcribeAndTranslateAudio(String audioPath) async {
    try {
      final file = File(filePath!);
      audioBytes = await file.readAsBytes();
      String transcribedText = await translateAudioToEnglish(audioPath);
      if (transcribedText.isNotEmpty) {
        recognizedText = transcribedText;
        // await translateAudioToEnglish(audioPath);
        await SaveFileDetails(recognizedText, file, audioBytes);
      } else {
        translatedText = 'No text recognized from audio.';
        update();
      }
    } catch (e) {
      translatedText = 'Audio processing error: $e';
      update();
    }
  }

  Future<void> SaveFileDetails(String translatedText, File file, List<int> audioBytes) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? loginId = pref.getString(AppString.keyLoginId);
    String? empId = pref.getString(AppString.keyEmpId);

    if (filePath != null) {
      print('Audio bytes read successfully, length: ${audioBytes.length}');
      await uploadVoiceToServer(
        bytes: audioBytes,
        filename: p.basename(file.path),
        loginId: loginId ?? '',
        empId: empId ?? '',
        uhid: uhid,
        ipdNo: ipdNo,
        patientName: patientName,
        doctorName: '',
        createdUser: '',
        translatedText: translatedText,
      );
    } else {
      Get.snackbar('Error', 'File path is null');
    }
  }

  Future<void> uploadVoiceToServer({
    required List<int> bytes,
    required String filename,
    required String loginId,
    required String empId,
    required String uhid,
    required String ipdNo,
    required String patientName,
    required String doctorName,
    required String createdUser,
    required String translatedText,
  }) async {
    String token = ''; // Add your token logic here if needed, e.g., from GetX state

    // Determine the MIME type of the file
    final mimeType = lookupMimeType(filename) ?? 'audio/m4a';

    // Prepare form data with correct keys and casing
    final formData = dio.FormData.fromMap({
      'voiceFile': dio.MultipartFile.fromBytes(
        bytes,
        filename: filename,
        contentType: DioMediaType.parse(mimeType),
      ),
      'LoginId': loginId,
      'EmpID': empId,
      'UHID': uhid,
      'IPDNo': ipdNo,
      'PatientName': patientName,
      'VoiceFileName': filename,
      'DoctorName': doctorName,
      'CreatedUser': createdUser,
      'TranslatedText': translatedText,
    });

    // Set headers (only include Authorization if token exists)
    final headers = {
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    try {
      final dioPackage = Dio();
      final response = await dioPackage.post(
        ConstApiUrl.empVoiceApi, // Ensure this matches your API endpoint, e.g., "/UploadPatientVoiceNote"
        data: formData,
        options: Options(
          headers: headers,
        ),
      );

      // Handle the response based on status code and response data
      if (response.statusCode == 200) {
        var responseData = response.data;
        if (responseData['isSuccess'] == 'true') {
          print('Upload success: ${responseData['message']}');
        } else {
          print('Upload failed: ${responseData['message']}');
        }
      } else if (response.statusCode == 400) {
        print('Bad request: ${response.data}');
      } else {
        print('Upload failed: ${response.statusCode} - ${response.statusMessage}');
      }
    } catch (e) {
      print('Upload Exception: $e');
    }
  }

  // Future<void> uploadVoiceToServer({
  //   required List<int> bytes,
  //   required String filename,
  //   required String loginId,
  //   required String empId,
  //   required String uhid,
  //   required String ipdNo,
  //   required String patientName,
  //   required String doctorName,
  //   required String createdUser,
  // }) async {
  //   // final dio = Dio();
  //   String token = ''; // Add your token logic here if needed

  //   // Determine the MIME type of the file
  //   final mimeType = lookupMimeType(filename) ?? 'audio/m4a';

  //   // Prepare form data
  //   final formData = dio.FormData.fromMap({
  //     'file': dio.MultipartFile.fromBytes(
  //       bytes,
  //       filename: filename,
  //       contentType: dio.DioMediaType.parse(mimeType),
  //     ),
  //     'loginId': loginId,
  //     'empID': empId,
  //     'uHID': uhid,
  //     'iPDNo': ipdNo,
  //     'patientName': patientName,
  //     'voiceFileName': filename,
  //     'doctorName': doctorName,
  //     'createdUser': createdUser,
  //     'contentType': mimeType,
  //   });

  //   // Set headers
  //   final headers = {
  //     'Content-Type': 'application/json',
  //     if (token.isNotEmpty) 'Authorization': 'Bearer $token',
  //   };

  //   try {
  //     // Send the request
  //     final dioPackage = Dio();
  //     final response = await dioPackage.request(
  //       ConstApiUrl.empVoiceApi, // Replace with the actual API endpoint URL
  //       data: formData,
  //       options: Options(
  //         method: 'POST',
  //         headers: headers,
  //       ),
  //     );

  //     // Handle the response
  //     if (response.statusCode == 200) {
  //       print('Upload success: ${response.data}');
  //     } else {
  //       print('Upload failed: ${response.statusCode} - ${response.statusMessage}');
  //     }
  //   } catch (e) {
  //     print('Upload Exception: $e');
  //   }
  // }

  Future<void> togglePlayback() async {
    if (filePath == null || !File(filePath!).existsSync()) return;

    if (isPlaying) {
      await player.pause();
      isPlaying = false;
      update(); // Immediately reflect Pause to Play
    } else {
      // Immediately update UI to "Pause"
      isPlaying = true;
      update();

      // Seek to start if already completed
      if (player.playerState.processingState == ProcessingState.completed || player.position == player.duration) {
        await player.seek(Duration.zero);
      }

      // if (player.audioSource == null) {
      await player.setFilePath(filePath!);
      // }

      await player.play();
    }
  }

  Future<String> translateAudioToEnglish(String audioPath) async {
    File audioFile = File(audioPath);
    final apiKey =
        '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';

    final uri = Uri.parse('https://api.openai.com/v1/audio/translations');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $apiKey'
      ..headers['Content-Type'] = 'multipart/form-data'
      ..fields['model'] = 'whisper-1'
      ..files.add(await http.MultipartFile.fromPath('file', audioFile.path, filename: p.basename(audioFile.path)));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      print("Translated Text: $responseBody");
      translatedText = responseBody; // <-- store full response here
      translatedText = await makeMedicalStyleTranslation(translatedText);
      update();
      return json.decode(responseBody)['text'].toString().trim();
    } else {
      print("Error: ${response.statusCode}");

      final responseBody = await response.stream.bytesToString();
      print("Details: $responseBody");
    }
    return 'Translation failed: ${response.statusCode}';
  }

  Future<String> makeMedicalStyleTranslation(String translatedText) async {
    final apiKey =
        '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';
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'},
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "system",
            "content":
                "You are a professional medical doctor. Convert the provided plain English text into a medically appropriate version using clinical terminology and doctor-style explanation.",
          },
          {"role": "user", "content": translatedText},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['choices'][0]['message']['content'];
    } else {
      return 'Error: ${response.statusCode}\n${response.body}';
    }
  }

  @override
  void onClose() {
    speech.stop();
    audioRecorder.dispose();
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    player.dispose();
    super.onClose();
  }
}
